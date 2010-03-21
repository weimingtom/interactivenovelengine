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
        private static extern long mciSendString(string strCommand, StringBuilder strReturn, int iReturnLength, IntPtr hwndCallback);

        [DllImport("winmm.dll")]
        private static extern int waveOutGetVolume(IntPtr hwo, out uint dwVolume);
        [DllImport("winmm.dll")]
        private static extern int waveOutSetVolume(IntPtr hwo, uint dwVolume);

        public static void Play(string strFileName, string name)
        {
            //mciSendString("setaudio " + name + " volume to 50", null, 0, IntPtr.Zero);
            mciSendString("play " + name + " repeat", null, 0, IntPtr.Zero);
        }

        public static void SetVolume(int newVolumePercentage)
        {
            // Set the same volume for both the left and the right channels
            uint NewVolumeAllChannels = ((uint)(0x0000ffff * newVolumePercentage / 100f));
            // Set the volume
            waveOutSetVolume(IntPtr.Zero, NewVolumeAllChannels);
        }

        public static void Init()
        { 
        }

        public static void LoadSound(string file)
        {
            mciSendString("open \"" + file + "\" alias " + file, null, 0, IntPtr.Zero);
        }


        public static void CloseSound(string file)
        {
            mciSendString("close \"" + file + "\"", null, 0, IntPtr.Zero);
        }

        public static void PlaySound(string file, Boolean loop)
        {
            string commandString = "play " + file + " from 0";
            if (loop) commandString = commandString + " repeat";
            mciSendString(commandString, null, 0, IntPtr.Zero);
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
