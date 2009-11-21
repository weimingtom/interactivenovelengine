using System;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using INovelEngine.Script;
using INovelEngine.Effector;

namespace INovelEngine.StateManager
{

    // GameState class representing a game state. 
    public class GameState : IResource, IGameComponent
    {
        public String id;
        private ResourceCollection resources = new ResourceCollection();
        private GameComponentCollection components = new GameComponentCollection();
        public LuaEventHandler eventhandler;


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
            foreach (IGameComponent component in components)
            {
                component.Draw();
            }
        }

        public void Update(GameTime gameTime)
        {
            foreach (IGameComponent component in components)
            {
                component.Update(gameTime);
            }
        }

        #endregion

        public void AddComponent(IGUIComponent component)
        {
            components.Add(component);
            resources.Add(component);
        }

        public void SendEvent(ScriptEvents luaevent, Object args)
        {
            this.eventhandler(this, luaevent, args);
        }
    }
}
