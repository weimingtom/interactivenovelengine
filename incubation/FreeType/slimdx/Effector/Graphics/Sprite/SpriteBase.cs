using System;
using System.Drawing;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;

namespace INovelEngine
{
    public class SpriteBase : IComparable, IResource
    {
        public string id;
        protected GraphicsDeviceManager manager;
        protected Sprite sprite;
        public Texture texture;
        public string textureFile;
        public int x;
        public int y;
        public int layer;
        protected int alpha;
        public Rectangle sourceArea;
        protected bool sourceAreaUsed = false;

        private float beginTick;
        private float endTick;
        private float currentTick;
        private float tickLength;
        private bool fadeIn;
        private bool inTransition;

        public SpriteBase(string textureFile, int x, int y, int layer, Rectangle sourceArea, bool fadedOut)
        {
            this.textureFile = textureFile;
            this.x = x;
            this.y = y;
            this.layer = layer;
            this.sourceArea = sourceArea;
            this.sourceAreaUsed = true;
            this.FadedOut = fadedOut;
        }

        public SpriteBase(string textureFile, int x, int y, int layer, bool fadedOut)
        {
            this.textureFile = textureFile;
            this.x = x;
            this.y = y;
            this.layer = layer;
            this.sourceAreaUsed = false;
            this.FadedOut = fadedOut;
        }

        Device Device
        {
            get { return manager.Direct3D9.Device; }
        }

        public bool FadedOut
        {
            get;
            set;
        }

        public int CompareTo(Object rhs)
        {
            SpriteBase t = (SpriteBase)rhs;
            return this.layer.CompareTo(t.layer);
        }

        public void Draw()
        {
            if (FadedOut)
            {

            }
            else if (inTransition)
            {
                currentTick = Clock.GetTime();

                float progress = Math.Min(1.0f, (currentTick - beginTick) / tickLength);

                sprite.Begin(SpriteFlags.AlphaBlend);
                sprite.Draw(this.texture, new Vector3(), new Vector3(x, y, 0), Color.FromArgb((int)(progress * 255), Color.White));
                sprite.End();

                if (currentTick == endTick)
                {
                    inTransition = false;
                }
            }
            else
            {
                sprite.Begin(SpriteFlags.AlphaBlend);
                sprite.Draw(this.texture, new Vector3(), new Vector3(x, y, 0), Color.White);
                sprite.End();
            }
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
            this.texture = Texture.FromFile(Device, this.textureFile);
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

        public void LaunchTransition(float duration, bool isFadeingIn, Color fadeColor)
        {
            beginTick = Clock.GetTime();
            tickLength = duration;
            endTick = beginTick + duration;
            inTransition = true;
            fadeIn = isFadeingIn;
            FadedOut = false;
        }

    }
}
