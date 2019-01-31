using System;
using System.Data;
using Npgsql;
using System.Configuration;
using DataBaseTools.FieldsInfo;
using DataBaseTools.FieldsInfo.Classes;


namespace DataBaseTools
{
    /*           Класс, для работы с базой данных (получение/отправка самих данных)                */
    public static class DataBase
    {
        private static FieldsTypesInfo types = new FieldsTypesInfo();
        private static InputUPDColumnsInfo columns = new InputUPDColumnsInfo();

        private static string connection_string = ConfigurationManager.ConnectionStrings["postgreSQL"].ConnectionString;
        private static NpgsqlConnection connection = new NpgsqlConnection(connection_string);


        public static bool HasError { get; set; } = false;

        public static string ErrorMessage { get; set; } = "";


        /*------------------ Вспомогательные методы --------------*/
        private static DataTable FillTable(NpgsqlCommand command)
        {
            HasError = false;
            ErrorMessage = "";

            var table = new DataTable();
            var adapter = new NpgsqlDataAdapter();
            adapter.SelectCommand = command;
            try { adapter.Fill(table); }
            catch (Exception ex) { HasError = true; ErrorMessage = ex.Message; }
            return table;
        }
        private static NpgsqlCommand DoRequestWithParametrs(string name, params object[] parameters)
        {
            NpgsqlCommand command = new NpgsqlCommand("clinic." + name, connection);
            command.CommandType = CommandType.StoredProcedure;
            FieldType[] typesArr = types[name];

            for (int i = 0; i < typesArr.Length; i++)
                command.Parameters.AddWithValue(typesArr[i].TypeColumn, parameters[i]);
            
            return command;
        }
        private static Object ScalarCommon(NpgsqlCommand command)
        {
            HasError = false;
            ErrorMessage = "";

            Object result = new Object();
            try
            {
                connection.Open();
                result = command.ExecuteScalar();
            }
            catch (Exception ex) { HasError = true; ErrorMessage = ex.Message; /*ErrorMessage = ex.Message.Substring(7);*/}
            finally { connection.Close(); }
            return result;
        }
        private static void InsertOrDelete(string name, params object[] parameters)
        {
            HasError = false;
            ErrorMessage = "";

            NpgsqlCommand command = DoRequestWithParametrs(name, parameters);
            try
            {
                connection.Open();
                command.ExecuteNonQuery();
            }
            catch (Exception ex) { HasError = true; ErrorMessage = ex.Message; }
            finally { connection.Close(); }
        }

        /*-------------------- Рабчие методы --------------------*/
        public static DataTable Select(string name)
        {
            NpgsqlCommand command = new NpgsqlCommand("SELECT * FROM clinic." + name + ";", connection);
            return FillTable(command);
        }
        public static DataTable Select(string name, params object[] parameters)
        {
            return FillTable(DoRequestWithParametrs(name, parameters));
        }
        public static void Delete(string name, params object[] parameters)
        {
            InsertOrDelete(name, parameters);
        }
        public static void Insert(string name, params object[] parameters)
        {
            InsertOrDelete(name, parameters);
        }
        public static void Update(string name, DataTable table)
        {
            InputUPDColumn[] columnsArr = columns[name];
            FieldType[] typesArr = types[name];

            if (columnsArr.Length != typesArr.Length)
                throw new Exception("Размеры массивов типов полоей и колонок для UPDATE запросане совпадают!");

            DataRow[] rows = table.Select(null, null, DataViewRowState.ModifiedCurrent);

            HasError = false;

            foreach (DataRow row in rows)
            {
                NpgsqlCommand command = new NpgsqlCommand("clinic." + name, connection);
                command.CommandType = CommandType.StoredProcedure;

                for (int i = 0; i < typesArr.Length; i++)
                    command.Parameters.AddWithValue(typesArr[i].TypeColumn, row[columnsArr[i].ColumnName]);

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                }
                catch (Exception ex) { HasError = true; ErrorMessage = ex.Message; }
                finally { connection.Close(); }
            }
            table.AcceptChanges();
        }
        public static Object Scalar(string name)
        {
            NpgsqlCommand command = new NpgsqlCommand("clinic." + name, connection);
            command.CommandType = CommandType.StoredProcedure;
            return ScalarCommon(command);

        }
        public static Object Scalar(string name, params object[] parameters)
        {
            NpgsqlCommand command = DoRequestWithParametrs(name, parameters);
            return ScalarCommon(command);
        }

        /*------------- Дополниетельные рабчие методы -----------*/
        public static bool TestConection()
        {
            bool test_connection = true;
            try
            {
                connection.Open();
            }
            catch (Exception) { test_connection = false; }
            finally { connection.Close(); }
            return test_connection;
        }
    }
}