using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace INovelEngine.ResourceManager
{
    class SaveManager
    {
        public static void SaveData(string data, string path)
        {
            File.WriteAllText(path, EncodeDecode(data));
        }

        public static string LoadData(string path)
        {
            return EncodeDecode(File.ReadAllText(path));
        }

        private static string EncodeDecode(string x)
        {
            int key = 88; 
            char[] charArray = new char[x.Length];
            int len = x.Length - 1;
            for (int i = 0; i <= len; i++)
                charArray[i] = (char)(x[len - i] ^ key);
            return new string(charArray);
        }

    }
}
