using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using SlimDX.Direct3D9;
using Tao.FreeType;
using SlimDX;
using System.Drawing;

namespace INovelEngine.Effector.Graphics.Text
{
    class Glyph
    {
        public enum GlyphType
        { Default, Space, LineBreak }

        public GlyphType Type;
        public uint Index;
        public FT_GlyphSlotRec Slot;
        public Texture Texture;
        public FT_BBox Box;

        public Glyph(GlyphType type, uint index, FT_GlyphSlotRec slot)
        {
            this.Type = type;
            this.Index = index;
            this.Slot = slot;
            this.Box = new FT_BBox();
            this.Box.xMin = this.Box.yMin = 32000;
            this.Box.xMax = this.Box.xMax = -32000;
        }

        public Glyph(GlyphType type)
        {
            this.Type = type;
            this.Box = new FT_BBox();
            this.Box.xMin = this.Box.yMin = 32000;
            this.Box.xMax = this.Box.xMax = -32000;
        }
    }


    class FreeFont : IDisposable
    {
        private const int Maxsize = 128;

        private string _fontPath;
        
        private readonly IntPtr _library;
        private readonly IntPtr _face;

        private SlimDX.Direct3D9.Device _device;
        private FT_GlyphSlotRec _fslot;

        private int _size;
        private int _lineSpacing;

        private Vector3 _center = new Vector3();
        private Vector3 _pos = new Vector3();

        private readonly Dictionary<char, Glyph> _glyphCache;
        private readonly List<Glyph> _displayList;

        private string _prevString;

        private readonly List<int> _heightList;
        private readonly List<int> _widthList;
        private Dictionary<int, string> _tokenList;

        public Color _color = Color.Black;
        public Boolean Wrap = true;
        private int _wrapWidth = 100;

        private Vector2 _lastPos;
        public Vector2 LastPos
        {
            get
            {
                return this._lastPos;
            }
        }

        public FreeFont(SlimDX.Direct3D9.Device device, string fontPath, int size)
        {
            this._device = device;
            this._fontPath = fontPath;

            this._size = Math.Min(Maxsize/2, size);
            this._lastPos = new Vector2();

            _glyphCache = new Dictionary<char, Glyph>();
            _displayList = new List<Glyph>();
            _heightList = new List<int>();
            _widthList = new List<int>();
            
            _tokenList = new Dictionary<int, string>();

            int error;

            error = FT.FT_Init_FreeType(out _library);
            if (error != 0) throw new Exception("freetype library init error!");
            error = FT.FT_New_Face(_library, fontPath, 2, out _face);
            if (error != 0) throw new Exception("face init error!");
            this.SetSize(_size);
        }


        public void ProcessString(String str)
        {
            if (_prevString == null || _prevString != str)
            {
#if DEBUG
                Console.WriteLine(str);
#endif

                _prevString = str;

                _tokenList.Clear();
                // first pass: parse markup tags

                int tagPosition = str.IndexOf('[');
                int tagPositionEnd = str.IndexOf(']');
                int interval = tagPositionEnd - tagPosition + 1;
                

                while (tagPosition > -1 && interval > 0)
                {
                    _tokenList.Add(tagPosition,str.Substring(tagPosition, interval));
                    str = str.Remove(tagPosition, interval);
                    tagPositionEnd -= interval;
                    tagPosition = str.IndexOf('[', tagPositionEnd);
                    tagPositionEnd = str.IndexOf(']', tagPosition + 1);
                    interval = tagPositionEnd - tagPosition + 1;
                }

                foreach(int i in _tokenList.Keys)
                {
                    Console.WriteLine(i + ":" + _tokenList[i]);
                }

                // second pass: process width/height and get glyphs

                _displayList.Clear();
                _heightList.Clear();
                _widthList.Clear();

                Glyph currentGlyph;

                int currentMaximum = this._size / 2;
                int penx = 0;
                
                Boolean wrapping = false;
                Boolean afterWrapping = false;

                for (int i = 0; i < str.Length; i++)
                {
                    int height = 0;

                    if (str[i] == '\n' || wrapping)
                    {
                        currentGlyph = new Glyph(Glyph.GlyphType.LineBreak);
                        height = currentGlyph.Slot.bitmap_top + currentGlyph.Box.yMax;
                        height = this._size / 2;

                        // break line
                        _heightList.Add(currentMaximum);
                        _widthList.Add(penx);

                        currentMaximum = this._size / 2;
                        penx = 0;

                        if(wrapping)
                        {
                            wrapping = false;
                            afterWrapping = true;
                            i--;
                        }
                    }
                    else if (str[i] == ' ') // white space
                    {
                        if (afterWrapping && this.WrapWidth < this._size / 2)
                        {
                            afterWrapping = false;
                        }
                        else if (this.Wrap && penx + this._size / 2 > this._wrapWidth)
                        {
                            wrapping = true;
                            i--;
                            continue;
                        }

                        currentGlyph = new Glyph(Glyph.GlyphType.Space);
                        height = this._size / 2;
                        
                        _widthList.Add(penx);
                        penx += this._size / 2;
                    }
                    else
                    {
                        currentGlyph = GetChar(str[i]);

                        if (afterWrapping && this.WrapWidth < currentGlyph.Slot.advance.x / 64)
                        {
                            afterWrapping = false;
                        }
                        else if (this.Wrap && penx + currentGlyph.Slot.advance.x / 64 > this._wrapWidth)
                        {
                            wrapping = true;
                            i--;
                            continue;
                        }

                        height = currentGlyph.Slot.bitmap_top + currentGlyph.Box.yMax;
                        
                        _widthList.Add(penx + currentGlyph.Slot.bitmap_left);
                        penx += currentGlyph.Slot.advance.x / 64;

                        if (i == str.Length - 1)
                        {
                            _heightList.Add(currentMaximum);
                        }
                    }

                    if (currentMaximum < height) currentMaximum = height;
                    _displayList.Add(currentGlyph);
                    
                }
            }
        }

        public void DrawString(Sprite sprite, String str, int x, int y)
        {
            ProcessString(str);

            // use _heightList, _widthList, and _displayList to render characters
            int breakCount = 0;
            int penx = 0;
            int peny = _heightList[0];

            for (int i = 0; i < _displayList.Count; i++)
            {
                switch (_displayList[i].Type)
                {
                    case  Glyph.GlyphType.Space:
                        penx += this._size / 2;
                        continue;
                    case Glyph.GlyphType.LineBreak:
                        penx = 0;
                        peny += _heightList[breakCount++] + this._lineSpacing;
                        continue;
                    default:
                        _pos.X = x + _widthList[i]; ;
                        _pos.Y = y + peny - _displayList[i].Slot.bitmap_top;
                        penx += _displayList[i].Slot.advance.x/64;
                        sprite.Draw(_displayList[i].Texture, _center, _pos, this._color);
                        break;
                }
            }

            if (penx > this._wrapWidth)
            {
                penx = 0;
                peny += this.LineSpacing + this._size;
            }

            if (_heightList.Count > 1)
            {
                _lastPos.X = penx;
                _lastPos.Y = peny;
            }
            else
            {
                _lastPos.X = penx;
                _lastPos.Y = y;
            }
        }

        private Glyph GetChar(char c)
        {
            //if (_charCache.ContainsKey(index))
            if (this._glyphCache.ContainsKey(c))
            {
                Glyph g = this._glyphCache[c];
                return g;
            }
            else
            {
                return LoadChar(c);
            }
        }

        private uint GetGlyphIndex(char c)
        {
            uint index = FT.FT_Get_Char_Index(_face, Convert.ToUInt32(c));
            return index;
        }

        private Glyph LoadChar(char c)
        {
            uint index = GetGlyphIndex(c);

            int error = FT.FT_Load_Glyph(_face, index, FT.FT_LOAD_DEFAULT);
            if (error != 0) throw new Exception("load glyph error!");

            FT_FaceRec _fface = (FT_FaceRec)Marshal.PtrToStructure(_face, typeof(FT_FaceRec));
            FT_GlyphSlotRec fslot = (FT_GlyphSlotRec)Marshal.PtrToStructure(_fface.glyph, typeof(FT_GlyphSlotRec));

            error = FT.FT_Render_Glyph(ref fslot, FT_Render_Mode.FT_RENDER_MODE_NORMAL);
            if (error != 0) throw new Exception("load glyph error!");

            this._fslot = fslot;
            
            Glyph g = new Glyph(Glyph.GlyphType.Default, index, fslot);

            RenderBitmap(g, 0, 0);

            this._glyphCache.Add(c,g);
            return g;
        }

        void RenderBitmap(Glyph g, int left, int top)
        {
            FT_GlyphSlotRec fslot = g.Slot;
            FT_Bitmap bitmap = fslot.bitmap;
            int width = bitmap.width;
            int height = bitmap.rows;
            g.Texture = new Texture(_device, Maxsize, Maxsize, 0, Usage.Dynamic, Format.A8R8G8B8, Pool.Default);

            bool isMono = false;

            byte[] buffer;
            if (bitmap.pixel_mode == 1)
            {
                isMono = true;
                buffer = new byte[bitmap.pitch * height];
            }
            else
            {
                buffer = new byte[width * height];
            }

            Marshal.Copy(bitmap.buffer, buffer, 0, buffer.Length);

            DataRectangle rect = g.Texture.LockRectangle(0, LockFlags.None);

            int index = 0;
            long offset = 0;
            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    byte alpha = 0;

                    if (isMono)
                    {
                        offset = Maxsize * y * 4 + x * 4;
                        if ((buffer[y * bitmap.pitch + (x >> 3)] & (0x80 >> (x % 8))) != 0)
                        {
                            alpha = 255;
                        }
                    }
                    else
                    {
                        offset = Maxsize * y * 4 + x * 4;
                        index = y * width + x;
                        alpha = (byte)(buffer[index]);
                    }

                    if (alpha != 0)
                    {
                        rect.Data.Seek(offset, SeekOrigin.Begin);
                        rect.Data.WriteByte(255);
                        rect.Data.WriteByte(255);
                        rect.Data.WriteByte(255);
                        rect.Data.WriteByte((byte)(alpha * this._color.A / 255));

                        if (g.Box.xMin > x) g.Box.xMin = x;
                        if (g.Box.xMax < x) g.Box.xMin = x;
                        if (g.Box.yMin > y) g.Box.yMin = y;
                        if (g.Box.yMin < y) g.Box.yMin = y;
                    }
                }

            }

            g.Texture.UnlockRectangle(0);
        }

        private void SetSize(int size)
        {
            int error = FT.FT_Set_Char_Size(_face, size * 64, 0, 96, 96);
        }

        public int LineSpacing
        {
            get
            {
                return this._lineSpacing;
            }

            set
            {
                this._lineSpacing = Math.Max(0, value);
            }
        }

        public int WrapWidth
        {
            get
            {
                return this._wrapWidth;
            }
            set
            {
                this._wrapWidth = Math.Max(0, value);   
            }
        }

        public Color Color
        {
            get
            {
                return this._color;
            }
            set
            {
                this._color = value;
            }
        }

        #region IDisposable Members

        public void Dispose()
        {
            /* to do: dispose faces and textures */

            FT.FT_Done_Face(_face);
            FT.FT_Done_FreeType(_library);
        }

        #endregion
    }
}
