using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using Com.StellmanGreene.CSVReader;

namespace InovelTest
{
    /// <summary>
    /// Summary description for InovelTest
    /// </summary>
    [TestClass]
    public class CSVReaderTest
    {
        private string csvData;

        public CSVReaderTest()
        {
            csvData = @"F1,F2
1,abc
2,def
3,fff
4.14,ggg";
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion


        /// <summary>
        ///A test for OutputString
        ///</summary>
        [TestMethod()]
        public void CSVReadingTest()
        {
            CSVReader csvReader = new CSVReader(this.csvData);

            List<Object> row = csvReader.ReadRow();

            // read column names
            List<String> columnNames = new List<string>();
            foreach (Object obj in row)
            {
                switch (obj.GetType().ToString())
                {
                    case "System.String":
                        columnNames.Add(obj.ToString());
                        break;
                    default:
                        break;
                }

            }
            row = csvReader.ReadRow();


            while (row != null)
            {
                for (int i = 0; i < row.Count; i++)
                {
                    Object obj = row[i];
                    Console.Write(columnNames[i] + ":");
                    switch (obj.GetType().ToString())
                    {
                        case "System.String":
                            Console.Write("string: " + obj.ToString());
                            break;
                        case "System.Byte":
                            Console.Write("byte: " + obj.ToString());
                            break;
                        case "System.Single":
                            float number = (float)obj;
                            Console.Write("float: " + number.ToString());
                            break;
                        default:
                            Console.Write(obj.GetType().ToString());
                            break;
                    }
                    Console.WriteLine("");

                }
                row = csvReader.ReadRow();
            }

        }



    }
}
