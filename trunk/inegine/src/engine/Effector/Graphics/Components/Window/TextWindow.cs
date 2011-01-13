using System;
using System.Drawing;
using System.Collections.Generic;
using System.Text;
using INovelEngine.Effector.Graphics.Text;
using INovelEngine.ResourceManager;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using INovelEngine.Core;
using INovelEngine.Script;
using Font=SlimDX.Direct3D9.Font;

namespace INovelEngine.Effector
{
    public class TextWindow : WindowBase
    {
        public enum Mode
        {
            Narration, Skipping
        }

        protected TextNarrator textNarrator;

        protected Color _textColor;
        protected bool printOverCalled;

        public TextWindow()
            : base()
        {
            narrationSpeed = 50;
            LineSpacing = 20;
            IsStatic = true;
            TextColor = 0xFFFFFF;
            _margin = 10;
            textNarrator = new TextNarrator();
            printOverCalled = false;
            lines = new Vector2[2];
        }

        public int TextColor
        {
            get
            {
                return this._textColor.ToArgb();
            }

            set
            {
                this._textColor = Color.FromArgb(value);
                this._textColor = Color.FromArgb(255, _textColor); 
            }
        }


        private AnimatedSprite cursorSprite;

        public AnimatedSprite Cursor
        {
            get
            {
                return cursorSprite;
            }
            set
            {
                cursorSprite = value;
            }
        }

        public LuaEventHandler PrintOver;
        private TimeEvent tickEvent;
        
        protected bool isStatic;

        public bool IsStatic
        {
            get
            {
                return isStatic;
            }
            set
            {
                isStatic = value;

                if (isStatic)
                {
                    stopTickEvent();
                }
                else
                {
                    startTickEvent();
                }
            }
        }

        protected bool centerTextVertically = false;

        public bool CenterTextVertically
        {
            get
            {
                return centerTextVertically;
            }
            set
            {
                centerTextVertically = value;
            }
        }
        protected bool centerText = false;
        
        public bool CenterText
        {
            get
            {
                return centerText;
            }
            set
            {
                centerText = value;
            }
        }

        protected Mode narrationMode = Mode.Narration;

        private int _narrationSpeed;
        public int narrationSpeed
        {
            get
            {
                return _narrationSpeed;
            }
            set
            {
                _narrationSpeed = value;
                if (!this.isStatic)
                {
                    stopTickEvent();
                    startTickEvent();
                }
            }
        }

        private void startTickEvent()
        {
            if (tickEvent == null)
            {
                tickEvent = new TimeEvent(_narrationSpeed, TickText);
                Clock.AddTimeEvent(tickEvent);
            }
        }

        private void stopTickEvent()
        {
            if (tickEvent != null)
            {
                Clock.RemoveTimeEvent(tickEvent);
                tickEvent = null;
            }
        }
        private int _lineSpacing;

        public int LineSpacing
        {
            get
            {
                return this._lineSpacing;
            }
            set
            {
                this._lineSpacing = value;
                if (this.freeFont != null) this.freeFont.LineSpacing = _lineSpacing;
            }
        }

        protected int _margin = 10;
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

        protected int _leftmargin = 10;
        public int LeftMargin
        {
            get
            {
                return _leftmargin;
            }
            set
            {
                _leftmargin = value;
            }
        }

        private Line line;

        private INEFont fontManager;

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
        
        Vector2[] lines;
        
        public string Text
        {
            set
            {
                IsStatic = true;
                stopTickEvent();
                textNarrator.Clear();
                textNarrator.AppendText(value);
            }
        }

        public override void Draw()
        {
            base.Draw();
        }

        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
        }

        public override void DrawWindow()
        {
            lines[0].X = RealX;
            lines[0].Y = RealY + Height / 2;
            lines[1].X = RealX + Width;
            lines[1].Y = RealY + Height / 2;

            line.Width = (float)Math.Max(0.000001, Height); // FIXME
            line.Begin();
            if (this.Fading)
            {
                line.Draw(this.lines, Color.FromArgb((int)(progress * _alpha), _backgroundColor));
            }
            else
            {
                line.Draw(this.lines, Color.FromArgb(_alpha, _backgroundColor));
            }
            line.End();
        }

        public override void DrawText()
        {
            if (freeFont == null) return; //throw new Exception("Font not loaded!");

            this.sprite.Begin(SpriteFlags.AlphaBlend);

            Size dim = this.freeFont.Measure(isStatic ? textNarrator.SourceString : textNarrator.OutputString);
            int leftMargin;
            int topMargin;
            if (this.centerText) leftMargin = (this.Width - dim.Width) / 2;
            else leftMargin = _leftmargin;
            if (this.centerTextVertically) topMargin = (this.Height - dim.Height) / 2;
            else topMargin = _margin;
            //if (Fading)
            //{
            //    TextRenderer.DrawText(this.sprite, this.freeFont, isStatic ? viewText : scrollBuffer,
            //                          this.RealX + leftMargin, this.RealY + topMargin,
            //                          Width - _margin * 2, Height - _margin * 2, Color.FromArgb(255, this._textColor));
            //}
            //else
            //{
            TextRenderer.DrawText(this.sprite, this.freeFont, isStatic ? textNarrator.SourceString : textNarrator.OutputString,
                                  this.RealX + leftMargin, this.RealY + topMargin,
                                  Width - leftMargin * 2, Height - _margin * 2, Color.FromArgb(255, this._textColor));
            //}
            if (textNarrator.State == NarrationState.Stopped)
            {
                if (cursorSprite != null)
                {
                    cursorSprite.X = (int)TextRenderer.cursorPosition.X;
                    cursorSprite.Y = (int)TextRenderer.cursorPosition.Y;
                    if (cursorSprite.RealX + cursorSprite.Width > this.Width)
                    {
                        cursorSprite.X = 0;
                        cursorSprite.Y = cursorSprite.RealY + this.freeFont.Size + this.freeFont.LineSpacing;
                    }
                    cursorSprite.X += this.RealX + leftMargin;

                    if (cursorSprite.RealY + cursorSprite.Height <= this.Height)
                    {
                        cursorSprite.Y += this.RealY + topMargin;
                        cursorSprite.Draw();
                    }
                }
            }
            this.sprite.End();
        }

        private void PrintOverEnd() // what to do when everything is printed
        {
            if (this.PrintOver != null)
            {
                try
                {
                    Supervisor.CallLater(PrintOver); 
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
            }
        }

        public void AdvanceText()
        {
            textNarrator.Advance();
        }

        public void Clear()
        {
            textNarrator.Clear();
        }

        public void Print(string value)
        {
            IsStatic = false;
            startTickEvent();
            printOverCalled = false;
            textNarrator.AppendText(value);
        }

        private void TickText()
        {
            if (textNarrator.State == NarrationState.Over && !printOverCalled)
            {
                printOverCalled = true;
                PrintOverEnd();
            }
            else
            {
                textNarrator.Tick();
            }
        }


        public void TurnOffSkip()
        {
            this.narrationMode = Mode.Narration;
        }

        public void TurnOnSkip()
        {
            this.narrationMode = Mode.Skipping;
        }

        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            base.Initialize(graphicsDeviceManager);
            this.line = new Line(graphicsDeviceManager.Direct3D9.Device);
            if (cursorSprite != null)
            {
                this.cursorSprite.Initialize(graphicsDeviceManager);
                this.cursorSprite.Begin(100, 0, 2, true);
            }
        }


        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            this.line.OnResetDevice();
            if (cursorSprite != null) cursorSprite.LoadContent();
            base.LoadContent();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public override void UnloadContent()
        {
            this.line.OnLostDevice();
            if (cursorSprite != null) cursorSprite.UnloadContent();
            base.UnloadContent();
        }

        public override void Dispose()
        {
            if (Cursor != null)
            {
                Cursor.Dispose();
            }
            line.Dispose();
            base.Dispose();
        }

    }

}
