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
        protected Sprite sprite
        {
            get
            {
                return Supervisor.GetInstance().GetSpriteBatch();
            }
        }

        private SpriteBase oldBodySprite;
        private SpriteBase bodySprite;
        private SpriteBase oldDressSprite;
        private SpriteBase dressSprite;

        private bool dressFirstTime;
        private bool bodyFirstTime;
        
        private Rectangle sourceArea;
        private float relativePosition;

        public Tachie()
        {
            dressFirstTime = true;
            bodyFirstTime = true;
            FadeOn = true;
            FadeTime = 150;
            Position = 0.5f;
            Width = 380;
            Height = 600;
            sourceArea = new Rectangle();
            BackgroundWidth = Supervisor.GetInstance().GetWidth();

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

            bodySprite.FadeIn(duration);
            dressSprite.FadeIn(duration / 2);

        }

        public override void FadeOut(float duration)
        {
            LaunchTransition(duration, false);

            bodySprite.FadeOut(duration / 2);
            dressSprite.FadeOut(duration);
        }

        public string BodyTexture
        {
            get
            {
                return this.bodySprite.Texture;
            }
            set
            {
                if (this.bodySprite != null && this.bodySprite.Texture == value) 
                {
                    return; //do nothing since nothing changed
                }

                if (!bodyFirstTime)
                {
                    if (oldBodySprite != null)
                        RemoveComponent(oldBodySprite.Name);

                    oldBodySprite = bodySprite;
                    oldBodySprite.Layer = 5;
                    if (!this.Visible)
                    {
                        RemoveComponent(oldBodySprite.Name);
                        oldBodySprite = null;
                    }
                    else if (FadeOn)
                    {
                        oldBodySprite.FadeOut(FadeTime * 3);
                    }
                    else
                    {
                        oldBodySprite.Hide();
                    }
                }

                bodySprite = new SpriteBase();
                bodySprite.Layer = 4;
                bodySprite.Texture = value;
                bodySprite.Relative = true;
                bodySprite.X = 0;
                bodySprite.Y = 0;
                bodySprite.Width = Width;
                bodySprite.Height = Height;
                AddComponent(bodySprite);

                if (!bodyFirstTime)
                {
                    //if (FadeOn)
                    //{
                    //    bodySprite.FadeIn(FadeTime / 2);
                    //}
                    //else
                    //{
                        bodySprite.Show();
                    //}
                }

                bodyFirstTime = false;
            }
        }

        public string DressTexture
        {
            get
            {
                return dressSprite.Texture;
            }
            set
            {
                if (this.dressSprite != null && this.dressSprite.Texture == value)
                {
                    return; //do nothing since nothing changed
                }

                if (!dressFirstTime)
                {
                    if (oldDressSprite != null)
                        RemoveComponent(oldDressSprite.Name);

                    oldDressSprite = dressSprite;
                    oldDressSprite.Layer = 10;
                    if (!this.Visible)
                    {
                        RemoveComponent(oldDressSprite.Name);
                        oldDressSprite = null;
                    }
                    else if (FadeOn && this.Visible)
                    {
                        oldDressSprite.FadeOut(FadeTime * 3);
                    }
                    else
                    {
                        oldDressSprite.Hide();
                    }
                }

                dressSprite = new SpriteBase();
                dressSprite.Layer = 9;
                dressSprite.Texture = value;
                dressSprite.Relative = true;
                dressSprite.X = 0;
                dressSprite.Y = 0;
                dressSprite.Width = Width;
                dressSprite.Height = Height;
                AddComponent(dressSprite);

                if (!dressFirstTime)
                {
                    //if (FadeOn)
                    //{
                    //    dressSprite.FadeIn(FadeTime);
                    //}
                    //else
                    //{
                        dressSprite.Show();
                    //}
               }

                dressFirstTime = false;
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
            base.Initialize(graphicsDeviceManager);
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
        }


    }
}
