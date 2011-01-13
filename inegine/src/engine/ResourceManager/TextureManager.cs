using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Text;
using INovelEngine.Core;
using INovelEngine.Effector;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;

namespace INovelEngine.ResourceManager
{
    public class INETexture : AbstractResource
    {
        public Texture Texture;
        public int Width;
        public int Height;
        public int Rows;
        public int Cols;

        private Device device;

        private Bitmap scaledBitmap;
        private string fileName;

        public INETexture (string fileName)
        {
            this.Type = INovelEngine.Effector.ResourceType.Graphical;
            this.TextureFile = fileName;
            this.Name = fileName;
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
                Bitmap bitmap;
                if (ArchiveManager.IsURI(fileName))
                {
                    bitmap = new Bitmap(ArchiveManager.GetStream(fileName));
                }
                else
                {
                    bitmap = new Bitmap(fileName);
                }

                this.Width = bitmap.Width;
                this.Height = bitmap.Height;

                if (fileName.EndsWith(".gif")) // for gif animations
                {
                    scaledBitmap = ConvertGifToImage(bitmap);
                }
                else
                {
                    Rows = -1;
                    Cols = -1;

                    int newWidth = ClosestPower2(bitmap.Width);
                    int newHeight = ClosestPower2(bitmap.Height);
                    if (!(bitmap.Width == newWidth && bitmap.Height == newHeight))
                    {
                        scaledBitmap = new Bitmap(newWidth, newHeight);

                        using (Graphics g = Graphics.FromImage((Image) scaledBitmap))
                            g.DrawImage(bitmap, 0, 0, bitmap.Width, bitmap.Height);
                        bitmap.Dispose();
                    }
                    else
                    {
                        scaledBitmap = bitmap;
                    }
                }
            }
            catch (Exception)
            {
                throw new TextureLoadError(fileName);
            }
        }

        private Bitmap ConvertGifToImage(Bitmap bitmap)
        {
            FrameDimension dimension = new FrameDimension(bitmap.FrameDimensionsList[0]);
            int frameCount = bitmap.GetFrameCount(dimension);
            this.Rows = frameCount;
            this.Cols = 1;

            Bitmap scaledBitmap = new Bitmap(ClosestPower2(bitmap.Width), ClosestPower2(bitmap.Height * frameCount));

            using (Graphics g = Graphics.FromImage((Image)scaledBitmap))
            {
                for (int i=0; i < frameCount; i++)
                {
                    bitmap.SelectActiveFrame(dimension, i);
                    g.DrawImage(bitmap, 0, i * bitmap.Height, bitmap.Width, bitmap.Height);
                }
            }
            bitmap.Dispose();

            return scaledBitmap;
        }


        #region IResource Members

        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            base.Initialize(graphicsDeviceManager);
            this.device = graphicsDeviceManager.Direct3D9.Device;
        }

        public override void LoadContent()
        {
            if (this.scaledBitmap == null) LoadTextureFile(fileName);

            //Console.WriteLine("loading : " + this.fileName);

            //this.Texture = Texture.FromFile(device, this.fileName);
            if (this.scaledBitmap != null)
            {
                if (this.Texture != null) this.Texture.Dispose();


                using (MemoryStream ms = new MemoryStream())
                {
                    scaledBitmap.Save(ms, ImageFormat.Png);
                    byte[] bitmapData = ms.ToArray();
                    this.Texture = Texture.FromMemory(device, bitmapData);
                    Console.WriteLine("...loaded " + this.fileName);
                }
                
                scaledBitmap.Dispose();
                scaledBitmap = null;
            }



            base.LoadContent();
        }

        public override void UnloadContent()
        {
            base.UnloadContent();
        }

        #endregion

        #region IDisposable Members

        public override void Dispose()
        {
            Console.WriteLine("disposing texture " + this.Name);
            Texture.Dispose();
        }

        #endregion

        private static int ClosestPower2(int x)
        {
            double temp = Math.Ceiling(Math.Log(x) / Math.Log(2));
            return (int)Math.Pow(2, temp);
        }
    }
}