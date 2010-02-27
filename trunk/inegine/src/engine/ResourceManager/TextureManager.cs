using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Text;
using INovelEngine.Core;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;

namespace INovelEngine.ResourceManager
{
    public class INETexture : IResource
    {
        public Texture texture;
        public int width;
        public int height;
        private Device device;

        private Bitmap scaledBitmap;
        private string fileName;

        public INETexture ()
        {
            
        }

        public INETexture (string fileName)
        {
        }

        public string TextureFile
        {
            get
            {
                return fileName;
            }
            set
            {
                fileName = value;
                LoadTextureFile(fileName);
                if (device != null) LoadContent();
            }
        }

        public void LoadTextureFile(string fileName)
        {
            try
            {
                Bitmap bitmap = new Bitmap(fileName);
                scaledBitmap = bitmap;
                this.width = bitmap.Width;
                this.height = bitmap.Height;

                int newWidth = ClosestPower2(bitmap.Width);
                int newHeight = ClosestPower2(bitmap.Height);

                if (!(bitmap.Width == newWidth && bitmap.Height == newHeight))
                {
                    scaledBitmap = new Bitmap(newWidth, newHeight);

                    using (Graphics g = Graphics.FromImage((Image)scaledBitmap))
                        g.DrawImage(bitmap, 0, 0, bitmap.Width, bitmap.Height);
                    bitmap.Dispose();
                }
            }
            catch (Exception e)
            {
                throw new TextureLoadError(fileName);
            }
        }

        #region IResource Members

        public void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            this.device = graphicsDeviceManager.Direct3D9.Device;
        }

        public void LoadContent()
        {
            if (this.scaledBitmap != null)
            {
                if (this.texture != null) this.texture.Dispose();

                using (MemoryStream ms = new MemoryStream())
                {
                    scaledBitmap.Save(ms, ImageFormat.Bmp);
                    byte[] bitmapData = ms.ToArray();
                    this.texture = Texture.FromMemory(device, bitmapData);
                }
            }
        }

        public void UnloadContent()
        {
        }

        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            scaledBitmap.Dispose();
        }

        #endregion

        private static int ClosestPower2(int x)
        {
            double temp = Math.Ceiling(Math.Log(x) / Math.Log(2));
            return (int)Math.Pow(2, temp);
        }
    }
}
