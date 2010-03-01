using System;
using System.Collections.Generic;
using System.Text;
using INovelEngine.Core;
using LuaInterface;
using INovelEngine.StateManager;

namespace INovelEngine.Script
{
    public enum ScriptEvents
    {
        MouseDown,
        MouseUp,
        MouseMove,
        MouseClick,
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
        public LuaEventHandler MouseClick;
        public LuaEventHandler KeyDown;
        public LuaEventHandler StateUpdate;
        public LuaEventHandler AnimationOver;

        public object state;
        public Boolean handleMyself
        { get; set; }

        public virtual void SendEvent(ScriptEvents luaevent, params object[] args)
        {
            try
            {
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
                if (handler != this) handler.SendEvent(luaevent, args);
                else
                {
                    switch (luaevent)
                    {
                        case ScriptEvents.KeyPress:
                            if (handler.KeyDown != null) handler.KeyDown(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseDown:
                            if (handler.MouseDown != null) handler.MouseDown(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseUp:
                            if (handler.MouseUp != null) handler.MouseUp(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseMove:
                            if (handler.MouseMove != null) handler.MouseMove(handler, luaevent, args);
                            break;
                        case ScriptEvents.MouseClick:
                            if (handler.MouseClick != null) handler.MouseClick(handler, luaevent, args);
                            break;
                        case ScriptEvents.Update:
                            if (handler.StateUpdate != null) handler.StateUpdate(handler, luaevent, args);
                            break;
                        default:
                            if (handler.GeneralEvent != null) handler.GeneralEvent(handler, luaevent, args);
                            break;
                    }
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
        public static Lua lua;
            
        public static void Init()
        {
            try
            {
                lua = new Lua();
                lua.DoFile("BaseScripts/Init.lua");
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        public static String ParseESS(String path)
        {
            Scanner scanner = new Scanner(path);
            Parser parser = new Parser(scanner);
            parser.gen = new CodeGenerator();
            parser.Parse();
            return parser.gen.GetScript();
        }

        public static void WaitDo(float delay, LuaEventHandler Do)
        {
            TimeEvent eventToDo = new TimeEvent(1, delay, delegate() { },
                                                delegate() { Do(null, ScriptEvents.Etc, null); });
            Clock.AddTimeEvent(eventToDo);
        }
    }
}
