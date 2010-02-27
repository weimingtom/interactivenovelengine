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
        protected bool _enabled = true;
        protected GraphicsDeviceManager manager;

        protected float beginTick;
        protected float endTick;
        protected float currentTick;
        protected float tickLength;
        protected bool fadeIn;
        protected bool inTransition = false;
        protected Color renderColor = Color.White;
        protected float progress = 0;

        protected bool loaded = false;
        protected bool initialized = false;

        public Device Device
        {
            get { return manager.Direct3D9.Device; }
        }

        public GameState ManagingState
        {
            get;
            set;
        }

        public ComponentType Type
        {
            get;
            set;
        }

        public bool Enalbed
        {
            get
            {
                return _enabled;
            }
            set
            {
                _enabled = value;
            }
        }

        public string Name
        {
            get;
            set;
        }

        public int X
        {
            get;
            set;
        }

        public int Y
        {
            get;
            set;
        }

        public virtual int Width
        {
            get;
            set;
        }

        public virtual int Height
        {
            get;
            set;
        }

        private int _layer;

        public int Layer
        {
            get
            {
                return this._layer;
            }
            set
            {
                if (this.ManagingState != null) this.ManagingState.InvalidateZOrder();
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

        private bool _visible = true;
        public bool Visible
        {
            get { return _visible; }
            set { _visible = value; }
        }

        public void FadeIn(float duration)
        {
            LaunchTransition(duration, true);
        }

        public void FadeOut(float duration)
        {
            LaunchTransition(duration, false);
        }

        public void LaunchTransition(float duration, bool isFadingIn)
        {
            beginTick = Clock.GetTime();
            tickLength = duration;
            endTick = beginTick + duration;
            fadeIn = isFadingIn;
            Fading = true;
            Visible = true;
        }

        #region IGameComponent Members

        public virtual void Draw()
        {
            if (this.Enalbed)
            {
                if (this.Visible)
                {
                    if (this.Fading)
                    {
                        renderColor = Color.FromArgb((int) (progress*255), Color.White);
                        ;
                    }
                    else
                    {
                        renderColor = Color.White;
                    }
                    this.DrawInternal();
                }
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
                    Visible = fadeIn == true;
                }
                else
                {
                    progress = fadeIn
                                   ? Math.Min(1.0f, (currentTick - beginTick)/tickLength)
                                   : 1.0f - Math.Min(1.0f, (currentTick - beginTick) / tickLength);
                }
            }
        }

        #endregion

        #region IResource Members

        public virtual void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            initialized = true;
            manager = graphicsDeviceManager;
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

        #region IComparable Members

        public int CompareTo(object obj)
        {
            AbstractGUIComponent g = (AbstractGUIComponent)obj;
            return this.Layer.CompareTo(g.Layer);
        }

        #endregion
    }

}
