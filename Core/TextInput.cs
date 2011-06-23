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
        public string value
        {
            get
            {
                return this.textBox.Text;
            }
        }
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

        void textBox_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
                button1_Click(null, null);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void TextInput_Load(object sender, EventArgs e)
        {
            if (this.numeric)
                this.textBox.ImeMode = ImeMode.Off;
        }

    }
}
