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
        public static Vector2 cursorPosition;

        static public void DrawText(Sprite sprite, RubyFont font, string text, int x, int y, int width, int height, Color color)
        {
            font.WrapWidth = width;
            font.Wrap = true;
            PutText(sprite, font, text, x, y, color);   
        }

        static public void PutText(Sprite sprite, RubyFont font, string text, int x, int y, Color color)
        {
            font.Color = color;
            font.RubyColor = color;
            font.DrawString(sprite, text, x, y);
            cursorPosition = font.LastPos;

        }

        static public RubyFont LoadFont(SlimDX.Direct3D9.Device device, string fontName, int size, FontWeight weight, Boolean italic)
        {
            try
            {
                return new RubyFont(device, fontName, size, fontName, size/4);

            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
        }
    }
}
