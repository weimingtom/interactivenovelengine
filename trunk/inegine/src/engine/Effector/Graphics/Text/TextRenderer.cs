using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using INovelEngine.Effector.Graphics.Text;
using SlimDX;
using SlimDX.Direct3D9;
using Font=SlimDX.Direct3D9.Font;

namespace INovelEngine.Effector
{
    public class TextRenderer
    {
        private static Rectangle rectangle = new Rectangle();
        public static Vector2 cursorPosition;

        static public void DrawText(Sprite sprite, RubyFont font, string text, int x, int y, int width, int height, Color color)
        {
            font.WrapWidth = width;
            font.Wrap = true;

            //Rectangle rectangle = new Rectangle(x, y, width, height);
            //rectangle.X = x;
            //rectangle.Y = y;
            //rectangle.Width = width;
            //rectangle.Height = height;
            
            //PutText(sprite, font, text, rectangle, Color.Black);
            
            //rectangle.X++;
            //rectangle.Y++;
            //PutText(sprite, font, text, rectangle, Color.Black);
            //rectangle.X++;
            //rectangle.Y++;
            PutText(sprite, font, text, x, y, color);   
        }

        static public void PutText(Sprite sprite, RubyFont font, string text, int x, int y, Color color)
        {
            font.Color = color;
            font.RubyColor = color;
            font.DrawString(sprite, text, x, y);
            cursorPosition = font.LastPos;
            //font.DrawString(sprite, text, rectangle, DrawTextFormat.NoClip | DrawTextFormat.ExpandTabs, color);
            //font.DrawString(sprite, text, Location.X, Location.Y, ForegroundColor);
            //Rectangle projectedRect = new Rectangle(x, y, width, height);
            //font.DrawText(null, text, projectedRect, DrawTextFormat.NoClip | DrawTextFormat.ExpandTabs, color);
        }

        //static public Rectangle MeasureText(SlimDX.Direct3D9.Font font, string text, Color color)
        //{
        //    Rectangle result = font.MeasureString(null, text, DrawTextFormat.NoClip | DrawTextFormat.ExpandTabs);
        //    return result;
        //}

        static public RubyFont LoadFont(SlimDX.Direct3D9.Device device, string fontName, int size, FontWeight weight, Boolean italic)
        {
            try
            {
                return new RubyFont(device, fontName, size, fontName, size/4);
                //return new SlimDX.Direct3D9.Font(device, size, 0, weight, 1, italic, CharacterSet.ShiftJIS,
                //                                 Precision.Default, FontQuality.ClearType, PitchAndFamily.Default,
                //                                 fontName);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
        }
    }
}
