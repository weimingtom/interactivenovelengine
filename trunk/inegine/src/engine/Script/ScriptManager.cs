using System;
using System.Collections.Generic;
using System.Text;
using LuaInterface;

namespace INovelEngine.Script
{
    public delegate void LuaEventHandler();

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
