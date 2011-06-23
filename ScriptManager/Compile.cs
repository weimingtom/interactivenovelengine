using System;

namespace INovelEngine.Script
{

class Compile {

	public static void Main (string[] arg) {
		if (arg.Length > 0) {
			Scanner scanner = new Scanner(arg[0]);
			Parser parser = new Parser(scanner);
			parser.gen = new CodeGenerator();
			parser.Parse();
			if (parser.errors.count == 0) {
                Console.Write(parser.gen.GetScript());
			}
		} else
			Console.WriteLine("-- No source file specified");
	}
	
}

} // end namespace

