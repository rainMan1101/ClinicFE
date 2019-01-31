using NpgsqlTypes;


namespace DataBaseTools.FieldsInfo.Classes
{
    /*              Информация о типе входного параметра(колонки) для вызова необдимой ХП(API)       */
    internal class FieldType : IAPIName
    {
        public FieldType(string apiName, int serialNumber, NpgsqlDbType typeColumn)
        {
            APIName = apiName;
            SerialNumber = serialNumber;
            TypeColumn = typeColumn;
        }

        public string APIName { get; }
        public int SerialNumber { get; }
        public NpgsqlDbType TypeColumn { get; }
    }
}
