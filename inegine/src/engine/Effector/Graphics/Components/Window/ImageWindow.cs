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

        public ImageWindow()
            : base()
        {
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
            rect.Width = 16;
            rect.Height = 16;

            position.X = this.RealX;
            position.Y = this.RealY;

            int numHorizontalTiles = this.Width / 16 - 2;
            int numVerticalTiles = this.Height / 16 - 2;


            int widthDrawn = 0;
            int heightDrawn = 0;
            // left side
            rect.X =  (int)TilePositions.UPLEFT;

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));
            
            position.X += 16;
            widthDrawn += 16;
            
            // tile upper side
            rect.X = (int)TilePositions.UPCENTER;
            
            for (int i = 0; i < numHorizontalTiles; i++)
            {
                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                position.X += 16;
                widthDrawn += 16;
            }

            // draw last tile
            int lastWidth = this.Width - widthDrawn - 16;
            rect.Width = lastWidth;

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            position.X += lastWidth;

            // right side
            rect.Width = 16;
            rect.X = (int)TilePositions.UPRIGHT;
            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            heightDrawn += 16;
            position.Y += 16;
            
            // draw rows
            for (int j = 0; j < numVerticalTiles; j++)
            {
                position.X = this.RealX;
                widthDrawn = 0;
                // left side
                rect.X = (int)TilePositions.CENTERLEFT;

                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                position.X += 16;
                widthDrawn += 16;

                // tile upper side
                rect.X = (int)TilePositions.CENTER;

                for (int i = 0; i < numHorizontalTiles; i++)
                {
                    sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                    position.X += 16;
                    widthDrawn += 16;
                }

                // draw last tile
                lastWidth = this.Width - widthDrawn - 16;
                rect.Width = lastWidth;

                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                position.X += lastWidth;

                // right side
                rect.Width = 16;
                rect.X = (int)TilePositions.CENTERRIGHT;
                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                heightDrawn += 16;
                position.Y += 16;
            }
            
            /* draw last row tiles */
            int lastHeight = this.Height - heightDrawn - 16;

            rect.Height = lastHeight;
            
            position.X = this.RealX;
            widthDrawn = 0;
            // left side
            rect.X = (int)TilePositions.CENTERLEFT;

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            position.X += 16;
            widthDrawn += 16;

            // tile upper side
            rect.X = (int)TilePositions.CENTER;

            for (int i = 0; i < numHorizontalTiles; i++)
            {
                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                position.X += 16;
                widthDrawn += 16;
            }

            // draw last tile
            lastWidth = this.Width - widthDrawn - 16;
            rect.Width = lastWidth;

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            position.X += lastWidth;

            // right side
            rect.Width = 16;
            rect.X = (int)TilePositions.CENTERRIGHT;
            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            heightDrawn += 16;
            position.Y += lastHeight;
            
            
            // draw lower part

            rect.Height = 16;
            position.X = this.RealX;
            widthDrawn = 0;
            // left side
            rect.X = (int)TilePositions.DOWNLEFT;

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            position.X += 16;
            widthDrawn += 16;

            // tile upper side
            rect.X = (int)TilePositions.DOWNCENTER;

            for (int i = 0; i < numHorizontalTiles; i++)
            {
                sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

                position.X += 16;
                widthDrawn += 16;
            }

            // draw last tile
            lastWidth = this.Width - widthDrawn - 16;
            rect.Width = lastWidth;

            sprite.Draw(this._windowTexture.Texture, rect, center, position, Color.FromArgb(this._alpha, this._backgroundColor));

            position.X += lastWidth;

            // right side
            rect.Width = 16;
            rect.X = (int)TilePositions.DOWNRIGHT;
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

        enum TilePositions : int
        {
            UPLEFT = 0,
            UPCENTER = 16,
            UPRIGHT = 32,
            CENTERRIGHT = 48,
            DOWNRIGHT = 64,
            DOWNCENTER = 80,
            DOWNLEFT = 96,
            CENTERLEFT = 112,
            CENTER = 128
        }


    }
}
