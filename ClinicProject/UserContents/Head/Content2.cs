using System;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Security.Cryptography;
using System.Drawing.Imaging;
using DataBaseTools;
using DataBaseTools.FieldsInfo;
using ClinicProject.ImageServiceSoap;


namespace ClinicProject.UserContents.Head
{
    public partial class Content2 : UserControl
    {
        private string image_path = ""; 

        public Content2()
        {
            InitializeComponent();
            this.Dock = DockStyle.Fill;

            ColumnsCreator.GetData(comboBox2, "view_offices");
            comboBox2.DataSource = DataBase.Select("view_offices").DefaultView;
            dateTimePicker1.MaxDate = DateTime.Today;
            dateTimePicker1.Value = DateTime.Today.AddYears(-20);
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            panel2.Visible = false;

            switch (comboBox1.SelectedIndex)
            {
                case -1:
                    label2.Visible = false;
                    comboBox2.Visible = false;
                    label3.Visible = false;
                    comboBox3.Visible = false;
                    comboBox2.SelectedIndex = -1;
                    break;
                case 0:
                    label2.Visible = true;
                    comboBox2.Visible = true;
                    comboBox2.SelectedIndex = 0;
                    label3.Visible = true;
                    comboBox3.Visible = true;
                    break;
                case 1:
                case 2:
                    label2.Visible = false;
                    comboBox2.Visible = false;
                    label3.Visible = true;
                    comboBox3.Visible = true;
                    comboBox2.SelectedIndex = -1;

                    char ch;
                    if (comboBox1.SelectedIndex == 1) ch = 'H';
                    else ch = 'A';

                    ColumnsCreator.GetData(comboBox3, "fun_sel_post_in_depart");
                    comboBox3.DataSource = DataBase.Select("fun_sel_post_in_depart", ch);
                    comboBox3.SelectedIndex = -1;
                    break;
            }
        }


        private void Content3_VisibleChanged(object sender, EventArgs e)
        {
            if (!this.Visible)
            {
                comboBox1.SelectedIndex = -1;
                comboBox2.SelectedIndex = -1;
                openFileDialog1.FileName = "";
                image_path = ""; 
            }
            if (this.Visible) Clear();
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            panel2.Visible = false;
            if (comboBox2.Items.Count != 0)
            {
                if (comboBox2.SelectedIndex != -1)
                {
                    ColumnsCreator.GetData(comboBox3, "fun_sel_post_in_office");
                    comboBox3.DataSource = DataBase.Select("fun_sel_post_in_office", comboBox2.SelectedValue).DefaultView;
                    comboBox3.SelectedIndex = -1;
                }
            }
        }

        private void comboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBox3.Items.Count != 0)
            {
                if (comboBox3.SelectedIndex != -1)
                {
                    Clear();
                    bool is_doc = Convert.ToBoolean(DataBase.Scalar("fun_scal_is_doc", Convert.ToInt32(comboBox3.SelectedValue)));
                    if (is_doc) panel2.Visible = true;
                    else panel2.Visible = false;
                }
            }
        }

        private async void button1_Click(object sender, EventArgs e)
        {
            if (comboBox3.Text == "") MessageBox.Show("Невыбрана должность!"); 
            else if (textBox1.Text == "") MessageBox.Show("Не указан логин!");
            else if (textBox2.Text == "") MessageBox.Show("Не указан пароль!"); 
            else if (textBox3.Text == "") MessageBox.Show("Не указана фамилия!"); 
            else if (textBox4.Text == "") MessageBox.Show("Не указано имя!"); 
            else if (textBox5.Text == "") MessageBox.Show("Не указано отчество!");

            else if (textBox7.Text == "" && panel2.Visible) MessageBox.Show("Не указан кабинет!");
            else if (textBox8.Text == "" && panel2.Visible) MessageBox.Show("Не указано образование!");
            else if (textBox6.Text == "" && panel2.Visible) MessageBox.Show("Не указан стаж!");
            else
            {
                if (panel2.Visible)
                {
                    try { Convert.ToInt32(textBox7.Text); } catch { MessageBox.Show("В поле 'Кабинет' должно быть указанно число!"); return; }
                    try { Convert.ToInt32(textBox6.Text); } catch { MessageBox.Show("В поле 'Стаж' должно быть указанно число!"); return; }
                }


                //хеширование
                MD5 Hasher = MD5.Create();
                byte[] data = Hasher.ComputeHash(Encoding.Default.GetBytes(textBox2.Text));
                StringBuilder sBuilder = new StringBuilder();
                for (int i = 0; i < data.Length; i++)
                    sBuilder.Append(data[i].ToString("x2"));
                string hash = sBuilder.ToString();

                if (image_path != "")
                {
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
                        image_path = response.Body.SaveImageResult;
                    }
                }


                if (Convert.ToString(comboBox2.SelectedValue) == "")
                {
                    DataBase.Insert("fun_ins_worker",
                        textBox1.Text, hash, textBox3.Text, textBox4.Text, textBox5.Text,
                        Convert.ToInt32(comboBox3.SelectedValue), DateTime.Today,
                        dateTimePicker1.Value, image_path);

                    if (!DataBase.HasError)
                        MessageBox.Show("Сотрудник зачислен в штат.");
                    else
                        MessageBox.Show(DataBase.ErrorMessage);
                }
                else
                {
                    bool is_doc = Convert.ToBoolean(DataBase.Scalar("fun_scal_is_doc", comboBox3.SelectedValue));
                    if (is_doc)
                    {
                        DataBase.Insert("fun_ins_doctor",
                            textBox1.Text, hash, textBox3.Text, textBox4.Text, textBox5.Text,
                            Convert.ToInt32(comboBox3.SelectedValue), DateTime.Today,
                            dateTimePicker1.Value, image_path, Convert.ToInt32(comboBox2.SelectedValue),
                            Convert.ToInt32(textBox7.Text), textBox8.Text, Convert.ToInt32(textBox6.Text));

                        if (!DataBase.HasError)
                            MessageBox.Show("Сотрудник зачислен в штат.");
                        else
                            MessageBox.Show(DataBase.ErrorMessage);
                    }
                    else
                    {
                        DataBase.Insert("fun_ins_medworker",
                            textBox1.Text, hash, textBox3.Text, textBox4.Text, textBox5.Text,
                            Convert.ToInt32(comboBox3.SelectedValue), DateTime.Today,
                            dateTimePicker1.Value, image_path, Convert.ToInt32(comboBox2.SelectedValue));

                        if (!DataBase.HasError)
                            MessageBox.Show("Сотрудник зачислен в штат.");
                        else
                            MessageBox.Show(DataBase.ErrorMessage);
                    }
                }
                Clear();
            }
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                image_path = openFileDialog1.FileName;
                pictureBox1.Image = Image.FromFile(openFileDialog1.FileName);
            }
        }

        private void Clear()
        {
            pictureBox1.Image = null;
            pictureBox1.Invalidate();
            pictureBox1.Image = ClinicProject.Properties.Resources._79d79e77_7bbc_4489_b1e1_4d95e7aa3e33;

            textBox1.Text = "";
            textBox2.Text = "";
            textBox3.Text = "";
            textBox4.Text = "";
            textBox5.Text = "";
            textBox6.Text = "";
            textBox7.Text = "";
            textBox8.Text = "";
            dateTimePicker1.Value = DateTime.Today;
        }
    }
}
