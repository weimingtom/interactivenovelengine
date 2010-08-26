using System;
using System.Collections.Generic;
using System.Text;
using SlimDX.Direct3D9;

namespace INovelEngine.Effector
{
    class Label : Button
    {
        protected override void DrawInternal()
        {
            sprite.Begin(SpriteFlags.AlphaBlend);

            DrawText();

            sprite.End();
        }
    }
}
