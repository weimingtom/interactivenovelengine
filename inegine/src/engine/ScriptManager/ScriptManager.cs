using System;
using System.Collections.Generic;
using System.Text;
using INovelEngine.Core;
using LuaInterface;
using INovelEngine.StateManager;
using INovelEngine.ResourceManager;
using System.IO;
using INovelEngine.Effector;

namespace INovelEngine.Script
{
    public enum ScriptEvents
    {
        MouseDown,
        MouseUp,
        MouseMove,
        MouseClick,
        MouseDoubleClick,
        MouseEnter,
        MouseLeave,
        KeyPress,
        AnimationOver,
        Update,
        StateEnable,
        StateDisable,
        Etc
    }

    public class AbstractLuaEventHandler
    {
        public LuaEventHandler GeneralEvent;
        public LuaEventHandler MouseDown;
        public LuaEventHandler MouseUp;
        public LuaEventHandler MouseMove;
        public LuaEventHandler MouseDoubleClick;
        public LuaEventHandler MouseClick;
        public LuaEventHandler MouseEnter;
        public LuaEventHandler MouseLeave;
        public LuaEventHandler KeyDown;
        public LuaEventHandler AnimationOver;

        public AbstractLuaEventHandler mouseDownLocked;
        public AbstractLuaEventHandler mouseMoveLocked;
        public AbstractLuaEventHandler previousMouseMove;

        public object state;
        public bool handleMyself
        { get; set; }

        protected bool _enabled = true;

        public bool Enabled
        {
            get
            {
                return _enabled;
            }
            set
            {
                _enabled = value;
            }
        }

        protected bool _removed = false;

        public bool Removed
        {
            get
            {
                return _removed;
            }
            set
            {
                _removed = value;
            }
        }

        public virtual void SendEvent(ScriptEvents luaevent, params object[] args)
        {
            try
            {
                if (!Enabled) return; // since not enabled...

                AbstractLuaEventHandler handler = FindEventHandler(luaevent, args);
                SendEvent(handler, luaevent, args);
                if (handler != this && handleMyself) SendEvent(this, luaevent, args);
            }
            catch (Exception e)
            {
                Supervisor.Error(e.ToString());
            }
        }

        public virtual void SendEvent(AbstractLuaEventHandler handler, ScriptEvents luaevent, params object[] args)
        {
            try
            {   
                /* handle the event myself since handler is this */
                if (handler == this)
                {
                    switch (luaevent)
                    {
                        case ScriptEvents.KeyPress:
                            if (KeyDown != null) KeyDown(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseDown:
                            if (MouseDown != null) MouseDown(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseUp:
                            if (MouseUp != null) MouseUp(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseMove:
                            if (MouseMove != null) MouseMove(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseDoubleClick:
                            if (MouseDoubleClick != null) MouseDoubleClick(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseClick:
                            if (MouseClick != null) MouseClick(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseEnter:
                            if (MouseEnter != null) MouseEnter(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseLeave:
                            if (MouseLeave != null) MouseLeave(handler, luaevent, args);
                            break;
                        default:
                            if (GeneralEvent != null) GeneralEvent(handler, luaevent, args);
                            break;
                    }
                }
                else // send the event to the handler and delegate handling
                {
                    handler.SendEvent(luaevent, args);
                }


            }
            catch (Exception e)
            {
                Supervisor.Error(e.ToString());
            }
        }

        public virtual AbstractLuaEventHandler FindEventHandler(ScriptEvents luaevent, params object[] args)
        {
            return this;
        }
    }

    public delegate void LuaEventHandler(Object state, ScriptEvents luaevent, params object[] args);

    public static class ScriptManager
    {
        public static Lua lua = new Lua();
        private static List<String> commandList = new List<string>();
    
        public static void Init()
        {
            try
            {
                lua.DoFile("BaseScripts/Init.lua");
            }
            catch (Exception e)
            {
                Supervisor.Error(e.Message);
            }
        }

        public static void ClearCommands()
        {
            commandList.Clear();
        }

        public static void AddCommand(string cmd)
        {
            if (!commandList.Contains(cmd))
            {
                commandList.Add(cmd);
            }
        }

        public static void DoLua(string path)
        {
            string script = "";
            using (StreamReader reader = new StreamReader(ArchiveManager.GetStream(path), Encoding.Default))
            {
                script = reader.ReadToEnd();
            }
            lua.DoString(script, path); 
        }

        public static Object Pop()
        {
            return lua.Pop();
        }

        public static void Push(Object obj)
        {
            lua.Push(obj);
        }

        public static string ParseESS(string path)
        {
            Scanner scanner;
            Parser parser;
            using (Stream s = ArchiveManager.GetStream(path))
            {
                scanner = new Scanner(s);

                parser = new Parser(scanner);
                parser.gen = new CodeGenerator();
                parser.gen.CommandList = commandList;
                parser.Parse();
            }
            return parser.gen.GetScript();
        }

        public static string GetESSLine(string path, int line)
        {
            // Read the file and display it line by line.
            System.IO.StreamReader reader;
            
            reader = new System.IO.StreamReader(ArchiveManager.GetStream(path));

           
            int counter = 0;
            string buffer;
            while ((buffer = reader.ReadLine()) != null && counter < line - 1)
            {
                counter++;
            }

            return buffer;
        }

        public static void WaitDo(float delay, LuaEventHandler Do)
        {
            TimeEvent eventToDo = new TimeEvent(1, (int)delay, delegate() { },
                                                delegate() {
                                                    try
                                                    {
                                                        Do(null, ScriptEvents.Etc, null);
                                                    }
                                                    catch (Exception e)
                                                    {
                                                        Supervisor.Error(e.Message);
                                                    }    
                                                });
            Clock.AddTimeEvent(eventToDo);
        }
    }
}
