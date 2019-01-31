namespace DataBaseTools.FieldsInfo.Classes
{
    /*                  Информация о привязке колонки, которую необходимо обновить          */
    internal class InputUPDColumn : IAPIName
    {
        public InputUPDColumn(string apiName, int serialNumber, string columnName)
        {
            APIName = apiName;
            SerialNumber = serialNumber;
            ColumnName = columnName;
        }

        public string APIName { get; }
        public int SerialNumber { get; }
        public string ColumnName { get; }
    }
}
