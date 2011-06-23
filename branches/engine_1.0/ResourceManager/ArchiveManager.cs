using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;

namespace INovelEngine.ResourceManager
{
    class ArchiveManager
    {
        private static string package = null;
        private static string password = null;
        private static string path = null;

        public static void SetPackage(string package, string password)
        {
            ArchiveManager.package = package;
            ArchiveManager.password = password.GetHashCode().ToString();
        }

        public static void SetPath(string path)
        {
            ArchiveManager.path = path;
        }



        /// <summary>
        /// Get stream from given path
        /// If relative path is set by SetPath, a stream for the file within the path is returned
        /// If package is set by SetPackage, a stream for the file within the package is returned
        /// </summary>
        public static Stream GetStream(string path)
        {
            if (ArchiveManager.package != null)
            {
                return GetStreamInternal(package, path, password);
            }
            else
            {
                if (ArchiveManager.path != null)
                {
                    path = ArchiveManager.path + "/" + path;
                }
                return File.OpenRead(path);
            }
        }

        private static Stream GetStreamInternal(string archivePath, string resourcePath, string password)
        {
            ZipInputStream s = new ZipInputStream(File.OpenRead(archivePath));    
            s.Password = password;
            ZipEntry theEntry;
            while ((theEntry = s.GetNextEntry()) != null)
            {
                if (theEntry.Name.Equals(resourcePath) || theEntry.Name.Equals(resourcePath.Replace("\\", "/")))
                {
                    return s;
                }
            }
            throw new Exception(resourcePath + " not found");
        }
    }
}
