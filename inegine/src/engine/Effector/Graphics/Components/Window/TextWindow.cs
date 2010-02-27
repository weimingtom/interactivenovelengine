using System;
using System.Drawing;
using System.Collections.Generic;
using System.Text;
using INovelEngine.Effector.Graphics.Text;
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


        private AnimatedSprite cursorSprite = new AnimatedSprite();

        private State _printState = State.Idle;
        private readonly List<int> breaks = new List<int>();
        private int _breakIndex = 0;
        
        private string sourceText = "";
        private string viewText = "";
        private string scrollBuffer = "";
        public LuaEventHandler printOverHandler;

        public bool isStatic = false;
        public bool centerText = false;
        private Mode narrationMode = Mode.Narration;
        private int narrationIndex = 0;

        public int narrationSpeed
        {
            get; set;
        }

        private int _lineSpacing;

        public int lineSpacing
        {
            get
            {
                return this._lineSpacing;
            }
            set
            {
                this._lineSpacing = value;
                if (this.font != null) this.font.LineSpacing = _lineSpacing;
            }
        }

        public int margin = 10;
        private TimeEvent narrationEvent;

        public Line line;
        //SlimDX.Direct3D9.Font font;
        private FreeFont font;

        private bool wrapFlag = false;

        Vector2[] lines = new Vector2[2];
        private bool _cancelFlag = false; // flag for indicating whether to skip when beginning a new textout

        private bool _rubyOn;
        private int _fontSize;

        public TextWindow(String id, int color, int alpha, int x, int y, int width, int height, int layer, string text, int fontSize, bool rubyOn, int margin)
            : base(id, color, alpha, x, y, width, height, layer)
        {
            this.Type = ComponentType.TextWindow;
            this._fontSize = fontSize;
            this._rubyOn = rubyOn;
            this.margin = margin;
            this.Text = text;
            this.narrationSpeed = 50;
            this.lineSpacing = 20;
        }

        public string Text
        {
            get { return this.sourceText; }
            set
            {
                Console.WriteLine(value);
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
            lines[0].X = X;
            lines[0].Y = Y + Height / 2;
            lines[1].X = X + Width;
            lines[1].Y = Y + Height / 2;

            line.Width = Height;
            line.Begin();
            line.Draw(this.lines, Color.FromArgb(alpha, _color));
            line.End();
        }

        public override void DrawText()
        {
            this.sprite.Begin(SpriteFlags.AlphaBlend);

            if (isStatic)
            {
                Size dim = this.font.Measure(viewText);
                int leftMargin;
                if (this.centerText) leftMargin = (this.Width - dim.Width)/2;
                else leftMargin = margin;
                TextRenderer.DrawText(this.sprite, this.font, viewText, this.X + leftMargin,
                                      this.Y + margin, Width - margin * 2, Height - margin * 2, Color.White);
            }
            else
            {
                TextRenderer.DrawText(this.sprite, this.font, scrollBuffer, this.X + margin,
                                      this.Y + margin, Width - margin * 2, Height - margin * 2, Color.White);
            }

            if (_printState == State.Waiting)
            {
                cursorSprite.X = (int)TextRenderer.cursorPosition.X;
                cursorSprite.Y = (int)TextRenderer.cursorPosition.Y;
                if (cursorSprite.X + cursorSprite.Width > this.Width)
                {
                    cursorSprite.X = 0;
                    cursorSprite.Y = cursorSprite.Y + this.font.Size + this.font.LineSpacing;
                }
                cursorSprite.X += this.X + this.margin;

                if (cursorSprite.Y + cursorSprite.Height <= this.Height)
                {
                    cursorSprite.Y += this.Y + this.margin;
                    cursorSprite.Draw();
                }
            }
            this.sprite.End();
            
            //textRenderer.DrawText(sourceText, this.x + margin, this.y + margin, width - margin * 2, height - margin * 2, Color.White);
        }

        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
 	        base.Initialize(graphicsDeviceManager);
            this.line = new Line(graphicsDeviceManager.Direct3D9.Device);
            this.cursorSprite.Initialize(graphicsDeviceManager);
            this.cursorSprite.Begin(100, 0, 2, true);
            //this.font = TextRenderer.LoadFont(graphicsDeviceManager, "Resources\\meiryo.ttc", 25, FontWeight.UltraBold, false);
            this.font = TextRenderer.LoadFont(graphicsDeviceManager, "c:\\windows\\fonts\\gulim.ttc", _rubyOn, _fontSize, FontWeight.UltraBold, false);
            this.font.LineSpacing = lineSpacing;
            this.font.TextEffect = FreeFont.Effect.Shadow;

            if (wrapFlag)
            {
                this.WrapText();
                this.ParseText();
            }
        }

        private void WrapText()
        {
            if (this.font == null)
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
 
            scrollBuffer = viewText.Substring(0, narrationIndex);
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
            if (this.printOverHandler != null) printOverHandler(this, ScriptEvents.Etc, null);
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
                        if (this.printOverHandler != null)
                        {
                            printOverHandler(this, ScriptEvents.Etc, null);
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
            this.Text = "";
            this._breakIndex = 0;
            this.narrationIndex = 0;
            //this.AdvanceText();
        }

        public Boolean Print(string value)
        {
            this.Text += value;
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

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            this.line.OnResetDevice();
            //this.font.OnResetDevice();
            cursorSprite.LoadContent();
            base.LoadContent();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public override void UnloadContent()
        {
            this.line.OnLostDevice();
            //this.font.OnLostDevice();
            cursorSprite.UnloadContent();
            base.UnloadContent();
        }

    }

}
