using System;
using System.Collections.Generic;
using System.Text;
using INovelEngine.Core;
using LuaInterface;
using INovelEngine.StateManager;
using INovelEngine.ResourceManager;
using System.IO;

namespace INovelEngine.Script
{
    public enum ScriptEvents
    {
        MouseDown,
        MouseUp,
        MouseMove,
        MouseClick,
        MouseDoubleClick,
        MouseLeave,
        KeyPress,
        AnimationOver,
        Update,
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
        public LuaEventHandler MouseLeave;
        public LuaEventHandler KeyDown;
        public LuaEventHandler StateUpdate;
        public LuaEventHandler AnimationOver;

        public object state;
        public Boolean handleMyself
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
                Console.WriteLine(e.ToString());
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
                        case ScriptEvents.MouseLeave:
                            if (MouseLeave != null) MouseLeave(handler, luaevent, args);
                            break;
                        case ScriptEvents.Update:
                            if (StateUpdate != null) StateUpdate(handler, luaevent, args);
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
                Console.WriteLine(e.ToString());
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
            
        public static void Init()
        {
            try
            {
                lua.DoFile("BaseScripts/Init.lua");
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        public static void DoLua(String path)
        {
            if (ArchiveManager.IsURI(path))
            {
                StreamReader reader = new StreamReader(ArchiveManager.GetStream(path), Encoding.Default);
                string script = reader.ReadToEnd();
                lua.DoString(script, path);
            }
            else
            {
                path = path.Replace("/", "\\");
                string script = File.ReadAllText(path, Encoding.Default);
                lua.DoString(script, path);
            }   
        }

        public static Object Pop()
        {
            return lua.Pop();
        }

        public static void Push(Object obj)
        {
            lua.Push(obj);
        }

        public static String ParseESS(String path)
        {
            Scanner scanner;
            if (ArchiveManager.IsURI(path))
            {
                scanner = new Scanner(ArchiveManager.GetStream(path));
            }
            else
            {
                scanner = new Scanner(path);
            } 
            
            Parser parser = new Parser(scanner);
            parser.gen = new CodeGenerator();
            parser.Parse();
            return parser.gen.GetScript();
        }

        public static String GetESSLine(String path, int line)
        {
            // Read the file and display it line by line.
            System.IO.StreamReader reader;
            if (ArchiveManager.IsURI(path))
            {
                reader = new System.IO.StreamReader(ArchiveManager.GetStream(path));
            }
            else
            {
                reader = new System.IO.StreamReader(path);
            } 
           
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
                                                        Console.WriteLine(e.Message);
                                                    }    
                                                });
            Clock.AddTimeEvent(eventToDo);
        }
    }
}
