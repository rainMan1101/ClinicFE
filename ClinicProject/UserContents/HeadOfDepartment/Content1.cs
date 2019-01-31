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
    public partial class Content1 : UserControl
    {
        private int click_row;

        public Content1()
        {
            InitializeComponent();
            this.Dock = DockStyle.Fill;

            ColumnsCreator.GetData(dataGridView1, "fun_sel_graph");
            dataGridView1.EditMode = DataGridViewEditMode.EditOnEnter;

            //dateTimePicker
            DateTime date = DateTime.Today;
            dateTimePicker1.MinDate = date;
            dateTimePicker1.MaxDate = date.AddMonths(1);
            dateTimePicker1.Value = date;

            set_combo();
        }

 
        private void dataGridView1_DataError(object sender, DataGridViewDataErrorEventArgs e) {}

        private void button1_Click(object sender, EventArgs e)
        {
            DataTable table = (DataTable)dataGridView1.DataSource;
            DataRow[] rows = table.Select(null, null, DataViewRowState.ModifiedCurrent);
            bool has_error = false;

            for (int i = 0; i < rows.Count(); i++)
            {
                DataRow row = rows[i];
                if (Convert.ToString(row[3]) == "" || Convert.ToString(row[4]) == ""
                    || Convert.ToString(row[5]) == "")
                {
                    has_error = true;
                    if (Convert.ToString(row[3]) == "" && Convert.ToString(row[4]) == ""
                        && Convert.ToString(row[5]) == "") row.ClearErrors();
                    else
                    {
                        string error_string = "";
                        if (Convert.ToString(row[3]) == "") error_string += "Не указано начало приема \n";
                        if (Convert.ToString(row[4]) == "") error_string += "Не указан конец приема \n";
                        if (Convert.ToString(row[5]) == "") error_string += "Не указано время на прием \n";
                        row.SetColumnError(1, error_string);
                    }
                }
                else row.ClearErrors();
            }

            if (has_error) MessageBox.Show("Для конкретных записей поля заполнены неполностью!");
            else
            {
                DataBase.Update("fun_upd_ins_graph", (DataTable)dataGridView1.DataSource);
                if (!DataBase.HasError) MessageBox.Show("Изменения сохранены");
            }
        }


        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                dataGridView1.DataSource = DataBase.Select("fun_sel_graph", dateTimePicker1.Value, LoginInfo.office_id);
                if (DataBase.HasError) MessageBox.Show(DataBase.ErrorMessage);
            }
        }

        private void set_combo()
        {
            DataGridViewComboBoxColumn comboBox; 

            if ((comboBox = ((DataGridViewComboBoxColumn)dataGridView1.Columns[2]))!= null)
                comboBox.DataSource = SetCombo.SetBegin();

            if ((comboBox = ((DataGridViewComboBoxColumn)dataGridView1.Columns[3])) != null)
                comboBox.DataSource = SetCombo.SetEnd();

            if ((comboBox = ((DataGridViewComboBoxColumn)dataGridView1.Columns[4])) != null)
                comboBox.DataSource = SetCombo.SetTime();
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void Content1_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                if (dateTimePicker1.Value == DateTime.Today) dateTimePicker1_ValueChanged(sender, e);
                else dateTimePicker1.Value = DateTime.Today;
            }
        }

        private void dataGridView1_CurrentCellDirtyStateChanged(object sender, EventArgs e)
        {
            dataGridView1.CommitEdit(DataGridViewDataErrorContexts.Commit);
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
            DataBase.Delete("fun_scal_del_graph", dateTimePicker1.Value, table.Rows[click_row][0]);
            if (!DataBase.HasError)
            {
                dataGridView1.DataSource = DataBase.Select("fun_sel_graph", dateTimePicker1.Value, LoginInfo.office_id);
                //
                if (DataBase.HasError) MessageBox.Show(DataBase.ErrorMessage);
            }
        }

        private void ContextClickCancelChanges(object sender, EventArgs e)
        {
            DataTable table = ((DataTable)dataGridView1.DataSource);
            table.Rows[click_row].RejectChanges();
            table.Rows[click_row].ClearErrors();
        }
    }
}
