using System;
using System.Windows.Forms;
using System.IO;
using DataBaseTools;
using DataBaseTools.FieldsInfo;
using ClinicProject.PatientServiceSoap;


namespace ClinicProject.UserContents.Registrar.Patient.User
{
    public partial class Content1 : UserControl
    {
        private string number_polis;

        public Content1(string polis)
        {
            number_polis = polis;
            InitializeComponent();

            ColumnsCreator.GetData(comboBox1, "view_docktors");
            ColumnsCreator.GetData(comboBox2, "fun_sel_get_time");
        }

        private async void button1_Click(object sender, EventArgs e)
        {
            if (comboBox2.Text != "")
            {
                DataBase.Insert("fun_ins_records", dateTimePicker1.Value, Convert.ToInt32(comboBox1.SelectedValue), 
                    number_polis, Convert.ToDateTime(comboBox2.Text).TimeOfDay);

                if (!DataBase.HasError)
                {
                    try
                    {
                        await Program.patient.generateTalonAsync(dateTimePicker1.Value,
                        Convert.ToInt32(comboBox1.SelectedValue), number_polis);
                    }
                    catch (Exception ex) { MessageBox.Show(ex.Message); }

                    if (MessageBox.Show("Запись прошла успешно! \nРаспечатать талон?",
                        "Талон", MessageBoxButtons.OKCancel) == DialogResult.OK)
                    {

                        //Вызов сервиса печати талона
                        byte[] byte_array = null;
                        getTalonResponse response = await Program.patient.getTalonAsync(
                            dateTimePicker1.Value, Convert.ToInt32(comboBox1.SelectedValue), number_polis);
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
                    dateTimePicker1_ValueChanged(sender, e);
                }
                else
                    MessageBox.Show(DataBase.ErrorMessage);
            }
            else
                MessageBox.Show("Выберите время!");
        }

        private void Content1_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                comboBox1.DataSource = DataBase.Select("view_docktors").DefaultView;
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            comboBox2.DataSource = DataBase.Select("fun_sel_get_time",
                dateTimePicker1.Value, comboBox1.SelectedValue).DefaultView; ///!!!
        }

        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {
            comboBox2.DataSource = DataBase.Select("fun_sel_get_time",
                dateTimePicker1.Value, comboBox1.SelectedValue).DefaultView; ///!!!
        }
    }
}
