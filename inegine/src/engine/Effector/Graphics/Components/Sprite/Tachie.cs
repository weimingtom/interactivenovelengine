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
        private RenderToSurface rtsHelper;
        private Surface renderSurface;
        private Viewport renderViewport;
        private bool dressInvalidated;

        protected Sprite sprite
        {
            get
            {
                return Supervisor.GetInstance().GetSpriteBatch();
            }
        }

        private INETexture bodyTexture;
        private INETexture dressTexture;

        private Texture renderTexture;

        private Rectangle sourceArea;
        private float relativePosition;

        public Tachie()
        {
            FadeOn = true;
            FadeTime = 150;
            Position = 0.5f;
            Width = 380;
            Height = 600;
            sourceArea = new Rectangle();
            sourceArea.X = 0;
            sourceArea.Y = 0;
            sourceArea.Width = Width;
            sourceArea.Height = Height;
            BackgroundWidth = Supervisor.GetInstance().GetWidth();
            renderViewport = new Viewport(0, 0, Width, Height);
            renderViewport.MaxZ = 1.0f;
            dressInvalidated = true;
            handleMyself = true;
        }

        public float FadeTime
        {
            get;
            set;
        }

        public bool FadeOn
        {
            get;
            set;
        }

        public override void FadeIn(float duration)
        {
            LaunchTransition(duration, true);

        }

        public override void FadeOut(float duration)
        {
            LaunchTransition(duration, false);
        }

        public string BodyTexture
        {
            get
            {
                return this.bodyTexture.TextureFile;
            }
            set
            {
                if (this.bodyTexture != null) resources.Remove(bodyTexture);
                bodyTexture = new INETexture(value);
                resources.Add(bodyTexture);
            }
        }

        private void processDressTexture()
        {
            if (bodyTexture == null)
            {
                Supervisor.Error("body texture not loaded");
                return;
            }


            if (dressTexture == null)
            {
                Supervisor.Error("body texture not loaded");
                return;
            }

            using (renderSurface = renderTexture.GetSurfaceLevel(0))
            {
                rtsHelper.BeginScene(renderSurface, renderViewport);
                
                Device.Clear(ClearFlags.Target | ClearFlags.ZBuffer, Color.Transparent, 1.0f, 0);
              
                sprite.Begin(SpriteFlags.AlphaBlend);

                sprite.Draw(this.bodyTexture.Texture, this.sourceArea, new Vector3(), new Vector3(0, 0, 0), Color.White);
                sprite.Draw(this.dressTexture.Texture, this.sourceArea, new Vector3(), new Vector3(0, 0, 0), Color.White);
            
                sprite.End();

                rtsHelper.EndScene(Filter.None);
            }

            Supervisor.Trace("tachie rendered");
        }

        public string DressTexture
        {
            get
            {
                return this.dressTexture.TextureFile;
            }
            set
            {
                if (this.dressTexture != null) resources.Remove(dressTexture);
                dressTexture = new INETexture(value);
                resources.Add(dressTexture);
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
                if (BackgroundWidth > 100 && Width > 50 && relativePosition > 0f && relativePosition < 1f)
                {
                    X = (int)(BackgroundWidth * relativePosition - Width / 2);
                }
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
            if (this.renderTexture == null) return;
            sprite.Begin(SpriteFlags.AlphaBlend);

            sprite.Draw(this.renderTexture, this.sourceArea, new Vector3(), new Vector3(RealX, RealY, 0), renderColor);

            sprite.End();
        }

        public override void Update(GameTime gameTime)
        {
            if (dressInvalidated && loaded)
            {
                processDressTexture();
                dressInvalidated = false;
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

            rtsHelper = new RenderToSurface(Device, renderViewport.Width, renderViewport.Height, Format.A8R8G8B8, 
                Format.D16);
            renderTexture = new Texture(Device, renderViewport.Width, renderViewport.Height, 1, Usage.RenderTarget,
                Format.A8R8G8B8, Pool.Default);
        }

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            base.LoadContent();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public override void UnloadContent()
        {
            base.UnloadContent();
        }


        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public override void Dispose()
        {
            base.Dispose();
            rtsHelper.Dispose();
        }


    }
}
