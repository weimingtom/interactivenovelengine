using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using NAudio.Wave;

namespace INovelEngine.Effector.Audio
{
    class SoundPlayer
    {
        [DllImport("winmm.dll")]
        private static extern int mciSendString(string strCommand, StringBuilder strReturn, int iReturnLength, IntPtr hwndCallback);
        [DllImport("winmm.dll")]
        private static extern bool mciGetErrorString(int fdwError, StringBuilder lpszErrorText, long cchErrorText);

        [DllImport("winmm.dll")]
        private static extern int waveOutGetVolume(IntPtr hwo, out uint dwVolume);
        [DllImport("winmm.dll")]
        private static extern int waveOutSetVolume(IntPtr hwo, uint dwVolume);

        public static void SetVolume(int newVolumePercentage)
        {
            Supervisor.Info("setting overall volume to " + newVolumePercentage);
            // Set the same volume for both the left and the right channels
            uint NewVolumeAllChannels = ((uint)(0x0000ffff * newVolumePercentage / 100f))
                                        + ((uint)(0xffff0000 * (100 - newVolumePercentage) / 100f));
            // Set the volume
            waveOutSetVolume(IntPtr.Zero, NewVolumeAllChannels);
        }
        
        // works only for mp3...
        public static void SetVolume(string file, float newVolumePercentage)
        {
            string volumeString = ((int)Math.Min(100, Math.Max(0, newVolumePercentage)) * 10).ToString();
            string commandString = "setaudio  \"" + file + "\" volume to " + volumeString;
            mciSendString(commandString, null, 0, IntPtr.Zero);
        }

        public static void LoadSound(string file)
        {
            Supervisor.Info("loading " + file);
            mciSendString("open \"" + file + "\" alias " + file, null, 0, IntPtr.Zero);
        }


        public static void CloseSound(string file)
        {
            mciSendString("close \"" + file + "\"", null, 0, IntPtr.Zero);
        }

        public static void PlaySound(string file, bool loop)
        {
            StopSound(file);
            string commandString = "play \"" + file + "\" from 0";
            int mcierror = mciSendString(commandString, null, 0, IntPtr.Zero);
            if (mcierror != 0)
            {
                Supervisor.Error("playing sound " + file + " failed!");
                throw new Exception("playing sound failed!");
            }
        }


        public static void StopSound(string file)
        {
            mciSendString("stop \"" + file + "\"", null, 0, IntPtr.Zero);
        }

        public static void Dispose()
        {
            mciSendString("close all", null, 0, IntPtr.Zero);
            mciSendString("clear all", null, 0, IntPtr.Zero);
        }

 

    }

}
