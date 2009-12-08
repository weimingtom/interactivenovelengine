using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;
using Tao.FreeType;

namespace FreeTextTest
{


    public partial class Form1 : Form
    {
        private IntPtr library;
        private IntPtr face;
        private FT_FaceRec fface;
        private FT_GlyphSlotRec fslot;
        private int penx = 0;
        private int peny = 300;


        public Form1()
        {
            this.FormClosing += new FormClosingEventHandler(Form1FormClosing);

            int error;

            error = FT.FT_Init_FreeType(out library);
            if (error != 0) Console.WriteLine("init error!");

            error = FT.FT_New_Face(library, "c:\\windows\\fonts\\gulim.ttc", 2, out face);
            if (error != 0) Console.WriteLine("load face error!");

            uint index = FT.FT_Get_Char_Index(face, Convert.ToUInt32('형'));

            error = FT.FT_Set_Char_Size(face, 256*64, 0, 96, 96);

            error = FT.FT_Load_Glyph(face, index, FT.FT_LOAD_DEFAULT);
            if (error != 0) Console.WriteLine("load glyph error!");

            fface = (FT_FaceRec) Marshal.PtrToStructure(face, typeof(FT_FaceRec));
            fslot = 
                (FT_GlyphSlotRec) Marshal.PtrToStructure(fface.glyph, typeof (FT_GlyphSlotRec));
            
            error = FT.FT_Render_Glyph(ref fslot, FT_Render_Mode.FT_RENDER_MODE_NORMAL);
            if (error != 0) Console.WriteLine("load glyph error!");

            InitializeComponent();
          
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);

            int width = fslot.bitmap.width;
            int height = fslot.bitmap.rows;

            Graphics g = e.Graphics;
            g.Clear(Color.White);
            DrawBitmap(fslot.bitmap, fslot.bitmap_left + penx, peny - fslot.bitmap_top, g);

            g.Dispose();
        }

        void DrawBitmap(FT_Bitmap bitmap, int left, int top, Graphics g)
        {
            int width = fslot.bitmap.width;
            int height = fslot.bitmap.rows;

            byte[] buffer = new byte[width * height];
            Marshal.Copy(bitmap.buffer, buffer, 0, buffer.Length);


            Pen pen = new Pen(Brushes.Black);

            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    int color = 255 - buffer[y * width + x];
                    if (color != 255)
                    {
                        pen.Color = Color.FromArgb(color, color, color);
                        g.DrawRectangle(pen, left + x, top + y, 0.5f, 0.5f);
                    }

                }

            }
        }

        void Form1FormClosing(object sender, FormClosingEventArgs e)
        {
            FT.FT_Done_FreeType(library);
        }

       

    }


}
