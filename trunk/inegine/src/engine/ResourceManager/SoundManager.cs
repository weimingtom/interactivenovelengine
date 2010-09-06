
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
        private float fadeStartTick;
        private float fadeDuration;
        private float oldVolume;

        public string FileName
        { 
            get; set;
        }

        public bool Loop
        {
            get; set;
        }


        public INESound()
        {
            this.Type = INovelEngine.Effector.ResourceType.General;
        }

        public INESound(string fileName)
        {
            this.Type = INovelEngine.Effector.ResourceType.General;
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
                Console.WriteLine("setting volume to " + value);
                _volume = value;
                if (this.loaded) SoundPlayer.SetVolume(this.FileName, _volume);

            }
        }

        private void FadeOutStep()
        {
            float currentTick = Clock.GetTime();
            //Console.WriteLine("elapsed:" + (currentTick - fadeStartTick).ToString() + " / " + fadeDuration);
            
            float progress = (currentTick - fadeStartTick) / fadeDuration + 0.1f;

            Console.WriteLine("progress:" + progress);
            Volume = oldVolume * (1.0f - (float)Math.Log10(progress * 10f));
            //Volume = oldVolume * (1.1f - progress);

            if (currentTick >= (fadeStartTick + fadeDuration)) fadeOutEvent.kill = true;
        }

        private void FadeOutOver()
        {
            this.Stop();
        }

        TimeEvent fadeOutEvent;

        public void Fadeout(int delay)
        {
            int steps = delay/5;
            float stepDuration = 5;
            
            fadeStartTick = Clock.GetTime();
            fadeDuration = (float)delay;
            oldVolume = Volume;

            fadeOutEvent = new TimeEvent(steps, stepDuration, FadeOutStep, FadeOutOver);
            Clock.AddTimeEvent(fadeOutEvent);
        }

        public void Fadein(int delay)
        {
        }

        #region IResource Members

        public override void LoadContent()
        {
            SoundPlayer.LoadSound(FileName);
            SoundPlayer.SetVolume(this.FileName, _volume);
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