using System;
using System.Drawing;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using SlimDX.Direct3D9;

namespace INovelEngine
{
    public class WindowBase : IComparable, IResource, IGameComponent
    {
        public string id;
        public Color color;
        public int alpha;


        public int x;
        public int y;
        public int width;
        public int height;
        public int layer;

        protected GraphicsDeviceManager manager;
        protected Sprite sprite;

        public WindowBase(Color color, int alpha, int x, int y, int width, int height, int layer)
        {
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
        public virtual void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            manager = graphicsDeviceManager;
            sprite = new Sprite(manager.Direct3D9.Device);
        }

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public virtual void LoadContent()
        {
            sprite.OnResetDevice();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public virtual void UnloadContent()
        {
            sprite.OnLostDevice();
        }


        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public virtual void Dispose()
        {
            sprite.Dispose();

            GC.SuppressFinalize(this);
        }


        public virtual void Draw()
        {
            this.DrawWindow();
            this.DrawText();
        }

        /// <summary>
        /// Does cool things to the entity, if you know what I mean.
        /// </summary>
        /// <param name="gameTime">What do you think it is?</param>
        public virtual void Update(GameTime gameTime)
        {
        }

        public virtual void DrawWindow()
        {
        }

        public virtual void DrawText()
        {
        }

        public int CompareTo(Object rhs)
        {
            WindowBase t = (WindowBase)rhs;
            return this.layer.CompareTo(t.layer);
        }

    }
}
