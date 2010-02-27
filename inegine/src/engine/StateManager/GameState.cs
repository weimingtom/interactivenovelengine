using System;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using INovelEngine.Script;
using INovelEngine.Effector;

namespace INovelEngine.StateManager
{

    // GameState class representing a game state. 
    public class GameState : AbstractLuaEventHandler, IResource, IGameComponent
    {
        public GameState()
        {
            this.handleMyself = true;
        }

        public string Name
        {
            get;
            set;
        }

        protected ResourceCollection resources = new ResourceCollection();
        /* components sorted in z-order */
        protected List<AbstractGUIComponent> componentList = new List<AbstractGUIComponent>();
        protected Dictionary<String, AbstractGUIComponent> componentMap = 
            new Dictionary<string, AbstractGUIComponent>();

        #region IResource Members

        void IResource.Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            resources.Initialize(graphicsDeviceManager);
        }

        void IResource.LoadContent()
        {
            resources.LoadContent();
        }

        void IResource.UnloadContent()
        {
            resources.UnloadContent();
        }

        #endregion

        #region IDisposable Members

        void IDisposable.Dispose()
        {
            resources.Dispose();
        }

        #endregion

        #region IGameComponent Members

        public void Draw()
        {
            foreach (IGameComponent component in componentList)
            {
                component.Draw();
            }
        }

        public void Update(GameTime gameTime)
        {
            foreach (IGameComponent component in componentList)
            {
                component.Update(gameTime);
            }
        }

        #endregion
        
        public void AddComponent(AbstractGUIComponent component)
        {
            if (componentMap.ContainsKey(component.Name)) return;

            component.ManagingState = this;

            componentList.Add(component);
            resources.Add(component);
            componentMap.Add(component.Name, component);

            InvalidateZOrder();
        }

        public AbstractGUIComponent GetComponent(string id)
        {
            if (componentMap.ContainsKey(id))
            {
                return componentMap[id];
            }
            else
            {
                return null;
            }
        }

        public void RemoveComponent(string id)
        {
            if (componentMap.ContainsKey(id))
            {
                componentList.Remove(componentMap[id]);
                componentMap.Remove(id);
            }
        }

        public void InvalidateZOrder()
        {
            componentList.Sort(); // sort them according to z-order (higher, higher)
        }

        private AbstractLuaEventHandler mouseDownLocked;

        public override AbstractLuaEventHandler FindEventHandler(ScriptEvents luaevent, params object[] args)
        {
            AbstractLuaEventHandler handler = this;
            switch (luaevent)
            {
                case ScriptEvents.KeyPress:
                    handler = this;
                    break;
                case ScriptEvents.MouseMove:
                    if (mouseDownLocked != null) handler = mouseDownLocked;
                    else
                    {
                        handler = GetCollidingComponent((int)args[0], (int)args[1]);
                        if (handler == null) handler = this;
                    }
                    break;
                case ScriptEvents.MouseDown:
                    handler = GetCollidingComponent((int)args[0], (int)args[1]);
                    if (handler == null) handler = this;
                    mouseDownLocked = handler;
                    break;
                case ScriptEvents.MouseUp:
                    if (mouseDownLocked != null) handler = mouseDownLocked;
                    break;
                case ScriptEvents.MouseClick:
                    handler = GetCollidingComponent((int)args[0], (int)args[1]);
                    if (handler == null) handler = this;
                    break;
                default:
                    handler = this;
                    break;
            }
            return handler;
        }

        public AbstractGUIComponent GetCollidingComponent(int x, int y)
        {
            AbstractGUIComponent component;
            // do it in reverse order because components sorted in z order...
            for (int i = componentList.Count - 1; i >= 0; i--)
            {
                component = componentList[i];
                if (component.X <= x && component.Y <= y &&
                    component.X + component.Width >= x &&
                    component.Y + component.Height >= y) return component;
            }
            return null;
        }
    }
}
