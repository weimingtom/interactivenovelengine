using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using NAudio.Wave;

namespace INovelEngine.Effector.Audio
{
    /* todo: reimplement using MCI! */

    public enum PlayingStatus
    {
        Playing,
        Paused,
        Stopped
    };

    /// <summary>
    /// Stream for looping playback
    /// </summary>
    public class LoopStream : WaveStream
    {

        public PlayingStatus status = PlayingStatus.Stopped;

        public WaveChannel32 sourceStream;

        private WaveStream mp3Reader;
        private WaveStream pcmStream;
        private WaveStream blockAlignedStream;


        public LoopStream(string fileName)
        {
            WaveChannel32 inputStream;
            if (fileName.EndsWith(".wav"))
            {
                WaveStream readerStream = new WaveFileReader(fileName);
                if (readerStream.WaveFormat.Encoding != WaveFormatEncoding.Pcm)
                {
                    readerStream = WaveFormatConversionStream.CreatePcmStream(readerStream);
                    readerStream = new BlockAlignReductionStream(readerStream);
                }
                if (readerStream.WaveFormat.BitsPerSample != 16)
                {
                    var format = new WaveFormat(readerStream.WaveFormat.SampleRate,
                       16, readerStream.WaveFormat.Channels);
                    readerStream = new WaveFormatConversionStream(format, readerStream);
                }
                inputStream = new WaveChannel32(readerStream);
            }
            else if(fileName.EndsWith(".mp3"))
            {
                mp3Reader = new Mp3FileReader(fileName);
                pcmStream = WaveFormatConversionStream.CreatePcmStream(mp3Reader);
                blockAlignedStream = new BlockAlignReductionStream(pcmStream);
                inputStream = new WaveChannel32(blockAlignedStream);
            }
            else
            {
                throw new InvalidOperationException("Unsupported extension");
            }
            this.sourceStream = inputStream;
        
        }

        /// <summary>
        /// Use this to turn looping on or off
        /// </summary>
        public bool EnableLooping { get; set; }

        /// <summary>
        /// Return source stream's wave format
        /// </summary>
        public override WaveFormat WaveFormat
        {
            get { return sourceStream.WaveFormat; }
        }

        /// <summary>
        /// LoopStream simply returns
        /// </summary>
        public override long Length
        {
            get { return sourceStream.Length; }
        }

        /// <summary>
        /// LoopStream simply passes on positioning to source stream
        /// </summary>
        public override long Position
        {
            get { return sourceStream.Position; }
            set { sourceStream.Position = value; }
        }

        public override int Read(byte[] buffer, int offset, int count)
        {
            int totalBytesRead = 0;

            while (totalBytesRead < count)
            {
                int bytesRead = sourceStream.Read(buffer, offset + totalBytesRead, count - totalBytesRead);
                if (bytesRead == 0)
                {
                    if (!EnableLooping)
                    {
                        // something wrong with the source stream
                        break;
                    }
                    // loop
                    sourceStream.Position = 0;
                    break;
                }
                totalBytesRead += bytesRead;
            }

            if (EnableLooping && this.Position + totalBytesRead >= this.Length) this.Position = 0;

            return totalBytesRead;
        }

        protected override void Dispose(bool disposing)
        {
            if (blockAlignedStream != null) blockAlignedStream.Dispose();
            base.Dispose(disposing);
        }
    }


    public class Sound : IDisposable
    {
        private WaveMixerStream32 mixer;
        private LoopStream sample;

        public Sound(WaveMixerStream32 mixer, string file)
        {
            this.mixer = mixer;
            this.sample = new LoopStream(file);
            mixer.AddInputStream(sample);
            Stop();

        }

        public void Play(Boolean loop)
        {
            sample.status = PlayingStatus.Playing;
            sample.EnableLooping = loop;
            sample.Position = 0;
        }

        public void Stop()
        {
            sample.status = PlayingStatus.Stopped;
            sample.EnableLooping = false;
            sample.Position = sample.Length;
        }

        public float Volume
        {
            get
            {
                return sample.sourceStream.Volume;
            }
            set
            {
                sample.sourceStream.Volume = value;
            }
        }

        private WaveStream CreateInputStream(string fileName)
        {
            WaveChannel32 inputStream;
            if (fileName.EndsWith(".wav"))
            {
                WaveStream readerStream = new WaveFileReader(fileName);
                if (readerStream.WaveFormat.Encoding != WaveFormatEncoding.Pcm)
                {
                    readerStream = WaveFormatConversionStream.CreatePcmStream(readerStream);
                    readerStream = new BlockAlignReductionStream(readerStream);
                }
                if (readerStream.WaveFormat.BitsPerSample != 16)
                {
                    var format = new WaveFormat(readerStream.WaveFormat.SampleRate,
                       16, readerStream.WaveFormat.Channels);
                    readerStream = new WaveFormatConversionStream(format, readerStream);
                }
                inputStream = new WaveChannel32(readerStream);
            }
            else if(fileName.EndsWith(".mp3"))
            {
                WaveStream mp3Reader = new Mp3FileReader(fileName);
                WaveStream pcmStream = WaveFormatConversionStream.CreatePcmStream(mp3Reader);
                WaveStream blockAlignedStream = new BlockAlignReductionStream(pcmStream);
                inputStream = new WaveChannel32(blockAlignedStream);
                blockAlignedStream.Dispose();
                pcmStream.Dispose();
                mp3Reader.Dispose();
            } 
            else
            {
                throw new InvalidOperationException("Unsupported extension");
            }
            return inputStream;
        }


        #region IDisposable Members

        public void Dispose()
        {
            mixer.RemoveInputStream(sample);
            sample.Close();
            sample.Dispose();
        }

        #endregion
    }

    class SoundPlayer
    {

        #region MCI based test code

        [DllImport("winmm.dll")]
        private static extern long mciSendString(string strCommand, StringBuilder strReturn, int iReturnLength, IntPtr hwndCallback);

        [DllImport("winmm.dll")]
        public static extern int waveOutGetVolume(IntPtr hwo, out uint dwVolume);
        [DllImport("winmm.dll")]
        public static extern int waveOutSetVolume(IntPtr hwo, uint dwVolume);

        System.Media.SoundPlayer myPlayer = new System.Media.SoundPlayer();

        public void Play(string strFileName, string name)
        {
            mciSendString("open \"" + strFileName + "\" type mpegvideo alias " + name, null, 0, IntPtr.Zero);
            //mciSendString("setaudio " + name + " volume to 50", null, 0, IntPtr.Zero);
            mciSendString("play " + name + " repeat", null, 0, IntPtr.Zero);
        }

        public void PlayWav(string fileName)
        {
            myPlayer.SoundLocation = fileName;
            myPlayer.Play();
        }

        public void SetVolume(int newVolumePercentage)
        {
            // Set the same volume for both the left and the right channels
            uint NewVolumeAllChannels = ((uint)(0x0000ffff * newVolumePercentage / 100f));
            // Set the volume
            waveOutSetVolume(IntPtr.Zero, NewVolumeAllChannels);
        }
        #endregion



        private static IWavePlayer waveOutDevice;
        private static WaveMixerStream32 mixer;

        public static void Init()
        {
            waveOutDevice = new DirectSoundOut();
            mixer = new WaveMixerStream32();
            mixer.AutoStop = false;
            waveOutDevice.Init(mixer);
            waveOutDevice.Play();    
        }

        public static Sound LoadSound(string file)
        {
            return new Sound(mixer, file);
        }

        public static void PlaySound(Sound sound, Boolean loop)
        {
            sound.Play(loop);
            waveOutDevice.Play();
        }


        public static void StopSound(Sound sound)
        {
            sound.Stop();  
        }

        public static void Dispose()
        {
            waveOutDevice.Stop();
            mixer.Dispose();
            waveOutDevice.Dispose();
        }

 

    }

}
