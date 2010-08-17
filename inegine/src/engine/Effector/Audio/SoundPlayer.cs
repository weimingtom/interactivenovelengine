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

        public static void SetVolume(int newVolumePercentage)
        {
            Console.WriteLine("setting overall volume to " + newVolumePercentage);
            // Set the same volume for both the left and the right channels
            uint NewVolumeAllChannels = ((uint)(0x0000ffff * newVolumePercentage / 100f))
                                        + ((uint)(0xffff0000 * (100 - newVolumePercentage) / 100f));
            // Set the volume
            waveOutSetVolume(IntPtr.Zero, NewVolumeAllChannels);
        }
        
        // works only for mp3...
        public static void SetVolume(string file, int newVolumePercentage)
        {
            string volumeString = (newVolumePercentage*10).ToString();
            string commandString = "setaudio  \"" + file + "\" volume to " + volumeString;
            Console.WriteLine(commandString);
            mciSendString(commandString, null, 0, IntPtr.Zero);
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

            string commandString = "play \"" + file + "\"";
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
