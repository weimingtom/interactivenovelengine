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
using System.Text;
using AxShockwaveFlashObjects;
using System.Xml;

namespace INovelEngine
{
    class Supervisor : Game
    {
        private static Supervisor instance = null;

        private LuaConsole luaConsole;

        static int InitialWidth = 800;
        static int InitialHeight = 600;

        private GameState activeState;

        private Dictionary<string, GameState> states = new Dictionary<string, GameState>();

        //private Stack<GameState> stateStack = new Stack<GameState>();
        private List<GameState> stateList = new List<GameState>();

        private FontManager fontManager = new FontManager();
        private CsvManager csvManager = new CsvManager();
        private SoundManager soundManager = new SoundManager();
        private LogManager logManager = new LogManager();

        private FadingTransition fadingTransition = new FadingTransition();

        private static Queue<LuaEventHandler> defferedCallList = new Queue<LuaEventHandler>();

        private Sprite sharedSprite;
        private Line sharedLine;

        //flash panel
        private System.Windows.Forms.Panel videoPlaceholder;
        private AxShockwaveFlashObjects.AxShockwaveFlash flashPlayer;
        private LuaEventHandler overHandler;
        private bool playingVideo = false;

        public Device Device
        {
            get { return GraphicsDeviceManager.Direct3D9.Device; }
        }

        public Color ClearColor
        {
            get;
            set;
        }

        // singleton
        static readonly object padlock = new object();
        public static Supervisor GetInstance()
        {
            lock (padlock)
            {
                if (instance == null)
                {
                    instance = new Supervisor();
                }
                return instance;
            }
        }

        private Supervisor()
        {
        }

        public void StartGame()
        {
            ClearColor = Color.White;
            Window.KeyPreview = true;
            Window.ClientSize = new Size(InitialWidth, InitialHeight);
            Window.KeyDown += new KeyEventHandler(Window_KeyDown);
            Window.MouseDown += new MouseEventHandler(Window_MouseDown);
            Window.MouseUp += new MouseEventHandler(Window_MouseUp);
            Window.MouseMove += new MouseEventHandler(Window_MouseMove);
            Window.MouseClick += new MouseEventHandler(Window_MouseClick);
            Window.MouseDoubleClick += new MouseEventHandler(Window_MouseDoubleClick);

            // init device
            InitDevice();

            this.RegisterLuaGlue();

            SoundPlayer.SetVolume(100);

            ScriptManager.Init();

            Resources.Add(fontManager);
            Resources.Add(fadingTransition);

            csvManager.Initialize(this.GraphicsDeviceManager);
            csvManager.LoadContent();
            soundManager.Initialize(this.GraphicsDeviceManager);
            soundManager.LoadContent();

            /* load lua entry script */
            Lua_LoadScript("Resources/start.lua");

            this.Window.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.Window.MaximizeBox = false;

#if DEBUG
            Clock.AddTimeEvent(new TimeEvent(1000, displayFPS));
#endif

#if DEBUG
            luaConsole = new LuaConsole();
            luaConsole.Show();
            //AdjustLuaConsole();
            this.Window.LocationChanged += new EventHandler(Window_LocationChanged);
#endif
            /* initialize flash player panel for displaying videos */
            InitializeFlashPanel();

        }

        private void InitializeFlashPanel()
        {
            this.videoPlaceholder = new System.Windows.Forms.Panel();
            this.flashPlayer = new AxShockwaveFlashObjects.AxShockwaveFlash();
            // 
            // videoPlaceholder
            // 
            this.videoPlaceholder.BackColor = System.Drawing.Color.White;
            this.videoPlaceholder.Controls.Add(this.flashPlayer);
            this.videoPlaceholder.Dock = System.Windows.Forms.DockStyle.Fill;
            this.videoPlaceholder.Location = new System.Drawing.Point(0, 0);
            this.videoPlaceholder.Name = "videoPlaceholder";
            this.videoPlaceholder.Size = new System.Drawing.Size(800, 600);
            this.videoPlaceholder.TabIndex = 6;
            this.videoPlaceholder.Visible = true;
            this.videoPlaceholder.Hide();

            // 
            // flashPlayer
            // 
            this.flashPlayer.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flashPlayer.Enabled = true;
            this.flashPlayer.Location = new System.Drawing.Point(0, 0);
            this.flashPlayer.Name = "flashPlayer";
            this.flashPlayer.Size = new System.Drawing.Size(800, 600);
            this.flashPlayer.TabIndex = 0;

            this.Window.Controls.Add(videoPlaceholder);

        }

        private void LoadVideo(string videoPath)
        {
            Trace("Starting Video playback");
            try
            {
                playingVideo = true;
                this.videoPlaceholder.Show();
                flashPlayer.LoadMovie(0, Application.StartupPath + "\\inovelplayer.dat");
                this.flashPlayer.FlashCall += new _IShockwaveFlashEvents_FlashCallEventHandler(flashPlayer_FlashCall);
            }
            catch (Exception ex)
            {
                Error("Unable to load SWF video player, please verify you have Flash Player 8 installed and try again.");
                Error(ex.Message);
            }
            try
            {
                flashPlayer.CallFunction("<invoke name=\"loadAndPlayVideo\" returntype=\"xml\"><arguments><string>" + videoPath + "</string></arguments></invoke>");
            }
            catch (Exception ex)
            {
                Error("unable to load given video from " + videoPath);
                Error(ex.Message);
            }
            this.Window.Focus();
        }

        private void StopVideo()
        {
            if (playingVideo)
            {
                Trace("Stopping Video playback");
                playingVideo = false;
                flashPlayer.CallFunction("<invoke name=\"stopVideo\" returntype=\"xml\"><arguments></arguments></invoke>");
                videoPlaceholder.Hide();
                if (overHandler != null) overHandler(this, ScriptEvents.Etc, null);
            }
        }

        private void flashPlayer_FlashCall(object sender, _IShockwaveFlashEvents_FlashCallEvent e)
        {
            //XmlDocument document = new XmlDocument();
            //document.LoadXml(e.request);

            //XmlAttributeCollection attributes = document.FirstChild.Attributes;
            //String command = attributes.Item(0).InnerText;

            //switch (command)
            //{
            //    case "VideoOver":
            Trace("Video playback over");
            StopVideo();
            //        break;
            //}
        }

        void Window_LocationChanged(object sender, EventArgs e)
        {
#if DEBUG
            //AdjustLuaConsole();
#endif
        }

        private void AdjustLuaConsole()
        {
            luaConsole.Left = this.Window.Left;
            luaConsole.Top = this.Window.Top + this.Window.Height + 5;
        }

        public Sprite GetSpriteBatch()
        {
            return this.sharedSprite;
        }

        public Line GetLineBatch()
        {
            return this.sharedLine;
        }

        protected override void OnExiting(EventArgs e)
        {
            base.OnExiting(e);

            csvManager.Dispose();
            soundManager.Dispose();
            this.Dispose();

            DumpObjects();
#if DEBUG
            MessageBox.Show("Terminating INE");
#endif
        }

        protected override void Dispose(bool disposing)
        {
            Supervisor.Info("disposing supervisor!");
            base.Dispose(disposing);

            sharedSprite.Dispose();
            sharedLine.Dispose();
            Supervisor.Info("supervisor disposed!");
        }
  
        public static void DumpObjects()
        {
            Supervisor.Info("Dumping undisposed dx objects");
            Supervisor.Info("====");
            ReadOnlyCollection<ComObject> table = ObjectTable.Objects;
            foreach (ComObject obj in table)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(obj.GetType().ToString());
                sb.Append(":");
                sb.Append(obj.CreationTime.ToString());
                sb.Append(":");
                if (obj.Tag != null)
                {
                    sb.Append((string)obj.Tag);

                }
                if (obj.Tag == null || !((string)obj.Tag).StartsWith("[glyph]"))
                {
                    Supervisor.Info(sb.ToString());
                }
            }
            Supervisor.Info("====");
            Supervisor.Info("Dumping undisposed dx objects over");
        }

        public static int CountObjects()
        {
            int numObjects = 0;
            ReadOnlyCollection<ComObject> table = ObjectTable.Objects;
            foreach (ComObject obj in table)
            {
                if (obj.Tag == null || !((string)obj.Tag).StartsWith("[glyph]"))
                {
                    numObjects++;
                }
            }
            return numObjects;
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

        #region Input Handler

        void Window_KeyDown(object sender, KeyEventArgs e)
        {
            StopVideo();

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


        void Window_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            if (activeState != null) activeState.SendEvent(ScriptEvents.MouseDoubleClick, e.X, e.Y);
        }


        #endregion


        protected override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            if (this.activeState != null)
            {
                this.activeState.Update(gameTime);
            }

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
                    Supervisor.Error(e.Message);
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

            fadingTransition.Draw();

            Device.EndScene();
        }

        private void displayFPS()
        {
            StringBuilder output = new StringBuilder();
            output.Append("[DEBUG MODE] FPS: ");
            output.Append(Clock.GetFPS());
            output.Append(" STATES:");
            foreach (GameState state in this.stateList)
            {
                output.Append(" ");
                output.Append(state.Name);
            }
            this.Window.Text = output.ToString();;
        }

        protected override void Initialize()
        {
            base.Initialize();

            sharedSprite = new Sprite(this.Device);
            sharedLine = new Line(this.Device);
        }

        protected override void LoadContent()
        {
            base.LoadContent();

            sharedSprite.OnResetDevice();
            sharedLine.OnResetDevice();
        }

        protected override void UnloadContent()
        {
            base.UnloadContent();

            sharedSprite.OnLostDevice();
            sharedLine.OnLostDevice();
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
            ScriptManager.lua.RegisterFunction("SetPackage", this, this.GetType().GetMethod("Lua_SetPackage"));


            ScriptManager.lua.RegisterFunction("SetSize", this, this.GetType().GetMethod("Lua_SetSize"));
            ScriptManager.lua.RegisterFunction("GetWidth", this, this.GetType().GetMethod("GetWidth"));
            ScriptManager.lua.RegisterFunction("GetHeight", this, this.GetType().GetMethod("GetHeight"));

            ScriptManager.lua.RegisterFunction("Trace", this, this.GetType().GetMethod("Lua_Trace"));
            ScriptManager.lua.RegisterFunction("Info", this, this.GetType().GetMethod("Lua_Info"));
            ScriptManager.lua.RegisterFunction("Error", this, this.GetType().GetMethod("Lua_Error"));

            ScriptManager.lua.RegisterFunction("Replace", this, this.GetType().GetMethod("Lua_Replace"));
            ScriptManager.lua.RegisterFunction("Substring", this, this.GetType().GetMethod("Lua_Substring"));
            ScriptManager.lua.RegisterFunction("Length", this, this.GetType().GetMethod("Lua_Length"));
            
            ScriptManager.lua.RegisterFunction("LoadScript", this, this.GetType().GetMethod("Lua_LoadScript"));
            ScriptManager.lua.RegisterFunction("CloseState", this, this.GetType().GetMethod("Lua_CloseState"));
            ScriptManager.lua.RegisterFunction("CloseStates", this, this.GetType().GetMethod("Lua_CloseStates"));
            
            ScriptManager.lua.RegisterFunction("LoadState", this, this.GetType().GetMethod("Lua_LoadState"));
            ScriptManager.lua.RegisterFunction("CurrentState", this, this.GetType().GetMethod("Lua_CurrentState"));

            ScriptManager.lua.RegisterFunction("Supervisor", this, this.GetType().GetMethod("Lua_Supervisor"));
            ScriptManager.lua.RegisterFunction("FontManager", this, this.GetType().GetMethod("Lua_FontManager"));
            ScriptManager.lua.RegisterFunction("SoundManager", this, this.GetType().GetMethod("Lua_SoundManager"));
            ScriptManager.lua.RegisterFunction("CsvManager", this, this.GetType().GetMethod("Lua_CsvManager"));

            ScriptManager.lua.RegisterFunction("Delay", this, this.GetType().GetMethod("Lua_DelayedCall"));
            ScriptManager.lua.RegisterFunction("LoadESS", this, this.GetType().GetMethod("Lua_LoadESS"));
            ScriptManager.lua.RegisterFunction("AddESSCmd", this, this.GetType().GetMethod("Lua_AddESSCmd"));
            ScriptManager.lua.RegisterFunction("ClearESSCmd", this, this.GetType().GetMethod("Lua_ClearESSCmd"));
            ScriptManager.lua.RegisterFunction("EssLine", this, this.GetType().GetMethod("Lua_GetESSLine"));

            ScriptManager.lua.RegisterFunction("SetVolume", this, this.GetType().GetMethod("Lua_SetVolume"));

            ScriptManager.lua.RegisterFunction("GetInput", this, this.GetType().GetMethod("Lua_GetInput"));

            ScriptManager.lua.RegisterFunction("ShowWinCursor", this, this.GetType().GetMethod("Lua_ShowCursor"));
            ScriptManager.lua.RegisterFunction("HideWinCursor", this, this.GetType().GetMethod("Lua_HideCursor"));

            ScriptManager.lua.RegisterFunction("GetFader", this, this.GetType().GetMethod("Lua_GetFader"));

            ScriptManager.lua.RegisterFunction("SaveData", this, this.GetType().GetMethod("Lua_SaveData"));
            ScriptManager.lua.RegisterFunction("LoadData", this, this.GetType().GetMethod("Lua_LoadData"));

            ScriptManager.lua.RegisterFunction("Dump", this, this.GetType().GetMethod("DumpObjects"));

            ScriptManager.lua.RegisterFunction("Video", this, this.GetType().GetMethod("Lua_Video"));
            

        }

        public void Lua_LoadScript(string ScriptFile)
        {
            try
            {
                ScriptManager.DoLua(ScriptFile);
            }
            catch (LuaInterface.LuaException e)
            {
                Supervisor.Error(e.Message);

            }
            catch (Exception e)
            {
                Supervisor.Error(e.Message);
            }
        }

        /* create a new state and initialize the state using given lua script */
        public void Lua_LoadState(string stateName, string ScriptFile)
        {
            if (states.ContainsKey(stateName))
            {
                throw new Exception("duplicate state name exists!");
            }

            GameState newState = new GameState();
            newState.Name = stateName;
            
            //disable old state
            if (activeState != null)
                activeState.Disable();

            states.Add(newState.Name, newState);
            stateList.Add(newState);

            activeState = newState;  // set the new state as the active state
            ScriptManager.lua.DoString("CurrentState().State = {}"); // initialize state table
            Lua_LoadScript(ScriptFile);
            newState.OnStarting();

            Resources.Add(newState);

        }

        public void Lua_CloseState()
        {

            if (stateList.Count <= 0)
            {
                throw new Exception("no more state to be removed!");
            }

            GameState removedState = stateList[stateList.Count - 1];
            stateList.Remove(removedState);
            states.Remove(removedState.Name);
            Resources.Remove(removedState);
            removedState.OnExiting();

            if (stateList.Count > 0)
            {
                activeState = stateList[stateList.Count - 1];
                activeState.Enable();
            }
            else
            {
                activeState = null;
            }
        }

        public void Lua_CloseStates()
        {
            while (this.stateList.Count > 0)
            {
                this.Lua_CloseState();
            }
        }

        public GameState Lua_CurrentState()
        {
            return this.activeState;
        }

        public void Lua_Trace(string s)
        {
            Trace(s);
        }

        public static void Trace(string msg)
        {
            Supervisor.GetInstance().logManager.Trace(msg);
        }

        public void Lua_Info(string s)
        {
            Info(s);
        }

        public static void Info(string msg)
        {
            Supervisor.GetInstance().logManager.Info(msg);
        }

        public void Lua_Error(string s)
        {
            Error(s);
        }

        public static void Error(string msg)
        {
            Supervisor.GetInstance().logManager.Error(msg);
        }

        public string Lua_LoadESS(string path)
        {
            string result = null;
            try
            {
                result = ScriptManager.ParseESS(path);
            }
            catch (Exception e)
            {
                Supervisor.Error(e.Message);
            }
            return result;
        }

        public void Lua_AddESSCmd(string cmd)
        {
            ScriptManager.AddCommand(cmd);
        }

        public void Lua_ClearESSCmd()
        {
            ScriptManager.ClearCommands();
        }

        public string Lua_GetESSLine(string path, int lineNumber)
        {
            return ScriptManager.GetESSLine(path, lineNumber);
        }

        public void Lua_SetTitle(string s)
        {
            Window.Text = s;
        }

        public void Lua_SetIcon(string s)
        {
            Window.Icon = new System.Drawing.Icon(s);
        }

        public void Lua_SetSize(int width, int height)
        {
            InitialWidth = width;
            InitialHeight = height;
            Window.ClientSize = new Size(width, height);
        }

        public int GetWidth()
        {
            return Window.ClientSize.Width;
        }

        public int GetHeight()
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

        public SoundManager Lua_SoundManager()
        {
            return this.soundManager;
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

        public void Lua_SaveData(string data, string path)
        {
            SaveManager.SaveData(data, path);
        }

        public string Lua_LoadData(string path)
        {
            return SaveManager.LoadData(path);
        }

        public string Lua_GetInput(bool numeric)
        {
            string result = "";
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

        public void Lua_SetPackage(string path, string password, bool isPackage)
        {
            if (isPackage)
            {
                ArchiveManager.SetPackage(path, password);
            }
            else
            {
                ArchiveManager.SetPath(path);
            }
        }

        public string Lua_Replace(string source, string pattern, string target)
        {
            return source.Replace(pattern, target);
        }


        public string Lua_Substring(string source, int pos, int length)
        {
            if (length == -1)
            {
                return source.Substring(pos); 
            }
            else
            {
                return source.Substring(pos, length);
            }
        }


        public int Lua_Length(string source)
        {
            return source.Length;
        }

        public void Lua_Video(string path, LuaEventHandler overHandler)
        {
            this.overHandler = overHandler;
            this.LoadVideo(path);
        }

        #endregion

    }


}
