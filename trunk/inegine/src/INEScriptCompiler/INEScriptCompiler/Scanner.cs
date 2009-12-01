using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace ConsoleApplication1
{
    class Scanner
    {
        public enum Symbols
        {
            Semi,
            Newline
        }


        public List<Token> result;

        public Scanner(TextReader input)
        {
            this.result = new List<Token>();
            this.Scan(input);
        }

        private void Scan(TextReader input)
        {
            while (input.Peek() != -1)
            {
                char ch = (char)input.Peek();
                if (char.IsWhiteSpace(ch) && ch != '\n') input.Read();
                else if (ch == '\n')
                {
                    input.Read();
                    this.result.Add(new Newline());
                }
                else if (ch == ';')
                {
                    input.Read();
                    this.result.Add(new Semi());
                }
                else if (char.IsLetter(ch))
                {
                    StringBuilder accum = new StringBuilder();
                    Boolean firstChar = true;

                    while (char.IsLetter(ch) || (!firstChar && char.IsDigit(ch)))
                    {
                        firstChar = false;
                        accum.Append(ch);
                        input.Read();

                        if (input.Peek() == -1)
                        {
                            break;
                        }
                        else
                        {
                            ch = (char)input.Peek();
                        }
                    }
                    this.result.Add(new Symbol(accum.ToString()));
                }
                else if (ch == '"')
                {
                    StringBuilder accum = new StringBuilder();
                    input.Read();

                    if (input.Peek() == -1)
                    {
                        throw new System.Exception("unterminated string literal");
                    }

                    while ((ch = (char)input.Peek()) != '"')
                    {
                        accum.Append(ch);
                        input.Read();

                        if (input.Peek() == -1)
                        {
                            throw new System.Exception("unterminated string literal");
                        }

                    }

                    input.Read();
                    this.result.Add(new StringLit(accum.ToString()));
                }
                else
                {
                    input.Read();
                }
            }
        }
    }
}
