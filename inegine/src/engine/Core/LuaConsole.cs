using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Text.RegularExpressions;
using System.Globalization;
using System.IO;

namespace INovelEngine.Core
{
    public partial class LuaConsole : Form
    {
        public LuaConsole()
        {
            InitializeComponent();
            this.textBox1.TextChanged += new EventHandler(textBox1_TextChanged);
            readText();
        }

        private void readText()
        {
            try
            {
                TextReader reader = new StreamReader("buffer.txt");
                string history = reader.ReadToEnd();
                reader.Close();
                EditorText = history;
            }
            catch (Exception e)
            {
                Supervisor.Error(e.Message);
            }
        }

        void textBox1_TextChanged(object sender, EventArgs e)
        {
            TextWriter writer = new StreamWriter("buffer.txt");
            writer.Write(EditorText);
            writer.Close();
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

        public string EditorText
        {
            get
            {
                return this.textBox1.Text;
            }
            set
            {
                this.textBox1.Text = value;
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

        private void RunLuaString(string text)
        {
            try
            {
                //byte[] buffer = Encoding.UTF8.GetBytes(text);
                //System.IO.FileStream st = new System.IO.FileStream("c:\\temp.dat", System.IO.FileMode.Create);
                //st.Write(buffer, 0, buffer.Length);
                //st.Close();
                ////INovelEngine.Script.ScriptManager.lua.DoString("dofile(\"c:\\\\temp.dat\")");
                //INovelEngine.Script.ScriptManager.lua.DoFile("c:\\\\temp.dat");//buffer);
                INovelEngine.Script.ScriptManager.lua.DoString(text);
                Supervisor.Trace("[console input executed]");
            }
            catch (Exception exception)
            {
                Supervisor.Error(exception.Message);
            }
        }

        private void toolStripButton1_Click(object sender, EventArgs e)
        {
            RunLuaString("load()");
        }

        private void toolStripButton2_Click(object sender, EventArgs e)
        {
            RunLuaString("save()");
        }

        private void toolStripButton4_Click(object sender, EventArgs e)
        {
            RunLuaString("if (CurrentState().Name == \"event\") then CloseState() end");
        }

        private void openToolStripButton_Click(object sender, EventArgs e)
        {
            RunLuaString("load()");
        }

        private void saveToolStripButton_Click(object sender, EventArgs e)
        {
            RunLuaString("save()");
        }

        private void copyToolStripButton_Click(object sender, EventArgs e)
        {
            openFileDialog1.Title = "Select event script";
            openFileDialog1.InitialDirectory = System.Environment.CurrentDirectory + "\\resources\\musume\\resources\\event";
            openFileDialog1.Filter = "ESS|*.ess|All Files|*.*";

            if (openFileDialog1.ShowDialog() != DialogResult.Cancel)
            {
                string fileName = openFileDialog1.FileName;
                fileName = fileName.Replace(System.Environment.CurrentDirectory + "\\Resources\\musume\\", "");
                fileName = fileName.Replace("\\", "\\\\");
                RunLuaString("testevent(\"" + fileName + "\", true)");
            }
        }
    }
}
