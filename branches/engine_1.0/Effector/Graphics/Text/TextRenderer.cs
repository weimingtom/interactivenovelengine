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
        public static Color rubyColor;

        static public void DrawText(Sprite sprite, FreeFont font, string text, int x, int y, int width, int height, Color color)
        {
            font.WrapWidth = width;
            font.Wrap = true;
            font.RubyColor = rubyColor;
            PutText(sprite, font, text, x, y, color);   
        }

        static public void PutText(Sprite sprite, FreeFont font, string text, int x, int y, Color color)
        {
            font.Color = color;
            font.RubyColor = rubyColor;
            font.DrawString(sprite, text, x, y);
            cursorPosition = font.LastPos;
        }
    }
}
