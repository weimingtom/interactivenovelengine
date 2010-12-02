using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using LuaInterface;

namespace INovelEngine.Core
{
    public class Clock
    {
        static private List<TimeEvent> timeEventList = new List<TimeEvent>();
        static private int startUpTime = GetTime();
        static private int timeBetweenFrames;
        static private int timeOfLastTick = GetTime();
        static private int frameRate = 0;
        static private int totalEvents = 0;

        static public int GetTime()
        {
            return System.Environment.TickCount;
        }

        static public int AddTimeEvent(TimeEvent timeEvent)   
        {
            timeEvent.timeID = totalEvents++;
            timeEventList.Add(timeEvent);
            timeEventList.Sort();
            return timeEvent.timeID;
        }

        static public void RemoveTimeEvent(TimeEvent timeEvent)
        {
            timeEventList.Remove(timeEvent);
            timeEventList.Sort();
        }

        static private void ExecuteEvents()
        {
            foreach (TimeEvent t in timeEventList)
            {
                if (t.timeLeft < (GetTime() - t.birthTime))
                {
                    t.call();

                    if (!t.immortal)
                    {
                        t.iterationsLeft--;

                        if (t.iterationsLeft == 0) t.kill = true;
                    }

                    t.birthTime = GetTime();

                }
                else
                {
                    return;
                }
            }
        }

        static public void Tick()
        {
            ExecuteEvents();
            PurgeList();
            MeasureProgramSpeed();
        }

        static public int GetFPS()
        {
            int fps = frameRate;
            frameRate = 0;
            return fps;
        }

        static private void PurgeList()
        {
            int currentListSize = timeEventList.Count;
            TimeEvent t;
            for (int i = 0; i < currentListSize; i++)
            {
                t = timeEventList[i];
                if (t.kill)
                {
                    if (t.EndCall != null) t.EndCall();
                    timeEventList.Remove(t);
                    currentListSize--;
                }
            }
        }

        static private void MeasureProgramSpeed()
        {
            frameRate++;
            timeBetweenFrames = GetTime() - timeOfLastTick;
            timeOfLastTick = GetTime();
        }

    }

    public class TimeEvent : IComparable
    {
        public int timeID;
        public int timeLeft;
        public int birthTime;

        public bool kill = false;
        public bool immortal = false;
        public int iterationsLeft;

        public delegate void Call();
        public Call call;
        public Call EndCall;

        public TimeEvent(int iterationNumber, int delay, Call c, Call e)
        {
            this.EndCall = new Call(e);
            this.call = new Call(c);
            this.birthTime = Clock.GetTime();
            this.iterationsLeft = iterationNumber;
            this.timeLeft = delay;
        }

        public TimeEvent(int iterationNumber, int delay, Call c)
        {
            this.call = new Call(c);
            this.birthTime = Clock.GetTime();
            this.iterationsLeft = iterationNumber;
            this.timeLeft = delay;
        }

        public TimeEvent(int delayToCall, Call c)
        {
            this.call = new Call(c);
            this.birthTime = Clock.GetTime();
            this.timeLeft = delayToCall;
            this.immortal = true;
        }

        public int CompareTo(Object rhs)
        {
            TimeEvent t = (TimeEvent)rhs;
            return this.timeLeft.CompareTo(t.timeLeft);
        }

    }
}
