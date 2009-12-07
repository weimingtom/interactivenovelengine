using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;
using FreeType;

namespace FreeTextTest
{


    public partial class Form1 : Form
    {
        private int ret;
        private IntPtr libptr;
        private IntPtr faceptr;
        private FreeTypeFont font;

        public Form1()
        {
            this.FormClosing += new FormClosingEventHandler(Form1_FormClosing);
            try
            {
                font = new FreeTypeFont("c:\\windows\\fonts\\batang.tc", 1);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            InitializeComponent();
          
        }

        void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (font != null) font.Dispose();
        }

       

    }


}
