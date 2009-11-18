using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using SlimDX.Direct3D9;

namespace INovelEngine.Effector
{
    public class TextRenderer
    {
        private static Rectangle rectangle = new Rectangle();

        static public void DrawText(Sprite sprite, SlimDX.Direct3D9.Font font, string text, int x, int y, int width, int height, Color color)
        {
            //Rectangle rectangle = new Rectangle(x, y, width, height);
            rectangle.X = x;
            rectangle.Y = y;
            rectangle.Width = width;
            rectangle.Height = height;
            
            PutText(sprite, font, text, rectangle, Color.Black);
            
            rectangle.X++;
            rectangle.Y++;
            PutText(sprite, font, text, rectangle, Color.Black);
            rectangle.X++;
            rectangle.Y++;
            PutText(sprite, font, text, rectangle, color);   
        }

        static public void PutText(Sprite sprite, SlimDX.Direct3D9.Font font, string text, Rectangle rectangle, Color color)
        {
            font.DrawString(sprite, text, rectangle, DrawTextFormat.NoClip | DrawTextFormat.ExpandTabs, color);
            //font.DrawString(sprite, text, Location.X, Location.Y, ForegroundColor);
            //Rectangle projectedRect = new Rectangle(x, y, width, height);
            //font.DrawText(null, text, projectedRect, DrawTextFormat.NoClip | DrawTextFormat.ExpandTabs, color);
        }

        static public Rectangle MeasureText(SlimDX.Direct3D9.Font font, string text, Color color)
        {
            Rectangle result = font.MeasureString(null, text, DrawTextFormat.NoClip | DrawTextFormat.ExpandTabs);
            return result;
        }

        static public SlimDX.Direct3D9.Font LoadFont(SlimDX.Direct3D9.Device device, string fontName, int size, FontWeight weight, Boolean italic)
        {
            try
            {
                return new SlimDX.Direct3D9.Font(device, size, 0, weight, 1, italic, CharacterSet.Default,
                                                 Precision.Default, FontQuality.ClearType, PitchAndFamily.Default,
                                                 fontName);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
        }
    }
}
