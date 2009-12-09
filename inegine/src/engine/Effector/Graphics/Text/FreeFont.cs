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
    class FreeFont : IDisposable
    {
        private static int _maxsize = 128;

        private string _fontPath;
        
        private readonly IntPtr _library;
        private readonly IntPtr _face;

        private SlimDX.Direct3D9.Device _device;
        private FT_GlyphSlotRec _fslot;

        private int _size;

        private Texture _buffer;
        private Vector3 _center = new Vector3();
        private Vector3 _pos = new Vector3();

        private Dictionary<uint, Texture> _charCache = new Dictionary<uint, Texture>();
        private Dictionary<uint, Vector3> _marginCache = new Dictionary<uint, Vector3>();
        private Dictionary<char, uint> _glyphIndexCache = new Dictionary<char, uint>();
        private Dictionary<uint, FT_GlyphSlotRec> _slotCache = new Dictionary<uint, FT_GlyphSlotRec>();

        public FreeFont(SlimDX.Direct3D9.Device device, string fontPath, int size)
        {
            this._device = device;
            this._fontPath = fontPath;

            this._size = Math.Min(_maxsize/2, size);

            int error;

            error = FT.FT_Init_FreeType(out _library);
            if (error != 0) throw new Exception("freetype library init error!");
            error = FT.FT_New_Face(_library, fontPath, 2, out _face);
            if (error != 0) throw new Exception("face init error!");
            this.SetSize(_size);
        }


        public void DrawString(Sprite sprite, String str, int x, int y)
        {
            //FT_Vector delta;
            int penx = 0;
            int peny = 0;
        
            
            sprite.Begin(SpriteFlags.AlphaBlend);
            for (int i = 0; i < str.Length; i++)
            {
                if (str[i] == 32) // white space
                {
                    penx += this._size/2;
                    continue;
                }

                uint glyphIndex = GetGlyphIndex(str[i]);

                GetChar(glyphIndex);

                _pos.X = x + penx + _fslot.bitmap_left;
                _pos.Y = y + peny + _size - _fslot.bitmap_top;
                
                sprite.Draw(this._buffer, _center, _pos, System.Drawing.Color.White);

                penx += _fslot.advance.x / 64;
            }
            sprite.End();
        }


        private void GetChar(uint index)
        {
            if (_charCache.ContainsKey(index))
            {
                this._buffer = _charCache[index];
                this._fslot = _slotCache[index];
            }
            else
            {
                LoadChar(index);
            }
        }

        private uint GetGlyphIndex(char c)
        {
            if (_glyphIndexCache.ContainsKey(c))
            {
                return _glyphIndexCache[c];
            }
            else
            {
                uint index = FT.FT_Get_Char_Index(_face, Convert.ToUInt32(c));
                _glyphIndexCache.Add(c, index);
                return index;
            }
        }

        private void LoadChar(uint index)
        {
            int error = FT.FT_Load_Glyph(_face, index, FT.FT_LOAD_DEFAULT);
            if (error != 0) throw new Exception("load glyph error!");

            FT_FaceRec _fface = (FT_FaceRec)Marshal.PtrToStructure(_face, typeof(FT_FaceRec));
            FT_GlyphSlotRec fslot = (FT_GlyphSlotRec)Marshal.PtrToStructure(_fface.glyph, typeof(FT_GlyphSlotRec));

            error = FT.FT_Render_Glyph(ref fslot, FT_Render_Mode.FT_RENDER_MODE_NORMAL);
            if (error != 0) throw new Exception("load glyph error!");

            this._fslot = fslot;
            this._buffer = RenderBitmap(fslot, 0, 0);

            _charCache.Add(index, _buffer);
            _slotCache.Add(index, fslot);
        }

        Texture RenderBitmap(FT_GlyphSlotRec fslot, int left, int top)
        {
            FT_Bitmap bitmap = fslot.bitmap;
            int width = _fslot.bitmap.width;
            int height = _fslot.bitmap.rows;
            this._buffer = new Texture(_device, _maxsize, _maxsize, 0, Usage.Dynamic, Format.A8R8G8B8, Pool.Default);

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

            DataRectangle rect = _buffer.LockRectangle(0, LockFlags.None);
            
            int index = 0;
            long offset = 0;
            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    byte color = 255;
                    if (isMono)
                    {
                        offset = _maxsize * y * 4 + x * 4;
                        if ((buffer[y * bitmap.pitch + (x >> 3)] & (0x80 >> (x % 8))) != 0)
                        {
                            //Console.WriteLine("yes");
                            color = 0;
                        }
                        else
                        {
                            //Console.WriteLine("no!");
                        }
                    }
                    else
                    {
                        offset = _maxsize * y * 4 + x * 4;
                        index = y * width + x;
                        color = (byte)(255 - buffer[index]);
                    }

                    //if (color != 255)
                    //{
                        rect.Data.Seek(offset, SeekOrigin.Begin);
                        rect.Data.WriteByte(color);
                        rect.Data.WriteByte(color);
                        rect.Data.WriteByte(color);
                        rect.Data.WriteByte(255);
                    //}
                }

            }

            _buffer.UnlockRectangle(0);

            return _buffer;
        }

        public void SetSize(int size)
        {
            int error = FT.FT_Set_Char_Size(_face, size * 64, 0, 96, 96);
        }

        #region IDisposable Members

        public void Dispose()
        {
            FT.FT_Done_Face(_face);
            FT.FT_Done_FreeType(_library);
        }

        #endregion
    }
}
