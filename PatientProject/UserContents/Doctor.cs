using System;
using System.Windows.Forms;
using PatientProject.Classes;
using DataBaseTools;
using DataBaseTools.FieldsInfo;


namespace PatientProject.UserContents
{
    public partial class Doctor : UserControl
    {
        public Doctor()
        {
            InitializeComponent();

            ColumnsCreator.GetData(dataGridView1, "fun_sel_doctors_with_post");
        }

        private void Doctor_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
                dataGridView1.DataSource = DataBase.Select("fun_sel_doctors_with_post", Info.Post);
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            {
            if ((e.ColumnIndex == 3) && (e.RowIndex > -1))
                Info.Doctor = Convert.ToInt32(dataGridView1[0, e.RowIndex].Value); //сохраняю код врача
                History.Values.Push(5);
                ((UserForm)this.Parent).NextPage(6);
                this.Hide();
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            ((UserForm)this.Parent).NextPage(History.Values.Pop());
            this.Hide();
        }

        private void Doctor_Load(object sender, EventArgs e)
        {

        }
    }
}
