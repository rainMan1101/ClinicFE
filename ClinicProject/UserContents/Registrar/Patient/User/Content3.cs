using System;
using System.Windows.Forms;
using System.IO;


namespace ClinicProject.UserContents.Registrar.Patient.User
{
    public partial class Content3 : UserControl
    {
        private string number_polis;
        public Content3(string polis)
        {
            number_polis = polis;
            InitializeComponent();
        }

        private void Content3_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                byte[] byte_array = null;
                byte_array = Program.patient.getMedCard(number_polis);
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
