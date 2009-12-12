using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using SlimDX.Direct3D9;
using Tao.FreeType;
using Font=SlimDX.Direct3D9.Font;

namespace INovelEngine
{
    public class TextRenderer
    {
        
        private static Rectangle rectangle = new Rectangle();

        static public void DrawText(Sprite sprite, SlimDX.Direct3D9.Font font, string text, int x, int y, int width, int height, Color color)
        {

        }

        static public void PutText(Sprite sprite, SlimDX.Direct3D9.Font font, string text, Rectangle rectangle, Color color)
        {

        }

        static public Rectangle MeasureText(SlimDX.Direct3D9.Font font, string text, Color color)
        {
            return new Rectangle();
        }

        static public SlimDX.Direct3D9.Font LoadFont(SlimDX.Direct3D9.Device device, string fontName, int size, FontWeight weight, Boolean italic)
        {
            try
            {

            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return null;
            }

            return null;
        }
         
    }
}
