using System.Text;



using System;



public class Parser {
	public const int _EOF = 0;
	public const int _ident = 1;
	public const int _luaident = 2;
	public const int _litstring = 3;
	public const int _numericstring = 4;
	public const int _label = 5;
	public const int maxT = 7;

	const bool T = true;
	const bool x = false;
	const int minErrDist = 2;
	
	public Scanner scanner;
	public Errors  errors;

	public Token t;    // last recognized token
	public Token la;   // lookahead token
	int errDist = minErrDist;

public enum Op { ADD, SUB, MUL, DIV, EQU, LSS, GTR, NEG };
    public enum ExprType { String, Numeric };
    public INovelEngine.Script.CodeGenerator gen;



	public Parser(Scanner scanner) {
		this.scanner = scanner;
		errors = new Errors();
	}

	void SynErr (int n) {
		if (errDist >= minErrDist) errors.SynErr(la.line, la.col, n);
		errDist = 0;
	}

	public void SemErr (string msg) {
		if (errDist >= minErrDist) errors.SemErr(t.line, t.col, msg);
		errDist = 0;
	}
	
	void Get () {
		for (;;) {
			t = la;
			la = scanner.Scan();
			if (la.kind <= maxT) { ++errDist; break; }

			la = t;
		}
	}
	
	void Expect (int n) {
		if (la.kind==n) Get(); else { SynErr(n); }
	}
	
	bool StartOf (int s) {
		return set[s, la.kind];
	}
	
	void ExpectWeak (int n, int follow) {
		if (la.kind == n) Get();
		else {
			SynErr(n);
			while (!StartOf(follow)) Get();
		}
	}


	bool WeakSeparator(int n, int syFol, int repFol) {
		int kind = la.kind;
		if (kind == n) {Get(); return true;}
		else if (StartOf(repFol)) {return false;}
		else {
			SynErr(n);
			while (!(set[syFol, kind] || set[repFol, kind] || set[0, kind])) {
				Get();
				kind = la.kind;
			}
			return StartOf(syFol);
		}
	}

	
	void INESCRIPT() {
		Expect(6);
		gen.StartScript(); 
		Stat();
		while (StartOf(1)) {
			Stat();
		}
		gen.EndScript(); 
	}

	void Stat() {
		string val; 
		if (la.kind == 2) {
			LuaCall();
		} else if (la.kind == 1) {
			FunctionCall();
		} else if (la.kind == 5) {
			Label(out val);
			gen.EndLabel(); gen.SetDebugInfo(t.line, t.col); gen.StartLabel(val); 
		} else if (la.kind == 3) {
			Litstring(out val);
			gen.SetDebugInfo(t.line, t.col); gen.StringLit(val.TrimStart('\n')); 
		} else if (la.kind == 4 || la.kind == 6 || la.kind == 7) {
			Get();
		} else SynErr(8);
	}

	void LuaCall() {
		string val = ""; 
		LuaIdent();
		while (la.kind == 4) {
			String(out val);
		}
		gen.SetDebugInfo(t.line, t.col); gen.AddText(val); 
	}

	void FunctionCall() {
		string name, val; 
		Ident(out name);
		gen.SetDebugInfo(t.line, t.col); gen.StartFunction(name); 
		while (la.kind == 4) {
			Parameters(out val);
		}
		gen.EndFunction(); 
	}

	void Label(out string val) {
		Expect(5);
		val = t.val.TrimEnd(':').TrimStart('\n'); 
	}

	void Litstring(out string val) {
		Expect(3);
		val = t.val; 
	}

	void Ident(out string val) {
		Expect(1);
		val = 
		t.val.TrimStart('\n').TrimStart('#'); 
	}

	void Parameters(out string val) {
		ExprType type; 
		Expr(out val, out type);
		gen.Parameter(val, true, type); 
	}

	void Expr(out string val, out ExprType type) {
		val = ""; type = ExprType.Numeric; 
		String(out val);
		type = ExprType.String; 
	}

	void String(out string val) {
		Expect(4);
		val = t.val; 
	}

	void LuaIdent() {
		Expect(2);
	}



	public void Parse() {
		la = new Token();
		la.val = "";		
		Get();
		INESCRIPT();

    Expect(0);
	}
	
	static readonly bool[,] set = {
		{T,x,x,x, x,x,x,x, x},
		{x,T,T,T, T,T,T,T, x}

	};
} // end Parser


public class Errors {
	public int count = 0;                                    // number of errors detected
	public System.IO.TextWriter errorStream = Console.Out;   // error messages go to this stream
  public string errMsgFormat = "-- line {0} col {1}: {2}"; // 0=line, 1=column, 2=text
  
	public void SynErr (int line, int col, int n) {
		string s;
		switch (n) {
			case 0: s = "EOF expected"; break;
			case 1: s = "ident expected"; break;
			case 2: s = "luaident expected"; break;
			case 3: s = "litstring expected"; break;
			case 4: s = "numericstring expected"; break;
			case 5: s = "label expected"; break;
			case 6: s = "\"[INESCRIPT]\" expected"; break;
			case 7: s = "??? expected"; break;
			case 8: s = "invalid Stat"; break;

			default: s = "error " + n; break;
		}
		errorStream.WriteLine(errMsgFormat, line, col, s);
		count++;
	}

	public void SemErr (int line, int col, string s) {
		errorStream.WriteLine(errMsgFormat, line, col, s);
		count++;
	}
	
	public void SemErr (string s) {
		errorStream.WriteLine(s);
		count++;
	}
	
	public void Warning (int line, int col, string s) {
		errorStream.WriteLine(errMsgFormat, line, col, s);
	}
	
	public void Warning(string s) {
		errorStream.WriteLine(s);
	}
} // Errors


public class FatalError: Exception {
	public FatalError(string m): base(m) {}
}

