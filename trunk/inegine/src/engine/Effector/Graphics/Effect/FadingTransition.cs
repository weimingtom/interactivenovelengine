using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using INovelEngine.Effector.Graphics.Effect;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using INovelEngine.Core;

namespace INovelEngine.Effector
{
    class FadingTransition : AbstractTransition
    {
        private Line line;
        private Vector2[] linePath = new Vector2[2];

        
        public FadingTransition()
            : base()
        {
        }

        public override void LaunchTransition(int width, int height, float duration, bool isFadingIn, Color fadeColor)
        {
            base.LaunchTransition(width, height, duration, isFadingIn, fadeColor);
            linePath[0] = new Vector2(0, height / 2);
            linePath[1] = new Vector2(width, height / 2);
            thichkness = height;
        }

        public void FadeOutIn(int width, int height, int duration, Color fadeColor)
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

        public override void Draw()
        {
            base.Draw();

            if (inTransition || fadedOut)
            {
                line.Width = thichkness;
                line.Begin();
                line.Draw(linePath, Color.FromArgb((int)(progress * 255), color));
                line.End();
            }
        }

        public override void Update()
        {
            base.Update();
        }


        /// <summary>
        /// Initializes the resource.
        /// </summary>
        /// <param name="graphicsDeviceManager">The graphics device manager.</param>
        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            base.Initialize(graphicsDeviceManager);
            this.line = new Line(manager.Direct3D9.Device);
        }

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            base.LoadContent();
            line.OnResetDevice();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public override void UnloadContent()
        {
            base.UnloadContent();
            line.OnLostDevice();
        }


        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public override void Dispose()
        {
            base.Dispose();
            line.Dispose();
        }





    }
}
