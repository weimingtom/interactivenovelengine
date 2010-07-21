﻿
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Text;
using INovelEngine.Core;
using INovelEngine.Effector;
using INovelEngine.Effector.Graphics.Text;
using SampleFramework;
using SlimDX;
using SlimDX.Direct3D9;

namespace INovelEngine.ResourceManager
{
    public class INEFont : AbstractResource
    {
        private GraphicsDeviceManager manager;

        public FreeFont Font;

        private bool _rubyOn = false;

        public bool RubyOn
        {
            get
            {
                return _rubyOn;    
            }
            set
            {
                _rubyOn = value;    
            }
        }

        public int Size
        {
            get; set;
        }

        public int RubySize
        {
            get; set;
        }

        private int _lineSpacing;
        public int LineSpacing
        {
            get
            {
                return Font.LineSpacing;
            }
            set
            {
                _lineSpacing = value;
                if (this.loaded) Font.LineSpacing = value;
            }
        }

        private FreeFont.TextEffect _textEffect;

        public int TextEffect
        {
            get
            {
                return (int) _textEffect;
            }
            set
            {
                _textEffect = (FreeFont.TextEffect)value;
                if (this.loaded) Font.Effect = (FreeFont.TextEffect)value;
            }
        }

        public INEFont(string fileName)
        {
            this.Type = INovelEngine.Effector.ResourceType.Graphical;
            this.FontFile = fileName;
            this.Name = fileName;
        }

        public string FontFile
        {
            get; set;
        }

        public string RubyFontFile
        {
            get; set;
        }

        #region IResource Members

        public override void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            base.Initialize(graphicsDeviceManager);
            this.manager = graphicsDeviceManager;
        }

        public override void LoadContent()
        {
            base.LoadContent();

            if (_rubyOn)
            {
                Font = new RubyFont(manager, FontFile, Size, this.RubyFontFile, RubySize);
            }
            else
            {
                Font = new FreeFont(manager, FontFile, Size);
            }

            Font.LineSpacing = _lineSpacing;
            Font.Effect = _textEffect;
        }

        public override void UnloadContent()
        {
            base.UnloadContent();
        }

        #endregion

        #region IDisposable Members

        public override void Dispose()
        {
            Font.Dispose();
        }

        #endregion
    }
}