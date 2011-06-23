using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using INovelEngine.Core;
using INovelEngine.Script;
using SampleFramework;

namespace INovelEngine.Effector.Graphics.Effect
{
    public class AbstractTransition : IResource
    {
        protected int thichkness;
        protected float beginTick;
        protected float endTick;
        protected float currentTick;
        protected float tickLength;
        protected bool inTransition;
        protected bool fadeIn;
        protected bool _fadedOut = false;
        protected bool fadedOut
        {
            get
            {
                return _fadedOut;
            }
            set
            {
                if (value)
                {
                    progress = 1.0f;
                }
                _fadedOut = value;
            }
        }

        protected Color color;

        protected GraphicsDeviceManager manager;
        protected float progress;


        public LuaEventHandler printOverHandler;

        public virtual void LaunchTransition(int width, int height, float duration, bool isFadingIn, Color fadeColor)
        {
            beginTick = Clock.GetTime();
            tickLength = duration;
            endTick = beginTick + duration;
            inTransition = true;
            fadeIn = isFadingIn;
            fadedOut = false;
            color = fadeColor;
        }

        public virtual void Draw()
        {

        }

        public virtual void Update()
        {
            if (inTransition || fadedOut)
            {
                currentTick = Clock.GetTime();

                progress = Math.Max(0, Math.Min(1.0f, (currentTick - beginTick) / tickLength));
                if (fadeIn) progress = 1.0f - progress;

                if (currentTick >= endTick)
                {
                    inTransition = false;
                    if (!fadeIn) fadedOut = true;
                }
            }
        }

        #region IResource Members

        public virtual void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            manager = graphicsDeviceManager;
        }

        public virtual void LoadContent()
        {
        }

        public virtual void UnloadContent()
        {
        }

        #endregion

        #region IDisposable Members

        public virtual void Dispose()
        {
            GC.SuppressFinalize(this);
        }

        #endregion
    }
}
