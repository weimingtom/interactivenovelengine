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
            else if (e.KeyCode == Keys.Enter && e.Control)
            {
                RunLuaString(GetSelectedText());
                e.SuppressKeyPress = true;
                e.Handled = true;
            }
            else if (e.KeyCode == Keys.F5)
            {
                RunLuaString(textBox1.Text);

                e.Handled = true;
            }
        }

        public string GetSelectedText()
        {
            // Get selected character.
            int charIndex = textBox1.SelectionStart;

            // Get line index from selected character.
            int lineIndex = textBox1.GetLineFromCharIndex(charIndex);

            // Get line.
            string line = textBox1.Lines[lineIndex];
            return line;
        }

        void RunLuaString(string text)
        {
            try
            {
                INovelEngine.Script.ScriptManager.lua.DoString(text);
                Supervisor.Trace("[console input executed]");
            }
            catch (Exception exception)
            {
                Supervisor.Error(exception.Message);
            }
        }
    }
}
