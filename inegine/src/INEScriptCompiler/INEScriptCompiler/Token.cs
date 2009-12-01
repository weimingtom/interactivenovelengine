using System;
using System.Collections.Generic;
using System.Text;

namespace ConsoleApplication1
{
    public class Token
    {
        public enum Type
        {
            stringLiteral,
            symbol,
            semi,
            newline
        }

        public Type type;

        public string stringValue;

        public Token(Type type)
        {
            this.type = type;
        }

        public Token(Type type, string value)
        {
            this.type = type;
            this.stringValue = value;
        }
    }

    public class StringLit  : Token
    {
        public StringLit(string value)
            : base(Token.Type.stringLiteral, value)
        {
        }
    }

    public class Symbol : Token
    {
        public Symbol(string value)
            : base(Token.Type.symbol, value)
        {
        }
    }

    public class Semi : Token
    {
        public Semi()
            : base(Token.Type.semi)
        {
        }
    }

    public class Newline : Token
    {
        public Newline()
            : base(Token.Type.newline)
        {
        }
    }
}
