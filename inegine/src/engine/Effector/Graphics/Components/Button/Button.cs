using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using INovelEngine.Effector.Graphics.Text;
using INovelEngine.ResourceManager;
using SlimDX.Direct3D9;

namespace INovelEngine.Effector.Graphics.Components.Button
{
    class Button : SpriteBase
    {
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

            this.sprite.Begin(SpriteFlags.AlphaBlend);
            
            Size dim = this.freeFont.Measure(Text, Width);
            
            int leftMargin = (Width - dim.Width)/2;
            int topMargin = (Height - dim.Height)/2;
            
            TextRenderer.DrawText(this.sprite, this.freeFont, Text, this.X + leftMargin,
                                  this.Y + topMargin, Width - leftMargin * 2, Height - topMargin * 2, Color.White);
       
            this.sprite.End();
        }
    }
}
