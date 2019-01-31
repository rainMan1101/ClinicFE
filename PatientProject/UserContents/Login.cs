using System;
using System.Data;
using System.Linq;
using System.Windows.Forms;
using System.IO;
using PatientProject.Classes;
using DataBaseTools;


namespace PatientProject.UserContents
{
    public partial class Login : UserControl
    {
        public Login()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (maskedTextBox1.Text.Replace(" ", "").Length != 16) {
                MessageBox.Show("Некорректно задан номер медецинского полиса!");
            }
            else
            {
                DataTable table = DataBase.Select("fun_sel_login_pacient", maskedTextBox1.Text);
                DataRow[] rows = table.Select();

                if (!DataBase.HasError && rows.Count() != 0)
                {
                    Patient.NumberPolicy = Convert.ToString(rows[0][0]);
                    Patient.LastName = Convert.ToString(rows[0][1]);
                    Patient.FirstName = Convert.ToString(rows[0][2]);
                    Patient.MiddLeName = Convert.ToString(rows[0][3]);

                    maskedTextBox1.Text = "";
                    if (Info.Page != 100)
                    {
                        History.Values.Push(1);
                        ((UserForm)this.Parent).NextPage(Info.Page);
                        this.Hide();
                    }
                    else
                    {
                        byte[] byte_array = null;
                        byte_array = Program.patient.getMedCard(Patient.NumberPolicy);
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

        private void button2_Click(object sender, EventArgs e)
        {
            maskedTextBox1.Text = "";
            ((UserForm)this.Parent).NextPage(History.Values.Pop());
            this.Hide();
        }
    }
}
