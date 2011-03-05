using System;
using System.Collections.Generic;
using System.Text;
using INovelEngine.Core;
using INovelEngine.Script;
using LuaInterface;

namespace INovelEngine.Effector
{
    public class AnimatedSprite : SpriteBase
    {
        public int Cols
        {
            get;
            set;
        }

        public int Rows
        {
            get;
            set;
        }

        public override int Width
        {
            get
            {
                return this.tileWidth;
            }
            set
            {
                tileWidth = Math.Max(0, value);
                sourceArea.Width = tileWidth;
            }
        }

        public override int Height
        {
            get
            {
                return this.tileHeight;
            }
            set
            {
                tileHeight = Math.Max(0, value);
                sourceArea.Height = tileHeight;
            }
        }

        protected int startFrame = 0;
        protected int endFrame = 0;
        public bool inAnimation = false;
        protected TimeEvent updateEvent;

        protected int tileWidth;
        protected int tileHeight;
        
        protected int _frame;
        
        public int Frame
        {
            get
            {
                return this._frame;
            }
            set
            {
                if (this.endFrame < value)
                {
                    this._frame = startFrame;
                }
                else if (value < startFrame)
                {
                    this._frame = endFrame;
                }
                else
                {
                    this._frame = value;
                }

                int rownum = this._frame / Cols;
                int colnum = this._frame % Cols;
                this.sourceArea.Y = rownum * tileHeight;
                this.sourceArea.X = colnum * tileWidth;


            }
        }

        public AnimatedSprite()
            : base()
        {
            Rows = 0;
            Cols = 0;
        }

        protected override void SetDimensions()
        {
        }

        public override void Update(SampleFramework.GameTime gameTime)
        {
            base.Update(gameTime);
        }

        public void UpdateFrame()
        {
            this.Frame++;
        }

        public void EndFrame()
        {
            int id = this.updateEvent.timeID;
            this.updateEvent = null;
            this.inAnimation = false;
            this.Frame = this.endFrame;
            if (this.AnimationOver != null)
                try
                {
                    this.AnimationOver(this, ScriptEvents.AnimationOver, id);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
        }

        public void Begin(int interval)
        {
            Begin(interval, this.startFrame, this.endFrame);
        }

        public void Begin(int interval, int startFrame)
        {
            Begin(interval, startFrame, this.Cols * this.Rows - 1, false);
        }

        public void Begin(int interval, int startFrame, int endFrame)
        {
            Begin(interval, startFrame, endFrame, false);   
        }

        public void Begin(int interval, int startFrame, int endFrame, bool loopForever)
        {
            Begin(interval, startFrame, endFrame, loopForever, 1);
        }

        public void Begin(int interval, int startFrame, int endFrame, int loopNumber)
        {
            Begin(interval, startFrame, endFrame, false, loopNumber);
        }

        public void Begin(int interval, int startFrame, int endFrame, bool loopForever, int loopNumber)
        {
            if (this.updateEvent != null)
            {
                Clock.RemoveTimeEvent(this.updateEvent);
            }

            loopNumber = Math.Max(0, loopNumber);
            this.startFrame = Math.Max(0, startFrame);
            this.endFrame = Math.Max(0, endFrame);
            this.Frame = startFrame;
            if (loopForever)
            {
                this.updateEvent = new TimeEvent(interval, UpdateFrame);
            }
            else
            {
                this.updateEvent = new TimeEvent((endFrame - startFrame + 1) * loopNumber, interval, UpdateFrame, EndFrame);
            }
            int eventID = Clock.AddTimeEvent(this.updateEvent);
            inAnimation = true;
        }

        public void Stop()
        {
            if (this.updateEvent != null)
            {
                Clock.EndTimeEvent(this.updateEvent);
            }
            this.updateEvent = null;
            inAnimation = false;
        }

        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            base.LoadContent();
            if (this.textureManager.Rows != -1)
            {
                this.Rows = this.textureManager.Rows;
                this.Cols = this.textureManager.Cols;
                this.Width = this.textureManager.Width;
                this.Height = this.textureManager.Height;
            }
        }
    }
}
