using System;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Windows.Forms;
using ClinicProject.Classes;
using DataBaseTools;
using DataBaseTools.FieldsInfo;


namespace ClinicProject.UserContents.HeadOfDepartment
{
    public partial class Content2 : UserControl
    {
        private bool allow = true;
        private int click_row;

        public Content2()
        {
            InitializeComponent();

            ColumnsCreator.GetData(dataGridView1, "fun_sel_template");
            ColumnsCreator.GetData(comboBox1, "view_templnames");
            ColumnsCreator.GetData(comboBox2, "fun_sel_doctors_by_office");


            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            dataGridView1.EditMode = DataGridViewEditMode.EditOnEnter;
            set_combo();
        }

        private void Content2_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                comboBox1.DataSource = DataBase.Select("view_templnames");
                comboBox1.SelectedValue = "Новый"; //!!!
                this.comboBox1_SelectedIndexChanged(sender, e);

                comboBox2.DataSource = DataBase.Select("fun_sel_doctors_by_office", LoginInfo.office_id);
            }
        }
        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.Visible && allow)
                dataGridView1.DataSource = DataBase.Select("fun_sel_template", Convert.ToString(comboBox1.SelectedValue));
        }
        private void button1_Click(object sender, EventArgs e)
        {
            string name = "";
            DataTable table;
            DataRow[] rows;

            if (Convert.ToString(comboBox1.SelectedValue) == "Новый")
            {
                name = Microsoft.VisualBasic.Interaction.InputBox("Введите название нового шаблона расписания:", "Создание нового шаблона");
                if (name == "")
                {
                    MessageBox.Show("Вы не ввели название!");
                    return;
                }

                DataBase.Insert("fun_ins_templ", name);
                if (!DataBase.HasError) MessageBox.Show("Новый шаблон успешно добавлен!");
                else return;
                allow = false;
                comboBox1.DataSource = DataBase.Select("view_templnames");
                comboBox1.SelectedValue = name;
                allow = true;

                table = (DataTable)dataGridView1.DataSource;
                rows = table.Select();
                foreach (DataRow row in rows) row[0] = name;
                dataGridView1.DataSource = table;
            }
            else
                name = Convert.ToString(comboBox1.SelectedValue);



            table = (DataTable)dataGridView1.DataSource;
            rows = table.Select(null, null, DataViewRowState.ModifiedCurrent);
            bool has_error = false;

            for (int i = 0; i < rows.Count(); i++)
            {
                DataRow row = rows[i];
                if ((Convert.ToString(row[3]) == "" || Convert.ToString(row[4]) == ""
                    || Convert.ToString(row[5]) == "") && !(Convert.ToString(row[3]) == "" 
                    && Convert.ToString(row[4]) == ""  && Convert.ToString(row[5]) == ""))
                {
                    has_error = true;
                    string error_string = "";
                    if (Convert.ToString(row[3]) == "") error_string += "Не указано начало приема \n";
                    if (Convert.ToString(row[4]) == "") error_string += "Не указан конец приема \n";
                    if (Convert.ToString(row[5]) == "") error_string += "Не указано время на прием \n";
                    row.SetColumnError(2, error_string);
                }
                else row.ClearErrors();
            }

            if (has_error) MessageBox.Show("Для конкретных дней поля заполнены неполностью!");
            else
            {
                DataBase.Update("fun_upd_templ", (DataTable)dataGridView1.DataSource);
                if (!DataBase.HasError) MessageBox.Show("Шаблон расписания успешно обновлен!");
            }
        }

        private void dataGridView1_MouseClick(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                ContextMenu m = new ContextMenu();
                MenuItem menu_item = new MenuItem("Отменить изменения");
                menu_item.Click += ContextClickCancelChanges;
                m.MenuItems.Add(menu_item);

                menu_item = new MenuItem("Удалить");
                menu_item.Click += ContextClickDelete;
                m.MenuItems.Add(menu_item);

                click_row = dataGridView1.HitTest(e.X, e.Y).RowIndex;
                if (click_row >= 0) m.Show(dataGridView1, new Point(e.X, e.Y));
            }
        }

        private void ContextClickDelete(object sender, EventArgs e)
        {
            DataTable table = ((DataTable)dataGridView1.DataSource);
            DataBase.Scalar("fun_upd_clear_temp", table.Rows[click_row][0], table.Rows[click_row][1]);
            if (!DataBase.HasError)
                dataGridView1.DataSource = DataBase.Select("fun_sel_template", Convert.ToString(comboBox1.SelectedValue));
        }

        private void ContextClickCancelChanges(object sender, EventArgs e)
        {
            DataTable table = ((DataTable)dataGridView1.DataSource);
            table.Rows[click_row].RejectChanges();
            table.Rows[click_row].ClearErrors();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (allow_fill())
            {
                DateTime date = DateTime.Today;
                DataBase.Insert("fun_upd_ins_graph_with_temp",
                    Convert.ToString(comboBox1.SelectedValue),
                    Convert.ToInt32(comboBox2.SelectedValue),
                    date, 7);
                if (!DataBase.HasError) MessageBox.Show("Расписание на неделю успешно заполненно для данного врача!");
            }
        }
        private void button3_Click(object sender, EventArgs e)
        {
            if (allow_fill())
            {
                DateTime date = DateTime.Today;
                TimeSpan intervalDate = Convert.ToDateTime(date.AddMonths(1)) - date;
                int count = intervalDate.Days;

                DataBase.Insert("fun_upd_ins_graph_with_temp",
                    Convert.ToString(comboBox1.SelectedValue),
                    Convert.ToInt32(comboBox2.SelectedValue),
                    date, count);
                if (!DataBase.HasError) MessageBox.Show("Расписание на месяц успешно заполненно для данного врача!");
            }
        }
        //private void dataGridView1_DataError(object sender, DataGridViewDataErrorEventArgs e) { }

        private void set_combo()
        {
            DataGridViewComboBoxColumn comboBoxColumn;

            if ((comboBoxColumn = ((DataGridViewComboBoxColumn)dataGridView1.Columns[1])) != null)
                comboBoxColumn.DataSource = SetCombo.SetBegin();

            if ((comboBoxColumn = ((DataGridViewComboBoxColumn)dataGridView1.Columns[2])) != null)
                comboBoxColumn.DataSource = SetCombo.SetEnd();

            if ((comboBoxColumn = ((DataGridViewComboBoxColumn)dataGridView1.Columns[3])) != null)
                comboBoxColumn.DataSource = SetCombo.SetTime();
        }

        private bool allow_fill()
        {
            string name = Convert.ToString(comboBox1.SelectedValue);
            if (name == "Новый")
            {
                MessageBox.Show("Нельзя использовать еще несозданный шаблон!");
                return false;
            }
            return true;
        }

        private void button4_Click(object sender, EventArgs e)
        {
            DataBase.Delete("fun_del_temp", Convert.ToString(comboBox1.SelectedValue));
            if (!DataBase.HasError)
            {
                MessageBox.Show("Шаблон успешно удален!");
                comboBox1.DataSource = DataBase.Select("view_templnames");
                comboBox1.SelectedValue = "Новый";
            }
        }

        private void dataGridView1_DataError(object sender, DataGridViewDataErrorEventArgs e) { }
    }
}
