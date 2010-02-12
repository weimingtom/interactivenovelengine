using System;
using System.IO;
using System.Text;

namespace INovelEngine.Script
{

    public class CodeGenerator
    {
        private StringBuilder compiledScript = new StringBuilder("");
        
        
        private enum FunctionType
        {
            Function, Goto, Load
        }

        private FunctionType callType = FunctionType.Function;

        public string GetScript()
        {
            return this.compiledScript.ToString();
        }

        public void StartScript()
        {
            compiledScript.Append("function init()\n");
        }

        public void EndScript()
        {
            compiledScript.Append("end\nreturn init();");
        }

        public void StartFunction(string name)
        {
            if (name.Equals("goto"))
            {
                callType = FunctionType.Goto;
                compiledScript.Append("return ");
            }
            else if(name.Equals("load"))
            {
                callType = FunctionType.Load;
                compiledScript.Append("return ");
            }
            else
            {
                callType = FunctionType.Function;
                compiledScript.Append(name);
                compiledScript.Append("(");
            }
        }

        public void EndFunction()
        {
            if (callType == FunctionType.Goto || callType == FunctionType.Load)
            {
                compiledScript.Append(";\n");
            }
            else
            {
                compiledScript.Append(");\n");
            }
        }

        public void StartLabel(string name)
        {
            compiledScript.Append("function ");
            compiledScript.Append(name);
            compiledScript.Append("()\n");
        }

        public void EndLabel()
        {
            compiledScript.Append("end\n");
        }

        public void Parameter(string content, bool first, Parser.ExprType type)
        {
            if (callType == FunctionType.Goto)
            {
                compiledScript.Append(content);
                compiledScript.Append("()");
            }
            else if (callType == FunctionType.Load)
            {
                compiledScript.Append("BeginESS(");
                compiledScript.Append(content);
                compiledScript.Append(")");
            }
            else
            {
                if (!first) compiledScript.Append(",");
                compiledScript.Append(content);
            }
        }

        public void StringLit(string content)
        {
            string temp;
            int index = content.IndexOf('\\');
            Console.WriteLine(index);
            if (index > -1)
            {
                while (index > -1)
                {
                    if (index > 0) temp = content.Substring(0, index);
                    else temp = "";

                    if (index <= content.Length - 1) content = content.Substring(index + 1);
                    index = content.IndexOf('\\');

                    compiledScript.Append("TextOut(\"");
                    compiledScript.Append(temp);
                    compiledScript.Append("\\n\");\n");

                    compiledScript.Append("Clear();\n");
                }

            }
            compiledScript.Append("TextOut(\"");
            compiledScript.Append(content);
            compiledScript.Append("\\n\");\n");
        }

    }

}