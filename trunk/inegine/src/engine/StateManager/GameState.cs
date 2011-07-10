using System;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using INovelEngine.Script;
using INovelEngine.Effector;
using INovelEngine.Effector.Graphics.Components;

namespace INovelEngine.StateManager
{

    // GameState class representing a game state. 
    public class GameState : AbstractLuaEventHandler, IResource, IGameComponent, IComponentManager
    {

#if DEBUG
        public int COMobjectCount = 0;
#endif
        /* event handlers */
        public LuaEventHandler StateDisable;
        public LuaEventHandler StateEnable;
        public LuaEventHandler StateExit;
        public bool disableOthers = true;

        /* resources managed by state */
        protected ResourceCollection graphicalResources = new ResourceCollection();
        protected Dictionary<string, AbstractResource> graphicalResourcesMap = new Dictionary<string, AbstractResource>();


        protected ResourceCollection generalResources = new ResourceCollection();
        protected Dictionary<string, AbstractResource> generalResourcesMap = new Dictionary<string, AbstractResource>();

        /* components (objects to draw) managed by state */
        /* componentList sorted by z-order (higher, higher) */
        protected List<AbstractGUIComponent> componentList = new List<AbstractGUIComponent>();
        protected Dictionary<string, AbstractGUIComponent> componentMap = 
            new Dictionary<string, AbstractGUIComponent>();

        public GameState()
        {
            this.handleMyself = true;
        }

        public string Name
        {
            get;
            set;
        }

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
            
#if DEBUG
            this.COMobjectCount = Supervisor.CountObjects();
#endif

            Removed = false;
            Supervisor.Info("State " + this.Name + " is starting!");
            Enable();
        }

        public void OnExiting()
        {
            Removed = true;
            Supervisor.Info("State " + this.Name + " is closing!");
            Disable();
            Exit();
            generalResources.Dispose();

#if DEBUG
            int newCount = Supervisor.CountObjects();
            Supervisor.Trace("SlimDX COM precount: " + this.COMobjectCount + " | postcount: " + newCount);
#endif
        }

        public void Enable()
        {
            if (StateEnable != null)
            {
                StateEnable(this, ScriptEvents.StateEnable, null);
            }
        }

        public void Disable()
        {
            if (StateDisable != null)
            {
                StateDisable(this, ScriptEvents.StateDisable, null);
            }
        }

        public void Exit()
        {
            if (StateExit != null)
            {
                StateExit(this, ScriptEvents.StateExit, null);
            }
        }

        #region IDisposable Members

        public void Dispose()
        {
            graphicalResources.Dispose();
        }

        #endregion

        #region IGameComponent Members

        public void Draw()
        {
            if (this._removed) return;
            foreach (IGameComponent component in componentList)
            {
                component.Draw();
            }
        }

        public void Update(GameTime gameTime)
        {
            if (this._removed) return;
            foreach (IGameComponent component in componentList)
            {
                component.Update(gameTime);
            }
        }

        #endregion


        #region resource management

        public void AddResource(AbstractResource resource)
        {
            if (resource.Name == null || resource.Name.Length == 0)
            {
                resource.Name = System.Guid.NewGuid().ToString();
            }

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
            if (component.Name == null || component.Name.Length == 0)
            {
                component.Name = System.Guid.NewGuid().ToString();
            }

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

        #endregion

        #region event handling 
        
        public override AbstractLuaEventHandler FindEventHandler(ScriptEvents luaevent, params object[] args)
        {
            return ComponentManagerHelper.FindEventHandler(this, this.componentList, luaevent, args);
        }

        #endregion

    }
}
