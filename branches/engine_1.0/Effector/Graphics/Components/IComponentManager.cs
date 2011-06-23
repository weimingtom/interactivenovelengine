using System;
using INovelEngine.Script;
using System.Collections.Generic;
namespace INovelEngine.Effector.Graphics.Components
{
    interface IComponentManager
    {
        void AddComponent(INovelEngine.Effector.AbstractGUIComponent component);
        INovelEngine.Effector.AbstractGUIComponent GetComponent(string id);
        void RemoveComponent(string id);
    }

    public class ComponentManagerHelper
    {        
        public static AbstractGUIComponent GetCollidingComponent(
            List<AbstractGUIComponent> componentList,
            int x, int y
            )
        {
            AbstractGUIComponent component;
            // do it in reverse order because components sorted in z order...
            for (int i = componentList.Count - 1; i >= 0; i--)
            {
                component = componentList[i];
                if (component.RealX <= x && component.RealY <= y &&
                    component.RealX + component.Width >= x &&
                    component.RealY + component.Height >= y && component.Enabled) return component;
            }
            return null;
        }

        public static AbstractLuaEventHandler FindEventHandler(AbstractLuaEventHandler parent,
            List<AbstractGUIComponent> componentList, ScriptEvents luaevent, params object[] args)
        {
            AbstractLuaEventHandler handler = parent;
            switch (luaevent)
            {
                case ScriptEvents.KeyPress:
                    handler = parent;
                    break;
                case ScriptEvents.MouseMove:
                    handler = ComponentManagerHelper.GetCollidingComponent(componentList, (int)args[0], (int)args[1]);

                    if (handler == null) handler = parent;

                    if (parent.previousMouseMove == null || parent.previousMouseMove != handler)
                    {
                        if (parent.previousMouseMove != null) 
                            parent.SendEvent(parent.previousMouseMove, ScriptEvents.MouseLeave, null);
                        parent.SendEvent(handler, ScriptEvents.MouseEnter, null);
                        parent.previousMouseMove = handler;
                    }

                    break;
                case ScriptEvents.MouseDown:
                    handler = ComponentManagerHelper.GetCollidingComponent(componentList, (int)args[0], (int)args[1]);
                    if (handler == null) handler = parent;
                    parent.mouseDownLocked = handler;
                    break;
                case ScriptEvents.MouseUp:
                    if (parent.mouseDownLocked != null) handler = parent.mouseDownLocked;
                    parent.mouseDownLocked = null;
                    break;
                case ScriptEvents.MouseRightUp:
                    handler = parent;
                    break;
                case ScriptEvents.MouseDoubleClick:
                    handler = ComponentManagerHelper.GetCollidingComponent(componentList, (int)args[0], (int)args[1]);
                    if (handler == null) handler = parent;
                    break;
                case ScriptEvents.MouseClick:
                    handler = ComponentManagerHelper.GetCollidingComponent(componentList, (int)args[0], (int)args[1]);
                    if (handler == null) handler = parent;
                    break;
                default:
                    handler = parent;
                    break;
            }
            return handler;
        }

    }
}
