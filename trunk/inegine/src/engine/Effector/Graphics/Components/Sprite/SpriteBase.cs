using System;
using System.Drawing;
using System.Collections.Generic;
using System.Drawing.Imaging;
using System.IO;
using System.Text;
using INovelEngine.ResourceManager;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using INovelEngine.Core;

namespace INovelEngine.Effector
{
    public class SpriteBase : AbstractGUIComponent, IComparable
    {
        protected GraphicsDeviceManager manager;
        protected Sprite sprite;

        public INETexture sourceImage;
        public Texture texture;
        public string textureFile;
        protected int alpha;
        protected Rectangle sourceArea;
        protected bool sourceAreaUsed = false;

        private float beginTick;
        private float endTick;
        private float currentTick;
        private float tickLength;
        private bool fadeIn;
        private bool inTransition = false;

        public bool Fading
        {
            get
            {
                return this.inTransition;
            }
        }

        public SpriteBase(String id, string textureFile, int x, int y, int layer, bool fadedOut)
        {
            this.id = id;
            this.textureFile = textureFile;

            this.sourceImage = new INETexture(textureFile);

            this.sourceArea.Width = sourceImage.width;
            this.sourceArea.Height = sourceImage.height;
            this.width = sourceImage.width;
            this.height = sourceImage.height;

            this.x = x;
            this.y = y;

            this.layer = layer;
            this.sourceArea = new Rectangle(0, 0, width, height);//sourceArea;
            this.sourceAreaUsed = true;
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

        #region IGameComponent Members

        protected override void DrawInternal()
        {
            if (FadedOut)
            {

            }
            else if (inTransition)
            {
                currentTick = Clock.GetTime();

                float progress = Math.Min(1.0f, (currentTick - beginTick) / tickLength);

                if (fadeIn == false) progress = 1.0f - progress;

                sprite.Begin(SpriteFlags.AlphaBlend);
                sprite.Draw(this.texture, this.sourceArea, new Vector3(), new Vector3(x, y, 0), Color.FromArgb((int)(progress * 255), Color.White));
                //sprite.Draw(this.texture, new Vector3(), new Vector3(x, y, 0), Color.FromArgb((int)(progress * 255), Color.White));
                sprite.End();

                if (currentTick >= endTick)
                {
                    inTransition = false;
                    if (fadeIn == false) FadedOut = true;
                    else FadedOut = false;
                }
            }
            else
            {
                sprite.Begin(SpriteFlags.AlphaBlend);
                sprite.Draw(this.texture, this.sourceArea, new Vector3(), new Vector3(x, y, 0), Color.White);
                //sprite.Draw(this.texture, new Vector3(), new Vector3(x, y, 0), Color.White);
                sprite.End();
            }
        }

        public override void Update(GameTime gameTime)
        {
        }

        #endregion

        /// <summary>
        /// Initializes the resource.
        /// </summary>
        /// <param name="graphicsDeviceManager">The graphics device manager.</param>
        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            manager = graphicsDeviceManager;
            sprite = new Sprite(manager.Direct3D9.Device);
            this.sourceImage.Initialize(graphicsDeviceManager);
        }

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            sprite.OnResetDevice();

            this.sourceImage.LoadContent();
            this.texture = sourceImage.texture;

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

        public void LaunchTransition(float duration, bool isFadingIn)
        {
            beginTick = Clock.GetTime();
            tickLength = duration;
            endTick = beginTick + duration;
            inTransition = true;
            fadeIn = isFadingIn;
            FadedOut = false;
        }


    }
}
