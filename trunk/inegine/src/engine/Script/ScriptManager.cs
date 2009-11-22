using System;
using System.Collections.Generic;
using System.Text;
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
        KeyPress
    }

    public class AbstractLuaEventHandler
    {
        public LuaEventHandler eventHandler;
        public LuaEventHandler mouseDownEventHandler;
        public LuaEventHandler mouseUpEventHandler;
        public LuaEventHandler mouseMoveEventHandler;
        public LuaEventHandler mouseClickEventHandler;
        public LuaEventHandler keyDownHandler;

        public object state;

        public void SendEvent(ScriptEvents luaevent, params object[] args)
        {
            try
            {
                AbstractLuaEventHandler handler = GetHandler(luaevent, args);
                switch (luaevent)
                {
                    case ScriptEvents.KeyPress:
                        if (handler.keyDownHandler != null) handler.keyDownHandler(handler, luaevent, args);
                        break;
                    case ScriptEvents.MouseDown:
                        if (handler.mouseDownEventHandler != null) handler.mouseDownEventHandler(handler, luaevent, args);
                        break;
                    case ScriptEvents.MouseUp:
                        if (handler.mouseUpEventHandler != null) handler.mouseUpEventHandler(handler, luaevent, args);
                        break;
                    case ScriptEvents.MouseMove:
                        if (handler.mouseMoveEventHandler != null) handler.mouseMoveEventHandler(handler, luaevent, args);
                        break;
                    case ScriptEvents.MouseClick:
                        if (handler.mouseClickEventHandler != null) handler.mouseClickEventHandler(handler, luaevent, args);
                        break;
                    default:
                        if (handler.eventHandler != null) handler.eventHandler(handler, luaevent, args);
                        break;
                }
 
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }
        }

        public virtual AbstractLuaEventHandler GetHandler(ScriptEvents luaevent, params object[] args)
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
            lua = new Lua();
            lua.DoFile("Resources/Init.lua");
        }
    }
}
