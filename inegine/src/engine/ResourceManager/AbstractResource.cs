using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using INovelEngine.Core;
using SampleFramework;
using INovelEngine.StateManager;
using INovelEngine.Script;
using SlimDX.Direct3D9;

namespace INovelEngine.Effector
{
    public enum ResourceType
    {
        Graphical, General
    }

    public abstract class AbstractResource : IResource
    {

        protected bool loaded = false;
        protected bool initialized = false;

        public ResourceType Type
        {
            get;
            set;
        }

        public string Name
        {
            get;
            set;
        }

        public bool Loaded
        {
            get
            {
                return loaded;
            }
        }

        #region IResource Members

        public virtual void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            initialized = true;
        }

        public virtual void LoadContent()
        {
            loaded = true;
        }

        public virtual void UnloadContent()
        {
            loaded = false;
        }

        #endregion

        #region IDisposable Members

        public virtual void Dispose()
        {
        }

        #endregion
    }

}
