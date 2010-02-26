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
        public bool enabled = true;
        protected GraphicsDeviceManager manager;

        //private List<AbstractGUIComponent> components = new List<AbstractGUIComponent>();
        //public Dictionary<String, AbstractGUIComponent> guiComponents =
        //    new Dictionary<string, AbstractGUIComponent>();

        protected float beginTick;
        protected float endTick;
        protected float currentTick;
        protected float tickLength;
        protected bool fadeIn;
        protected bool inTransition = false;

        protected Color renderColor = Color.White;
        protected float progress = 0;
       
        public Device Device
        {
            get { return manager.Direct3D9.Device; }
        }

        public GameState managingState
        {
            get;
            set;
        }

        public ComponentType type
        {
            get;
            set;
        }

        //public void AddComponent(AbstractGUIComponent component)
        //{
        //    if (guiComponents.ContainsKey(component.id)) return;

        //    component.ParentComponent = this;

        //    components.Add(component);
        //    guiComponents.Add(component.id, component);

        //    InvalidateZOrder();
        //}

        //public AbstractGUIComponent GetComponent(string id)
        //{
        //    if (guiComponents.ContainsKey(id))
        //    {
        //        return guiComponents[id];
        //    }
        //    else
        //    {
        //        return null;
        //    }
        //}

        //public void InvalidateZOrder()
        //{
        //    components.Sort(); // sort them according to z-order (higher, higher)
        //}

        public bool Enabled
        {
            get
            {
                return enabled;
            }
            set
            {
                enabled = value;
            }
        }

        public string id
        {
            get;
            set;
        }

        public int x
        {
            get;
            set;
        }

        public int y
        {
            get;
            set;
        }

        public virtual int width
        {
            get;
            set;
        }

        public virtual int height
        {
            get;
            set;
        }

        private int _layer;

        public int layer
        {
            get
            {
                return this._layer;
            }
            set
            {
                if (this.managingState != null) this.managingState.InvalidateZOrder();
                this._layer = value;
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

        public bool FadedOut
        {
            get;
            set;
        }

        public AbstractGUIComponent ParentComponent
        {
            get; set;
        }

        #region IGameComponent Members

        public virtual void Draw()
        {
            if (this.enabled)
            {
                if (!this.FadedOut)
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

                    //foreach (AbstractGUIComponent component in this.components)
                    //{
                    //    component.Draw();
                    //}
                }
            }
        }
        protected abstract void DrawInternal();

        public virtual void Update(GameTime gameTime)
        {
            if (Fading)
            {
                currentTick = Clock.GetTime();

                if (currentTick >= endTick)
                {
                    Fading = false;
                    FadedOut = fadeIn == false;
                }
                else
                {
                    progress = fadeIn
                                   ? Math.Min(1.0f, (currentTick - beginTick)/tickLength)
                                   : 1.0f - Math.Min(1.0f, (currentTick - beginTick) / tickLength);
                }
            }
        }

        public void LaunchTransition(float duration, bool isFadingIn)
        {
            beginTick = Clock.GetTime();
            tickLength = duration;
            endTick = beginTick + duration;
            fadeIn = isFadingIn;
            Fading = true;
            FadedOut = false;
        }

        #endregion

        #region IResource Members

        public virtual void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            manager = graphicsDeviceManager;

            //foreach (AbstractGUIComponent component in this.components)
            //{
            //    component.Initialize(graphicsDeviceManager);
            //}
        }

        public virtual void LoadContent()
        {
            //foreach (AbstractGUIComponent component in this.components)
            //{
            //    component.LoadContent();
            //}        
        }

        public virtual void UnloadContent()
        {
            //foreach (AbstractGUIComponent component in this.components)
            //{
            //    component.UnloadContent();
            //}       
        }

        #endregion

        #region IDisposable Members

        public virtual void Dispose()
        {
            //foreach (AbstractGUIComponent component in this.components)
            //{
            //    component.Dispose();
            //}  
        }

        #endregion

        #region IComparable Members

        public int CompareTo(object obj)
        {
            AbstractGUIComponent g = (AbstractGUIComponent)obj;
            return this.layer.CompareTo(g.layer);
        }

        #endregion


        //public override void SendEvent(ScriptEvents luaevent, params object[] args)
        //{
        //    try
        //    {
        //        if (!enabled) return;
        //        AbstractLuaEventHandler handler = GetHandler(luaevent, args);
        //        SendEvent(handler, luaevent, args);
        //        if (handler != this) SendEvent(this, luaevent, args);
        //    }
        //    catch (Exception e)
        //    {
        //        Console.WriteLine(e.ToString());
        //    }
        //}

        //private AbstractLuaEventHandler mouseDownLocked;

        //public override AbstractLuaEventHandler GetHandler(ScriptEvents luaevent, params object[] args)
        //{
        //    AbstractLuaEventHandler handler = this;
        //    switch (luaevent)
        //    {
        //        case ScriptEvents.KeyPress:
        //            handler = this;
        //            break;
        //        case ScriptEvents.MouseMove:
        //            if (mouseDownLocked != null) handler = mouseDownLocked;
        //            else
        //            {
        //                handler = GetCollidingComponent((int)args[0], (int)args[1]);
        //                if (handler == null) handler = this;
        //            }
        //            break;
        //        case ScriptEvents.MouseDown:
        //            handler = GetCollidingComponent((int)args[0], (int)args[1]);
        //            if (handler == null) handler = this;
        //            mouseDownLocked = handler;
        //            break;
        //        case ScriptEvents.MouseUp:
        //            if (mouseDownLocked != null) handler = mouseDownLocked;
        //            break;
        //        case ScriptEvents.MouseClick:
        //            handler = GetCollidingComponent((int)args[0], (int)args[1]);
        //            if (handler == null) handler = this;
        //            break;
        //        default:
        //            handler = this;
        //            break;
        //    }
        //    return handler;
        //}

        //public AbstractGUIComponent GetCollidingComponent(int x, int y)
        //{
        //    AbstractGUIComponent component;
        //    // do it in reverse order because components sorted in z order...
        //    for (int i = this.components.Count - 1; i >= 0; i--)
        //    {
        //        component = this.components[i];
        //        if (component.x <= x && component.y <= y &&
        //            component.x + component.width >= x &&
        //            component.y + component.height >= y) return component;
        //    }
        //    return null;
        //}
    }

}
