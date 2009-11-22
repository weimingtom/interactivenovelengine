using System;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using INovelEngine.StateManager;
using INovelEngine.Script;

namespace INovelEngine.Effector
{
    public enum ComponentType
    {
        TextWindow
    }


    public interface IGUIComponent : IResource, IGameComponent, IComparable
    {

    }

    public abstract class AbstractGUIComponent : AbstractLuaEventHandler, IGUIComponent
    {
        public bool enabled = true;

        public GameState managingState
        {
            get;
            set;
        }

        public ComponentType type
        {
            get;
            set;
        }

        public string id
        {
            get;
            set;
        }

        public int x
        {
            get;
            set;
        }

        public int y
        {
            get;
            set;
        }

        public int width
        {
            get;
            set;
        }

        public int height
        {
            get;
            set;
        }

        private int _layer;

        public int layer
        {
            get
            {
                return this._layer;
            }
            set
            {
                if (this.managingState != null) this.managingState.InvalidateZOrder();
                this._layer = value;
            }
        }

        #region IGameComponent Members

        public virtual void Draw()
        {
            if (this.enabled) this.DrawInternal();
        }
        protected abstract void DrawInternal();

        public abstract void Update(GameTime gameTime);

        #endregion

        #region IResource Members

        public abstract void Initialize(GraphicsDeviceManager graphicsDeviceManager);

        public abstract void LoadContent();

        public abstract void UnloadContent();

        #endregion

        #region IDisposable Members

        public abstract void Dispose();

        #endregion

        #region IComparable Members

        public int CompareTo(object obj)
        {
            AbstractGUIComponent g = (AbstractGUIComponent)obj;
            return this.layer.CompareTo(g.layer);
        }

        #endregion
    }

}
