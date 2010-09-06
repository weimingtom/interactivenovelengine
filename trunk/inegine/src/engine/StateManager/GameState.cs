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
        protected ResourceCollection graphicalResources = new ResourceCollection();
        protected Dictionary<String, AbstractResource> graphicalResourcesMap = new Dictionary<string, AbstractResource>();


        protected ResourceCollection generalResources = new ResourceCollection();
        protected Dictionary<String, AbstractResource> generalResourcesMap = new Dictionary<string, AbstractResource>();

        /* components (objects to draw) managed by state */
        /* componentList sorted by z-order (higher, higher) */
        protected List<AbstractGUIComponent> componentList = new List<AbstractGUIComponent>();
        protected Dictionary<String, AbstractGUIComponent> componentMap = 
            new Dictionary<string, AbstractGUIComponent>();

        #region IResource Members for managing graphical resources

        public void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            graphicalResources.Initialize(graphicsDeviceManager);
        }

        public void LoadContent()
        {
            graphicalResources.LoadContent();
        }

        public void UnloadContent()
        {
            graphicalResources.UnloadContent();
        }

        #endregion


        public void OnStarting()
        {
            Console.WriteLine(this.Name + " is starting!");
        }

        public void OnExiting()
        {
            Console.WriteLine(this.Name + " is closing!");
            generalResources.Dispose();
            
        }

        #region IDisposable Members

        public void Dispose()
        {
            Console.WriteLine("disposing game state!");
            graphicalResources.Dispose();
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


        #region resource management

        public void AddResource(AbstractResource resource)
        {
            if (resource.Type == INovelEngine.Effector.ResourceType.Graphical)
            {
                if (graphicalResourcesMap.ContainsKey(resource.Name)) return;

                graphicalResources.Add(resource);
                graphicalResourcesMap[resource.Name] = resource;
            }
            else
            {
                if (generalResourcesMap.ContainsKey(resource.Name)) return;

                generalResources.Add(resource);
                generalResourcesMap[resource.Name] = resource;
                resource.Initialize(null);
                resource.LoadContent();
            }
        }
    

        public AbstractResource GetResource(string id)
        {
            if (graphicalResourcesMap.ContainsKey(id))
            {
                return graphicalResourcesMap[id];
            }
            else if(generalResourcesMap.ContainsKey(id))
            {
                return generalResourcesMap[id];
            }
            else
            {
                return null;
            }
        }

        public void RemoveResource(string id)
        {
            if (graphicalResourcesMap.ContainsKey(id))
            {
                AbstractResource resource = graphicalResourcesMap[id];
                graphicalResources.Remove(resource);
                graphicalResourcesMap.Remove(id);
                resource.Dispose();
            }
            else if (generalResourcesMap.ContainsKey(id))
            {
                AbstractResource resource = generalResourcesMap[id];
                generalResources.Remove(resource);
                generalResourcesMap.Remove(id);
                resource.Dispose();
            }
        }

        #endregion


        #region GUI component management

        public void AddComponent(AbstractGUIComponent component)
        {
            if (componentMap.ContainsKey(component.Name)) return;

            component.ManagingState = this;

            componentList.Add(component);
            graphicalResources.Add(component);
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
                graphicalResources.Remove(component);
                component.Dispose();
            }
        }

        public void InvalidateZOrder()
        {
            componentList.Sort(); // sort them according to z-order (higher, higher)
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

        #endregion

        #region event handling 

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

        #endregion

    }
}
