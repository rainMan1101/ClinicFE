using System;
using System.Data;
using System.Linq;
using System.Windows.Forms;
using System.IO;
using PatientProject.Classes;
using DataBaseTools;
using DataBaseTools.FieldsInfo;


namespace PatientProject.UserContents
{
    public partial class Record : UserControl
    {
        private bool upd = false;
        private bool show = false;

        public Record()
        {
            InitializeComponent();

            ColumnsCreator.GetData(comboBox2, "fun_sel_get_time");
        }

        private async void button1_Click(object sender, EventArgs e)
        {
            if (comboBox2.Text != "")
            {
                DataBase.Insert("fun_ins_records", dateTimePicker1.Value, Info.Doctor, 
                    Patient.NumberPolicy, Convert.ToDateTime(comboBox2.Text).TimeOfDay);

                if (!DataBase.HasError)
                {
                    //Генерация талона
                    try
                    {
                        //Program.patient.generateTalon(dateTimePicker1.Value, Info.doctor, Pacient.number_policy);
                        await Program.patient.generateTalonAsync(dateTimePicker1.Value, Info.Doctor, Patient.NumberPolicy);
                    }
                    catch (Exception ex) { MessageBox.Show(ex.Message); }

                    if (MessageBox.Show("Запись прошла успешно! \nРаспечатать талон?",
                        "Талон", MessageBoxButtons.OKCancel) == DialogResult.OK)
                    {

                        //Вызов сервиса печати талона
                        byte[] byte_array = null;
                        //byte_array = Program.patient.getTalon(dateTimePicker1.Value, Info.doctor, Pacient.number_policy);
                        PatientServiceSoap.getTalonResponse response =
                            await Program.patient.getTalonAsync(dateTimePicker1.Value, Info.Doctor, Patient.NumberPolicy);
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

                    History.Values.Clear();
                    ((UserForm)this.Parent).NextPage(0);
                    this.Hide();
                }
                else
                    MessageBox.Show(DataBase.ErrorMessage);
            }
            else
            {
                MessageBox.Show("Выберите время!");
            }
        }

        private void Record_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                DataTable table = DataBase.Select("fun_sel_doctor_with_room_and_office", Info.Doctor);
                DataRow[] rows = table.Select();

                if (!DataBase.HasError && rows.Count() != 0)
                {
                    textBox1.Text = Convert.ToString(rows[0][0]);
                    textBox2.Text = Convert.ToString(rows[0][1]);
                    textBox3.Text = Convert.ToString(rows[0][2]);
                }

                //dateTimePicker1.Value = DateTime.Today;
                /**/
                upd = false;
                show = false;
                DateTime date = DateTime.Today;
                dateTimePicker1.MinDate = date;
                dateTimePicker1.MaxDate = date.AddMonths(1);
                upd = true;
                dateTimePicker1.Value = date;
                show = true;
            }
        }

        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {
            if (upd)
            {
                //comboBox2.Text = "";

                comboBox2.DataSource = DataBase.Select("fun_sel_get_time", 
                    dateTimePicker1.Value, Info.Doctor).DefaultView;

                if (comboBox2.Items.Count == 0 && show)
                {
                    //comboBox2.Items.Add("");
                    //comboBox2.Items.RemoveAt(0);
                    if (dateTimePicker1.Value.DayOfWeek == DayOfWeek.Saturday ||
                        dateTimePicker1.Value.DayOfWeek == DayOfWeek.Sunday)
                    {
                        MessageBox.Show("Выбран выходной день. \nПоликлиника работает с пондельника по пятницу!");
                    }
                    else
                    {
                        MessageBox.Show("Нет свободного времени для записи в выбранный день!");
                    }
                }
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            ((UserForm)this.Parent).NextPage(History.Values.Pop());
            this.Hide();
        }
    }
}
