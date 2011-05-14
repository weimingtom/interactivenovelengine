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
        protected GraphicsDeviceManager manager;

        protected int beginTick;
        protected int endTick;
        protected int currentTick;
        protected int tickLength;
        protected bool fadeIn;
        protected bool inTransition = false;
        protected Color renderColor = Color.White;
        protected float progress = 0;

        protected bool loaded = false;
        protected bool initialized = false;


        protected ResourceCollection resources = new ResourceCollection();

        // componentList sorted by z-order (higher, higher)
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
                    return Parent.RealX + X;
                }
                else
                {
                    return X;
                }
            }
        }

        public int RealY
        {
            get
            {
                if (Relative && Parent != null)
                {
                    return Parent.RealY + Y;
                }
                else
                {
                    return Y;
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
            set { _visible = value; }
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

        public void FadeIn(float duration)
        {
            LaunchTransition(duration, true);
        }

        public void FadeOut(float duration)
        {
            LaunchTransition(duration, false);
        }

        public void LaunchTransition(float duration, bool isFadingIn)
        {
            beginTick = Clock.GetTime();
            tickLength = (int)duration;
            endTick = beginTick + (int)duration;
            fadeIn = isFadingIn;
            Fading = true;
            Visible = true;
        }

        #region IGameComponent Members

        public virtual void Draw()
        {
            UpdateFadeRate();

            if (this.Visible)
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
        }

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
                currentTick = Clock.GetTime();

                if (currentTick >= endTick)
                {
                    Fading = false;
                    Visible = fadeIn == true;
                }
                else
                {
                    progress = fadeIn
                                   ? Math.Min(1.0f, (float)(currentTick - beginTick) / (float)tickLength)
                                   : 1.0f - Math.Min(1.0f, (float)(currentTick - beginTick) / (float)tickLength);

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
            Console.WriteLine("initializing:" + this.Name);
            initialized = true;
            manager = graphicsDeviceManager;
            resources.Initialize(graphicsDeviceManager);
        }

        public virtual void LoadContent()
        {
            Console.WriteLine("loading:" + this.Name);
            resources.LoadContent();
            loaded = true;
            Removed = false;
        }

        public virtual void UnloadContent()
        {
            Console.WriteLine("unloading:" + this.Name);
            resources.UnloadContent();
            loaded = false;
        }

        #endregion

        #region IDisposable Members

        public virtual void Dispose()
        {
            Console.WriteLine("disposing : " + this.Name + " [" + this.ToString() + "] (" + ((object)this).GetHashCode() + ")");
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
