using System;
using System.Windows.Forms;
using DataBaseTools;
using DataBaseTools.FieldsInfo;

namespace ClinicProject.UserContents.Registrar
{
    public partial class Content2 : UserControl
    {
        public Content2()
        {
            InitializeComponent();
            ColumnsCreator.GetData(dataGridView1, "view_patients_district");
        }

        private void Content2_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                dataGridView1.DataSource = DataBase.Select("view_patients_district");
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (dataGridView1.CurrentCell != null)
            {
                int select_row = dataGridView1.CurrentCell.RowIndex;
                if (select_row >= 0)
                {
                    string number_police = Convert.ToString(dataGridView1[0, select_row].Value);
                    if (textBox1.Text != "")
                    {
                        Object obj = DataBase.Scalar("fun_ins_district_record", DateTime.Today, number_police);

                        if (!DataBase.HasError)
                            MessageBox.Show("Пациент записан к участковому врачу");
                    }
                    else MessageBox.Show("Жалобы не указаны!");
                }
                else MessageBox.Show("Не выбран пациент!");
            }
            else MessageBox.Show("Не выбран пациент!");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            dataGridView1.DataSource = DataBase.Select("fun_sel_patients_with_FIO", textBox2.Text, true);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            dataGridView1.DataSource = DataBase.Select("fun_sel_patients_with_police", textBox3.Text, true);
        }
    }
}
