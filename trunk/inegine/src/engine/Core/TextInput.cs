using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace INovelEngine.Core
{
    public partial class TextInput : Form
    {
        public string value;
        public bool numeric;

        public TextInput()
        {
            numeric = false;

            InitializeComponent();
        }

        void textBox_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
        {
            if (this.numeric) 
                if (e.KeyChar != '\b' && ((e.KeyChar < '0') || (e.KeyChar > '9'))) e.Handled = true;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Console.WriteLine("entered!");
            value = this.textBox.Text;
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

    }
}
