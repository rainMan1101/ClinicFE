using System;
using System.Windows.Forms;
using System.IO;
using DataBaseTools;
using DataBaseTools.FieldsInfo;
using ClinicProject.PatientServiceSoap;


namespace ClinicProject.UserContents.Registrar.Patient.User
{
    public partial class Content2 : UserControl
    {
        private string number_polis;
        public Content2(string polis)
        {
            number_polis = polis;
            InitializeComponent();


            ColumnsCreator.GetData(dataGridView1, "fun_sel_talons");
        }

        private void Content2_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                dataGridView1.DataSource = DataBase.Select("fun_sel_talons", number_polis, DateTime.Today);
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
                getTalonResponse response = await Program.patient.getTalonAsync(date, id_doc, number_polis);
                byte_array = response.Body.getTalonResult;

                if (byte_array != null)
                {
                    File.WriteAllBytes(@"C:\Temp\temp.pdf", byte_array);
                    PrintWindow pw = new PrintWindow();
                    pw.webBrowser1.Navigate(@"C:\Temp\temp.pdf");
                    pw.Show();
                }
                else MessageBox.Show("Ошибка!");
            }
        }
    }
}
