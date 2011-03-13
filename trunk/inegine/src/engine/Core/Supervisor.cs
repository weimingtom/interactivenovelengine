using System;
using System.Collections.ObjectModel;
using System.Drawing;
using System.Windows.Forms;
using INovelEngine.Effector;
using INovelEngine.Effector.Audio;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using INovelEngine.Core;
using INovelEngine.StateManager;
using INovelEngine.Script;
using System.Collections.Generic;
using INovelEngine.ResourceManager;

namespace INovelEngine
{
    class Supervisor : Game
    {
        static int InitialWidth = 800;
        static int InitialHeight = 600;

        private GameState activeState;

        private Dictionary<String, GameState> states = new Dictionary<string, GameState>();

        //private Stack<GameState> stateStack = new Stack<GameState>();
        private List<GameState> stateList = new List<GameState>();

        private FontManager fontManager = new FontManager();
        private CsvManager csvManager = new CsvManager();

        private FadingTransition fadingTransition = new FadingTransition();

        private static Queue<LuaEventHandler> defferedCallList = new Queue<LuaEventHandler>();

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
            Window.KeyDown += new KeyEventHandler(Window_KeyDown);
            Window.MouseDown += new MouseEventHandler(Window_MouseDown);
            Window.MouseUp += new MouseEventHandler(Window_MouseUp);
            Window.MouseMove += new MouseEventHandler(Window_MouseMove);
            Window.MouseClick += new MouseEventHandler(Window_MouseClick);

            // init device
            InitDevice();

            this.RegisterLuaGlue();

            SoundPlayer.Init();
            SoundPlayer.SetVolume(50);

            ScriptManager.Init();

            Resources.Add(fontManager);
            Resources.Add(csvManager);
            Resources.Add(fadingTransition);

            /* load lua entry script */
            //Lua_LoadScript("Resources/start.lua");
            Lua_LoadScript("zip://Resources/test.zip|start.lua");
            

            this.Window.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.Window.MaximizeBox = false;

#if DEBUG
            Clock.AddTimeEvent(new TimeEvent(1000, displayFPS));
#endif         
        }

        protected override void OnExiting(EventArgs e)
        {
            base.OnExiting(e);
        }

        protected override void Dispose(bool disposing)
        {
            Console.WriteLine("disposing supervisor!");
            base.Dispose(disposing);

            DumpObjects();

            Console.WriteLine("supervisor disposed!");
        }
  
        public static void DumpObjects()
        {
            ReadOnlyCollection<ComObject> table = ObjectTable.Objects;
            foreach (ComObject obj in table)
            {
                Console.WriteLine(obj.GetType().ToString() + ":" + obj.CreationTime.ToString());
            }
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

        #region Keyboard Input Handler

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

            //for (int i = 0; i < stateList.Count; i++)
            //{
            //    stateList[i].Update(gameTime);
            //}

            //activeState.SendEvent(ScriptEvents.Update, Clock.GetTime());

            Clock.Tick();

            // call deferred calls
            while (defferedCallList.Count > 0)
            {
                LuaEventHandler luaEvent = defferedCallList.Dequeue();
                try
                {
                    luaEvent(this, ScriptEvents.AnimationOver, null);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
            }

            fadingTransition.Update();
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


            //GameState[] stateList = stateStack.ToArray();
            //for (int i = 0; i < stateList.Count; i++)
            //{
            //    stateList[i].Draw();
            //}


            fadingTransition.Draw();
            Device.EndScene();
        }

        private void displayFPS()
        {
            this.Window.Text = Clock.GetFPS().ToString();
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

        public static void CallLater(LuaEventHandler luaEvent)
        {
            defferedCallList.Enqueue(luaEvent);
        }

        #region Lua core bindings

        protected void RegisterLuaGlue()
        {

            ScriptManager.lua.RegisterFunction("SetIcon", this, this.GetType().GetMethod("Lua_SetIcon"));
            ScriptManager.lua.RegisterFunction("SetTitle", this, this.GetType().GetMethod("Lua_SetTitle"));


            ScriptManager.lua.RegisterFunction("SetSize", this, this.GetType().GetMethod("Lua_SetSize"));
            ScriptManager.lua.RegisterFunction("GetWidth", this, this.GetType().GetMethod("Lua_GetWidth"));
            ScriptManager.lua.RegisterFunction("GetHeight", this, this.GetType().GetMethod("Lua_GetHeight"));

            ScriptManager.lua.RegisterFunction("Trace", this, this.GetType().GetMethod("Lua_Trace"));


            ScriptManager.lua.RegisterFunction("LoadScript", this, this.GetType().GetMethod("Lua_LoadScript"));
            ScriptManager.lua.RegisterFunction("CloseState", this, this.GetType().GetMethod("Lua_CloseState"));

            ScriptManager.lua.RegisterFunction("SwitchState", this, this.GetType().GetMethod("Lua_SwitchState"));
            ScriptManager.lua.RegisterFunction("LoadState", this, this.GetType().GetMethod("Lua_LoadState"));
            ScriptManager.lua.RegisterFunction("CurrentState", this, this.GetType().GetMethod("Lua_CurrentState"));

            ScriptManager.lua.RegisterFunction("Supervisor", this, this.GetType().GetMethod("Lua_Supervisor"));
            ScriptManager.lua.RegisterFunction("FontManager", this, this.GetType().GetMethod("Lua_FontManager"));
            ScriptManager.lua.RegisterFunction("CsvManager", this, this.GetType().GetMethod("Lua_CsvManager"));

            ScriptManager.lua.RegisterFunction("Delay", this, this.GetType().GetMethod("Lua_DelayedCall"));
            ScriptManager.lua.RegisterFunction("LoadESS", this, this.GetType().GetMethod("Lua_LoadESS"));
            ScriptManager.lua.RegisterFunction("EssLine", this, this.GetType().GetMethod("Lua_GetESSLine"));

            ScriptManager.lua.RegisterFunction("SetVolume", this, this.GetType().GetMethod("Lua_SetVolume"));

            ScriptManager.lua.RegisterFunction("GetInput", this, this.GetType().GetMethod("Lua_GetInput"));

            ScriptManager.lua.RegisterFunction("ShowWinCursor", this, this.GetType().GetMethod("Lua_ShowCursor"));
            ScriptManager.lua.RegisterFunction("HideWinCursor", this, this.GetType().GetMethod("Lua_HideCursor"));

            ScriptManager.lua.RegisterFunction("GetFader", this, this.GetType().GetMethod("Lua_GetFader"));

            ScriptManager.lua.RegisterFunction("SaveData", this, this.GetType().GetMethod("Lua_SaveData"));
            ScriptManager.lua.RegisterFunction("LoadData", this, this.GetType().GetMethod("Lua_LoadData"));

        }

        public void SetStateNamespace()
        {
            ScriptManager.lua.DoString("this = CurrentState().State");
        }

        public void Lua_LoadScript(String ScriptFile)
        {
            try
            {
                ScriptManager.DoLua(ScriptFile);
            }
            catch (LuaInterface.LuaException e)
            {
                Console.WriteLine(">" + e.Message);

            }
            catch (Exception e)
            {
                Console.WriteLine("]" + e.Message);
            }
        }

        /* create a new state and initialize the state using given lua script */
        public void Lua_LoadState(String stateName, String ScriptFile)
        {
            GameState newState = new GameState();
            newState.Name = stateName;
            newState.OnStarting();
            this.activeState = newState;  // set the new state as the active state

            ScriptManager.lua.DoString("CurrentState().State = {}"); // initialize state table

            SetStateNamespace(); // set the namespace

            AddState(newState);
            Lua_LoadScript(ScriptFile);
        }

        public void Lua_SwitchState(String id)
        {
            if (states.ContainsKey(id))
            {
                this.activeState = states[id];
            }
        }

        public void Lua_CloseState()
        {

            if (stateList.Count <= 0)
            {
                throw new Exception("no more state to be removed!");
            }

            GameState removedState = stateList[stateList.Count - 1];//stateStack.Pop();
            stateList.Remove(removedState);
            states.Remove(removedState.Name);
            Resources.Remove(removedState);
            removedState.OnExiting();

            if (stateList.Count > 0)
            {
                this.activeState = stateList[stateList.Count - 1];//stateStack.Peek();
                SetStateNamespace();
            }
        }

        public void AddState(GameState state)
        {
            if (states.ContainsKey(state.Name))
            {
                throw new Exception("duplicate state name exists!");
            }

            states.Add(state.Name, state);
            
            stateList.Add(state);
            //stateStack.Push(state);


            this.activeState = state;
            SetStateNamespace();

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

        public string Lua_GetESSLine(String path, int lineNumber)
        {
            return ScriptManager.GetESSLine(path, lineNumber);
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

        public void Lua_DelayedCall(float delay, LuaEventHandler Do)
        {
            ScriptManager.WaitDo(delay, Do);
        }

        public Supervisor Lua_Supervisor()
        {
            return this;
        }

        public void Lua_SetVolume(int volumePercentage)
        {
            SoundPlayer.SetVolume(volumePercentage);
        }

        public FontManager Lua_FontManager()
        {
            return this.fontManager;
        }

        public CsvManager Lua_CsvManager()
        {
            return this.csvManager;
        }

        public void Lua_HideCursor()
        {
            Cursor.Hide();
        }


        public void Lua_ShowCursor()
        {
            Cursor.Show();
        }

        public FadingTransition Lua_GetFader()
        {
            return this.fadingTransition;
        }

        public void Lua_SaveData(String data, String path)
        {
            SaveManager.SaveData(data, path);
        }

        public String Lua_LoadData(String path)
        {
            return SaveManager.LoadData(path);
        }

        public String Lua_GetInput(Boolean numeric)
        {
            String result = "";
            using (TextInput inputForm = new TextInput())
            {
                inputForm.numeric = numeric;
                DialogResult dialogResult = inputForm.ShowDialog();
                if (dialogResult == DialogResult.Cancel)
                {
                    result = null;
                }
                else
                {
                    result = inputForm.value;
                }
            }
            return result;
        }

        #endregion

    }


}
