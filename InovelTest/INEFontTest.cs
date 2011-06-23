using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Data;
using INovelEngine.Effector.Graphics.Text;

namespace InovelTest.ResourceManager
{
    /// <summary>
    /// Summary description for InovelTest
    /// </summary>
    [TestClass]
    public class INEFontTest
    {
        public INEFontTest()
        {
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
        ///</summary>
        [TestMethod()]
        public void LURCacheAddingTest()
        {
            Dictionary<string, bool> disposeStatus = new Dictionary<string, bool>();
            CachedDictionary<int, string> dic = new CachedDictionary<int, string>(10,
                    delegate(string target)
                    {
                        disposeStatus[target] = true;
                    }
            );

            for (int i = 0; i < 10; i++)
            {
                disposeStatus[i.ToString()] = false;
                dic.Add(i, i.ToString());
            }

            string ret = dic[0];
            ret = dic[2];
            ret = dic[4];
            ret = dic[6];
            ret = dic[8];
            
            for (int i = 10; i < 15; i++)
            {
                disposeStatus[i.ToString()] = false;
                dic.Add(i, i.ToString());
            }

            Assert.AreEqual(10, dic.Count);
            Assert.AreEqual(false, disposeStatus[0.ToString()]);
            Assert.AreEqual(false, disposeStatus[2.ToString()]);
            Assert.AreEqual(false, disposeStatus[4.ToString()]);
            Assert.AreEqual(false, disposeStatus[6.ToString()]);
            Assert.AreEqual(false, disposeStatus[8.ToString()]);

            for (int i = 0; i < 15; i++)
            {
                dic.Remove(i);
                Assert.AreEqual(true, disposeStatus[i.ToString()]);
            }


            Assert.AreEqual(0, dic.Count);

            for (int i = 0; i < 15; i++)
            {
                dic.Add(i, i.ToString());
            }

            Assert.AreEqual(10, dic.Count);
        }


    }
}
