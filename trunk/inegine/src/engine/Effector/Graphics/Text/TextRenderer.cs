using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using INovelEngine.Effector.Graphics.Text;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;
using Font=SlimDX.Direct3D9.Font;

namespace INovelEngine.Effector
{
    public class TextRenderer
    {
        public static Vector2 cursorPosition;

        static public void DrawText(Sprite sprite, FreeFont font, string text, int x, int y, int width, int height, Color color)
        {
            font.WrapWidth = width;
            font.Wrap = true;
            PutText(sprite, font, text, x, y, color);   
        }

        static public void PutText(Sprite sprite, FreeFont font, string text, int x, int y, Color color)
        {
            font.Color = color;
            //font.RubyColor = color;
            font.DrawString(sprite, text, x, y);
            cursorPosition = font.LastPos;

        }

        static public FreeFont LoadFont(GraphicsDeviceManager manager, string fontName, bool rubyOn, int size, FontWeight weight, Boolean italic)
        {
            try
            {
                if (rubyOn)
                {
                    return new RubyFont(manager, fontName, size, fontName, size/4);
                }
                else
                {
                    return new FreeFont(manager, fontName, size);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
        }
    }
}
