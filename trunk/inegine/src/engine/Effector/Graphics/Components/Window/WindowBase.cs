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
        public int color
        {
            get
            {
                return this._color.ToArgb();
            }

            set
            {
                this._color = Color.FromArgb(value);
            }
        }

        protected Color _color;
        public int alpha;

        protected GraphicsDeviceManager manager;
        protected Sprite sprite;

        public WindowBase(String id, int color, int alpha, int x, int y, int width, int height, int layer)
        {
            this.id = id;
            this.color = color;
            this.alpha = alpha;
            this.x = x;
            this.y = y;
            this.width = width;
            this.height = height;
            this.layer = layer;
        }

        /// <summary>
        /// Initializes the resource.
        /// </summary>
        /// <param name="graphicsDeviceManager">The graphics device manager.</param>
        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            manager = graphicsDeviceManager;
            sprite = new Sprite(manager.Direct3D9.Device);
        }

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            sprite.OnResetDevice();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public override void UnloadContent()
        {
            sprite.OnLostDevice();
        }


        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public override void Dispose()
        {
            sprite.Dispose();

            GC.SuppressFinalize(this);
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
