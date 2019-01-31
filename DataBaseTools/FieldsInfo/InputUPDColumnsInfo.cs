using DataBaseTools.FieldsInfo.Classes;


namespace DataBaseTools.FieldsInfo
{
    /*                  Информация о привязке тех колонок, которые необходимо обновить             */
    //  Композиция
    internal class InputUPDColumnsInfo
    {
        private ColumnsInfo<InputUPDColumn> columnsInfo;

        public InputUPDColumnsInfo()
        {
            columnsInfo = ColumnsInfo<InputUPDColumn>.GetInstance(
            @"SELECT name, numb, column_name
              FROM clinic.sys_names JOIN clinic.sys_input_UPD_columns ON  id = id_name;",
            (reader) => {
                return new InputUPDColumn(
                    reader.GetString(0),
                    reader.GetInt32(1),
                    reader.GetString(2)
                    );
            });
        }

        public InputUPDColumn[] this[string apiName]
        {
            get
            {
                return columnsInfo[apiName];
            }
        }
    }
}
