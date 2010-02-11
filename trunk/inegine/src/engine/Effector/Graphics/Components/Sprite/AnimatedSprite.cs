using System;
using System.Collections.Generic;
using System.Text;
using INovelEngine.Core;
using INovelEngine.Script;
using LuaInterface;

namespace INovelEngine.Effector
{
    class AnimatedSprite : SpriteBase
    {
        protected int colcnt
        {
            get;
            set;
        }

        protected int rowcnt
        {
            get;
            set;
        }

        public override int width
        {
            get
            {
                return this.tileWidth;
            }
        }

        public override int height
        {
            get
            {
                return this.tileHeight;
            }
        }

        protected int startFrame = 0;
        protected int endFrame = 0;
        public bool inAnimation = false;
        protected TimeEvent updateEvent;

        protected int tileWidth;
        protected int tileHeight;
        
        protected int _frame;
        public int frame
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

                int rownum = this._frame / colcnt;
                int colnum = this._frame % colcnt;
                this.sourceArea.Y = rownum * tileHeight;
                this.sourceArea.X = colnum * tileWidth;
            }
        }

        public AnimatedSprite(String id, string textureFile, int x, int y, int layer, int rowcnt, int colcnt, int tileWidth, int tileHeight, bool fadedOut)
            : base(id, textureFile, x, y, layer, fadedOut)
        {
            this.tileWidth = tileWidth;
            this.tileHeight = tileHeight;
            this.sourceArea.Width = tileWidth;
            this.sourceArea.Height = tileHeight;
            this.rowcnt = rowcnt;
            this.colcnt = colcnt;
            this.frame = 0;
            this.endFrame = this.rowcnt * this.colcnt;
        }

        public override void Update(SampleFramework.GameTime gameTime)
        {
            base.Update(gameTime);
        }

        public void UpdateFrame()
        {
            this.frame++;
        }

        public void EndFrame()
        {
            int id = this.updateEvent.timeID;
            this.updateEvent = null;
            this.inAnimation = false;
            if (this.animationOverHandler != null) 
                this.animationOverHandler(this, ScriptEvents.AnimationOver, id);
            
        }
 
        public float BeginAnimation(int interval, int startFrame, int endFrame, bool loop)
        {
            if (this.updateEvent != null)
            {
                Clock.RemoveTimeEvent(this.updateEvent);
            }
            
            this.startFrame = startFrame;
            this.endFrame = endFrame;
            this.frame = startFrame;
            if (loop)
            {
                this.updateEvent = new TimeEvent(interval, UpdateFrame);
            }
            else
            {
                this.updateEvent = new TimeEvent(endFrame - startFrame + 1, interval, UpdateFrame, EndFrame);
            }
            int eventID = Clock.AddTimeEvent(this.updateEvent);
            inAnimation = true;
            return eventID;
        }

        public void StopAnimation()
        {
            if (this.updateEvent != null)
            {
                Clock.RemoveTimeEvent(this.updateEvent);
            }
            this.updateEvent = null;
            inAnimation = false;
        }
    }
}
