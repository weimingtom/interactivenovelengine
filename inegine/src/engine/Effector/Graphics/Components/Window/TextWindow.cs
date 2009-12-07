using System;
using System.Drawing;
using System.Collections.Generic;
using System.Text;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using INovelEngine.Core;
using INovelEngine.Script;

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
            Narration, Static
        }

        private State printState = State.Idle;
        private List<int> breaks = new List<int>();
        int index = 0;
        
        string sourceText = "";
        private string viewText = "";
        string scrollBuffer = "";
        public LuaEventHandler printOverHandler;

        public Mode narrationMode = Mode.Static;
        private int narrationIndex = 0;
        public int narrationSpeed
        {
            get; set;
        }

        int margin = 10;
        private TimeEvent narrationEvent;
        private bool InNarration = false;

        public Line line;
        SlimDX.Direct3D9.Font font;

        private bool wrapFlag = false;

        Vector2[] lines = new Vector2[2];

        public TextWindow(String id, int color, int alpha, int x, int y, int width, int height, int layer, string text, int margin)
            : base(id, color, alpha, x, y, width, height, layer)
        {
            this.type = ComponentType.TextWindow;
            this.margin = margin;
            this.Text = text;
            this.narrationSpeed = 50;
        }

        public string Text
        {
            get { return this.sourceText; }
            set
            {
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
            lines[0].X = x;
            lines[0].Y = y + height / 2;
            lines[1].X = x + width;
            lines[1].Y = y + height / 2;

            line.Width = height;
            line.Begin();
            line.Draw(this.lines, Color.FromArgb(alpha, _color));
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

            int index = 0;
            bool EOL = false;
            String testBuffer;
            Rectangle measureRect;
            int expectedWidth, expectedHeight;
            for (int i = 0; i <= this.sourceText.Length; i++)
            {
                testBuffer = sourceText.Substring(0, index);
                measureRect = TextRenderer.MeasureText(this.font, testBuffer, Color.White);
                expectedWidth = measureRect.Width;
                expectedHeight = measureRect.Height;

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
            //scrollBuffer = viewText;
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
            //index = 0;
        }

        private void CountText()
        {
            scrollBuffer = viewText.Substring(0, narrationIndex);
            if (narrationIndex + 1 >= viewText.Length) this.InNarration = false;
            else narrationIndex++;
        }

        private void EndText()
        {
            this.InNarration = false;
        }

        private void PrintOverEnd()
        {
            this.InNarration = false;
            this.narrationEvent = null;
            this.printState = State.Idle;
            if (this.printOverHandler != null) printOverHandler(this, ScriptEvents.Etc, null);
        }

        private void CancelNarration()
        {
            Console.WriteLine("cancelling!");
            Clock.RemoveTimeEvent(this.narrationEvent);
            this.InNarration = false;

            if (this.breaks.Count == 0)
            {
                this.scrollBuffer = viewText;
                this.narrationIndex = this.viewText.Length - 1;
                PrintOverEnd();
            }
            else
            {
                Console.WriteLine(index);
                if (index > this.breaks.Count) // last index
                {
                    this.scrollBuffer = viewText;
                    this.narrationIndex = this.viewText.Length - 1;
                    PrintOverEnd();
                }
                else
                {
                    this.scrollBuffer = this.viewText.Substring(0, breaks[index - 1]);
                    this.narrationIndex = breaks[index - 1];
                }
            }    
        }

        public void AdvanceText()
        {
            if (InNarration)
            {
                CancelNarration();
                return;
            }
            if (this.printState == State.Idle)
            {
                return;
            }
            if (this.viewText.Length > 0)
            {
                if (this.breaks.Count == 0)
                {
                    if (this.narrationMode == Mode.Narration)
                    {
                        this.InNarration = true;
                        this.narrationEvent = new TimeEvent(viewText.Length, narrationSpeed, CountText, PrintOverEnd);
                        Clock.AddTimeEvent(narrationEvent);
                        Console.WriteLine("adding event!");
                        this.printState = State.Narrating;
                    }
                    else
                    {
                        this.scrollBuffer = viewText;
                        this.printState = State.Idle;
                    }
                }
                else
                {
                    if (index < this.breaks.Count)
                    {
                        if (this.narrationMode == Mode.Narration)
                        {
                            this.InNarration = true;
                            int countCount = 0;
                            countCount = this.breaks[index] + 1 - narrationIndex;
                            this.narrationEvent = new TimeEvent(countCount, narrationSpeed, CountText, EndText);
                            Clock.AddTimeEvent(narrationEvent);

                            Console.WriteLine("adding event!");
                            this.printState = State.Narrating;
                        }
                        else {
                            this.scrollBuffer = viewText.Substring(0, this.breaks[index]);
                            this.printState = State.Waiting;                            
                        }
                        index++;
                    }
                    else
                    {
                        if (this.narrationMode == Mode.Narration)
                        {
                            this.InNarration = true;
                            int countCount = 0;
                            countCount = this.viewText.Length - narrationIndex;
                            this.narrationEvent = new TimeEvent(countCount, narrationSpeed, CountText, PrintOverEnd);
                            Clock.AddTimeEvent(narrationEvent);
                            Console.WriteLine("adding event!");
                            this.printState = State.Narrating;
                        }
                        else {
                            this.scrollBuffer = viewText;
                            this.printState = State.Idle;
                            if (this.printOverHandler != null)
                            {
                                printOverHandler(this, ScriptEvents.Etc, null);
                            }
                        }
                    }
                }
            }
            else
            {
                this.scrollBuffer = "";
                this.printState = State.Idle;
            }
            
        }

        public void Clear()
        {
            this.Text = "";
            this.index = 0;
            this.narrationIndex = 0;
            this.AdvanceText();
        }

        public Boolean Print(string value)
        {
            this.Text += value;
            this.printState = State.Started;
            AdvanceText();
            if (this.printState == State.Waiting) return true;
            else if(this.printState == State.Narrating) return true;
            else if(this.printState == State.Idle) return false;
            else return false;
        }


        public void TurnOnNarration()
        {
            this.narrationMode = Mode.Narration;
        }

        public void TurnOffNarration()
        {
            this.narrationMode = Mode.Static;
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
