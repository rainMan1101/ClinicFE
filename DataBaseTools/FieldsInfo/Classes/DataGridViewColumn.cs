namespace DataBaseTools.FieldsInfo.Classes
{
    /*          Информация о привязке и параметров одной колонки DataGridView       */
    internal class DataGridViewColumn : IAPIName
    {
        public DataGridViewColumn(
            string apiName, int serialNumber, string dataPropertyName, string headerText, 
            bool visible, int width, bool readOnly, int columnType)
        {
            APIName = apiName;
            SerialNumber = serialNumber;
            DataPropertyName = dataPropertyName;
            HeaderText = headerText;
            Visible = visible;
            Width = width;
            ReadOnly = readOnly;
            ColumnType = columnType;
        }


        //private set?
        public string APIName { get; }
        public int SerialNumber { get; }
        public string DataPropertyName { get; }
        public string HeaderText { get;  }
        public bool Visible { get;  }
        public int Width { get; }
        public bool ReadOnly { get; }
        public int ColumnType { get; }
    }
}
