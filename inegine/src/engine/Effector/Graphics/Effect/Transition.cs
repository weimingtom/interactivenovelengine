using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using INovelEngine.Core;

namespace INovelEngine.Effector
{
    class Transition : IResource
    {
        private Line line;
        private Vector2[] linePath = new Vector2[2];
        private int thichkness;
        private float beginTick;
        private float endTick;
        private float currentTick;
        private float tickLength;
        private bool inTransition;
        private bool fadeIn;
        private bool fadedOut = false;
        private Color color;
        private GraphicsDeviceManager manager;
        
        public void LaunchTransition(int width, int height, float duration, bool isFadingIn, Color fadeColor)
        {
            linePath[0] = new Vector2(0, height / 2);
            linePath[1] = new Vector2(width, height / 2);
            thichkness = height;
            beginTick = Clock.GetTime();
            tickLength = duration;
            endTick = beginTick + duration;
            inTransition = true;
            fadeIn = isFadingIn;
            fadedOut = false;
            color = fadeColor;
        }

        public void FadeOutIn(int width, int height, float duration, Color fadeColor)
        {
            this.LaunchTransition(width, height, duration / 2, false, fadeColor);
            Clock.AddTimeEvent(new TimeEvent(1, duration / 2, 
                delegate()
                {
                    this.LaunchTransition(width, height, duration / 2, true, fadeColor);
                }
            ));
        }

        public void FadeOutImmediate(int width, int height, Color fadeColor)
        {
            linePath[0] = new Vector2(0, height / 2);
            linePath[1] = new Vector2(width, height / 2);
            thichkness = height;
            fadedOut = true;
            color = fadeColor;
        }

        public void Draw()
        {
            if (inTransition || fadedOut)
            {
                currentTick = Clock.GetTime();

                float progress = Math.Min(1.0f, (currentTick - beginTick) / tickLength);
                if (fadeIn) progress = 1.0f - progress;
                line.Width = thichkness;
                line.Begin();
                line.Draw(linePath, Color.FromArgb((int)(progress * 255), color));
                line.End();
                if (currentTick >= endTick)
                {
                    inTransition = false;
                    if (!fadeIn) fadedOut = true;
                }

            }
        }


        /// <summary>
        /// Initializes the resource.
        /// </summary>
        /// <param name="graphicsDeviceManager">The graphics device manager.</param>
        public virtual void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            manager = graphicsDeviceManager;
            this.line = new Line(manager.Direct3D9.Device);
        }

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public virtual void LoadContent()
        {
            line.OnResetDevice();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public virtual void UnloadContent()
        {
            line.OnLostDevice();
        }


        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public virtual void Dispose()
        {
            line.Dispose();

            GC.SuppressFinalize(this);
        }





    }
}
