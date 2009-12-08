using System;
using System.Runtime.InteropServices;
using FreeTypeWrap;

namespace FreeType
{

	// A true 3D Font 
	public class FreeTypeFont : IDisposable
	{

    	//Public members
    	private int font_size;
	    private IntPtr libptr;
	    private IntPtr faceptr;
        public Face face;
	    public BitmapGlyph faceglyph;
	    public byte[] bmp;
        

        public FreeTypeFont(string font, int size) 
	    {
	    	// Save the size we need it later on when printing
	    	font_size=size;	    	

			// We begin by creating a library pointer
					
			int ret = Library.FT_Init_FreeType(out libptr);
            if (ret != 0) throw new Exception("Library creation failed!"); ;
			//Library lib=(Library)Marshal.PtrToStructure( libptr, typeof(Library) );
			
			
			//Once we have the library we create and load the font face
			
			int retb = Face.FT_New_Face( libptr, font, 2, out faceptr );
			if (retb!=0) throw new Exception("Face creation failed!");

			face=(Face)Marshal.PtrToStructure( faceptr, typeof(Face) );
			
			//Freetype measures the font size in 1/64th of pixels for accuracy 
			//so we need to request characters in size*64
			Face.FT_Set_Char_Size(faceptr, size << 6, size << 6, 96, 96 );
			
			//Provide a reasonably accurate estimate for expected pixel sizes
			//when we later on create the bitmaps for the font
			Face.FT_Set_Pixel_Sizes(faceptr, size, size );

            int index = Face.FT_Get_Char_Index(faceptr, Convert.ToInt32('Çü'));
            ret = Face.FT_Load_Glyph(faceptr, index,
                                    FT_LOAD_TYPES.FT_LOAD_DEFAULT);
            if (ret != 0) throw new Exception("Loading glyph failed!"); ;


            ret = Glyph.FT_Render_Glyph(face.glyphrec, FT_RENDER_MODES.FT_RENDER_MODE_NORMAL);

            Console.WriteLine(face.glyphrec.bitmap.width);

            //Convert the glyph to a bitmap
            //IntPtr glyph;
            //ret = Glyph.FT_Get_Glyph(face.glyphrec, out glyph);
            //if (ret != 0) throw new Exception("Converting glyph failed!"); 
            //GlyphRec glyph_rec=(GlyphRec)Marshal.PtrToStructure( face.glyphrec, typeof(GlyphRec) );

            //Glyph.FT_Glyph_To_Bitmap(out glyph, FT_RENDER_MODES.FT_RENDER_MODE_NORMAL, 0, 1);
            //faceglyph = (BitmapGlyph)Marshal.PtrToStructure(glyph, typeof(BitmapGlyph));
            
            //int bufsize = (faceglyph.bitmap.width * faceglyph.bitmap.rows);

            //this.bmp = new byte[bufsize];
            //Marshal.Copy(faceglyph.bitmap.buffer, bmp, 0, bmp.Length);
	    }




        #region IDisposable Members

        public void Dispose()
        {
            Face.FT_Done_Face(faceptr);
            Library.FT_Done_FreeType(libptr);
        }

        #endregion
    }
	
}