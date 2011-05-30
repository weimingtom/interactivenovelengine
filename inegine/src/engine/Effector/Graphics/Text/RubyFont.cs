using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using SampleFramework;
using SlimDX.Direct3D9;

namespace INovelEngine.Effector.Graphics.Text
{
    public class RubyFont : FreeFont
    {
        private string _rubyString = "";
        private int _rubyX;
        private int _rubyY;
        private int _rubySize;
        public bool RubyStarted
        {
            get
            {
                return _wrapLock;
            }
        }
        private FreeFont _rubyFont;

        public RubyFont(GraphicsDeviceManager manager, string fontPath, int size, string rubyFontPath, int rubysize)
            : base(manager, fontPath, size)
        {
            _spaceFirstLine = true;
            _rubySize = rubysize;
            _rubyFont = new FreeFont(manager, rubyFontPath, rubysize);
        }

        protected override void ProcessTag(Tag tag)
        {
            base.ProcessTag(tag);
            if (tag.Type == Tag.TagType.Ruby)
            {
                if (tag.IsEnding)
                {
                    this._wrapLock = false;
                }
                else
                {
                    this._wrapLock = true;
                    this._lockHeight = currentMaxHeight;
                    this._lockPos = _glyphList.Count - 1;
                    this._lockWidth = penx;
                }
            }
        }

        protected override void ApplyTag(Tag tag, Sprite sprite)
        {
            base.ApplyTag(tag, sprite);
            if (tag.Type == Tag.TagType.Ruby)
            {
                if (tag.IsEnding)
                {
                    if (!string.IsNullOrEmpty(_rubyString))
                    {
                        //_rubyFont.DrawString(sprite, _rubyString, _rubyX, 0);
                        Size rubyStringSize = _rubyFont.Measure(_rubyString);
                        int pos = _rubyX + (penx - _rubyX - rubyStringSize.Width) / 2;
                        _rubyFont.Color = this.RubyColor;
                        _rubyFont.DrawString(sprite, _rubyString, _x + pos, _y + _rubyY - rubyStringSize.Height - 5);

                    }
                }
                else
                {
                    _rubyString = tag.Value;
                    _rubyX = penx;
                    _rubyY = _prevy;
                }
            }
        }
        #region IDisposable Members

        public override void Dispose()
        {
            base.Dispose();
            _rubyFont.Dispose();
        }

        #endregion

    }
}
