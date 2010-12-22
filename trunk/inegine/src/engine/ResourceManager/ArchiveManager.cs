using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;

namespace INovelEngine.ResourceManager
{
    class ArchiveManager
    {
        private const string zipIdentifier = "zip://";
        
        public static string password;

        public static bool IsURI(string uri)
        {
            int archiveIndex = uri.IndexOf(zipIdentifier);
            if (archiveIndex < 0)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// Get stream from URI referencing resource path in archive
        /// URI example: "zip://test.zip|test/test.zip"
        /// </summary>
        /// <param name="uri"></param>
        /// <returns></returns>
        public static Stream GetStream(string uri)
        {
            int archiveIndex = uri.IndexOf(zipIdentifier);
            if (archiveIndex < 0)
            {
                throw new Exception("uri format invalid!");
            }

            int resourceIndex = uri.IndexOf("|");
            if (resourceIndex < 0 || resourceIndex > uri.Length - 2 || resourceIndex == zipIdentifier.Length)
            {
                throw new Exception("uri format invalid!");
            }

            string archivePath = uri.Substring(archiveIndex + zipIdentifier.Length, resourceIndex - (archiveIndex + zipIdentifier.Length));
            string resourcePath = uri.Substring(resourceIndex + 1, uri.Length - (resourceIndex + 1));

            return GetStream(archivePath, resourcePath);
        }

        public static Stream GetStream(string archivePath, string resourcePath)
        {
            return GetStream(archivePath, resourcePath, password);
        }

        public static Stream GetStream(string archivePath, string resourcePath, string password)
        {
            ZipInputStream s = new ZipInputStream(File.OpenRead(archivePath));    
            s.Password = password;
            ZipEntry theEntry;
            while ((theEntry = s.GetNextEntry()) != null)
            {
                if (theEntry.Name.Equals(resourcePath))
                {
                    return s;
                }
            }
            throw new Exception(resourcePath + " not found");
        }

        private static void CopyStream(Stream input, Stream output)
        {
            byte[] buffer = new byte[32768];
            while (true)
            {
                int read = input.Read(buffer, 0, buffer.Length);
                if (read <= 0)
                    return;
                output.Write(buffer, 0, read);
            }
        }
    }
}
