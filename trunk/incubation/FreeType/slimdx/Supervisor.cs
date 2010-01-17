using System;
using System.Drawing;
using System.Windows.Forms;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using LuaInterface;
using INovelEngine.Effector.Graphics.Text;
using Font=SlimDX.Direct3D9.Font;

namespace INovelEngine
{
    class Supervisor : Game
    {
        const int InitialWidth = 800;
        const int InitialHeight = 600;

        private FreeFont testtext;

        Texture bgImg;
        Texture cursor;
        Sprite sprite;
        private Font dxfont;

        /*
        TextWindow testWindow = null;
        ImageWindow testWindow2 = new ImageWindow(_color.MediumBlue, 200, 10, 390, 780, 200, 0, "Test2", 20);
        Transition testTransition = new Transition();
        */

        //SpriteBase testSprite = new SpriteBase("testsprite.png", 100, 100, 0, false);

        Lua lua = new Lua();

        public Device Device
        {
            get { return GraphicsDeviceManager.Direct3D9.Device; }
        }

        public Color ClearColor
        {
            get;
            set;
        }

        public Supervisor()
        {
            ClearColor = Color.White;

            Window.ClientSize = new Size(InitialWidth, InitialHeight);
            
            Window.Text = "SlimDX - Test Project";

            Window.KeyDown += Window_KeyDown;

            // init device
            InitDevice();

            /*
            Resources.Add(testWindow2);
            Resources.Add(testTransition);
            Resources.Add(testSprite);
            */

            
            //GraphicsDeviceManager.ChangeDevice(DeviceVersion.Direct3D9, true, InitialWidth, InitialHeight);

            this.Window.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.Window.MaximizeBox = false;

            Clock.AddTimeEvent(new TimeEvent(1000f, getFPS));
            //testTransition.FadeOutIn(800, 600, 1000, _color.Black);

            //lua.RegisterFunction("Fade", this, this.GetType().GetMethod("Test"));

            
        }

        private void InitDevice()
        {
            DeviceSettings settings = new DeviceSettings();
            settings.BackBufferWidth = InitialWidth;
            settings.BackBufferHeight = InitialHeight;
            settings.DeviceVersion = DeviceVersion.Direct3D9;
            settings.Windowed = true;
#if DEBUG
            settings.EnableVSync = false;
#else
            settings.EnableVSync = true;
#endif
            //settings.MultisampleType = MultisampleType.EightSamples;
            settings.MultisampleType = MultisampleType.None;

            GraphicsDeviceManager.ChangeDevice(settings);
        }

        public void Test()
        {
            //ImageWindow testWindow2 = new ImageWindow(_color.MediumBlue, 200, 10, 390, 780, 200, 0, "Test2", 20);
            //Resources.Add(testWindow2);
            //Components.Add(testWindow2);
            // testWindow2.BeginNarrate("Test  試験（しけん)\n시험중입니다. Test  試験（しけん) 시험중입니다.", 50);
            //testTransition.LaunchTransition(800, 600, 400, true, _color.White);
        }

        void Window_KeyDown(object sender, KeyEventArgs e)
        {
            //// F1 toggles between full screen and windowed mode
            //// Escape quits the application
            //if (e.KeyCode == Keys.F1)
            //    GraphicsDeviceManager.ToggleFullScreen();
            //else if (e.KeyCode == Keys.Escape)
            //    Exit();
            //else if (e.KeyCode == Keys.Space)
            //{
            //    lua.DoString("Fade();");
            //    //testWindow2.BeginNarrate("Test  試験（しけん)\n시험중입니다. Test  試験（しけん) 시험중입니다.", 50);
            //    //testTransition.LaunchTransition(800, 600, 400, true, _color.White);
            //    //testTransition.FadeOutIn(InitialWidth, InitialHeight, 3000, _color.White);
            //    //testSprite.LaunchTransition(200, true, _color.White);
            //}
        }

        protected override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            Clock.Tick();
        }

        private void getFPS()
        {
#if DEBUG
            this.Window.Text = Clock.GetFPS().ToString();
#endif
        }

        protected override void Draw(GameTime gameTime)
        {
            float startTime = Clock.GetTime();

            Device.BeginScene();

            Device.Clear(ClearFlags.Target | ClearFlags.ZBuffer, ClearColor, 1.0f, 0);

            sprite.Begin(SpriteFlags.AlphaBlend);
            sprite.Draw(this.bgImg, Color.White);


            //dxfont.DrawString(sprite, "가나다\n라마바\n사가나\n다라마\n바사가\n나다라\n마바사\n가나다\n라마바\n사가나\n다라마\n바사", 0, 0, Color.White.ToArgb());
            testtext.Wrap = false;
            testtext.DrawString(sprite, "가나다[r=test]가[/r]나다[col=#FF0000]마[col=#00FF00]바[/col]자[/col]하[/col]자", 0, 0);
            Vector2 lastpos = testtext.LastPos;
            lastpos.Y = lastpos.Y - 32;
            sprite.Draw(this.cursor, new Vector3(0, 0, 0), new Vector3(lastpos, 0), Color.White);


            testtext.Wrap = true;
            testtext.DrawString(sprite, "[r]가[/r]나다[col=#FF0000]마[col=#00FF00]바[/col]자[/col]하[/col]자", 0, 200);
            Vector2 lastpos2 = testtext.LastPos;
            lastpos2.Y = lastpos2.Y - 32 + 200;
            sprite.Draw(this.cursor, new Vector3(0, 0, 0), new Vector3(lastpos2, 0), Color.White);

            sprite.End();

            //testSprite.Draw();

            //if (testWindow != null) testWindow.Draw();
            //testWindow2.Draw();

            //testTransition.Draw();



            base.Draw(gameTime);

            Device.EndScene();

            float timeTaken = Clock.GetTime() - startTime;
            if (timeTaken != 0) Console.WriteLine(timeTaken);

        }

        protected override void Initialize()
        {
            
            base.Initialize();
            testtext = new FreeFont(Device, "c:\\windows\\fonts\\gulim.ttc", 32)
                           {
                               LineSpacing = 5,
                               WrapWidth = 100,
                               Color = Color.DimGray
                           };
            this.sprite = new Sprite(Device);
            this.bgImg = Texture.FromFile(Device, "bg.png");
            this.cursor = Texture.FromFile(Device, "cursor.png");
            this.dxfont = new SlimDX.Direct3D9.Font(Device, 30, 0, FontWeight.UltraBold, 1, false, CharacterSet.ShiftJIS,
                                                 Precision.Default, FontQuality.ClearType, PitchAndFamily.Default,
                                                  "MS P gothic");
            
        }

        protected override void LoadContent()
        {
            //this.sprite = new Sprite(Device);
            base.LoadContent();
        }

        protected override void UnloadContent()
        {
            //this.sprite.Dispose();
            base.UnloadContent();
        }

    }
}
