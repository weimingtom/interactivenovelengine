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

        /* resources managed by state */
        
        protected ResourceCollection resources = new ResourceCollection();
        protected Dictionary<String, AbstractResource> resourcesMap = new Dictionary<string, AbstractResource>();

        /* components (objects to draw) managed by state */

        // componentList sorted by z-order (higher, higher)
        protected List<AbstractGUIComponent> componentList = new List<AbstractGUIComponent>();
        protected Dictionary<String, AbstractGUIComponent> componentMap = 
            new Dictionary<string, AbstractGUIComponent>();

        #region IResource Members

        public void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            resources.Initialize(graphicsDeviceManager);
        }

        public void LoadContent()
        {
            resources.LoadContent();
        }

        public void UnloadContent()
        {
            resources.UnloadContent();
        }

        #endregion

        #region IDisposable Members

        public void Dispose()
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
        
        public void AddResource(AbstractResource resource)
        {
            if (resourcesMap.ContainsKey(resource.Name)) return;

            resources.Add(resource);
            resourcesMap[resource.Name] = resource;
        }

        public AbstractResource GetResource(string id)
        {
            if (resourcesMap.ContainsKey(id))
            {
                return resourcesMap[id];
            }
            else
            {
                return null;
            }
        }

        public void RemoveResource(string id)
        {
            if (resourcesMap.ContainsKey(id))
            {
                AbstractResource resource = resourcesMap[id];
                resources.Remove(resource);
                resourcesMap.Remove(id);
                resource.Dispose();
            }
        }

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
            if (id != null && componentMap.ContainsKey(id))
            {
                AbstractGUIComponent component = componentMap[id];
                componentList.Remove(component);
                componentMap.Remove(id);
                resources.Remove(component);
                component.Dispose();
            }
        }

        public void InvalidateZOrder()
        {
            componentList.Sort(); // sort them according to z-order (higher, higher)
        }

        private AbstractLuaEventHandler mouseDownLocked;
        private AbstractLuaEventHandler mouseMoveLocked;
        public override AbstractLuaEventHandler FindEventHandler(ScriptEvents luaevent, params object[] args)
        {
            AbstractLuaEventHandler handler = this;
            switch (luaevent)
            {
                case ScriptEvents.KeyPress:
                    handler = this;
                    break;
                case ScriptEvents.MouseMove:
                    if (mouseDownLocked != null && !mouseDownLocked.Removed) handler = mouseDownLocked;
                    else
                    {
                        handler = GetCollidingComponent((int)args[0], (int)args[1]);

                        if (handler == null) handler = this;

                        if (mouseMoveLocked != null && !mouseMoveLocked.Removed)
                        {
                            if (mouseMoveLocked != handler)
                            {
                                SendEvent(mouseMoveLocked, ScriptEvents.MouseLeave, null);
                                mouseMoveLocked = null;
                            }
                        }
                        else if (handler != this)
                        {
                            mouseMoveLocked = handler;
                        }
                    }
                    break;
                case ScriptEvents.MouseDown:
                    handler = GetCollidingComponent((int)args[0], (int)args[1]);
                    if (handler == null) handler = this;
                    mouseDownLocked = handler;
                    break;
                case ScriptEvents.MouseUp:
                    if (mouseDownLocked != null) handler = mouseDownLocked;
                    mouseDownLocked = null;
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
                if (component.RealX <= x && component.RealY <= y &&
                    component.RealX + component.Width >= x &&
                    component.RealY + component.Height >= y && component.Enabled) return component;
            }
            return null;
        }
    }
}
