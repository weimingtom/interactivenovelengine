using System;
using System.Drawing;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using INovelEngine.Core;

namespace INovelEngine.Effector
{
             
    public class TextWindow : WindowBase
    {
        int index;
        string sourceText;
        string viewText;
        string scrollBuffer;

        int margin = 10;
        private bool InNarration = false;

        public Line line;
        SlimDX.Direct3D9.Font font;

        private bool wrapFlag = false;


        Vector2[] lines = new Vector2[2];

        public TextWindow(int color, int alpha, int x, int y, int width, int height, int layer, string text, int margin)
            : base(color, alpha, x, y, width, height, layer)
        {
            this.margin = margin;
            this.Text = text;
        }

        public string Text
        {
            get { return this.sourceText; }
            set
            {
                this.sourceText = value;
                this.WrapText();
            }
        }

        public override void Draw()
        {
            base.Draw();
        }

        public override void DrawWindow()
        {
            lines[0].X = x;
            lines[0].Y = y + height / 2;
            lines[1].X = x + width;
            lines[1].Y = y + height / 2;

            line.Width = height;
            line.Begin();
            line.Draw(this.lines, Color.FromArgb(alpha, color));
            line.End();
        }

        public override void DrawText()
        {
            this.sprite.Begin(SpriteFlags.AlphaBlend);
            TextRenderer.DrawText(this.sprite, this.font, scrollBuffer, this.x + margin, this.y + margin, width - margin * 2, height - margin * 2, Color.White);
            this.sprite.End();
            
            //textRenderer.DrawText(sourceText, this.x + margin, this.y + margin, width - margin * 2, height - margin * 2, Color.White);
        }

        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
 	        base.Initialize(graphicsDeviceManager);
            this.line = new Line(graphicsDeviceManager.Direct3D9.Device);

            this.font = TextRenderer.LoadFont(graphicsDeviceManager.Direct3D9.Device, "Meiryo", 30, FontWeight.UltraBold, false);
            
            if (wrapFlag) this.WrapText();
        }

        public void BeginNarrate(string text, int interval)
        {
            if (!InNarration)
            {

                this.InNarration = true;
                this.sourceText = text;
                this.index = 1;
                this.WrapText();
                this.scrollBuffer = "";
                Clock.AddTimeEvent(new TimeEvent(viewText.Length, interval, CountText));
            }
        }

        private void CountText()
        {
            scrollBuffer = viewText.Substring(0, index);
            index++;
            if (index > viewText.Length) this.InNarration = false;
        }

        private void WrapText()
        {
            if (this.font == null)
            {
                wrapFlag = true;
                return;
            }

            wrapFlag = false;

            int index = 0;
            bool EOL = false;
            String testBuffer;
            for (int i = 0; i <= this.sourceText.Length; i++)
            {
                testBuffer = sourceText.Substring(0, index);
                Rectangle measureRect = TextRenderer.MeasureText(this.font, testBuffer, Color.White);
                int expectedWidth = measureRect.Width;
                int expectedHeight = measureRect.Height;

                if (expectedWidth > width - this.margin * 2)
                {
                    sourceText = sourceText.Insert(index - 1, "\n");
                    if (!EOL) viewText = sourceText;
                    //index++;
                }

                if (!EOL) viewText = sourceText.Substring(0, index);

                if (expectedHeight > height - this.margin * 2 && !EOL)
                {
                    viewText = sourceText.Substring(0, index - 1);
                    EOL = true;
                    //return;
                }

                index++;
            }

            scrollBuffer = viewText;
        }

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            this.line.OnResetDevice();
            this.font.OnResetDevice();
            base.LoadContent();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public override void UnloadContent()
        {
            this.line.OnLostDevice();
            this.font.OnLostDevice();
            base.UnloadContent();
        }

    }

}
