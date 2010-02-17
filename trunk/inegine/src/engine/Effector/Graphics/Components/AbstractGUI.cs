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
        protected GraphicsDeviceManager manager;
        public Dictionary<String, AbstractGUIComponent> guiComponents =
            new Dictionary<string, AbstractGUIComponent>();

        protected float beginTick;
        protected float endTick;
        protected float currentTick;
        protected float tickLength;
        protected bool fadeIn;
        protected bool inTransition = false;

        protected Color renderColor = Color.White;
        protected float progress = 0;

        public Device Device
        {
            get { return manager.Direct3D9.Device; }
        }

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

        public bool Enabled
        {
            get
            {
                return enabled;
            }
            set
            {
                enabled = value;
            }
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

        public virtual int width
        {
            get;
            set;
        }

        public virtual int height
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

        public bool Fading
        {
            set
            {
                this.inTransition = value;
                if (!inTransition) this.renderColor = Color.White;
            }

            get
            {
                return this.inTransition;
            }
        }

        public bool FadedOut
        {
            get;
            set;
        }

        #region IGameComponent Members

        public virtual void Draw()
        {
            if (this.enabled)
                if (!this.FadedOut)
                {
                    if (this.Fading)
                    {
                        renderColor = Color.FromArgb((int)(progress * 255), Color.White); ;
                    }
                    else
                    {
                        renderColor = Color.White;
                    }
                    this.DrawInternal();
                }
        }
        protected abstract void DrawInternal();

        public virtual void Update(GameTime gameTime)
        {
            if (Fading)
            {
                currentTick = Clock.GetTime();

                if (currentTick >= endTick)
                {
                    Fading = false;
                    FadedOut = fadeIn == false;
                }
                else
                {
                    progress = fadeIn
                                   ? Math.Min(1.0f, (currentTick - beginTick)/tickLength)
                                   : 1.0f - Math.Min(1.0f, (currentTick - beginTick) / tickLength);
                }
            }
        }

        public void LaunchTransition(float duration, bool isFadingIn)
        {
            beginTick = Clock.GetTime();
            tickLength = duration;
            endTick = beginTick + duration;
            fadeIn = isFadingIn;
            Fading = true;
            FadedOut = false;
        }

        #endregion

        #region IResource Members

        public virtual void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            manager = graphicsDeviceManager;
        }

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
