using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Drawing;
using System.Text;
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
        
        private Texture winParts;

        public ImageWindow(Color color, int alpha, int x, int y, int width, int height, int layer, string text, int margin)
            : base(color, alpha, x, y, width, height, layer, text, margin)
        {
        }

        /*
        public override void SetDevice(Microsoft.DirectX.Direct3D.Device device)
        {
            base.SetDevice(device);

            //this.winParts = Microsoft.DirectX.Direct3D.TextureLoader.FromFile(this.device, "win.png", 144, 16, 0, Usage.None, Format.A8R8G8B8, Pool.Default,
            //                                                      Filter.None, Filter.None, Color.FromArgb(255, 0, 255).ToArgb());

        }
        */


        public override void Draw()
        {
            base.Draw();
        }

        public override void DrawWindow()
        {
            /*
            lines[0].X = x - 1;
            lines[0].Y = y + height / 2;
            lines[1].X = x + width + 1;
            lines[1].Y = y + height / 2;

            line.Width = height + 2;
            line.Begin();
            line.Draw(this.lines, Color.Black);
            line.End();

            */


            //base.DrawWindow();

            sprite.Begin(SpriteFlags.AlphaBlend);
            rect.X = 0;
            rect.Y = 0;
            rect.Width = 16;
            rect.Height = 16;

            position.X = this.x;
            position.Y = this.y;

            int numHorizontalTiles = this.width / 16 - 2;
            int numVerticalTiles = this.height / 16 - 2;


            int widthDrawn = 0;
            int heightDrawn = 0;
            // left side
            rect.X =  (int)TilePositions.UPLEFT;

            sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));
            
            position.X += 16;
            widthDrawn += 16;
            
            // tile upper side
            rect.X = (int)TilePositions.UPCENTER;
            
            for (int i = 0; i < numHorizontalTiles; i++)
            {
                sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

                position.X += 16;
                widthDrawn += 16;
            }

            // draw last tile
            int lastWidth = this.width - widthDrawn - 16;
            rect.Width = lastWidth;

            sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

            position.X += lastWidth;

            // right side
            rect.Width = 16;
            rect.X = (int)TilePositions.UPRIGHT;
            sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

            heightDrawn += 16;
            position.Y += 16;
            
            // draw rows
            for (int j = 0; j < numVerticalTiles; j++)
            {
                position.X = this.x;
                widthDrawn = 0;
                // left side
                rect.X = (int)TilePositions.CENTERLEFT;

                sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

                position.X += 16;
                widthDrawn += 16;

                // tile upper side
                rect.X = (int)TilePositions.CENTER;

                for (int i = 0; i < numHorizontalTiles; i++)
                {
                    sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

                    position.X += 16;
                    widthDrawn += 16;
                }

                // draw last tile
                lastWidth = this.width - widthDrawn - 16;
                rect.Width = lastWidth;

                sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

                position.X += lastWidth;

                // right side
                rect.Width = 16;
                rect.X = (int)TilePositions.CENTERRIGHT;
                sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

                heightDrawn += 16;
                position.Y += 16;
            }
            
            /* draw last row tiles */
            int lastHeight = this.height - heightDrawn - 16;

            rect.Height = lastHeight;
            
            position.X = this.x;
            widthDrawn = 0;
            // left side
            rect.X = (int)TilePositions.CENTERLEFT;

            sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

            position.X += 16;
            widthDrawn += 16;

            // tile upper side
            rect.X = (int)TilePositions.CENTER;

            for (int i = 0; i < numHorizontalTiles; i++)
            {
                sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

                position.X += 16;
                widthDrawn += 16;
            }

            // draw last tile
            lastWidth = this.width - widthDrawn - 16;
            rect.Width = lastWidth;

            sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

            position.X += lastWidth;

            // right side
            rect.Width = 16;
            rect.X = (int)TilePositions.CENTERRIGHT;
            sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

            heightDrawn += 16;
            position.Y += lastHeight;
            
            
            // draw lower part

            rect.Height = 16;
            position.X = this.x;
            widthDrawn = 0;
            // left side
            rect.X = (int)TilePositions.DOWNLEFT;

            sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

            position.X += 16;
            widthDrawn += 16;

            // tile upper side
            rect.X = (int)TilePositions.DOWNCENTER;

            for (int i = 0; i < numHorizontalTiles; i++)
            {
                sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

                position.X += 16;
                widthDrawn += 16;
            }

            // draw last tile
            lastWidth = this.width - widthDrawn - 16;
            rect.Width = lastWidth;

            sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

            position.X += lastWidth;

            // right side
            rect.Width = 16;
            rect.X = (int)TilePositions.DOWNRIGHT;
            sprite.Draw(this.winParts, rect, center, position, Color.FromArgb(this.alpha, this.color));

            sprite.End();


        }

        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            base.Initialize(graphicsDeviceManager);

            //winParts = Texture.FromFile(graphicsDeviceManager.Direct3D9.Device, "win.png", 144, 16, 0, Usage.None, Format.A8R8G8B8, Pool.Default,
            //                                                      Filter.None, Filter.None, Color.FromArgb(255, 0, 255).ToArgb());

        }

        
        /// <summary>
        /// Allows the resource to load any short-term graphical content.
        /// </summary>
        public override void LoadContent()
        {
            winParts = Texture.FromFile(manager.Direct3D9.Device, "win.png", 144, 16, 0, Usage.None, Format.A8R8G8B8, Pool.Default,
                                                      Filter.None, Filter.None, Color.FromArgb(255, 0, 255).ToArgb());
            base.LoadContent();
        }

        /// <summary>
        /// Allows the resource to unload any short-term graphical content.
        /// </summary>
        public override void UnloadContent()
        {
            winParts.Dispose();
            base.UnloadContent();
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
