using System;
using System.IO;
using System.Text;
using System.Collections.Generic;

namespace INovelEngine.Script
{

    public class CodeGenerator
    {
        private StringBuilder compiledScript = new StringBuilder("");
        private int row, col;
        private Errors error = new Errors();

        public List<String> CommandList
        {
            get;
            set;
        }

        private enum FunctionType
        {
            Function, Goto, Load, If, Elseif, Else, Ifend, Return
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
            compiledScript.Append("end\ninit();\nreturn ESSOver();");
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
                compiledScript.Append("SupressESSOver = true;\n");
                compiledScript.Append("return ");
            }
            else if(name.Equals("if"))
            {
                callType = FunctionType.If;
                compiledScript.Append("if (");
            }
            else if (name.Equals("elseif"))
            {
                callType = FunctionType.Elseif;
                compiledScript.Append("elseif (");
            }
            else if (name.Equals("else"))
            {
                callType = FunctionType.Else;
                compiledScript.Append("else\n");
            }
            else if (name.Equals("end"))
            {
                callType = FunctionType.Ifend;
            }
            else if (name.Equals("return"))
            {
                callType = FunctionType.Return;
            }
            else
            {
                foreach (string cmd in CommandList)
                {
                    if (cmd.Equals(name))
                    {
                        callType = FunctionType.Function;
                        compiledScript.Append(name);
                        compiledScript.Append("(");
                        return;
                    }
                }
                error.SemErr(row, col, name + " is unrecognized");
                throw new Exception("ESS parsing error");
            }
        }

        public void EndFunction()
        {
            if (callType == FunctionType.Goto || callType == FunctionType.Load)
            {
                compiledScript.Append(";\n");
            }
            else if(callType == FunctionType.If || callType == FunctionType.Elseif)
            {
                compiledScript.Append(") then\n");
            }
            else if(callType == FunctionType.Else)
            {
            }
            else if(callType == FunctionType.Ifend)
            {
                compiledScript.Append("end;\n");
            }
            else if (callType == FunctionType.Return)
            {
                compiledScript.Append("return;\n");
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
            content = ReplaceString(content);
            string temp;
            int index = content.IndexOf('|');

            // escape case for "%/"
            if (index - 1 >= 0 && content[index - 1].Equals('&'))
            {
                content = content.Remove(index - 1, 1);
                index = content.IndexOf('|', index + 1);
            }
            if (index > -1)
            {
                while (index > -1)
                {
                    if (index > 0) temp = content.Substring(0, index);
                    else temp = "";

                    compiledScript.Append("TextOut(\"");
                    compiledScript.Append(temp);
                    //compiledScript.Append("\\n\");\n"); // why append "\n" before clearing?
                    compiledScript.Append("\");\n");

                    compiledScript.Append("Clear();\n");

                    // remove portion before index
                    if (index <= content.Length - 1) content = content.Substring(index + 1); 
                    // get next index
                    index = content.IndexOf('|');
                    // escape case for "%/"
                    if (index - 1 >= 0 && content[index - 1].Equals('&'))
                    {
                        content = content.Remove(index - 1, 1);
                        index = content.IndexOf('|', index + 1);
                    }     
                }

            }
            compiledScript.Append("TextOut(\"");
            compiledScript.Append(content);
            compiledScript.Append("\\n\");\n");
        }

        /* replace variable names in string lit */
        public string ReplaceString(string content)
        {
            StringBuilder output = new StringBuilder();
            //content = content.Replace("\"", "\\\""); // escape " characters so it won't interfere...
            int index = content.IndexOf('<');
            int endindex = content.IndexOf('>');
            if (index > -1)
            {
                while (index > -1 && endindex > -1 && index < endindex)
                {
                    output.Append(content.Substring(0, index).Replace("\"", "\\\""));
                    output.Append("\" .. tostring(");
                    String token = content.Substring(index + 1, endindex - index - 1);

                    int tokenIndex = token.IndexOf('(');
                    if (tokenIndex < 0 || !checkToken(token.Substring(0, tokenIndex)))
                    {
                        error.SemErr(row, col, token.Substring(0, tokenIndex) + " is unrecognized");
                        throw new Exception("ESS parsing error");
                    }
                    output.Append(token);
                    
                    output.Append(") .. \"");
                    if (index <= content.Length - 1) content = content.Substring(endindex + 1);
                    index = content.IndexOf('<');
                    endindex = content.IndexOf('>');
                }

            }
            output.Append(content.Replace("\"", "\\\""));
            return output.ToString();
        }

        private bool checkToken(string token)
        {
            foreach (string cmd in CommandList)
            {
                if (cmd.Equals(token))
                {
                    return true;
                }
            }
            return false;
        }

        public void AddText(string val)
        {
            compiledScript.Append(val);
            compiledScript.Append("\n");
        }

        /* todo: toggle for debug/production mode? */
        public void SetDebugInfo(int row, int col)
        {
            this.row = row;
            this.col = col;
            //compiledScript.Append("currentLine = " + row + "; ");
            //compiledScript.Append("currentCol = " + col + ";\n");
        }
    }

}