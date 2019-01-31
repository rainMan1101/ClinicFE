using System;
using System.Windows.Forms;
using ClinicProject.ImageServiceSoap;
using ClinicProject.PatientServiceSoap;
using ClinicProject.UserContents;


namespace ClinicProject
{
    static class Program
    {
        public static ImageServiceSoapClient image_service;
        public static PatientServiceSoapClient patient;

        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            try
            {
                patient = new PatientServiceSoapClient();
                image_service = new ImageServiceSoapClient();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

            // Запуск окна приложения
            Application.Run(new WorkerForm());
        }
    }
}
