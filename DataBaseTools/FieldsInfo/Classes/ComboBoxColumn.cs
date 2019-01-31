namespace DataBaseTools.FieldsInfo.Classes
{
    /*          Информация о привязке одной колонки ComboBox       */
    internal class ComboBoxColumn : IAPIName
    {
        public ComboBoxColumn(string apiName, int serialNumber, string columnName)
        {
            APIName = apiName;
            SerialNumber = serialNumber;
            ColumnName = columnName;
        }

        public string APIName { get; }
        public int SerialNumber { get; } // 2 Для 1 APIName
        public string ColumnName { get; }
    }
}
