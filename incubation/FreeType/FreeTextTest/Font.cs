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
        private Face face;

        public FreeTypeFont(string font, int size) 
	    {
	    	// Save the size we need it later on when printing
	    	font_size=size;	    	

			// We begin by creating a library pointer
					
			int ret = Library.FT_Init_FreeType(out libptr);
            if (ret != 0) throw new Exception("Library creation failed!"); ;
			//Library lib=(Library)Marshal.PtrToStructure( libptr, typeof(Library) );
			
			
			//Once we have the library we create and load the font face
			
			int retb = Face.FT_New_Face( libptr, font, 0, out faceptr );
			if (retb!=0) throw new Exception("Face creation failed!");

			face=(Face)Marshal.PtrToStructure( faceptr, typeof(Face) );
			
			//Freetype measures the font size in 1/64th of pixels for accuracy 
			//so we need to request characters in size*64
			Face.FT_Set_Char_Size( faceptr, size << 6, size << 6, 96, 96 );
			
			//Provide a reasonably accurate estimate for expected pixel sizes
			//when we later on create the bitmaps for the font
			Face.FT_Set_Pixel_Sizes( faceptr, size, size );
					
			
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