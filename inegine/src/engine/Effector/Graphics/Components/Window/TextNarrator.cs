using System;
using System.Collections.Generic;
using System.Text;

namespace INovelEngine.Effector
{
    public enum NarrationState
    {
        Stopped, Going, Over
    }

    public class TextNarrator
    {
        private StringBuilder outputStringBuffer;
        private String inputString;
        private int index;
        private NarrationState state;

        public TextNarrator()
        {
            outputStringBuffer = new StringBuilder();
            inputString = "";
            index = 0;
            state = NarrationState.Going;
        }

        public void AppendText(String text)
        {
            this.inputString += text;
            if (state != NarrationState.Stopped)
            {
                state = NarrationState.Going;
            }
        }

        public void Clear()
        {
            outputStringBuffer = new StringBuilder();
            inputString = "";
            index = 0;
            state = NarrationState.Going;
        }

        public void Advance()
        {
            if (state == NarrationState.Stopped)
            {
                state = NarrationState.Going;
            }
            else if (state == NarrationState.Going)
            {
                if (index > inputString.Length - 1)
                {
                    state = NarrationState.Over;
                    return;
                }
          
                // move index to next break (@) or end of string
                while (index <= inputString.Length - 1 && inputString[index] != '@')
                {
                    outputStringBuffer.Append(inputString[index]);
                    index++;
                }
                // if it stops at end of string, set state to over
                if (index > inputString.Length - 1)
                {
                    state = NarrationState.Over;
                }
                // if it stops at a break, set state to stopped
                else if (inputString[index] == '@')
                {
                    state = NarrationState.Stopped;
                    index++;
                }
            }
        }

        public String OutputString
        {
            get
            {
                return outputStringBuffer.ToString();
            }
        }

        public String SourceString
        {
            get
            {
                return inputString.Replace("@", "");
            }
        }

        public void Tick()
        {
            if (state == NarrationState.Going)
            {
                if (index > inputString.Length - 1)
                {
                    state = NarrationState.Over;
                    return;
                }

                // if current char is not @, add it to output buffer, advance index, and break
                char currentChar = inputString[index];
                if (currentChar != '@')
                {
                    outputStringBuffer.Append(currentChar);
                    index++;
                }
                else
                {
                    // if current char is @, advance index one more time and loop
                    state = NarrationState.Stopped;
                    index++;
                }
            }
        }

        public NarrationState State
        {
            get
            {
                return state;
            }
        }
    }
}
