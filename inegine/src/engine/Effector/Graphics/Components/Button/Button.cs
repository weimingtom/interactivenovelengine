using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using INovelEngine.Effector.Graphics.Text;
using INovelEngine.ResourceManager;
using SlimDX;
using SlimDX.Direct3D9;

namespace INovelEngine.Effector
{
    class Button : SpriteBase
    {
        protected Color _textColor = Color.Black;
        public int TextColor
        {
            get
            {
                return this._textColor.ToArgb();
            }

            set
            {
                _textColor = Color.FromArgb(value);
                _textColor = Color.FromArgb(255, _textColor);
            }
        }

        protected bool pushed = false;
        public bool Pushed
        {
            get
            {
                return pushed;
            }
            set
            {
                pushed = value;
            }
        }

        protected INEFont fontManager;
        public INEFont Font
        {
            get
            {
                return fontManager;
            }
            set
            {
                fontManager = value;
            }
        }

        private FreeFont freeFont
        {
            get
            {
                if (fontManager != null)
                {
                    return fontManager.Font;
                }
                else
                {
                    return null;
                }
            }
        }

        public string Text
        {
            get; set;
        }

        public void DrawText()
        {
            if (freeFont == null) throw new Exception("Font not loaded!");
            
            Size dim = this.freeFont.Measure(Text, Width);
            
            int leftMargin = (Width - dim.Width)/2;
            int topMargin = (Height - dim.Height)/2;


            if (pushed)
            {
                TextRenderer.DrawText(this.sprite, this.freeFont, Text, this.RealX + leftMargin + 2,
                                      this.RealY + topMargin + 2, Width - leftMargin * 2, Height - topMargin * 2, _textColor);
            }
            else
            {
                TextRenderer.DrawText(this.sprite, this.freeFont, Text, this.RealX + leftMargin,
                                       this.RealY + topMargin, Width - leftMargin * 2, Height - topMargin * 2, _textColor);
            }
        }

        protected override void DrawInternal()
        {
            sprite.Begin(SpriteFlags.AlphaBlend);


            if (this.Texture != null)
            {
                if (!Enabled)
                {
                    sprite.Draw(this.textureManager.Texture, this.sourceArea, new Vector3(),
                                new Vector3(RealX + 2, RealY + 2, 0), Color.DimGray);
                }
                else if (pushed)
                {
                    sprite.Draw(this.textureManager.Texture, this.sourceArea, new Vector3(),
                                new Vector3(RealX + 2, RealY + 2, 0), Color.LightSlateGray);
                }
                else
                {
                    sprite.Draw(this.textureManager.Texture, this.sourceArea, new Vector3(), new Vector3(RealX, RealY, 0), renderColor);
                }
            }

            DrawText();

            sprite.End();
        }
    }
}
