﻿using System;
using System.Drawing;
using System.Windows.Forms;
using SampleFramework;
using SlimDX.Direct3D9;
using INovelEngine.Core;
using INovelEngine.StateManager;
using INovelEngine.Script;
using System.Collections.Generic;

namespace INovelEngine
{
    class Supervisor : Game
    {
        const int InitialWidth = 800;
        const int InitialHeight = 600;

        private GameState activeState;
        Dictionary<String, GameState> states = new Dictionary<string, GameState>();
        //Texture bgImg;
        //Texture charImg;
        //Sprite sprite;

        /*
        TextWindow testWindow = null;
        ImageWindow testWindow2 = new ImageWindow(Color.MediumBlue, 200, 10, 390, 780, 200, 0, "Test2", 20);
        Transition testTransition = new Transition();
        */

        //SpriteBase testSprite = new SpriteBase("testsprite.png", 100, 100, 0, false);


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



            ScriptManager.Init();
            this.RegisterLuaGlue();



            LoadState("Resources/Test.lua");
            LoadState("Resources/Test2.lua");


            ////ScriptManager.lua.DoString("Test();");
            //Components.Add(CreateState("Resources/Test2.lua"));
            //LuaEventHandler test2 = ScriptManager.lua.GetFunction(typeof(LuaEventHandler), "Test") as LuaEventHandler;
            ////ScriptManager.lua.DoString("Test();");
            //test1();
            //test2();
            //Resources.Add(teststate);

            //GraphicsDeviceManager.ChangeDevice(DeviceVersion.Direct3D9, true, InitialWidth, InitialHeight);

            this.Window.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.Window.MaximizeBox = false;

            Clock.AddTimeEvent(new TimeEvent(1000f, getFPS));
            //testTransition.FadeOutIn(800, 600, 1000, Color.Black);

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
            settings.EnableVSync = true;
#else
            settings.EnableVSync = true;
#endif
            //settings.MultisampleType = MultisampleType.EightSamples;
            settings.MultisampleType = MultisampleType.None;

            GraphicsDeviceManager.ChangeDevice(settings);
        }

        public void Test()
        {
            //ImageWindow testWindow2 = new ImageWindow(Color.MediumBlue, 200, 10, 390, 780, 200, 0, "Test2", 20);
            //Resources.Add(testWindow2);
            //Components.Add(testWindow2);
            // testWindow2.BeginNarrate("Test  試験（しけん)\n시험중입니다. Test  試験（しけん) 시험중입니다.", 50);
            //testTransition.LaunchTransition(800, 600, 400, true, Color.White);
        }

        void Window_KeyDown(object sender, KeyEventArgs e)
        {
            Console.WriteLine(e.KeyCode.ToString());
            activeState.SendEvent(ScriptEvents.KeyPress, e.KeyValue);
            
            //eventhandler(ScriptEvents.KeyPress, e.KeyValue);
            
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
            //    //testTransition.LaunchTransition(800, 600, 400, true, Color.White);
            //    //testTransition.FadeOutIn(InitialWidth, InitialHeight, 3000, Color.White);
            //    //testSprite.LaunchTransition(200, true, Color.White);
            //}
        }

        protected override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            if (this.activeState != null)
            {
                this.activeState.Update(gameTime);
            }

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
            Device.BeginScene();

            Device.Clear(ClearFlags.Target | ClearFlags.ZBuffer, ClearColor, 1.0f, 0);

            //sprite.Begin(SpriteFlags.AlphaBlend);

            //sprite.Draw(this.bgImg, Color.White);
            
            //sprite.End();

            base.Draw(gameTime);

            if (this.activeState != null)
            {
                this.activeState.Draw();
            }

            //testSprite.Draw();

            //if (testWindow != null) testWindow.Draw();
            //testWindow2.Draw();

            //testTransition.Draw();


            Device.EndScene();


        }

        protected override void Initialize()
        {
            base.Initialize();
            
            
            //this.sprite = new Sprite(Device);
            //this.bgImg = Texture.FromFile(Device, "bg.png");
            //this.charImg = Texture.FromFile(Device, "testsprite.png");
            
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

        protected void RegisterLuaGlue()
        {
            ScriptManager.lua.RegisterFunction("TestTest", this, this.GetType().GetMethod("TestTest"));
            ScriptManager.lua.RegisterFunction("AddState", this, this.GetType().GetMethod("Lua_AddState"));
            ScriptManager.lua.RegisterFunction("SwitchState", this, this.GetType().GetMethod("Lua_SwitchState"));
        }

        public void LoadState(String ScriptFile)
        {
            ScriptManager.lua.DoFile(ScriptFile);
        }

        public void Lua_SwitchState(String id)
        {
            if (states.ContainsKey(id))
            {
                this.activeState = states[id];
            }
        }

        public void Lua_AddState(GameState state)
        {
            if (states.ContainsKey(state.id))
            {
            }
            else
            {
                states.Add(state.id, state);
            }

            this.activeState = state;
            Resources.Add(state);
            state.eventhandler = ScriptManager.lua.GetFunction(typeof(LuaEventHandler), "EventHandler") as LuaEventHandler;
        }

        public void TestTest(String s)
        {  
            Console.WriteLine(">" + s);
        }

    }
}
