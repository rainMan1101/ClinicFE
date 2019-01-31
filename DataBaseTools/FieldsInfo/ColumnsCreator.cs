using System.Windows.Forms;
using DataBaseTools.FieldsInfo.Classes;


namespace DataBaseTools.FieldsInfo
{
    /*                      Класс, для генерации колонок для 
     *      DataGridView и ComboBox с заданными параметрами и привязками данных        
     */

    public class ColumnsCreator
    {
        public static void GetData(DataGridView dataGridView, string apiName)
        {
            var columnsInfo = ColumnsInfo<Classes.DataGridViewColumn>.GetInstance(
                @"SELECT name, numb, dataPropertyName, headerText, visible, width, readOnly, columnType
                  FROM clinic.sys_names JOIN clinic.sys_dataGridView_columns ON  id = id_name; ",
                (reader) => {

                    return new Classes.DataGridViewColumn(
                        reader.GetString(0),
                        reader.GetInt32(1),
                        reader.GetString(2),
                        reader.GetString(3),
                        reader.GetBoolean(4),
                        reader.GetInt32(5),
                        reader.GetBoolean(6),
                        reader.GetInt32(7)
                        );
                });

            Classes.DataGridViewColumn[] dataGridViewColumns = columnsInfo[apiName];


            dataGridView.AutoGenerateColumns = false;

            foreach (var column in dataGridViewColumns)
            {
                switch (column.ColumnType)
                {
                    case 1:
                        dataGridView.Columns.Add(new DataGridViewTextBoxColumn()
                        {
                            DataPropertyName = column.DataPropertyName,
                            HeaderText = column.HeaderText,
                            Visible = column.Visible,
                            Width = column.Width,
                            ReadOnly = column.ReadOnly
                        });
                        break;

                    case 2:
                        dataGridView.Columns.Add(new DataGridViewComboBoxColumn()
                        {
                            DataPropertyName = column.DataPropertyName,
                            HeaderText = column.HeaderText,
                            Visible = column.Visible,
                            Width = column.Width,
                            ReadOnly = column.ReadOnly
                        });
                        break;

                    case 3:
                        dataGridView.Columns.Add(new DataGridViewButtonColumn()
                        {
                            DataPropertyName = column.DataPropertyName,
                            Text = column.HeaderText,
                            Visible = column.Visible,
                            Width = column.Width,
                            ReadOnly = column.ReadOnly,
                            HeaderText = "",
                            UseColumnTextForButtonValue = true
                        });
                        break;

                }
            }
        }


        public static void GetData(ComboBox comboBox, string apiName)
        {
            var columnsInfo = ColumnsInfo<ComboBoxColumn>.GetInstance(
                @"SELECT name,  numb, column_name
                  FROM clinic.sys_names JOIN clinic.sys_comboBox_columns ON  id = id_name; ",
                (reader) => {
                    return new ComboBoxColumn(
                        reader.GetString(0),
                        reader.GetInt32(1),
                        reader.GetString(2)
                        );
                });


            ComboBoxColumn[] comboBoxColumns = columnsInfo[apiName];

            comboBox.ValueMember = comboBoxColumns[0].ColumnName;
            comboBox.DisplayMember = comboBoxColumns[1].ColumnName;
        }
    }
}
