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
    public class FadingSprite : View
    {
        protected Sprite sprite
        {
            get
            {
                return Supervisor.GetInstance().GetSpriteBatch();
            }
        }

        private SpriteBase oldSprite;
        private SpriteBase currentSprite;

        private bool firstTime;
        
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

        public bool FirstTimeFadeOn
        {
            get;
            set;
        }

        public FadingSprite()
        {
            BackgroundColor = 0xFFFFFF;
            Alpha = 255;
            firstTime = true;
            FirstTimeFadeOn = true;
            FadeOn = true;
            FadeTime = 300;
            handleMyself = true;
        }

        public string Texture
        {
            get
            {
                return this.currentSprite.Texture;
            }
            set
            {
                if (this.currentSprite != null && this.currentSprite.Texture == value) 
                {
                    return; //do nothing since nothing changed
                }

                if (!firstTime)
                {
                    if (oldSprite != null)
                        RemoveComponent(oldSprite.Name);

                    oldSprite = currentSprite;
                    oldSprite.Layer = 5;
                    if (FadeOn)
                    {
                        oldSprite.FadeOut(FadeTime * 2);
                    }
                    else
                    {
                        oldSprite.Hide();
                    }
                }

                currentSprite = new SpriteBase();
                currentSprite.Layer = 9;
                currentSprite.Texture = value;
                currentSprite.Relative = true;
                currentSprite.X = 0;
                currentSprite.Y = 0;
                AddComponent(currentSprite);

                if (!firstTime || FirstTimeFadeOn)
                {
                    if (FadeOn)
                    {
                        currentSprite.FadeIn(FadeTime);
                    }
                    else
                    {
                        currentSprite.Show();
                    }
                }

                firstTime = false;
            }
        }

        public override void Draw()
        {
            base.Draw();
        }
    }
}
