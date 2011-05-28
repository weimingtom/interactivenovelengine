using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using SampleFramework;
using SlimDX.Direct3D9;
using Tao.FreeType;
using SlimDX;
using System.Drawing;
using System.Drawing.Imaging;

namespace INovelEngine.Effector.Graphics.Text
{
    public class GlyphHolder
    {
        public enum GlyphType
        { Tag, BaseLine, Space, LineBreak, Char }

        public GlyphType Type;
        public Glyph Glyph;
        public Tag Tag;
        public int X;
        public int Y;
    }

    public class Glyph : IDisposable
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

        #region IDisposable Members

        public void Dispose()
        {
            if (Texture != null) Texture.Dispose();
        }

        #endregion
    }

    public class Tag
    {
        public string Name;
        public TagType Type;
        public string Value;
        public bool IsEnding = false;

        public enum TagType
        {
            Color, Ruby, Etc
        };

        public const string Color = "col";
        public const string Ruby = "r";

        public Tag(string token)
        {
            string name = "";
            if (token[1] == '/') // ending tag
            {
                name = token.Substring(2, token.Length - 3);
                this.IsEnding = true;
            }
            else
            {
                int assignPos = token.IndexOf('=');
                if (assignPos > -1)
                {
                    // assigning tag
                    if (assignPos > 1 && token.Length > 4)
                    {
                        name = token.Substring(1, assignPos - 1);
                        this.Value = token.Substring(assignPos + 1, token.Length - assignPos - 2);
                    }
                }
                else
                {
                    name = token.Substring(1, token.Length - 2);
                    // non-assigning tag
                }
            }

            switch (name)
            {
                case Color:
                    this.Type = TagType.Color;
                    break;
                case Ruby:
                    this.Type = TagType.Ruby;
                    break;
                default:
                    this.Type = TagType.Etc;
                    this.Name = name;
                    break;
            }

        }

    }

    public class FreeFont : IDisposable
    {
        public enum TextEffect
        {
            None, Shadow
        };

        public TextEffect Effect;

        private const int Maxsize = 128;

        private string _fontPath;

        private readonly IntPtr _library;
        private readonly IntPtr _face;

        private GraphicsDeviceManager _manager;
        private SlimDX.Direct3D9.Device _device;
        private FT_GlyphSlotRec _fslot;

        private int _size;
        public int Size
        {
            get
            {
                return _size;   
            }
        }
        private int _lineSpacing;

        private Vector3 _center = new Vector3();
        private Vector3 _pos = new Vector3();

        private readonly Dictionary<char, Glyph> _glyphCache;
        protected readonly List<GlyphHolder> _glyphList;

        private string _prevString;
        private bool _prevWrap;
        private int _prevWrapWidth;
        protected bool _spaceFirstLine;

        protected readonly Stack<Color> _colorStack;

        private Color _color = Color.Black;
        public bool Wrap = false;
        private int _wrapWidth = 100;

        protected bool _wrapLock = false;
        protected int _lockPos = -1;
        protected int _lockHeight = -1;
        protected int _lockWidth = -1;

        private Vector2 _lastPos;
        public Vector2 LastPos
        {
            get
            {
                return this._lastPos;
            }
        }

        protected int penx;
        protected int peny;
        protected int _x;
        protected int _y;
        protected int _prevy;
        protected int _prevx;
        protected int _maxWidth;
        protected int _maxHeight;
        protected int currentMaxHeight;

        protected Bitmap glyphBuffer;
        protected byte[] textureBuffer;

        public FreeFont(GraphicsDeviceManager _manager, string fontPath, int size)
        {
            _spaceFirstLine = false;
            Effect = TextEffect.None;
            this._manager = _manager;
            this._device = _manager.Direct3D9.Device;
            this._fontPath = fontPath;

            this._size = Math.Min(Maxsize / 2, size);
            this._lastPos = new Vector2();

            _glyphCache = new Dictionary<char, Glyph>();
            _glyphList = new List<GlyphHolder>();
            _colorStack = new Stack<Color>();

            glyphBuffer = new Bitmap(Maxsize, Maxsize);
            textureBuffer = new byte[Maxsize * Maxsize * 4];

            int error = FT.FT_Init_FreeType(out _library);
            if (error != 0) throw new Exception("freetype library init error!");

            /* todo: support loading from package */
            error = FT.FT_New_Face(_library, fontPath, 0, out _face);
            
            if (error != 0) throw new Exception("face init error!");
            this.SetSize(_size);

        }


        public void ProcessString(string str)
        {
            if (_prevString == null || _prevString != str || _prevWrap != Wrap || (Wrap == true && _prevWrapWidth != WrapWidth))
            {
                _prevString = str;
                _prevWrap = Wrap;
                _prevWrapWidth = WrapWidth;

                //Dictionary<int, Tag> temptagList = ParseTags(ref str);
                //MeasureString(str, temptagList);
                CreateDisplayList(str);
            }
        }

        // parse markup tags - outputs str (without tags) and tag list
        private Dictionary<int, Tag> ParseTags(ref string str)
        {
            Dictionary<int, Tag> temptagList = new Dictionary<int, Tag>();

            int tagPosition = str.IndexOf('[');
            int tagPositionEnd = str.IndexOf(']');
            int interval = tagPositionEnd - tagPosition + 1;


            while (tagPosition > -1 && interval > 0)
            {
                string tag = str.Substring(tagPosition, interval);

                if (tag.Length > 2) // tag longer than "[]"
                {
                    temptagList.Add(tagPosition, new Tag(tag));
                }

                str = str.Remove(tagPosition, interval);
                tagPositionEnd -= interval - 1;
                tagPosition = str.IndexOf('[', tagPositionEnd);

                tagPositionEnd = str.IndexOf(']', tagPosition + 1);
                interval = tagPositionEnd - tagPosition + 1;
            }

            return temptagList;
        }

        private void CreateDisplayList(string str)
        {
            _glyphList.Clear();

            GlyphHolder currentGlyph = null;
            GlyphHolder lastLineBreak = null;

            int tagStartPosition = -1;
            bool tagStarted = false;

            _maxWidth = 0;
            _maxHeight = 0;

            currentMaxHeight = this._size / 2;
            penx = 0;

            currentGlyph = new GlyphHolder { Type = GlyphHolder.GlyphType.LineBreak };
            lastLineBreak = currentGlyph;
            _glyphList.Add(currentGlyph);

            for (int i = 0; i < str.Length; i++)
            {
                bool wrapThisLine = false;

                switch (str[i])
                {
                    case '\n':
                        lastLineBreak.Y = currentMaxHeight; // adjust baseline to max height
                        _maxHeight += currentMaxHeight + LineSpacing;
                        currentMaxHeight = this._size / 2; // reset baseline maximum
                        currentGlyph = new GlyphHolder { Type = GlyphHolder.GlyphType.LineBreak };
                        lastLineBreak = currentGlyph; // assign new baseline
                        if (penx > _maxWidth) _maxWidth = penx;
                        penx = 0;
                        break;
                    case ' ':
                        currentGlyph = new GlyphHolder { Type = GlyphHolder.GlyphType.Space };
                        penx += _size / 2;
                        if (this.Wrap && penx > this._wrapWidth) wrapThisLine = true;
                        break;
                    case '[':
                        if (!tagStarted)
                        {
                            tagStartPosition = i;
                            tagStarted = true;
                        }
                        continue;
                    case ']':
                        if (tagStarted)
                        {
                            currentGlyph = new GlyphHolder
                            {
                                Type = GlyphHolder.GlyphType.Tag,
                                Tag =
                                    new Tag(str.Substring(tagStartPosition, i - tagStartPosition + 1))
                            };
                            tagStarted = false;
                            ProcessTag(currentGlyph.Tag);
                        }
                        else
                        {
                            continue;
                        }
                        break;
                    default:
                        if (!tagStarted)
                        {
                            currentGlyph = new GlyphHolder
                            {
                                Type = GlyphHolder.GlyphType.Char,
                                Glyph = GetChar(str[i]),
                            };

                            int height = currentGlyph.Glyph.Slot.bitmap_top + currentGlyph.Glyph.Box.yMax;
                            if (height > currentMaxHeight) currentMaxHeight = height;
                           
                            int prevx = penx;
                            penx += currentGlyph.Glyph.Slot.advance.x / 64;

                            if (this.Wrap && penx > this._wrapWidth) wrapThisLine = true;
                        }
                        else
                        {
                            continue;
                        }
                        break;
                }

                if (wrapThisLine)
                {
                    char c = str[i];
                    //wrap
                    if (this._wrapLock)
                    {
                        lastLineBreak.Y = _lockHeight; // adjust baseline to max height
                        GlyphHolder lineBreaker = new GlyphHolder { Type = GlyphHolder.GlyphType.LineBreak };
                        lastLineBreak = lineBreaker; // assign new baseline
                        _glyphList.Insert(_lockPos, lineBreaker);
                        _wrapLock = false;
                        if (_lockWidth > _maxWidth) _maxWidth = penx;
                        penx -= _lockWidth;
                    }
                    else
                    {
                        lastLineBreak.Y = currentMaxHeight; // adjust baseline to max height
                        currentMaxHeight = this._size / 2; // reset baseline maximum
                        GlyphHolder lineBreaker = new GlyphHolder { Type = GlyphHolder.GlyphType.LineBreak };
                        lastLineBreak = lineBreaker; // assign new baseline
                        if (penx > _maxWidth) _maxWidth = penx;
                        penx = 0;
                        _glyphList.Add(lineBreaker);
                    }
                }

                _glyphList.Add(currentGlyph);

            }

            lastLineBreak.Y = currentMaxHeight; // adjust baseline to max height
            if (penx > _maxWidth) _maxWidth = penx;
            _maxHeight += currentMaxHeight;
        }

        public Size Measure(string str, int wrapWidth)
        {
            bool tempWrap = Wrap;
            Wrap = true;
            WrapWidth = wrapWidth;
            Size size = new Size();
            CreateDisplayList(str);
            size.Width = _maxWidth;
            size.Height = _maxHeight;
            Wrap = tempWrap;
            return size;
        }

        public Size Measure(string str)
        {
            Size size = new Size();
            CreateDisplayList(str);
            size.Width = _maxWidth;
            size.Height = _maxHeight;
            return size;
        }

        public void DrawString(Sprite sprite, string str, int x, int y)
        {
            ProcessString(str);
            _x = x;
            _y = y;
            penx = 0;
            peny = 0;
            _prevy = y + LineSpacing;

            if (!_spaceFirstLine) peny -= LineSpacing;

            for (int i = 0; i < _glyphList.Count; i++)
            {
                switch (_glyphList[i].Type)
                {
                    case GlyphHolder.GlyphType.Tag:
                        ApplyTag(_glyphList[i].Tag, sprite);
                        break;
                    case GlyphHolder.GlyphType.Space:
                        penx += _size / 2;
                        break;
                    case GlyphHolder.GlyphType.LineBreak:
                        _prevy = peny + LineSpacing;
                        peny += _size + LineSpacing;
                        penx = 0;
                        break;
                    case GlyphHolder.GlyphType.Char:
                        _pos.X = x + penx + _glyphList[i].Glyph.Slot.bitmap_left; ;
                        _pos.Y = y + peny - _glyphList[i].Glyph.Slot.bitmap_top;
                        _prevx = penx;
                        penx += _glyphList[i].Glyph.Slot.advance.x / 64;

                        if (Effect == TextEffect.Shadow)
                        {
                            _pos.X += 2;
                            _pos.Y += 2;
                            sprite.Draw(_glyphList[i].Glyph.Texture, _center, _pos, Color.Black);
                            _pos.X--;
                            _pos.Y--;
                            sprite.Draw(_glyphList[i].Glyph.Texture, _center, _pos, Color.Black);
                            _pos.Y--;
                            _pos.X--;
                        }

                        sprite.Draw(_glyphList[i].Glyph.Texture, _center, _pos, this._color);
                        break;
                    default:
                        break;
                }
            }

            _lastPos.X = penx;
            _lastPos.Y = peny - _size;
        }


        protected virtual void ProcessTag(Tag tag)
        {

        }

        protected virtual void ApplyTag(Tag tag, Sprite sprite)
        {
            if (tag.Type == Tag.TagType.Color)
            {
                //Console.Write("color");
                if (tag.IsEnding && _colorStack.Count > 0) this._color = _colorStack.Pop();
                else if (!tag.IsEnding)
                {
                    _colorStack.Push(this._color);
                    try
                    {
                        if (tag.Value.Length == 7 && tag.Value[0] == '#')
                        {
                            // hex color value
                            string color = "FF" + tag.Value.Substring(1);
                            this._color = System.Drawing.Color.FromArgb(Convert.ToInt32(color, 16));
                        }
                    }
                    catch (Exception e)
                    {
                        Supervisor.Error(e.Message);
                        _colorStack.Pop();
                    }
                }
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

            this._glyphCache.Add(c, g);
            return g;
        }

        // a version using image as medium...
        void RenderBitmap(Glyph g, int left, int top)
        {
            FT_GlyphSlotRec fslot = g.Slot;
            FT_Bitmap bitmap = fslot.bitmap;
            int width = bitmap.width;
            int height = bitmap.rows;


            bool isMono = false;

            byte[] buffer;
            if (bitmap.pixel_mode == 1)
            {
                isMono = true;
                buffer = new byte[bitmap.pitch*height];
            }
            else
            {
                buffer = new byte[width*height];
            }

            // copy freetype glyph bitmap to C# memory...
            if (bitmap.buffer != (System.IntPtr)0)
            {
                Marshal.Copy(bitmap.buffer, buffer, 0, buffer.Length);
            }

            const int unitLength = 4;
            // loop through glyph bitmap bytes to generate pixel bitmap
            Array.Clear(textureBuffer, 0, textureBuffer.Length);
            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    byte alpha = 0;
                    long offset = 0;

                    if (isMono)
                    {
                        offset = Maxsize*y*unitLength + x*unitLength;
                        if ((buffer[y*bitmap.pitch + (x >> 3)] & (0x80 >> (x%8))) != 0)
                        {
                            alpha = 255;
                        }
                    }
                    else
                    {
                        offset = Maxsize*y*unitLength + x*unitLength;
                        int index = y*width + x;
                        alpha = (byte) (buffer[index]);
                    }

                    if (alpha != 0)
                    {
                        textureBuffer[offset] = 255;
                        textureBuffer[offset + 1] = 255;
                        textureBuffer[offset + 2] = 255;
                        textureBuffer[offset + 3] = (byte) (alpha*this._color.A/255);

                        if (g.Box.xMin > x) g.Box.xMin = x;
                        if (g.Box.xMax < x) g.Box.xMin = x;
                        if (g.Box.yMin > y) g.Box.yMin = y;
                        if (g.Box.yMin < y) g.Box.yMin = y;
                    }
                }

            }

            // lock buffer image to copy from pixel bitmap
            BitmapData bData = glyphBuffer.LockBits(new Rectangle(0, 0, glyphBuffer.Width, glyphBuffer.Height),
                                                    ImageLockMode.WriteOnly, System.Drawing.Imaging.PixelFormat.Format32bppArgb);

            Marshal.Copy(textureBuffer, 0, bData.Scan0, textureBuffer.Length);
            glyphBuffer.UnlockBits(bData);

            // generate texture from buffer image...
            using (MemoryStream ms = new MemoryStream())
            {
                glyphBuffer.Save(ms, ImageFormat.Png);
                byte[] bitmapData = ms.ToArray();
                g.Texture = Texture.FromMemory(_device, bitmapData);
            }
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
                this.Wrap = true;
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

        public Color RubyColor
        {
            get;
            set;
        }

        #region IDisposable Members

        public void Dispose()
        {

            glyphBuffer.Dispose();

            foreach (Glyph glyph in _glyphCache.Values)
            {
                glyph.Dispose();

            }
            /* to do: fix error in face & library freeing.. */
            //FT.FT_Done_Face(_face);
            //FT.FT_Done_FreeType(_library);
        }

        #endregion
    }
}

