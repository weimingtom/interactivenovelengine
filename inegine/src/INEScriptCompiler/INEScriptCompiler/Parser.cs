using System;
using System.Collections.Generic;
using System.Text;

namespace ConsoleApplication1
{
    class Parser
    {
        private int index;
        private List<Token> tokens;
        private readonly Stmt result;
        public readonly List<Stmt> resultList;
        private int lineCnt = 0;

        public Parser(List<Token> tokens)
        {
            this.resultList = new List<Stmt>();
            this.tokens = tokens;
            this.index = 0;
            this.result = this.ParseStmt();

            if (this.index != this.tokens.Count)
                throw new System.Exception("new line or ; expected (line:" + lineCnt + ")");
        }

        private Stmt ParseStmt()
        {
            Stmt result = null;

            if (this.index == this.tokens.Count)
            {
                throw new Exception("expected statement, got EOF");
            }

            if (getCurrentToken().type == Token.Type.stringLiteral)
            {
                StringLiteral literal = new StringLiteral();
                literal.Value = getCurrentToken().stringValue;
                StmtExpr expr = new StmtExpr();
                expr.Expr = literal;
                result = expr;
                this.index++;
            }
            else if ((getCurrentToken().type == Token.Type.newline ||
                 getCurrentToken().type == Token.Type.semi))
            {
                // skip to sequence
            }
            else if (getCurrentToken().type == Token.Type.symbol)
            {
                switch (getCurrentToken().stringValue)
                {
                    case "p":
                        Print p = new Print();
                        if (getCurrentToken(1).type != Token.Type.stringLiteral)
                        {
                            throw new System.Exception("string value expected! (line:" + lineCnt + ")");
                        }
                        else
                        {
                            StringLiteral sl = new StringLiteral();
                            p.Expr = sl;
                            sl.Value = getCurrentToken(1).stringValue;
                            this.index++;
                        }
                        result = p;
                        break;
                    default:
                        Console.WriteLine("unrecognized symbol '" + getCurrentToken().stringValue
                                            + "' (line:" + lineCnt + ")");
                        break;
                }
                this.index++;
            }
            //else
            //{
            //    Console.WriteLine("unrecognized symbol '" + getCurrentToken().stringValue
            //                        + "' (line:" + lineCnt + ")");
            //    this.index++;
            //}


            if (result != null) resultList.Add(result);

            if (this.index < this.tokens.Count &&
                (getCurrentToken().type == Token.Type.newline ||
                 getCurrentToken().type == Token.Type.semi))
            {
                if (getCurrentToken().type == Token.Type.newline) lineCnt++;
                this.index++;
                if (this.index < this.tokens.Count)
                {
                    Sequence sequence = new Sequence();
                    sequence.First = result;
                    sequence.Second = this.ParseStmt();
                    result = sequence;
                }
            }

            return result;
        }

        private Token getCurrentToken()
        {
            return this.tokens[this.index];
        }

        private Token getCurrentToken(int offset)
        {
            return this.tokens[this.index + offset];
        }
    }
}
