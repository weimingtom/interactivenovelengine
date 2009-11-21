using System;
using System.Collections.Generic;
using System.Text;
using LuaInterface;
using INovelEngine.StateManager;

namespace INovelEngine.Script
{
    public enum ScriptEvents
    {
        MouseClick,
        KeyPress
    }

    public delegate void LuaEventHandler(GameState state, ScriptEvents luaevent, Object args);

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
