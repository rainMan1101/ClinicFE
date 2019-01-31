using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Security.Cryptography;
using DataBaseTools;
using ClinicProject.Classes;


namespace ClinicProject.UserContents
{
    public partial class Login : UserControl
    {
        MD5 Hasher;

        public Login()
        {
            InitializeComponent();
            Hasher = MD5.Create();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            byte[] data = Hasher.ComputeHash(Encoding.Default.GetBytes(textBox2.Text));
            StringBuilder sBuilder = new StringBuilder();
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }
            string password = sBuilder.ToString();

            

            DataTable table = DataBase.Select("fun_sel_login_worker", textBox1.Text, password);
            DataRow[] rows = table.Select();

            if (!DataBase.HasError && rows.Count() != 0)
            {
                LoginInfo.account = Convert.ToChar(rows[0][0]);
                LoginInfo.is_district_doc = Convert.ToBoolean(rows[0][1]);
                LoginInfo.last_name = Convert.ToString(rows[0][2]);
                LoginInfo.first_name = Convert.ToString(rows[0][3]);
                LoginInfo.middle_name = Convert.ToString(rows[0][4]);
                LoginInfo.photo = Convert.ToString(rows[0][5]);
                LoginInfo.post = Convert.ToString(rows[0][6]);
                LoginInfo.office = Convert.ToString(rows[0][7]);
                try { LoginInfo.office_id = Convert.ToInt32(rows[0][8]); } catch (Exception) { }
                this.Hide();
            }
            else if (DataBase.HasError)
                MessageBox.Show(DataBase.ErrorMessage);
        }
    }
}
