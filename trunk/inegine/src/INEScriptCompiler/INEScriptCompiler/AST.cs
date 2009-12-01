using System;
using System.Collections.Generic;
using System.Text;

namespace ConsoleApplication1
{
    /* <stmt> := <expr>
     * p <expr>
     *  | <stmt>;<stmt>
     */
    public abstract class Stmt
    {
    }

    // p <expr>
    public class Print : Stmt
    {
        public Expr Expr;

        public override string ToString()
        {
            return "lua_print \"" + Expr.ToString() + "\"";
        }
    }

    //<stmt>;<stmt>
    public class Sequence : Stmt
    {
        public Stmt First;
        public Stmt Second;
    }

    //<expr>
    public class StmtExpr : Stmt
    {
        public Expr Expr;

        public override string ToString()
        {
            return "lua_print \"" + Expr.ToString() + "\"";
        }
    }

    /* <expr> := <string> 
     */
    public abstract class Expr
    {
    }

    // <string> := <string_elem>*
    public class StringLiteral : Expr
    {
        public string Value;

        public override string ToString()
        {
            return this.Value;
        }
    }
}
