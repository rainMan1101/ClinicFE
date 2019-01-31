using System;
using System.Windows.Forms;
using PatientProject.PatientServiceSoap;


namespace PatientProject
{
    public static class Program
    {
        /// <summary>
        /// Главная точка входа для приложения.
        /// </summary>
        /// 
        public static PatientServiceSoapClient patient;

        [STAThread]
        public static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            try
            {
                patient = new PatientServiceSoapClient();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            Application.Run(new UserForm());
        }
    }
}
