using System;
using System.Collections.Generic;
using System.Text;

namespace INovelEngine.Core
{
    class TextureLoadError : Exception
    {
        public TextureLoadError(string str)
        {
            this.Source = str;
        }

        public override string Message
        {
            get
            {
                return "loading " + this.Source + " failed";
            }
        }
    }
}
