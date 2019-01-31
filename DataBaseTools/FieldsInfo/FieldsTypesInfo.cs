using NpgsqlTypes;
using DataBaseTools.FieldsInfo.Classes;


namespace DataBaseTools.FieldsInfo
{
    /*                  Информация о типах колонок(необходима для запросов)             */
    //  Композиция
    internal class FieldsTypesInfo
    {
        private ColumnsInfo<FieldType> columnsInfo;

        public FieldsTypesInfo()
        {
            columnsInfo = ColumnsInfo<FieldType>.GetInstance(
            @"SELECT name, numb, type_field
              FROM clinic.sys_names JOIN clinic.sys_fields_types ON  id = id_name;",
            (reader) => {
                return new FieldType(
                    reader.GetString(0),
                    reader.GetInt32(1),
                    (NpgsqlDbType)reader.GetInt32(2)
                    );
            });
        }


        public FieldType[] this[string apiName]
        {
            get
            {
                return columnsInfo[apiName];
            }
        }
    }
}