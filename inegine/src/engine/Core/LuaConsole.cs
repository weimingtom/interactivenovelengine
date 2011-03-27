using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace INovelEngine.Core
{
    public partial class LuaConsole : Form
    {
        public LuaConsole()
        {
            InitializeComponent();
        }


        void textBox1_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (e.Control && e.KeyCode == Keys.A)
            {
                textBox1.SelectAll();
            }
            else if (e.KeyCode == Keys.F5)
            {
                try
                {
                    INovelEngine.Script.ScriptManager.lua.DoString(textBox1.Text);
                    Console.WriteLine("[console input executed]");
                }
                catch (Exception exception)
                {
                    Console.WriteLine(exception.Message);
                }
                    
                    e.Handled = true;
            }
        }
    }
}
