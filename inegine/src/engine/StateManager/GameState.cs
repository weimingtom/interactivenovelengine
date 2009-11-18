using System;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using INovelEngine.Script;

namespace INovelEngine.StateManager
{

    // GameState class representing a game state. 


    class GameState : IResource, IGameComponent
    {
        private String stateScript;

        public GameState(String stateScript)
        {
            this.stateScript = stateScript;
            ScriptManager.lua.DoString(stateScript);
        }


        #region IResource Members

        void IResource.Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
        }

        void IResource.LoadContent()
        {
        }

        void IResource.UnloadContent()
        {
        }

        #endregion

        #region IDisposable Members

        void IDisposable.Dispose()  
        {
        }

        #endregion

        #region IGameComponent Members

        public void Draw()
        {
        }

        public void Update(GameTime gameTime)
        {
        }

        #endregion
    }
}
