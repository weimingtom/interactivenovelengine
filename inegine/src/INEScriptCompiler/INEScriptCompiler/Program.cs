using System;
using System.Collections.Generic;
using System.Text;
using System.IO;


namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                Scanner test = new Scanner(new StreamReader("test.txt"));
                Parser testparser = new Parser(test.result);
                Console.WriteLine(testparser.resultList.Count + " statements");
                foreach (Stmt stmt in testparser.resultList)
                    Console.WriteLine(stmt.ToString());
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }


            Console.ReadKey();
        }
    }


}
