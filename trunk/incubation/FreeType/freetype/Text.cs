using System;
using SdlDotNet;
using SdlDotNet.Sprites; 
using Tao.OpenGl;
using FreeType;


public static class Startup
{

	static Font3D smallFont;
	static Font3D largeFont;
	static float cnt1;
	static float cnt2;
	

	///A main application entrypoint
	public static void Main(string[] argv)
	{
	
		//Initialize a double buffered openGL window 
		Gl.glShadeModel(Gl.GL_SMOOTH);
		Gl.glClearColor(0.0F, 0.0F, 0.0F, 0.0F);
		Gl.glClearDepth(1.0F);
		Gl.glEnable(Gl.GL_DEPTH_TEST);
		Gl.glDepthFunc(Gl.GL_LEQUAL);
		Gl.glHint( Gl.GL_PERSPECTIVE_CORRECTION_HINT, Gl.GL_NICEST );
		
		//with SDL
		Video.Initialize();
		Video.GLSetAttribute( SdlDotNet.OpenGLAttr.DoubleBuffer, 1 );
		Video.SetVideoModeWindowOpenGL( 640, 480, false );
		Video.WindowCaption = "FreeType/2";
		
		//Create the fonts we want to use
		smallFont = new Font3D("FreeSans.ttf", 16);
		largeFont = new Font3D("FreeSans.ttf", 48);
		
		//Attach some events
		Events.KeyboardDown += new KeyboardEventHandler(KeyboardDown_Handler);			
		Events.Tick += new TickEventHandler(Tick_Handler);
		
		//Run it!
		Events.Run();		
	}
	
	///A default KeyboardDown event handler
	private static void KeyboardDown_Handler(object sender, KeyboardEventArgs e)
	{
	 	
	 		switch(e.Key)
			{
			
				//Close the app
				case Key.Escape:
					Video.Close();
					Events.QuitApplication();
					break;
			}
					
	}
	
	///A default Tick event handler
	private static void Tick_Handler(object sender, TickEventArgs e)
	{
		render();
		Video.GLSwapBuffers();
	}	
	
	///The main render method
	public static void render()
	{
	
		//Clear display 
	    Gl.glClear(Gl.GL_COLOR_BUFFER_BIT | Gl.GL_DEPTH_BUFFER_BIT);


		//Rotate something about
	    Gl.glColor3ub(0xff,0,0);
	    Gl.glPushMatrix();
	    Gl.glLoadIdentity();
	    Gl.glRotatef(cnt1,0,0,1);    
	    Gl.glScalef(1f,(float).8f+.3f* (float)Math.Cos((double)cnt1/5),1);
	    Gl.glTranslatef(-180,0,0);
	    largeFont.print( 320, 240, "FREE-TYPE / 2" );
	    Gl.glPopMatrix();
	    cnt1+=0.051f;   
	    cnt2+=0.005f;  
	    
		//Center a message
		string s = "You can press ESCAPE to exit the sample.";
		Gl.glColor3ub(0,0xff,0);		
		smallFont.print( 320-(smallFont.extent(s) >> 1), 10, s );

				
	}
	
}

