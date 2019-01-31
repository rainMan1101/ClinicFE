using System;
using System.Windows.Forms;
using System.IO;
using PatientProject.Classes;
using DataBaseTools;
using DataBaseTools.FieldsInfo;


namespace PatientProject.UserContents
{
    public partial class Talon : UserControl
    {
        public Talon()
        {
            InitializeComponent();

            ColumnsCreator.GetData(dataGridView1, "fun_sel_talons");
        }

        private void Talon_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                dataGridView1.DataSource = DataBase.Select("fun_sel_talons", Patient.NumberPolicy, DateTime.Today);
            }
        }

        private async void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if ((e.ColumnIndex == 7) && (e.RowIndex > -1))
            {
                int id_doc = Convert.ToInt32(dataGridView1[2, e.RowIndex].Value);
                DateTime date = Convert.ToDateTime(dataGridView1[1, e.RowIndex].Value);

                //Вызов сервиса печати талона
                byte[] byte_array = null;
                //byte_array = Program.patient.getTalon(date, id_doc, Pacient.number_policy);
                PatientServiceSoap.getTalonResponse response =
                    await Program.patient.getTalonAsync(date, id_doc, Patient.NumberPolicy);
                byte_array = response.Body.getTalonResult;

                if (byte_array != null)
                {
                    try
                    {
                        File.WriteAllBytes(@"C:\Temp\temp.pdf", byte_array);
                    }
                    catch (Exception)
                    {
                        MessageBox.Show("Файл " + @"C:\Temp\temp.pdf" + " уже открыт!");
                        return;
                    }
                    PrintWindow pw = new PrintWindow();
                    pw.webBrowser1.Navigate(@"C:\Temp\temp.pdf");
                    pw.Show();
                }
                else MessageBox.Show("Ошибка!");
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            ((UserForm)this.Parent).NextPage(History.Values.Pop());
            this.Hide();
        }
    }
}
