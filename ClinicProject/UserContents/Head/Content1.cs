using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Data;
using System.Linq;
using System.Windows.Forms;
using System.IO;
using DataBaseTools;
using DataBaseTools.FieldsInfo;
using ClinicProject.ImageServiceSoap;


namespace ClinicProject.UserContents.Head
{
    public partial class Content1 : UserControl
    {
        private char ch = 'W';
        private bool switcher = false;

        //Для изображний
        private string path = ""; //из базы
        private string image_path = ""; //локальная

        public Content1()
        {
            InitializeComponent();
            this.Dock = DockStyle.Fill;
        }

        private void Content2_VisibleChanged(object sender, EventArgs e)
        {
            switcher = false;
            comboBox4.SelectedIndex = -1;

            if (this.Visible)
            {
                comboBox4.DataSource = DataBase.Select("view_workers");
                ColumnsCreator.GetData(comboBox4, "view_workers");

                comboBox4.SelectedIndex = -1;
                switcher = true;
                comboBox4.SelectedIndex = 0;
            }
        }

        private void comboBox4_SelectedValueChanged(object sender, EventArgs e)
        {
            string birthday = "";
            string login = Convert.ToString(comboBox4.SelectedValue);

            pictureBox1.Image = null;
            pictureBox1.Invalidate();
            pictureBox1.Image = ClinicProject.Properties.Resources._79d79e77_7bbc_4489_b1e1_4d95e7aa3e33;
            panel2.Visible = false;

            if (switcher)
            {
                textBox2.Visible = false;
                label2.Visible = false;
                panel2.Visible = false;

                DataTable table = null;
                ch = Convert.ToChar(DataBase.Scalar("fun_scal_who_is_this", login));

                switch (ch)
                {
                    case 'W': table = DataBase.Select("fun_sel_worker", login); break;
                    case 'M': table = DataBase.Select("fun_sel_medworker", login); break;
                    case 'D': table = DataBase.Select("fun_sel_doctor", login); break;
                }


                if (table != null)
                {
                    DataRow[] rows = table.Select();

                    if (rows.Count() != 0)
                    {
                        textBox3.Text = Convert.ToString(rows[0][0]);
                        textBox4.Text = Convert.ToString(rows[0][1]);
                        textBox5.Text = Convert.ToString(rows[0][2]);
                        birthday = Convert.ToString(rows[0][3]);
                        dateTimePicker1.Value = Convert.ToDateTime(birthday);
                        path = Convert.ToString(rows[0][4]);
                        textBox9.Text = Convert.ToString(rows[0][5]);

                        switch (ch)
                        {
                            case 'W':
                                textBox1.Text = Convert.ToString(rows[0][6]);
                                textBox2.Visible = false;
                                label2.Visible = false;
                                panel2.Visible = false;
                                break;
                            case 'M':
                                textBox2.Text = Convert.ToString(rows[0][6]);
                                textBox1.Text = Convert.ToString(rows[0][7]);
                                textBox2.Visible = true;
                                label2.Visible = true;
                                panel2.Visible = false;
                                break;
                            case 'D':
                                textBox2.Text = Convert.ToString(rows[0][6]);
                                textBox7.Text = Convert.ToString(rows[0][7]);
                                textBox8.Text = Convert.ToString(rows[0][8]);
                                textBox6.Text = Convert.ToString(rows[0][9]);
                                textBox1.Text = Convert.ToString(rows[0][10]);
                                textBox2.Visible = true;
                                label2.Visible = true;
                                panel2.Visible = true;
                                break;
                        }
                        LoadImage();
                    }
                    else MessageBox.Show("Запрос не вернул результатов!");
                }
                else MessageBox.Show("Должность сотрудника не определена!");
            }
        }

        private async void LoadImage()
        {
            //Загрузка изображения
            if (path != null && path != "")
            {
                LoadImageResponse response = await Program.image_service.LoadImageAsync(path);
                byte[] array = response.Body.LoadImageResult;

                if (array != null)
                {
                    MemoryStream memoryStream = new MemoryStream();
                    foreach (byte b in array) memoryStream.WriteByte(b);
                    pictureBox1.Image = Image.FromStream(memoryStream);
                    image_path = "";
                }
            }
        }

        private async void button1_Click(object sender, EventArgs e)
        {
            if (image_path != "")
            {
                await Program.image_service.RemoveImageAsync(path);
                // Format of image
                int index = image_path.LastIndexOf('.');
                string format_string = image_path.Substring(index, image_path.Length - index);

                if (format_string == ".png" || format_string == ".jpg" || format_string == ".jpeg" || format_string == ".bmp")
                {
                    ImageFormat format = null;
                    if (format_string == ".png") format = ImageFormat.Png;
                    else if (format_string == ".jpg" || format_string == ".jpeg") format = ImageFormat.Jpeg;
                    else if (format_string == ".bmp") format = ImageFormat.Bmp;

                    //binary array image
                    MemoryStream memoryStream = new MemoryStream();
                    pictureBox1.Image.Save(memoryStream, format);
                    byte[] array = memoryStream.ToArray();
                    SaveImageResponse response = await Program.image_service.SaveImageAsync(array, format_string);
                    path = response.Body.SaveImageResult;
                }
            }


            if (ch == 'W' || ch == 'M')
            {
                //  ToString("yyyy-MM-dd")
                DataBase.Insert("fun_upd_worker_medworker",
                        Convert.ToString(comboBox4.SelectedValue), textBox3.Text, textBox4.Text,
                        textBox5.Text, dateTimePicker1.Value, path);
                if (!DataBase.HasError) MessageBox.Show("Изменения сохранены!");
            }
            else
            {
                DataBase.Insert("fun_upd_doctor",
                        Convert.ToString(comboBox4.SelectedValue), textBox3.Text, textBox4.Text,
                        textBox5.Text, dateTimePicker1.Value, path,
                        Convert.ToInt32(textBox7.Text), textBox8.Text, Convert.ToInt32(textBox6.Text));
                if (!DataBase.HasError) MessageBox.Show("Изменения сохранены!");
            }
            Content2_VisibleChanged(sender, e);
        }

        private async void button3_Click(object sender, EventArgs e)
        {
            DataBase.Delete("fun_del_worker", Convert.ToString(comboBox4.SelectedValue));
            if (!DataBase.HasError)
            {
                try { await Program.image_service.RemoveImageAsync(path); } catch (Exception) { }
                MessageBox.Show("Увольнение прошло успешно!");
                Content2_VisibleChanged(sender, e);
            }
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                image_path = openFileDialog1.FileName;
                pictureBox1.Image = System.Drawing.Image.FromFile(image_path);
            }
        }
    }
}
