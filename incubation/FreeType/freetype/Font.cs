using System;
using Tao.OpenGl;
using System.Runtime.InteropServices;
using FreeTypeWrap;

namespace FreeType
{

	// A true 3D Font 
	public class Font3D
	{

    	//Public members
    	private int list_base;
    	private int font_size;
    	private int[] textures;
    	private int[] extent_x;

	    public Font3D( string font, int size ) 
	    {
	    	
	    	// Save the size we need it later on when printing
	    	font_size=size;	    	

			// We begin by creating a library pointer
			System.IntPtr libptr;			
			int ret = Library.FT_Init_FreeType(out libptr);
			if (ret!=0) return;
			//Library lib=(Library)Marshal.PtrToStructure( libptr, typeof(Library) );
			
			
			//Once we have the library we create and load the font face
			Face face;
			System.IntPtr faceptr;		
			int retb = Face.FT_New_Face( libptr, font, 0, out faceptr );
			if (retb!=0) return;

			face=(Face)Marshal.PtrToStructure( faceptr, typeof(Face) );
			
			//Freetype measures the font size in 1/64th of pixels for accuracy 
			//so we need to request characters in size*64
			Face.FT_Set_Char_Size( faceptr, size << 6, size << 6, 96, 96 );
			
			//Provide a reasonably accurate estimate for expected pixel sizes
			//when we later on create the bitmaps for the font
			Face.FT_Set_Pixel_Sizes( faceptr, size, size );
			
			// Once we have the face loaded and sized we generate opengl textures 
			// from the glyphs  for each printable character
			textures = new int[128];
			extent_x = new int[128];
			list_base = Gl.glGenLists(128);
			Gl.glGenTextures( 128, textures );
			for(int c=0;c<128;c++) {
				Compile_Character( face, faceptr, c);
			}
			
			// Dispose of these as we don't need
			Face.FT_Done_Face(faceptr);
	    	Library.FT_Done_FreeType(libptr);
	    }
	    
	    public void Compile_Character( Face face, System.IntPtr faceptr, int c )
	    {
	    
	    	//We first convert the number index to a character index
	    	int index = Face.FT_Get_Char_Index( faceptr, Convert.ToChar(c) );
	    	
	    	//Here we load the actual glyph for the character
	    	int ret = Face.FT_Load_Glyph( faceptr, index, FT_LOAD_TYPES.FT_LOAD_DEFAULT );
	    	if (ret!=0) return;
	    	
	    	//Convert the glyph to a bitmap
	    	System.IntPtr glyph;
	    	int retb = Glyph.FT_Get_Glyph( face.glyphrec, out glyph );
	    	if (retb!=0) return;	    	
	    	//GlyphRec glyph_rec=(GlyphRec)Marshal.PtrToStructure( face.glyphrec, typeof(GlyphRec) );
	    	
	    	Glyph.FT_Glyph_To_Bitmap( out glyph, FT_RENDER_MODES.FT_RENDER_MODE_NORMAL, 0, 1 );
	    	BitmapGlyph glyph_bmp=(BitmapGlyph)Marshal.PtrToStructure( glyph, typeof(BitmapGlyph) );
			int size = (glyph_bmp.bitmap.width * glyph_bmp.bitmap.rows);
			if (size <= 0) {
			
				//space is a special `blank` character
				extent_x[c] = 0;
				if (c==32) {
					Gl.glNewList( (uint)(list_base+c), Gl.GL_COMPILE );
					Gl.glTranslatef(font_size >> 1 ,0,0);
					extent_x[c] = font_size >> 1;						
					Gl.glEndList();					
				}
				return;
				
			}
			
	    	byte[] bmp = new byte[ size ];
	    	Marshal.Copy( glyph_bmp.bitmap.buffer, bmp, 0, bmp.Length );

	    	//Next we expand the bitmap into an opengl texture 	    	
	    	int width = next_po2( glyph_bmp.bitmap.width );
	    	int height = next_po2( glyph_bmp.bitmap.rows );
	    	byte[] expanded = new byte[ 2 * width * height ];
	    	for( int j=0; j < height; j++ ) {
	    		for( int i=0; i < width; i++) {
	    			expanded[2*(i+j*width)] = expanded[2*(i+j*width)+1] = 
	    				(i>=glyph_bmp.bitmap.width || j>=glyph_bmp.bitmap.rows) ?
	    				(byte)0 : bmp[i+glyph_bmp.bitmap.width*j];
	    		}
	    	}
	    	
	    	//Set up some texture parameters for opengl
	    	Gl.glBindTexture( Gl.GL_TEXTURE_2D, textures[c] );
	    	Gl.glTexParameteri( Gl.GL_TEXTURE_2D, Gl.GL_TEXTURE_MAG_FILTER, Gl.GL_LINEAR );
	    	Gl.glTexParameteri( Gl.GL_TEXTURE_2D, Gl.GL_TEXTURE_MIN_FILTER, Gl.GL_LINEAR );

			//Create the texture
			Gl.glTexImage2D( Gl.GL_TEXTURE_2D, 0, Gl.GL_RGBA, width, height,
				0, Gl.GL_LUMINANCE_ALPHA, Gl.GL_UNSIGNED_BYTE, expanded );
			expanded=null;
    		bmp=null;
			
			//Create a display list and bind a texture to it
			Gl.glNewList( (uint)(list_base+c), Gl.GL_COMPILE );
			Gl.glBindTexture( Gl.GL_TEXTURE_2D, textures[c] );			
			
			//Account for freetype spacing rules
			Gl.glTranslatef(glyph_bmp.left,0,0);
			Gl.glPushMatrix();
			Gl.glTranslatef(0,glyph_bmp.top-glyph_bmp.bitmap.rows,0);
			float x=(float)glyph_bmp.bitmap.width / (float)width;
			float y=(float)glyph_bmp.bitmap.rows / (float)height;

			//Draw the quad
			Gl.glBegin(Gl.GL_QUADS);
			Gl.glTexCoord2d(0,0); Gl.glVertex2f(0,glyph_bmp.bitmap.rows);
			Gl.glTexCoord2d(0,y); Gl.glVertex2f(0,0);
			Gl.glTexCoord2d(x,y); Gl.glVertex2f(glyph_bmp.bitmap.width,0);
			Gl.glTexCoord2d(x,0); Gl.glVertex2f(glyph_bmp.bitmap.width,glyph_bmp.bitmap.rows);
			Gl.glEnd();
			Gl.glPopMatrix();

			//Advance for the next character			
			Gl.glTranslatef(glyph_bmp.bitmap.width,0,0);
			extent_x[c] = glyph_bmp.left+glyph_bmp.bitmap.width; 						
			Gl.glEndList(); 
	    	    		    			
	    } 
	    
	    public void Dispose()
	    {
	    	Gl.glDeleteLists(list_base, 128);
	    	Gl.glDeleteTextures(128, textures);
	    	textures = null;
	    	extent_x = null;	    	
	    }
	    
		internal int next_po2( int a )
		{
			int rval=1;
			while (rval<a) rval<<=1;
			return rval;
		}
		
		internal void push_scm() 
		{
			Gl.glPushAttrib(Gl.GL_TRANSFORM_BIT);
			int[] viewport = new int[4];
			Gl.glGetIntegerv(Gl.GL_VIEWPORT, viewport);
			Gl.glMatrixMode(Gl.GL_PROJECTION);
			Gl.glPushMatrix();
			Gl.glLoadIdentity();
			Gl.glOrtho(viewport[0],viewport[2],viewport[1],viewport[3], 0, 1);
			Gl.glPopAttrib();			
			viewport=null;
		}
		
		internal void pop_pm()
		{
			Gl.glPushAttrib(Gl.GL_TRANSFORM_BIT);
			Gl.glMatrixMode(Gl.GL_PROJECTION);
			Gl.glPopMatrix();
			Gl.glPopAttrib();			
		}
		
		public int extent( string what ) 
		{
			int ret = 0;
			for (int c=0; c<what.Length; c++) 
				ret += extent_x[ what[c] ];
			return ret;
		}
		
		public void print( float x, float y, string what ) 
		{
		
			int font = list_base;
			
			//Prepare openGL for rendering the font characters
			push_scm();
			Gl.glPushAttrib(Gl.GL_LIST_BIT | Gl.GL_CURRENT_BIT  | Gl.GL_ENABLE_BIT | Gl.GL_TRANSFORM_BIT);
			Gl.glMatrixMode(Gl.GL_MODELVIEW);
			Gl.glDisable(Gl.GL_LIGHTING);
			Gl.glEnable(Gl.GL_TEXTURE_2D);
			Gl.glDisable(Gl.GL_DEPTH_TEST);
			Gl.glEnable(Gl.GL_BLEND);
			Gl.glBlendFunc(Gl.GL_SRC_ALPHA, Gl.GL_ONE_MINUS_SRC_ALPHA);
			Gl.glListBase(font);
			float[] modelview_matrix = new float[16];
			Gl.glGetFloatv(Gl.GL_MODELVIEW_MATRIX, modelview_matrix);
        	Gl.glPushMatrix();
        	Gl.glLoadIdentity();
        	Gl.glTranslatef(x,y,0);
        	Gl.glMultMatrixf(modelview_matrix);
        	
        	//Render
        	byte []textbytes = new byte[what.Length];
        	for (int i=0; i<what.Length; i++)
        		textbytes[i] = (byte)what[i];
			Gl.glCallLists(what.Length, Gl.GL_UNSIGNED_BYTE, textbytes );
			textbytes=null;
			
			//Restore openGL state
			Gl.glPopMatrix();			
			Gl.glPopAttrib();			
			pop_pm();	
			
		}
				
	}
	
}