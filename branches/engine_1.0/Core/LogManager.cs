using System;
using System.Collections.Generic;
using System.Text;
using NLog;

namespace INovelEngine.Core
{
    class LogManager
    {
        private Logger logger;
        public LogManager()
        {
            logger = NLog.LogManager.GetCurrentClassLogger();

        }

        public void Trace(string msg)
        {
            logger.Trace(msg);
        }

        public void Info(string msg)
        {
            logger.Info(msg);
        }

        public void Error(string msg)
        {
            logger.Error(msg);
        }
    }
}
