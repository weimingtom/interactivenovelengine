
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
        public Sound Sound
        {
            get; set;
        }

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
            SoundPlayer.PlaySound(this.Sound, Loop);
        }

        public void Stop()
        {
            SoundPlayer.StopSound(this.Sound);
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
                if (this.loaded) Sound.Volume = _volume;
            }
        }

        #region IResource Members

        public override void LoadContent()
        {
            if (Sound != null) return;
            Sound = SoundPlayer.LoadSound(FileName);
            Sound.Volume = _volume;
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
            Console.WriteLine("disposing " + this.Name);
            Sound.Dispose();
        }

        #endregion
    }
}