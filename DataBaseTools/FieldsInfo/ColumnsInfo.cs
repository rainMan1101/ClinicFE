using System;
using System.Linq;
using System.Collections.Generic;
using System.Configuration;
using Npgsql;
//using DataBaseTools.Properties;
using DataBaseTools.FieldsInfo.Classes;


namespace DataBaseTools.FieldsInfo
{
    /*   Класс, реализующий алгоритм получения различной информации о столбцах 
     *   (типов, названий, привязок и пр.) из системных таблиц приложения.
     *                          (метаинформация)
     */
    internal class ColumnsInfo<TApi> where TApi : IAPIName
    {
        //  Чтобы не обращаться к базе каждый раз (конфигурация считывается только при запуске приложения)
        #region Singleton
        private static ColumnsInfo<TApi> fieldsTypesInfo;

        public static ColumnsInfo<TApi> GetInstance(string sqlString, Func<NpgsqlDataReader, TApi> getValue)
        {
            if (fieldsTypesInfo == null)
                fieldsTypesInfo = new ColumnsInfo<TApi>(sqlString, getValue);
            return fieldsTypesInfo;
        }
        #endregion

        private List<TApi> values = new List<TApi>();

        //  Выбор информации, соответствующей определенному API
        public TApi[] this[string apiName]
        {
            get
            {
                var result =
                    from value in values
                    where value.APIName == apiName
                    orderby value.SerialNumber
                    select value;

                return result.ToArray();
            }
        }

        private string connectionString = ConfigurationManager.ConnectionStrings["postgreSQL"].ConnectionString;

        // Заполнение соответствующей коллекции данными
        private ColumnsInfo(string sqlString, Func<NpgsqlDataReader, TApi> getValue)
        {
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();

                using (NpgsqlCommand command = new NpgsqlCommand(sqlString, connection))
                {
                    using (NpgsqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read() && reader.HasRows)
                            values.Add(getValue(reader));
                    }
                }
            }
        }

    }
}
