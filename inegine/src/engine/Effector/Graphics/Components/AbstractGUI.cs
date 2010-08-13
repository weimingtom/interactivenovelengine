using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using INovelEngine.Core;
using SampleFramework;
using INovelEngine.StateManager;
using INovelEngine.Script;
using SlimDX.Direct3D9;

namespace INovelEngine.Effector
{
    public enum ComponentType
    {
        TextWindow
    }


    public interface IGUIComponent : IResource, IGameComponent, IComparable
    {

    }

    public abstract class AbstractGUIComponent : AbstractLuaEventHandler, IGUIComponent
    {
        protected GraphicsDeviceManager manager;

        protected float beginTick;
        protected float endTick;
        protected float currentTick;
        protected float tickLength;
        protected bool fadeIn;
        protected bool inTransition = false;
        protected Color renderColor = Color.White;
        protected float progress = 0;

        protected bool loaded = false;
        protected bool initialized = false;


        protected ResourceCollection resources = new ResourceCollection();

        // componentList sorted by z-order (higher, higher)
        protected List<AbstractGUIComponent> componentList = new List<AbstractGUIComponent>();
        protected Dictionary<String, AbstractGUIComponent> componentMap =
            new Dictionary<string, AbstractGUIComponent>();

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

        public ComponentType Type
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

        protected int _alpha;

        public int Alpha
        {
            get { return _alpha; }
            set { _alpha = value; }
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
            tickLength = duration;
            endTick = beginTick + duration;
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
                    renderColor = Color.FromArgb((int) (progress*255), Color.White);
                    ;
                }
                else
                {
                    renderColor = Color.White;
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
                                   ? Math.Min(1.0f, (currentTick - beginTick) / tickLength)
                                   : 1.0f - Math.Min(1.0f, (currentTick - beginTick) / tickLength);

                }
            }
        }

        #region Subcomponent Management

        public void AddComponent(AbstractGUIComponent component)
        {
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

        private AbstractLuaEventHandler mouseDownLocked;
        private AbstractLuaEventHandler mouseMoveLocked;

        public override AbstractLuaEventHandler FindEventHandler(ScriptEvents luaevent, params object[] args)
        {
            AbstractLuaEventHandler handler = this;
            switch (luaevent)
            {
                case ScriptEvents.KeyPress:
                    handler = this;
                    break;
                case ScriptEvents.MouseMove:
                    if (this.Name == "selector")
                    {
                        Console.WriteLine("selection!");
                    }
                    if (mouseDownLocked != null && !mouseDownLocked.Removed) handler = mouseDownLocked;
                    else
                    {
                        handler = GetCollidingComponent((int)args[0], (int)args[1]);

                        if (handler == null) handler = this;

                        if (mouseMoveLocked != null && !mouseMoveLocked.Removed)
                        {
                            if (mouseMoveLocked != handler)
                            {
                                SendEvent(mouseMoveLocked, ScriptEvents.MouseLeave, null);
                                mouseMoveLocked = null;
                            }
                        }
                        else if (handler != this)
                        {
                            mouseMoveLocked = handler;
                        }
                    }
                    break;
                case ScriptEvents.MouseDown:
                    handler = GetCollidingComponent((int)args[0], (int)args[1]);
                    if (handler == null) handler = this;
                    mouseDownLocked = handler;
                    break;
                case ScriptEvents.MouseUp:
                    if (mouseDownLocked != null) handler = mouseDownLocked;
                    mouseDownLocked = null;
                    break;
                case ScriptEvents.MouseClick:
                    handler = GetCollidingComponent((int)args[0], (int)args[1]);
                    if (handler == null) handler = this;
                    break;
                default:
                    handler = this;
                    break;
            }
            return handler;
        }

        public AbstractGUIComponent GetCollidingComponent(int x, int y)
        {
            AbstractGUIComponent component;
            // do it in reverse order because components sorted in z order...
            for (int i = componentList.Count - 1; i >= 0; i--)
            {
                component = componentList[i];
                if (component.RealX <= x && component.RealY <= y &&
                    component.RealX + component.Width >= x &&
                    component.RealY + component.Height >= y && component.Enabled) return component;
            }
            return null;
        }

        #endregion

        #region IResource Members

        public virtual void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            initialized = true;
            manager = graphicsDeviceManager;
            resources.Initialize(graphicsDeviceManager);
        }

        public virtual void LoadContent()
        {
            resources.LoadContent();
            loaded = true;
            Removed = false;
        }

        public virtual void UnloadContent()
        {
            resources.UnloadContent();
            loaded = false;
        }

        #endregion

        #region IDisposable Members

        public virtual void Dispose()
        {
            Console.WriteLine("disposing : " + this.Name);
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
