using System;
using System.Windows.Forms;
using DataBaseTools;
using DataBaseTools.FieldsInfo;


namespace ClinicProject.UserContents.Registrar
{
    public partial class Content3 : UserControl
    {
        public Content3()
        {
            InitializeComponent();
            ColumnsCreator.GetData(dataGridView1, "view_patients");
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (dataGridView1.CurrentCell != null)
            {
                int select_row = dataGridView1.CurrentCell.RowIndex;
                if (select_row >= 0)
                {
                    string number_police = Convert.ToString(dataGridView1[0, select_row].Value);
                    Patient.UserForm patient = new Patient.UserForm(number_police);
                    patient.ShowDialog();
                }
                else MessageBox.Show("Не выбран пациент!");
            }
            else MessageBox.Show("Не выбран пациент!");
        }

        private void Content3_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                dataGridView1.DataSource = DataBase.Select("view_patients");
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            dataGridView1.DataSource = DataBase.Select("fun_sel_patients_with_FIO", textBox2.Text, false);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            dataGridView1.DataSource = DataBase.Select("fun_sel_patients_with_police", textBox3.Text, false);
        }
    }
}
