using System;
using System.Drawing;
using System.Windows.Forms;
using INovelEngine.Effector;
using INovelEngine.Effector.Audio;
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
        static int InitialWidth = 800;
        static int InitialHeight = 600;

        private GameState activeState;
        Dictionary<String, GameState> states = new Dictionary<string, GameState>();

        //Texture bgImg;
        //Texture charImg;
        //Sprite sprite;

        /*
        TextWindow testWindow = null;
        ImageWindow testWindow2 = new ImageWindow(Color.MediumBlue, 200, 10, 390, 780, 200, 0, "Test2", 20);
        
        */

        //FadingTransition testTransition = new FadingTransition();

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
            //Window.Text = "SlimDX - Test Project";
            Window.KeyDown += new KeyEventHandler(Window_KeyDown);
            Window.MouseDown += new MouseEventHandler(Window_MouseDown);
            Window.MouseUp += new MouseEventHandler(Window_MouseUp);
            Window.MouseMove += new MouseEventHandler(Window_MouseMove);
            Window.MouseClick += new MouseEventHandler(Window_MouseClick);

            // init device
            InitDevice();

            this.RegisterLuaGlue();

            SoundManager.Init();
            
            ScriptManager.Init();

            LoadState("Resources/start.lua");

            

            this.Window.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.Window.MaximizeBox = false;

            Clock.AddTimeEvent(new TimeEvent(1000f, getFPS));          
        }

        protected override void OnExiting(EventArgs e)
        {
            SoundManager.Dispose();
            base.OnExiting(e);
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

        #region Input Events

        void Window_KeyDown(object sender, KeyEventArgs e)
        {
            if (activeState != null) activeState.SendEvent(ScriptEvents.KeyPress, e.KeyValue);
        }

        void Window_MouseDown(object sender, MouseEventArgs e)
        {
            if (activeState != null) activeState.SendEvent(ScriptEvents.MouseDown, e.X, e.Y);
        }

        void Window_MouseUp(object sender, MouseEventArgs e)
        {
            if (activeState != null) activeState.SendEvent(ScriptEvents.MouseUp, e.X, e.Y);
        }

        void Window_MouseMove(object sender, MouseEventArgs e)
        {
            if (activeState != null) activeState.SendEvent(ScriptEvents.MouseMove, e.X, e.Y);
        }

        void Window_MouseClick(object sender, MouseEventArgs e)
        {
            if (activeState != null) activeState.SendEvent(ScriptEvents.MouseClick, e.X, e.Y);
        }


        #endregion


        protected override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            if (this.activeState != null)
            {
                this.activeState.Update(gameTime);
                this.activeState.SendEvent(ScriptEvents.Update, Clock.GetTime());
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

            base.Draw(gameTime);

            if (this.activeState != null)
            {
                this.activeState.Draw();
            }

            Device.EndScene();
        }

        protected override void Initialize()
        {
            base.Initialize();
        }

        protected override void LoadContent()
        {
            base.LoadContent();
        }

        protected override void UnloadContent()
        {
            base.UnloadContent();
        }

        protected void RegisterLuaGlue()
        {

            ScriptManager.lua.RegisterFunction("SetIcon", this, this.GetType().GetMethod("Lua_SetIcon"));
            ScriptManager.lua.RegisterFunction("SetTitle", this, this.GetType().GetMethod("Lua_SetTitle"));


            ScriptManager.lua.RegisterFunction("SetSize", this, this.GetType().GetMethod("Lua_SetSize"));
            ScriptManager.lua.RegisterFunction("GetWidth", this, this.GetType().GetMethod("Lua_GetWidth"));
            ScriptManager.lua.RegisterFunction("GetHeight", this, this.GetType().GetMethod("Lua_GetHeight"));

            ScriptManager.lua.RegisterFunction("Trace", this, this.GetType().GetMethod("Lua_Trace"));

            ScriptManager.lua.RegisterFunction("AddState", this, this.GetType().GetMethod("Lua_AddState"));
            ScriptManager.lua.RegisterFunction("SwitchState", this, this.GetType().GetMethod("Lua_SwitchState"));
            ScriptManager.lua.RegisterFunction("LoadState", this, this.GetType().GetMethod("Lua_LoadState"));
            ScriptManager.lua.RegisterFunction("CurrentState", this, this.GetType().GetMethod("Lua_CurrentState"));

            ScriptManager.lua.RegisterFunction("Supervisor", this, this.GetType().GetMethod("Lua_Supervisor"));
            
            ScriptManager.lua.RegisterFunction("Delay", this, this.GetType().GetMethod("Lua_DelayedCall"));
            ScriptManager.lua.RegisterFunction("LoadESS", this, this.GetType().GetMethod("Lua_LoadESS"));

            ScriptManager.lua.RegisterFunction("LoadSound", this, this.GetType().GetMethod("Lua_LoadSound"));
            ScriptManager.lua.RegisterFunction("PlaySound", this, this.GetType().GetMethod("Lua_PlaySound"));
            ScriptManager.lua.RegisterFunction("StopSound", this, this.GetType().GetMethod("Lua_StopSound"));
        
        }

        public void LoadState(String ScriptFile)
        {
            try
            {
                ScriptManager.lua.DoFile(ScriptFile);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }
        }

        public void Lua_LoadState(String stateName, String ScriptFile)
        {
            GameState newState = new GameState();
            newState.Name = stateName;
            Lua_AddState(newState);
            LoadState(ScriptFile);
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
            if (states.ContainsKey(state.Name))
            {
                throw new Exception("duplicate state name exists!");
            }

            states.Add(state.Name, state);
            this.activeState = state;
            Resources.Add(state);
        }

        public GameState Lua_CurrentState()
        {
            return this.activeState;
        }

        public void Lua_Trace(String s)
        {  
            Console.WriteLine(">" + s);
        }

        public string Lua_LoadESS(String path)
        {
            string result = null;
            try
            {
                result = ScriptManager.ParseESS(path);
                Console.WriteLine(result);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            return result;
        }

        public void Lua_SetTitle(String s)
        {
            Window.Text = s;
        }

        public void Lua_SetIcon(String s)
        {
            Window.Icon = new System.Drawing.Icon(s);
        }

        public void Lua_SetSize(int width, int height)
        {
            InitialWidth = width;
            InitialHeight = height;
            Window.ClientSize = new Size(width, height);
        }

        public int Lua_GetWidth()
        {
            return Window.ClientSize.Width;
        }

        public int Lua_GetHeight()
        {
            return Window.ClientSize.Height;
        }

        public void Lua_LoadSound(String id, String s)
        {
            SoundManager.LoadSound(id, s);
        }

        public void Lua_PlaySound(String id, Boolean loop)
        {
            SoundManager.PlaySound(id, loop);
        }

        public void Lua_StopSound(String id)
        {
            SoundManager.StopSound(id);
        }

        public void Lua_DelayedCall(float delay, LuaEventHandler Do)
        {
            ScriptManager.WaitDo(delay, Do);
        }

        public Supervisor Lua_Supervisor()
        {
            return this;
        }


    }
}
