using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using INovelEngine.Core;
using SampleFramework;
using INovelEngine.StateManager;
using INovelEngine.Script;
using SlimDX.Direct3D9;
using INovelEngine.Effector.Graphics.Components;

namespace INovelEngine.Effector
{
    public interface IGUIComponent : IResource, IGameComponent, IComparable
    {

    }

    public abstract class AbstractGUIComponent : AbstractLuaEventHandler, IGUIComponent, IComponentManager
    {
        /* shake scale */
        public const int SHAKE_X_SCALE = 2;
        public const int SHAKE_Y_SCALE = 0;

        protected GraphicsDeviceManager manager;

        /* fade related fields */
        protected int beginFadeTick;
        protected int endFadeTick;
        protected int currentFadeTick;
        protected int fadeTickLength;
        protected bool fadeIn;
        protected bool inTransition = false;
        protected float progress = 0;

        /* shaking related fields */
        protected int endShakeTick;
        protected bool shaking = false;

        protected Color renderColor = Color.White;

        protected bool loaded = false;
        protected bool initialized = false;


        protected ResourceCollection resources = new ResourceCollection();

        /* componentList sorted by z-order (higher, higher (front)) */
        protected List<AbstractGUIComponent> componentList = new List<AbstractGUIComponent>();
        protected Dictionary<string, AbstractGUIComponent> componentMap =
            new Dictionary<string, AbstractGUIComponent>();

        public AbstractGUIComponent()
            : base()
        {
            Relative = true;
        }

        public Device Device
        {
            get { return manager.Direct3D9.Device; }
        }

        public bool Loaded
        {
            get { return loaded; }
        }

        public GameState ManagingState
        {
            get;
            set;
        }

        public AbstractGUIComponent Parent
        {
            get;
            set;
        }

       
        public string Name
        {
            get;
            set;
        }

        public bool Relative
        {
            get; set;
        }

        public int X
        {
            get; set;
        }

        public int Y
        {
            get; set;
        }

        public int RealX
        {
            get
            {
                if (Relative && Parent != null)
                {
                    if (shaking)
                    {
                        return Parent.RealX + X + Clock.GetRand(-SHAKE_X_SCALE, SHAKE_X_SCALE);
                    }
                    else
                    {
                        return Parent.RealX + X;
                    }
                }
                else
                {
                    if (shaking)
                    {
                        return X + Clock.GetRand(-SHAKE_X_SCALE, SHAKE_X_SCALE);
                    }
                    else
                    {
                        return X;
                    }
                }
            }
        }

        public int RealY
        {
            get
            {
                if (Relative && Parent != null)
                {
                    if (shaking)
                    {
                        return Parent.RealY + Y + Clock.GetRand(-SHAKE_Y_SCALE, SHAKE_Y_SCALE);
                    }
                    else
                    {
                        return Parent.RealY + Y;
                    }
                }
                else
                {
                    if (shaking)
                    {
                        return Y + Clock.GetRand(-SHAKE_Y_SCALE, SHAKE_Y_SCALE);
                    }
                    else
                    {
                        return Y;
                    }
                }
            }
        }

        public virtual int Width
        {
            get;
            set;
        }

        public virtual int Height
        {
            get;
            set;
        }

        private int _layer;

        public int Layer
        {
            get
            {
                return this._layer;
            }
            set
            {
                this._layer = value;
                if (this.ManagingState != null)
                {
                    ManagingState.InvalidateZOrder();
                }
            }
        }

        public bool Fading
        {
            set
            {
                this.inTransition = value;
                if (!inTransition) this.renderColor = Color.White;
            }

            get
            {
                return this.inTransition;
            }
        }

        private bool _visible = true;

        public bool Visible
        {
            get { return _visible; }
            set {
                StopTransition();
                _visible = value;
            }
        }

        protected int _alpha = 255;

        public int Alpha
        {
            get { return _alpha; }
            set { _alpha = value; }
        }

        public void Hide()
        {
            this.Visible = false;
            this.Enabled = false;
        }

        public void Show()
        {
            this.Visible = true;
            this.Enabled = true;
        }

        public virtual void FadeIn(float duration)
        {
            LaunchTransition(duration, true);

            foreach (AbstractGUIComponent component in this.componentList)
            {
                component.FadeIn(duration);
            }
        }

        public virtual void FadeOut(float duration)
        {
            LaunchTransition(duration, false);

            foreach (AbstractGUIComponent component in this.componentList)
            {
                component.FadeOut(duration);
            }
        }

        public void LaunchTransition(float duration, bool isFadingIn)
        {
            beginFadeTick = Clock.GetTime();
            fadeTickLength = (int)duration;
            endFadeTick = beginFadeTick + (int)duration;
            fadeIn = isFadingIn;
            Fading = true;
            _visible = true;
        }

        public void StopTransition()
        {
            Fading = false;
        }

        public void Shake(float duration)
        {
            endShakeTick = Clock.GetTime() + (int)duration;
            shaking = true;

            foreach (AbstractGUIComponent component in this.componentList)
            {
                component.Shake(duration);
            }
        }

        #region IGameComponent Members

        public virtual void Draw()
        {
            /* update fade rate and shake are in Draw() because fade rate needs to be 
             * updated even when update is disabled */
            UpdateFadeRate();
            UpdateShake();

            if (this._visible)
            {
                if (this.Fading)
                {
                    renderColor = Color.FromArgb((int) (progress*_alpha), Color.White);
                }
                else
                {
                    renderColor = Color.FromArgb(_alpha, Color.White);
                }
                this.DrawInternal();

                foreach (IGameComponent component in componentList)
                {   
                    component.Draw();
                }
            }

#if DEBUG
            DrawDebugInfo();
#endif
        }

#if DEBUG
        protected void DrawDebugInfo()
        {
            if (!Supervisor.GetInstance().debugInfoOn)
            {
                return;
            }

            Point cursorPosition = Supervisor.GetInstance().cursorPosition;

            if (cursorPosition.X < this.RealX || cursorPosition.X > (this.RealX + this.Width))
            {
                return;
            }

            if (cursorPosition.Y < this.RealY || cursorPosition.Y > (this.RealY + this.Height))
            {
                return;
            }



            Sprite fontSprite = Supervisor.GetInstance().debugFontSprite;
            SlimDX.Direct3D9.Font font = Supervisor.GetInstance().debugFont;
            String info = this.Name.Substring(0, Math.Min(this.Name.Length, 4)) + System.IO.Path.GetExtension(this.GetType().ToString());
            Rectangle infoRect = font.MeasureString(fontSprite, info, DrawTextFormat.Left);
            String dim = this.Width + "x" + this.Height;
            Rectangle dimRect = font.MeasureString(fontSprite, dim, DrawTextFormat.Left);

            SlimDX.Vector2[] lines = new SlimDX.Vector2[2];

            Line line = Supervisor.GetInstance().GetLineBatch();


            lines[0].X = RealX;
            lines[0].Y = RealY + Height / 2;
            lines[1].X = RealX + Width;
            lines[1].Y = RealY + Height / 2;
            line.Width = (float)Height;

            line.Begin();
            line.Draw(lines, Color.FromArgb(15, Color.Black));
            line.End();

            lines[0].X = this.RealX + (this.Width - infoRect.Width) / 2;
            lines[0].Y = this.RealY + this.Height / 2 + infoRect.Height / 2;
            lines[1].X = this.RealX + (this.Width - infoRect.Width) / 2 + infoRect.Width;
            lines[1].Y = this.RealY + this.Height / 2 + infoRect.Height / 2;
            line.Width = (float)infoRect.Height;
            line.Begin();
            line.Draw(lines, Color.FromArgb(255, Color.White));
            line.End();

            lines[0].X = this.RealX + this.Width - dimRect.Width;
            lines[0].Y = this.RealY + this.Height - dimRect.Height + dimRect.Height / 2;
            lines[1].X = this.RealX + this.Width;
            lines[1].Y = this.RealY + this.Height - dimRect.Height + dimRect.Height / 2;
            line.Width = (float)dimRect.Height;
            line.Begin();
            line.Draw(lines, Color.FromArgb(255, Color.White));
            line.End();


            fontSprite.Begin(SpriteFlags.AlphaBlend);
            font.DrawString(fontSprite, this.X + "," + this.Y, this.RealX, this.RealY, Color.FromArgb(200, Color.Red));
            font.DrawString(fontSprite, info, this.RealX + (this.Width - infoRect.Width) / 2, this.RealY + this.Height / 2, Color.FromArgb(200, Color.Red));
            font.DrawString(fontSprite, dim, this.RealX + this.Width - dimRect.Width, this.RealY + this.Height - dimRect.Height, Color.FromArgb(200, Color.Red));
            fontSprite.End();

        }
#endif

        protected abstract void DrawInternal();

        public virtual void Update(GameTime gameTime)
        {
            /* check for mouse hover */

            foreach (IGameComponent component in componentList)
            {
                component.Update(gameTime);
            }
        }

        #endregion

        protected virtual void UpdateFadeRate()
        {
            if (Fading)
            {
                currentFadeTick = Clock.GetTime();

                if (currentFadeTick >= endFadeTick)
                {
                    StopTransition();
                    _visible = fadeIn == true;
                }
                else
                {
                    progress = fadeIn
                                   ? Math.Min(1.0f, (float)(currentFadeTick - beginFadeTick) / (float)fadeTickLength)
                                   : 1.0f - Math.Min(1.0f, (float)(currentFadeTick - beginFadeTick) / (float)fadeTickLength);

                }
            }
        }

        protected void UpdateShake()
        {
            if (shaking)
            {
                if (Clock.GetTime() >= endShakeTick)
                {
                    shaking = false;
                }
               
            }
        }

        #region Subcomponent Management

        public void AddComponent(AbstractGUIComponent component)
        {
            if (component.Name == null || component.Name.Length == 0)
            {
                component.Name = System.Guid.NewGuid().ToString();
            }

            if (componentMap.ContainsKey(component.Name)) return;

            component.Parent = this;

            componentList.Add(component);
            resources.Add(component);
            componentMap.Add(component.Name, component);

            InvalidateZOrder();
        }

        public AbstractGUIComponent GetComponent(string id)
        {
            if (componentMap.ContainsKey(id))
            {
                return componentMap[id];
            }
            else
            {
                return null;
            }
        }

        public void RemoveComponent(string id)
        {
            if (componentMap.ContainsKey(id))
            {
                AbstractGUIComponent component = componentMap[id];
                componentList.Remove(component);
                componentMap.Remove(id);
                resources.Remove(component);
                component.Dispose();
            }
        }

        public void InvalidateZOrder()
        {
            componentList.Sort(); // sort them according to z-order (higher, higher)
        }

        #endregion

        #region lua event handling

        public override AbstractLuaEventHandler FindEventHandler(ScriptEvents luaevent, params object[] args)
        {
            return ComponentManagerHelper.FindEventHandler(this, this.componentList, luaevent, args);
        }

        #endregion

        #region IResource Members

        public virtual void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            //Console.WriteLine("initializing:" + this.Name);
            initialized = true;
            manager = graphicsDeviceManager;
            resources.Initialize(graphicsDeviceManager);
        }

        public virtual void LoadContent()
        {
            //Console.WriteLine("loading:" + this.Name);
            resources.LoadContent();
            loaded = true;
            Removed = false;
        }

        public virtual void UnloadContent()
        {
            //Console.WriteLine("unloading:" + this.Name);
            resources.UnloadContent();
            loaded = false;
        }

        #endregion

        #region IDisposable Members

        public virtual void Dispose()
        {
            //Console.WriteLine("disposing : " + this.Name + " [" + this.ToString() + "] (" + ((object)this).GetHashCode() + ")");
            Removed = true;
            resources.Dispose();
        }

        #endregion

        #region IComparable Members

        public int CompareTo(object obj)
        {
            AbstractGUIComponent g = (AbstractGUIComponent)obj;
            return this.Layer.CompareTo(g.Layer);
        }

        #endregion
    }

}
