
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
using Com.StellmanGreene.CSVReader;

namespace INovelEngine.ResourceManager
{
    public class INECsv : AbstractResource 
    {
        public CSVReader csvReader;
        public List<String> columns;
        private List<Object> row;
        private List<List<Object>> rows;

        public INECsv()
        {
            this.Type = INovelEngine.Effector.ResourceType.General;
            columns = new List<string>();
            rows = new List<List<object>>();
        }

        public INECsv(string fileName)
        {
            this.Type = INovelEngine.Effector.ResourceType.General;
            this.FileName = fileName;
            this.Name = fileName;
            columns = new List<string>();
            rows = new List<List<object>>();
            this.Encoding = "UTF-8";
        }

        public string FileName
        {
            get;
            set;
        }

        public string Encoding
        {
            get; set;
        }

        public void readColumns()
        {
            if (next())
            {
                foreach (Object col in row)
                {
                    this.columns.Add(col.ToString());
                }
                this.row = null;
            }
        }

        public void readToEnd()
        {
            while (next())
            {
                rows.Add(this.row);
            }
        }

        private bool next()
        {
            row = this.csvReader.ReadRow();
            return (row != null);
        }

        public int Count
        {
            get
            {
                return this.rows.Count;
            }
            set
            {
            }
        }

        public int ColumnCount
        {
            get
            {
                return this.columns.Count;
            }
            set
            {
            }
        }

        public String GetColumn(int i)
        {
            return this.columns[i].Trim();
        }

        public String GetString(int row, int col)
        {
            Object obj = this.rows[row][col];
            return obj.ToString();
        }

        public int GetInt(int row, int col)
        {
            Object obj = this.rows[row][col];
            if (obj.GetType().ToString().Equals("System.Byte"))
            {
                return (int)((Byte)obj);
            }
            else
            {
                return 0;
            }
        }

        public float GetFloat(int row, int col)
        {
            Object obj = this.rows[row][col];
            if (obj.GetType().ToString().Equals("System.Single"))
            {
                return (float)obj;
            }
            else if (obj.GetType().ToString().Equals("System.Byte"))
            {
                return (float)(Byte)obj;
            }
            else
            {
                return float.NaN;
            }
        }

        public Boolean GetBoolean(int row, int col)
        {
            Object obj = this.rows[row][col];
            String condition = obj.ToString().ToLower();
            if (condition.Equals("true") || condition.Equals("yes")
                || condition.Equals("y") || condition.Equals("o")
                || condition.Equals("1"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        #region IResource Members

        public override void LoadContent()
        {
            base.LoadContent();
            StreamReader streamReader = new StreamReader(this.FileName, System.Text.Encoding.GetEncoding(this.Encoding));
            String fileContent = streamReader.ReadToEnd();
            streamReader.Close();
            csvReader = new CSVReader(fileContent);
            this.readColumns();
            this.readToEnd();
        }

        public override void UnloadContent()
        {
            base.UnloadContent();
        }

        #endregion

        #region IDisposable Members

        public override void Dispose()
        {
            base.Dispose();
        }

        #endregion
    }



    public class CsvManager : IResource // font manager is a graphical resource itself
    {
        protected ResourceCollection graphicalResources = new ResourceCollection();
        protected Dictionary<String, AbstractResource> graphicalResourcesMap = new Dictionary<string, AbstractResource>();


        #region IResource Members for managing graphical resources

        public void Initialize(GraphicsDeviceManager graphicsDeviceManager)
        {
            Console.WriteLine("initializing csv manager!");
            graphicalResources.Initialize(graphicsDeviceManager);
        }

        public void LoadContent()
        {
            graphicalResources.LoadContent();
        }

        public void UnloadContent()
        {
            graphicalResources.UnloadContent();
        }

        #endregion


        #region IDisposable Members

        public void Dispose()
        {
            Console.WriteLine("disposing csv manager!");
            graphicalResources.Dispose();
        }

        #endregion

        #region resource management

        public void LoadCsv(string alias, string path, string encoding)
        {
            if (graphicalResourcesMap.ContainsKey(alias)) return;
            INECsv newCsv = new INECsv(path);
            newCsv.Name = alias;
            newCsv.Encoding = encoding;
            AddCsv(newCsv);
        }

        public void AddCsv(INECsv font)
        {
            if (graphicalResourcesMap.ContainsKey(font.Name)) return;

            graphicalResources.Add(font);
            graphicalResourcesMap[font.Name] = font;
        }


        public INECsv GetCsv(string id)
        {

            if (graphicalResourcesMap.ContainsKey(id))
            {
                return (INECsv)graphicalResourcesMap[id];
            }
            else
            {
                throw new Exception("id not found!");
            }
        }

        public void RemoveCsv(string id)
        {
            if (graphicalResourcesMap.ContainsKey(id))
            {
                INECsv font = (INECsv)graphicalResourcesMap[id];
                graphicalResources.Remove(font);
                graphicalResourcesMap.Remove(id);
                font.Dispose();
            }
        }

        #endregion



    }
}