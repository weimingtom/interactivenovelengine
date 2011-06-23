using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using Com.StellmanGreene.CSVReader;
using INovelEngine.ResourceManager;

namespace InovelTest.ResourceManager
{
    /// <summary>
    /// Summary description for InovelTest
    /// </summary>
    [TestClass]
    public class INECsvTest
    {
        private string csvData;
        private INECsv ineCsv;
        public INECsvTest()
        {
            ineCsv = new INECsv();
            csvData = @"F1,F2
1,abc
2,def
3,fff
3.14,ggg
3.14,yes
3.14,no
3.14,y
3.14,n
3.14,1
3.14,0
3.14,-1
3.14,true
3.14,false
3.15,테스트
3.14,ウィキペディア
3.14,""g,gg""
3.14,""""""g,gg""
-4,test";
            ineCsv.csvReader = new CSVReader(csvData);
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
        public void CSVReadingColumnsTest()
        {
            ineCsv.readColumns();
            Assert.AreEqual("F1", ineCsv.columns[0]);
            Assert.AreEqual("F2", ineCsv.columns[1]);
        }


        /// <summary>
        ///A test for OutputString
        ///</summary>
        [TestMethod()]
        public void CSVReadingRowsTest()
        {
            ineCsv.readColumns();
            ineCsv.readToEnd();
            Assert.AreEqual(1, ineCsv.GetInt(0, "F1"));
            Assert.AreEqual(1.0f, ineCsv.GetFloat(0, "F1"));
            Assert.AreEqual("1", ineCsv.GetString(0, "F1"));
            Assert.AreEqual("abc", ineCsv.GetString(0, "F2"));
            Assert.AreEqual(3.14f, ineCsv.GetFloat(3, "F1"));
            Assert.AreEqual("3.14", ineCsv.GetString(3, "F1"));
            Assert.AreEqual("ggg", ineCsv.GetString(3, "F2"));

            Assert.AreEqual(true, ineCsv.GetBoolean(4, "F2"));
            Assert.AreEqual(false, ineCsv.GetBoolean(5, "F2"));
            Assert.AreEqual(true, ineCsv.GetBoolean(6, "F2"));
            Assert.AreEqual(false, ineCsv.GetBoolean(7, "F2"));
            Assert.AreEqual(true, ineCsv.GetBoolean(8, "F2"));
            Assert.AreEqual(false, ineCsv.GetBoolean(9, "F2"));
            Assert.AreEqual(false, ineCsv.GetBoolean(10, "F2"));
            Assert.AreEqual(true, ineCsv.GetBoolean(11, "F2"));
            Assert.AreEqual(false, ineCsv.GetBoolean(12, "F2"));
            Assert.AreEqual("테스트", ineCsv.GetString(13, "F2"));
            Assert.AreEqual("ウィキペディア", ineCsv.GetString(14, "F2"));
            Assert.AreEqual("g,gg", ineCsv.GetString(15, "F2"));
            Assert.AreEqual("\"g,gg", ineCsv.GetString(16, "F2"));
            Assert.AreEqual(-4f, ineCsv.GetFloat(17, "F1"));
            Assert.AreEqual(-4, ineCsv.GetInt(17, "F1"));
            
        }



    }
}
