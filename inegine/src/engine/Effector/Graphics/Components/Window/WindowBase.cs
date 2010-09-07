using System;
using System.Drawing;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using SlimDX.Direct3D9;

namespace INovelEngine.Effector
{
    public class WindowBase : AbstractGUIComponent
    {
        protected Color _backgroundColor;
        public int BackgroundColor
        {
            get
            {
                return this._backgroundColor.ToArgb();
            }

            set
            {
                this._backgroundColor = Color.FromArgb(value);
                this._backgroundColor = Color.FromArgb(255, _backgroundColor); 
            }
        }

        protected Sprite sprite;

        public WindowBase()
        {
            Alpha = 255;
            BackgroundColor = 0x000000;
        }

        /// <summary>
        /// Initializes the resource.
        /// </summary>
        /// <param name="graphicsDeviceManager">The graphics device manager.</param>
        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            base.Initialize(graphicsDeviceManager);
            manager = graphicsDeviceManager;
            sprite = new Sprite(manager.Direct3D9.Device);
        }

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            base.LoadContent();
            sprite.OnResetDevice();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public override void UnloadContent()
        {
            base.UnloadContent();
            sprite.OnLostDevice();
        }


        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public override void Dispose()
        {
            sprite.Dispose();
            //GC.SuppressFinalize(this);
            base.Dispose();
        }


        protected override void DrawInternal()
        {
            this.DrawWindow();
            this.DrawText();
        }

        /// <summary>
        /// Does cool things to the entity, if you know what I mean.
        /// </summary>
        /// <param name="gameTime">What do you think it is?</param>
        public override void Update(GameTime gameTime)
        {
        }

        public virtual void DrawWindow()
        {
        }

        public virtual void DrawText()
        {
        }
    }
}
