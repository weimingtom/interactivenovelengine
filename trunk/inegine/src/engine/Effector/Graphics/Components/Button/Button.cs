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

        protected int _margin = 5;
        public int Margin
        {
            get
            {
                return _margin;
            }
            set
            {
                _margin = value;
            }
        }

        protected int _alignment = 1;
        public int Alignment
        {
            get
            {
                return _alignment;
            }

            set
            {
                _alignment = value;
            }
        }


        protected int _verticalAlignment = 1;
        public int VerticalAlignment
        {
            get
            {
                return _verticalAlignment;
            }

            set
            {
                _verticalAlignment = value;
            }
        }

        public string Text
        {
            get; set;
        }

        protected void DrawText()
        {
            if (freeFont == null || Text == null) return;//throw new Exception("Font not loaded!");
            
            Size dim = this.freeFont.Measure(Text, Width);

            int leftMargin = 0;
            
            if (_alignment == 1)
            {
                leftMargin = (Width - dim.Width) / 2;
            }
            else if (_alignment == 0)
            {
                leftMargin = _margin;
            }
            else
            {
                leftMargin = (Width - dim.Width) - _margin;
            }

            int topMargin = 0;
            
            if (_verticalAlignment == 1)
            {
                topMargin = (Height - dim.Height)/2;
            }
            else if (_verticalAlignment == 0)
            {
                topMargin = _margin;
            }
            else
            {
                topMargin = (Height - dim.Height) - _margin;
            }


            if (pushed)
            {
                TextRenderer.DrawText(this.sprite, this.freeFont, Text, this.RealX + leftMargin + 2,
                                      this.RealY + topMargin + 2, Width - leftMargin * 2, Height - topMargin * 2, Color.FromArgb((int)(this.renderColor.A * GetEffectiveProgress()), _textColor));
            }
            else
            {
                TextRenderer.DrawText(this.sprite, this.freeFont, Text, this.RealX + leftMargin,
                                       this.RealY + topMargin, Width - leftMargin * 2, Height - topMargin * 2, Color.FromArgb((int)(this.renderColor.A * GetEffectiveProgress()), _textColor));
            }
        }

        protected override void DrawInternal()
        {
            sprite.Begin(SpriteFlags.AlphaBlend);


            if (this.Texture != null)
            {
                //if (!Enabled)
                //{
                //    sprite.Draw(this.textureManager.Texture, this.sourceArea, new Vector3(),
                //                new Vector3(RealX, RealY, 0), Color.DimGray);
                //}
                //else
                if (pushed)
                {
                    sprite.Draw(this.textureManager.Texture, this.sourceArea, new Vector3(),
                                new Vector3(RealX, RealY, 0), Color.LightSlateGray);
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
