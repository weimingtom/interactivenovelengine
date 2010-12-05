using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Drawing;
using System.Text;
using INovelEngine.ResourceManager;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;

namespace INovelEngine.Effector
{
    class ImageWindow : TextWindow
    {
        Vector3 center = new Vector3(0, 0, 0);
        Vector3 position = new Vector3(0, 0, 0);
        Rectangle rect = new Rectangle(0, 0, 16, 16);

        Vector2[] lines = new Vector2[2];

        
        protected INETexture _windowTexture;

        public ImageWindow()
            : base()
        {
            RectSize = 16;
        }

        public int RectSize
        {
            get;
            set;
        }

        private int GetPosition(TilePositions pos)
        {
            return (int)pos * RectSize;
        }
        public string WindowTexture
        {
            get
            {
                if (this._windowTexture != null)
                {
                    return this._windowTexture.TextureFile;
                }
                else
                {
                    return null;
                }
            }
            set
            {
                _windowTexture = new INETexture(value);
                resources.Add(_windowTexture);
                if (this.loaded)
                {
                    _windowTexture.Initialize(manager);
                    _windowTexture.LoadContent();
                }
            }
        }

       
        public override void Draw()
        {
            base.Draw();
        }

        public override void DrawWindow()
        {
            if (WindowTexture == null)
            {
                return;
            }

            sprite.Begin(SpriteFlags.AlphaBlend);
            rect.X = 0;
            rect.Y = 0;
            rect.Width = RectSize;
            rect.Height = RectSize;

            position.X = this.RealX;
            position.Y = this.RealY;

            int numHorizontalTiles = this.Width / RectSize - 2;
            int numVerticalTiles = this.Height / RectSize - 2;


            int widthDrawn = 0;
            int heightDrawn = 0;
            // left side
            rect.X = GetPosition(TilePositions.UPLEFT);

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));
            
            position.X += RectSize;
            widthDrawn += RectSize;
            
            // tile upper side
            rect.X = GetPosition(TilePositions.UPCENTER);
            
            for (int i = 0; i < numHorizontalTiles; i++)
            {
                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                position.X += RectSize;
                widthDrawn += RectSize;
            }

            // draw last tile
            int lastWidth = this.Width - widthDrawn - RectSize;
            rect.Width = lastWidth;

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            position.X += lastWidth;

            // right side
            rect.Width = RectSize;
            rect.X = GetPosition(TilePositions.UPRIGHT);
            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            heightDrawn += RectSize;
            position.Y += RectSize;
            
            // draw rows
            for (int j = 0; j < numVerticalTiles; j++)
            {
                position.X = this.RealX;
                widthDrawn = 0;
                // left side
                rect.X = GetPosition(TilePositions.CENTERLEFT);

                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                position.X += RectSize;
                widthDrawn += RectSize;

                // tile upper side
                rect.X = GetPosition(TilePositions.CENTER);

                for (int i = 0; i < numHorizontalTiles; i++)
                {
                    sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                    position.X += RectSize;
                    widthDrawn += RectSize;
                }

                // draw last tile
                lastWidth = this.Width - widthDrawn - RectSize;
                rect.Width = lastWidth;

                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                position.X += lastWidth;

                // right side
                rect.Width = RectSize;
                rect.X = GetPosition(TilePositions.CENTERRIGHT);
                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                heightDrawn += RectSize;
                position.Y += RectSize;
            }
            
            /* draw last row tiles */
            int lastHeight = this.Height - heightDrawn - RectSize;

            rect.Height = lastHeight;
            
            position.X = this.RealX;
            widthDrawn = 0;
            // left side
            rect.X = GetPosition(TilePositions.CENTERLEFT);

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            position.X += RectSize;
            widthDrawn += RectSize;

            // tile upper side
            rect.X = GetPosition(TilePositions.CENTER);

            for (int i = 0; i < numHorizontalTiles; i++)
            {
                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                position.X += RectSize;
                widthDrawn += RectSize;
            }

            // draw last tile
            lastWidth = this.Width - widthDrawn - RectSize;
            rect.Width = lastWidth;

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            position.X += lastWidth;

            // right side
            rect.Width = RectSize;
            rect.X = GetPosition(TilePositions.CENTERRIGHT);
            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            heightDrawn += RectSize;
            position.Y += lastHeight;
            
            
            // draw lower part

            rect.Height = RectSize;
            position.X = this.RealX;
            widthDrawn = 0;
            // left side
            rect.X = GetPosition(TilePositions.DOWNLEFT);

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            position.X += RectSize;
            widthDrawn += RectSize;

            // tile upper side
            rect.X = GetPosition(TilePositions.DOWNCENTER);

            for (int i = 0; i < numHorizontalTiles; i++)
            {
                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                position.X += RectSize;
                widthDrawn += RectSize;
            }

            // draw last tile
            lastWidth = this.Width - widthDrawn - RectSize;
            rect.Width = lastWidth;

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            position.X += lastWidth;

            // right side
            rect.Width = RectSize;
            rect.X = GetPosition(TilePositions.DOWNRIGHT);
            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            sprite.End();

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

        private enum TilePositions : int
        {
            UPLEFT = 0,
            UPCENTER = 1,
            UPRIGHT = 2,
            CENTERRIGHT = 3,
            DOWNRIGHT = 4,
            DOWNCENTER = 5,
            DOWNLEFT = 6,
            CENTERLEFT = 7,
            CENTER = 8
        }


    }
}
