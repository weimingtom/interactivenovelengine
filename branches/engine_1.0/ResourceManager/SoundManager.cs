
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
            SetVolume(_volume);
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
                SetVolume(_volume);
            }
        }

        private void SetVolume(float vol)
        {
            if (this.loaded) SoundPlayer.SetVolume(this.FileName, vol);
        }

        private void FadeOutStep()
        {
            float currentTick = Clock.GetTime();
            
            float progress = (currentTick - fadeStartTick) / fadeDuration + 0.1f;

            Volume = oldVolume * (1.0f - (float)Math.Log10(progress * 10f));

            if (currentTick >= (fadeStartTick + fadeDuration)) fadeOutEvent.kill = true;
        }

        private void FadeOutOver()
        {
            this.Stop();
            this.Volume = oldVolume;
        }

        TimeEvent fadeOutEvent;

        public void Fadeout(int delay)
        {
            int steps = delay/5;
            
            fadeStartTick = Clock.GetTime();
            fadeDuration = (float)delay;
            oldVolume = Volume;

            fadeOutEvent = new TimeEvent(steps, 5, FadeOutStep, FadeOutOver);
            Clock.AddTimeEvent(fadeOutEvent);
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
            Supervisor.Info("disposing:" + this.Name + "(" + this.ToString()  + ")");
            SoundPlayer.StopSound(FileName);
            SoundPlayer.CloseSound(FileName);
            base.Dispose();
        }

        #endregion
    }

    public class SoundManager : IResource // sound manager is a graphical resource itself
    {
        protected ResourceCollection resources = new ResourceCollection();
        protected Dictionary<string, AbstractResource> resourcesMap = new Dictionary<string, AbstractResource>();


        #region IResource Members for managing resources

        public void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            Supervisor.Info("initializing sound manager!");
            resources.Initialize(graphicsDeviceManager);
        }

        public void LoadContent()
        {
            resources.LoadContent();
        }

        public void UnloadContent()
        {
            resources.UnloadContent();
        }

        #endregion


        #region IDisposable Members

        public void Dispose()
        {
            Supervisor.Info("disposing sound manager!");
            resources.Dispose();
        }

        #endregion

        #region resource management

        public void LoadSound(string alias, string path)
        {
            if (resourcesMap.ContainsKey(alias)) return;
            INESound newSound = new INESound(path);
            newSound.Name = alias;
            AddSound(newSound);
        }

        public void AddSound(INESound sound)
        {
            if (resourcesMap.ContainsKey(sound.Name)) return;

            resources.Add(sound);
            resourcesMap[sound.Name] = sound;
        }


        public INESound GetSound(string id)
        {
            if (resourcesMap.ContainsKey(id))
            {
                return (INESound)resourcesMap[id];
            }
            else
            {
                return null;
            }
        }

        public void Stop()
        {
            foreach (INESound sound in this.resources)
            {
                sound.Stop();
            }
        }
        
        public void RemoveResource(string id)
        {
            if (resourcesMap.ContainsKey(id))
            {
                INESound sound = (INESound)resourcesMap[id];
                resources.Remove(sound);
                resourcesMap.Remove(id);
                sound.Dispose();
            }
        }

        #endregion
    }
}