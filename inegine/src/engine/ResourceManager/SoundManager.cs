
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Text;
using INovelEngine.Core;
using INovelEngine.Effector;
using INovelEngine.Effector.Audio;
using INovelEngine.Effector.Graphics.Text;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;

namespace INovelEngine.ResourceManager
{
    public class INESound : AbstractResource
    {
        public string FileName
        { 
            get; set;
        }

        public bool Loop
        {
            get; set;
        }

        public INESound ()
        {       
        }

        public INESound(string fileName)
        {
            this.FileName = fileName;
            this.Name = fileName;
        }

        public void Play()
        {
            SoundPlayer.PlaySound(this.FileName, Loop);
        }

        public void Stop()
        {
            SoundPlayer.StopSound(this.FileName);
        }

        private float _volume;
        public float Volume
        {
            get
            {
                return _volume;
            }
            set
            {
                _volume = value;
                SoundPlayer.SetVolume((int)(_volume * 100));
            }
        }

        #region IResource Members

        public override void LoadContent()
        {
            SoundPlayer.LoadSound(FileName);
            base.LoadContent();
        }

        public override void UnloadContent()
        {
            SoundPlayer.CloseSound(FileName);
            base.UnloadContent();
        }

        #endregion

        #region IDisposable Members

        public override void Dispose()
        {
        }

        #endregion
    }
}