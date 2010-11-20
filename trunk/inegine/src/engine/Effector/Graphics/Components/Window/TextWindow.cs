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
        private enum State
        {
            Started, Idle, Narrating, Waiting
        }

        public enum Mode
        {
            Narration, Skipping
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

        private State _printState = State.Idle;
        private readonly List<int> breaks = new List<int>();
        private int _breakIndex = 0;
        
        private string sourceText = "";
        private string viewText = "";
        private string scrollBuffer = "";

        public LuaEventHandler PrintOver;

        protected bool isStatic = false;

        public bool IsStatic
        {
            get
            {
                return isStatic;
            }
            set
            {
                isStatic = value;
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
        protected int narrationIndex = 0;

        public int narrationSpeed
        {
            get; set;
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

        private TimeEvent narrationEvent;

        public Line line;

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
        private bool wrapFlag = false;

        Vector2[] lines = new Vector2[2];
        private bool _cancelFlag = false; // flag for indicating whether to skip when beginning a new textout


        public TextWindow()
            : base()
        {
            this.Type = ComponentType.TextWindow;
            narrationSpeed = 50;
            LineSpacing = 20;
            IsStatic = true;
            _margin = 10;
        }

        public string Text
        {
            get { return this.sourceText; }
            set
            {
                this.isStatic = true;
                this.sourceText = value;
                this.WrapText();
                this.ParseText();
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
            line.Draw(this.lines, Color.FromArgb(_alpha, _backgroundColor));
            line.End();
        }

        public override void DrawText()
        {
            if (freeFont == null) return; //throw new Exception("Font not loaded!");

            this.sprite.Begin(SpriteFlags.AlphaBlend);

            Size dim = this.freeFont.Measure(isStatic?viewText:scrollBuffer);
            int leftMargin;
            int topMargin;
            if (this.centerText) leftMargin = (this.Width - dim.Width) / 2;
            else leftMargin = _leftmargin;
            if (this.centerTextVertically) topMargin = (this.Height - dim.Height) / 2;
            else topMargin = _margin;
            TextRenderer.DrawText(this.sprite, this.freeFont, isStatic ? viewText : scrollBuffer,
                                  this.RealX + leftMargin, this.RealY + topMargin,
                                  Width - _margin * 2, Height - _margin * 2, Color.White);

            if (_printState == State.Waiting)
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

        
        private void WrapText()
        {
            if (this.freeFont == null)
            {
                wrapFlag = true;
                return;
            }

            wrapFlag = false;

            viewText = sourceText;
        }


        private void ParseText()
        {
            this.breaks.Clear();
            for (int i = 0; i < this.viewText.Length; i++)
            {
                char currentChar = viewText[i];
                switch (currentChar)
                {
                    case '@':
                        viewText = viewText.Remove(i, 1);
                        this.breaks.Add(i);
                        break;
                    default:
                        break;
                }
            }
            //_breakIndex = 0;
        }

        private void CountText()
        {
            if (narrationIndex > 0 && viewText[narrationIndex - 1] == '[')
            {
                int tagEnd = viewText.IndexOf(']', narrationIndex - 1);
                if (tagEnd > -1)
                {
                    narrationIndex = tagEnd + 1;
                }
                else
                {
                    //_printState = State.Waiting;
                    //return;
                }
            }
 
            scrollBuffer = viewText.Substring(0, narrationIndex + 1);
            if (narrationIndex + 1 < viewText.Length)
            {
                narrationIndex++;
            }
            else
            {
                _printState = State.Idle;
            }
        }

        private void EndText()
        {
            this._printState = State.Waiting;
        }

        private void PrintOverEnd() // what to do when everything is printed
        {
            this.narrationEvent = null;
            this._printState = State.Idle;
            if (this.PrintOver != null) PrintOver(this, ScriptEvents.Etc, null);
        }

        private void SkipToNextBreak()
        {
            Clock.RemoveTimeEvent(this.narrationEvent);

            if (this.breaks.Count == 0)
            {
                this.scrollBuffer = viewText;
                this.narrationIndex = this.viewText.Length - 1;
                this._cancelFlag = true;
                PrintOverEnd();
            }
            else
            {
                if (!_cancelFlag && (_breakIndex >= this.breaks.Count || _breakIndex == 1 && this.breaks.Count == 1)) // last _breakIndex
                {
                    this.scrollBuffer = viewText;
                    this.narrationIndex = this.viewText.Length - 1;
                    this._cancelFlag = true;
                    PrintOverEnd();
                }
                else
                {
                    if (_cancelFlag) _cancelFlag = false;
                    this.scrollBuffer = this.viewText.Substring(0, breaks[_breakIndex - 1]);
                    this.narrationIndex = breaks[_breakIndex - 1];
                    this._printState = State.Waiting;
                }
            }    
        }

        public void AdvanceText()
        {
            if (this._printState == State.Narrating) // if in narration, skip to next stop
            {
                SkipToNextBreak();
                return;
            }
            else if (this._printState == State.Idle) // if in idle mode, do nothing
            {
                return;
            }
            else if (this._printState == State.Waiting || this._printState == State.Started)
            {
                if (this.viewText.Length == 0) return; // do nothing if viewtext length is zero
                
                if (this.breaks.Count == 0 || _breakIndex >= this.breaks.Count) // if there is no more text stop
                {
                    if (this.narrationMode == Mode.Narration)
                    {
                        int lengthToCount = 0;
                        lengthToCount = this.viewText.Length - narrationIndex;
                        this.narrationEvent = new TimeEvent(lengthToCount, narrationSpeed, CountText, PrintOverEnd);
                        Clock.AddTimeEvent(narrationEvent);
                        this._printState = State.Narrating;
                    }
                    else
                    {
                        this.scrollBuffer = viewText;
                        this._printState = State.Idle; 
                        if (this.PrintOver != null)
                        {
                            PrintOver(this, ScriptEvents.Etc, null);
                        }
                    }
                }
                else // if there is next text stop
                {
                    if (this.narrationMode == Mode.Narration)
                    {
                        int lengthToCount = 0;
                        lengthToCount = this.breaks[_breakIndex] + 1 - narrationIndex;
                        this.narrationEvent = new TimeEvent(lengthToCount, narrationSpeed, CountText, EndText);
                        Clock.AddTimeEvent(narrationEvent);
                        this._printState = State.Narrating;
                    }
                    else
                    {
                        this.scrollBuffer = viewText.Substring(0, this.breaks[_breakIndex]);
                        this._printState = State.Waiting;
                    }
                    _breakIndex++;
                }
            }

            if (_cancelFlag)
            {
                SkipToNextBreak();
            }
        }

        public void Clear()
        {
            this.sourceText = "";
            this.WrapText();
            this.ParseText();
            this._breakIndex = 0;
            this.narrationIndex = 0;
            //this.AdvanceText();
        }

        public Boolean Print(string value)
        {
            this.isStatic = false;
            this.sourceText += value;
            this.WrapText();
            this.ParseText();
            this._printState = State.Started;
            AdvanceText();
            if (this._printState == State.Waiting) return true;
            else if(this._printState == State.Narrating) return true;
            else if(this._printState == State.Idle) return false;
            else return false;
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

            if (wrapFlag)
            {
                this.WrapText();
                this.ParseText();
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
            line.Dispose();
            base.Dispose();
        }

    }

}
