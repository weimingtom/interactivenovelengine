using INovelEngine.Effector;
using Microsoft.VisualStudio.TestTools.UnitTesting;
namespace InovelTest
{
    
    
    /// <summary>
    ///This is a test class for TextNarratorTest and is intended
    ///to contain all TextNarratorTest Unit Tests
    ///</summary>
    [TestClass()]
    public class TextNarratorTest
    {


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
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion


        /// <summary>
        ///A test for OutputString
        ///</summary>
        [TestMethod()]
        public void OutputStringTest()
        {
            TextNarrator target = new TextNarrator(); // TODO: Initialize to an appropriate value
            target.AppendText("TEST");

            Assert.AreEqual("", target.OutputString);
            target.Tick();
            Assert.AreEqual("T", target.OutputString);
            target.Tick();
            Assert.AreEqual("TE", target.OutputString);
            target.Tick();
            Assert.AreEqual("TES", target.OutputString);
            target.Tick();
            Assert.AreEqual("TEST", target.OutputString);
            target.Tick();
            Assert.AreEqual("TEST", target.OutputString);
        }

        /// <summary>
        ///A test for OutputString
        ///</summary>
        [TestMethod()]
        public void OutputStringTestTag()
        {
            TextNarrator target = new TextNarrator(); // TODO: Initialize to an appropriate value
            target.AppendText("[col=#3ea61a]6年後の「成人式」[/col]");

            Assert.AreEqual("", target.OutputString);
            target.Tick();
            Assert.AreEqual("[col=#3ea61a]", target.OutputString);
            target.Tick();
            Assert.AreEqual("[col=#3ea61a]6", target.OutputString);
            target.Tick();
            Assert.AreEqual("[col=#3ea61a]6年", target.OutputString);
            target.Tick();
            Assert.AreEqual("[col=#3ea61a]6年後", target.OutputString);
            target.Tick();
            Assert.AreEqual("[col=#3ea61a]6年後の", target.OutputString);
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            Assert.AreEqual("[col=#3ea61a]6年後の「成人式」", target.OutputString);
            target.Tick();
            Assert.AreEqual("[col=#3ea61a]6年後の「成人式」[/col]", target.OutputString);

            target.Clear();
            target.AppendText("[col=#3ea61a]");
            target.Tick();
            Assert.AreEqual("[col=#3ea61a]", target.OutputString);
            target.Tick();
            Assert.AreEqual("[col=#3ea61a]", target.OutputString);
        }

        /// <summary>
        ///A test for Clear
        ///</summary>
        [TestMethod()]
        public void ClearTest()
        {
            TextNarrator target = new TextNarrator(); // TODO: Initialize to an appropriate value
            target.AppendText("TEST");

            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            Assert.AreEqual("TEST", target.OutputString);
            target.Clear();
            Assert.AreEqual("", target.OutputString);
        }

        /// <summary>
        ///A test for AppendText
        ///</summary>
        [TestMethod()]
        public void AppendTextTest()
        {
            TextNarrator target = new TextNarrator(); // TODO: Initialize to an appropriate value
            target.AppendText("TEST");

            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            Assert.AreEqual("TEST", target.OutputString);
            target.AppendText("\nTEST2");
            Assert.AreEqual("TEST", target.OutputString);
            target.Tick();
            Assert.AreEqual("TEST\n", target.OutputString);
            target.Tick();
            Assert.AreEqual("TEST\nT", target.OutputString);
            target.Tick();
            Assert.AreEqual("TEST\nTE", target.OutputString);
            target.Tick();
            Assert.AreEqual("TEST\nTES", target.OutputString);
            target.Tick();
            Assert.AreEqual("TEST\nTEST", target.OutputString);
            target.Tick();
            Assert.AreEqual("TEST\nTEST2", target.OutputString);
        }

        /// <summary>
        ///A test for Advance
        ///</summary>
        [TestMethod()]
        public void AdvanceTest()
        {
            TextNarrator target = new TextNarrator(); // TODO: Initialize to an appropriate value
            target.AppendText("TEST@TEST2");
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            Assert.AreEqual("TEST", target.OutputString);
            target.Tick();
            target.Tick();
            Assert.AreEqual("TEST", target.OutputString);
            target.Advance();
            target.Tick();
            Assert.AreEqual("TESTT", target.OutputString);
            target.Tick();
            Assert.AreEqual("TESTTE", target.OutputString);
            target.Tick();
            Assert.AreEqual("TESTTES", target.OutputString);
            target.Tick();
            Assert.AreEqual("TESTTEST", target.OutputString);
            target.Tick();
            Assert.AreEqual("TESTTEST2", target.OutputString);
        }

        /// <summary>
        ///A test for Advance to Skip
        ///</summary>
        [TestMethod()]
        public void AdvanceToSkipTest()
        {
            TextNarrator target = new TextNarrator(); // TODO: Initialize to an appropriate value
            target.AppendText("TEST@TEST2@TEST3@");
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            Assert.AreEqual("TEST", target.OutputString);
            target.Tick();
            target.Tick();
            Assert.AreEqual("TEST", target.OutputString);
            target.Advance();
            target.Tick();
            Assert.AreEqual("TESTT", target.OutputString);
            target.Advance();
            Assert.AreEqual("TESTTEST2", target.OutputString);
            Assert.AreEqual(NarrationState.Stopped, target.State);
            target.Advance();
            Assert.AreEqual("TESTTEST2", target.OutputString);
            target.Tick();
            Assert.AreEqual("TESTTEST2T", target.OutputString);
            target.Advance();
            Assert.AreEqual("TESTTEST2TEST3", target.OutputString);
            Assert.AreEqual(NarrationState.Stopped, target.State);
            target.AppendText("TEST4");
            target.Advance();
            target.Advance();
            Assert.AreEqual("TESTTEST2TEST3TEST4", target.OutputString);
            Assert.AreEqual(NarrationState.Over, target.State);
        }


        /// <summary>
        ///A test for Advance to Skip
        ///</summary>
        [TestMethod()]
        public void AdvanceToStaticTest()
        {
            TextNarrator target = new TextNarrator(); // TODO: Initialize to an appropriate value
            target.AppendText("TEST@TEST2@TEST3@");
            target.Advance();
            Assert.AreEqual("TEST", target.OutputString);
            target.Advance();
            target.Advance();
            Assert.AreEqual("TESTTEST2", target.OutputString);
            Assert.AreEqual(NarrationState.Stopped, target.State);
            target.Advance();
            target.Advance();
            Assert.AreEqual("TESTTEST2TEST3", target.OutputString);
            Assert.AreEqual(NarrationState.Stopped, target.State);
            target.AppendText("TEST4");
            target.Advance();
            target.Advance();
            Assert.AreEqual("TESTTEST2TEST3TEST4", target.OutputString);
            Assert.AreEqual(NarrationState.Over, target.State);
            target.Advance();
            Assert.AreEqual(NarrationState.Over, target.State);
            target.Advance();
            target.Advance();
            Assert.AreEqual(NarrationState.Over, target.State);
            target.Clear();
            Assert.AreEqual(NarrationState.Going, target.State);
        }


        /// <summary>
        ///A test for State
        ///</summary>
        [TestMethod()]
        public void StateTest()
        {
            TextNarrator target = new TextNarrator(); // TODO: Initialize to an appropriate value
            Assert.AreEqual(NarrationState.Going, target.State);
            target.AppendText("TEST@TEST@2");
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            Assert.AreEqual("TEST", target.OutputString);
            target.Tick();
            Assert.AreEqual(NarrationState.Stopped, target.State);
            target.Tick();
            target.Tick();
            Assert.AreEqual("TEST", target.OutputString);
            Assert.AreEqual(NarrationState.Stopped, target.State);
            target.Advance();
            Assert.AreEqual(NarrationState.Going, target.State);
            target.Tick();
            Assert.AreEqual(NarrationState.Going, target.State);
            Assert.AreEqual("TESTT", target.OutputString);
            target.Tick();
            Assert.AreEqual(NarrationState.Going, target.State);
            Assert.AreEqual("TESTTE", target.OutputString);
            target.Tick();
            Assert.AreEqual(NarrationState.Going, target.State);
            Assert.AreEqual("TESTTES", target.OutputString);
            target.Tick();
            Assert.AreEqual(NarrationState.Going, target.State);
            Assert.AreEqual("TESTTEST", target.OutputString);
            target.Tick();
            Assert.AreEqual(NarrationState.Stopped, target.State);
            target.Advance();
            Assert.AreEqual(NarrationState.Going, target.State);
            target.Tick();
            Assert.AreEqual("TESTTEST2", target.OutputString);
            target.Tick();
            Assert.AreEqual(NarrationState.Over, target.State);
            target.AppendText("TEST@3");
            Assert.AreEqual(NarrationState.Going, target.State);
            target.Tick();
            Assert.AreEqual("TESTTEST2T", target.OutputString);
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            target.Tick();
            Assert.AreEqual("TESTTEST2TEST", target.OutputString);
            Assert.AreEqual(NarrationState.Stopped, target.State);
            target.Advance();
            Assert.AreEqual(NarrationState.Going, target.State);
            target.Tick();
            Assert.AreEqual("TESTTEST2TEST3", target.OutputString);
            target.Tick();
            Assert.AreEqual(NarrationState.Over, target.State);
        }
    }
}
