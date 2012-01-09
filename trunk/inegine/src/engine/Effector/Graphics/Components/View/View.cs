using System;
using System.Collections.Generic;
using System.Text;
using SlimDX.Direct3D9;
using SlimDX;
using System.Drawing;
using SampleFramework;

namespace INovelEngine.Effector
{
    public class View : AbstractGUIComponent
    {
        protected Line line
        {
            get
            {
                return Supervisor.GetInstance().GetLineBatch();
            }
        }

        Vector2[] lines;
        protected Color _backgroundColor;
        private bool backgroundTrasnparent;

        public View()
            : base()
        {
            lines = new Vector2[2];
            backgroundTrasnparent = true;
        }

        protected override void DrawInternal()
        {
            if (!backgroundTrasnparent) DrawBackground();
        }

        private void DrawBackground()
        {
            lines[0].X = RealX;
            lines[0].Y = RealY + Height / 2;
            lines[1].X = RealX + Width;
            lines[1].Y = RealY + Height / 2;

            line.Width = (float)Math.Max(0.000001, Height); // FIXME
            line.Begin();
            if (this.Fading)
            {
                line.Draw(this.lines, Color.FromArgb((int)(GetEffectiveProgress() * _alpha), _backgroundColor));
            }
            else
            {
                line.Draw(this.lines, Color.FromArgb((int)(GetEffectiveProgress() * _alpha), _backgroundColor));
            }
            line.End();
        }

        public int BackgroundColor
        {
            get
            {
                return this._backgroundColor.ToArgb();
            }

            set
            {
                this._backgroundColor = Color.FromArgb(value);
                this._backgroundColor = Color.FromArgb(255, _backgroundColor);
                backgroundTrasnparent = false;
            }
        }

        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            base.Initialize(graphicsDeviceManager);
        }


        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            base.LoadContent();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public override void UnloadContent()
        {
            base.UnloadContent();
        }

        public override void Dispose()
        {
            base.Dispose();
        }

    }
}
