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
    public class Tachie : AbstractGUIComponent
    {
        private Sprite sprite;
        private INETexture bodyTexture;
        private INETexture dressTexture;
        private Rectangle sourceArea;
        private float relativePosition;

        public Tachie()
        {
            sourceArea = new Rectangle();
            BackgroundWidth = Supervisor.GetInstance().GetWidth();
        }

        public string BodyTexture
        {
            get
            {
                if (this.bodyTexture != null)
                {
                    return this.bodyTexture.TextureFile;
                }
                else
                {
                    return null;
                }
            }
            set
            {
                if (this.bodyTexture != null) resources.Remove(bodyTexture);
                bodyTexture = new INETexture(value);
                resources.Add(bodyTexture);
                if (this.loaded)
                {
                    bodyTexture.Initialize(manager);
                    bodyTexture.LoadContent();
                }
                SetDimensions(bodyTexture);
            }
        }

        public string DressTexture
        {
            get
            {
                if (this.dressTexture != null)
                {
                    return this.dressTexture.TextureFile;
                }
                else
                {
                    return null;
                }
            }
            set
            {
                if (this.dressTexture != null) resources.Remove(dressTexture);
                dressTexture = new INETexture(value);
                resources.Add(dressTexture);
                if (this.loaded)
                {
                    dressTexture.Initialize(manager);
                    dressTexture.LoadContent();
                }
                SetDimensions(dressTexture);
            }
        }

        public float BackgroundWidth
        {
            get;
            set;
        }

        public float Position
        {
            get
            {
                return relativePosition;
            }
            set
            {
                this.relativePosition = value;
            }
        }

        protected virtual void SetDimensions(INETexture texture)
        {
            sourceArea.Width = texture.Width;
            sourceArea.Height = texture.Height;
            Width = texture.Width;
            Height = texture.Height;
        }

        #region IGameComponent Members

        protected override void DrawInternal()
        {
            sprite.Begin(SpriteFlags.AlphaBlend);
            
            if (this.bodyTexture != null)
            {
                sprite.Draw(this.bodyTexture.Texture, this.sourceArea, new Vector3(), new Vector3(RealX, RealY, 0), renderColor);
            }

            if (this.dressTexture != null)
            {
                sprite.Draw(this.dressTexture.Texture, this.sourceArea, new Vector3(), new Vector3(RealX, RealY, 0), renderColor);
            }

            sprite.End();
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            if (BackgroundWidth > 100 && Width > 50 && relativePosition > 0f && relativePosition < 1f)
            {
                X = (int)(BackgroundWidth * relativePosition - Width / 2);
            }
        }

        #endregion
        /// <summary>
        /// Initializes the resource.
        /// </summary>
        /// <param name="graphicsDeviceManager">The graphics device manager.</param>
        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            base.Initialize(graphicsDeviceManager);
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
    }
}
