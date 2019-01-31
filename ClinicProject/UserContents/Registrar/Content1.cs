using System;
using System.Drawing;
using System.Windows.Forms;
using DataBaseTools;
using DataBaseTools.FieldsInfo;


namespace ClinicProject.UserContents.Registrar
{
    public partial class Content1 : UserControl
    {
        public Content1()
        {
            InitializeComponent();

            ColumnsCreator.GetData(comboBox1, "view_streets");
            ColumnsCreator.GetData(comboBox2, "fun_sel_building");
            ColumnsCreator.GetData(comboBox4, "employments");
            ColumnsCreator.GetData(comboBox5, "view_lgots");

            this.comboBox5.DrawMode = DrawMode.OwnerDrawFixed;
            this.comboBox5.DrawItem += new DrawItemEventHandler(comboBox5_DrawItem);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //Квартира - только номер!!!
            if (maskedTextBox1.Text.Replace(" ", "").Length != 16) { MessageBox.Show("Не корректно задан номер медецинского полса!"); }
            else if (maskedTextBox2.Text.Replace(" ", "").Replace("-", "").Length != 11) { MessageBox.Show("Не корректно задан номер телефона!"); }
            else if (textBox1.Text == "") { MessageBox.Show("Не заполненно поле 'Квартира'!"); }
            else if (textBox2.Text == "") { MessageBox.Show("Не заполненно поле 'Фамилия'!"); }
            else if (textBox3.Text == "") { MessageBox.Show("Не заполненно поле 'Имя'!"); }
            else if (textBox4.Text == "") { MessageBox.Show("Не заполненно поле 'Отчество'!"); }
            else if (textBox5.Text == "") { MessageBox.Show("Не указано место работы!"); }
            else if(checkBox1.Checked && textBox7.Text == "") { MessageBox.Show("Не выбрана улица!"); }
            else if (checkBox1.Checked && textBox8.Text == "") { MessageBox.Show("Не выбран дом!"); }
            else if(!checkBox1.Checked && comboBox1.Text == "") { MessageBox.Show("Не выбрана улица!"); }
            else if (!checkBox1.Checked && comboBox2.Text == "") { MessageBox.Show("Не выбран дом!"); }
            else if (comboBox3.Text == "") { MessageBox.Show("Не выбрана страховая компания!"); }
            else if (comboBox4.Text == "") { MessageBox.Show("Не выбрана занятость!"); }
            else if (comboBox5.Text == "") { MessageBox.Show("Не выбран код льготы!"); }
            else
            {
                int addr = 0;

                if (checkBox1.Checked)
                    addr = Convert.ToInt32(DataBase.Scalar("fun_scal_ins_addres", textBox7.Text, textBox8.Text));
                else                
                    addr = Convert.ToInt32(DataBase.Scalar("fun_scal_building", comboBox1.Text, comboBox2.Text));
                //дом!!!

                if (addr != 0)
                {
                    DataBase.Scalar("fun_ins_pacient",
                        maskedTextBox1.Text, textBox2.Text, textBox3.Text, textBox4.Text,
                        DateTime.Today, addr, Convert.ToInt32(textBox1.Text),
                        maskedTextBox2.Text, dateTimePicker1.Value, comboBox3.Text,
                        comboBox5.SelectedValue, textBox6.Text, radioButton1.Checked, textBox5.Text,
                        Convert.ToInt32(comboBox4.SelectedValue));

                    if (!DataBase.HasError)
                    {
                        MessageBox.Show("Регистрация прошла успешно!");
                        reset();
                    }
                    else
                        MessageBox.Show(DataBase.ErrorMessage);
                }
            }
        }

        private void reset()
        {
            textBox1.Text = "";
            textBox2.Text = "";
            textBox3.Text = "";
            textBox4.Text = "";
            textBox5.Text = "";
            textBox6.Text = "";
            maskedTextBox1.Text = "";
            maskedTextBox2.Text = "";
            comboBox1.SelectedIndex = -1;
            comboBox2.SelectedIndex = -1;
            comboBox3.SelectedIndex = -1;
            comboBox4.SelectedIndex = -1;
            comboBox5.SelectedIndex = -1;
            textBox7.Text = "";
            textBox8.Text = "";
            checkBox1.Checked = false;
            dateTimePicker1.Value = DateTime.Today;
            radioButton1.Checked = true;
        }

        private void Content1_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible)
            {
                comboBox1.DataSource = DataBase.Select("view_streets");
                comboBox5.DataSource = DataBase.Select("view_lgots");
                comboBox4.DataSource = DataBase.Select("employments");
                reset();
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            comboBox2.DataSource = DataBase.Select("fun_sel_building", Convert.ToString(comboBox1.SelectedValue));
            comboBox2.SelectedIndex = -1;
        }

        private void textBox7_TextChanged(object sender, EventArgs e)
        {

        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox1.Checked)
            {
                comboBox2.Visible = false;
                comboBox1.Visible = false;
                textBox7.Visible = true;
                textBox8.Visible = true;
            }
            else
            {
                comboBox2.Visible = true;
                comboBox1.Visible = true;
                textBox7.Visible = false;
                textBox8.Visible = false;
            }
        }

        private void comboBox5_DrawItem(object sender, DrawItemEventArgs e)
        {
            if (e.Index > -1)
            {
                //MessageBox.Show("dfgh");
                string text = this.comboBox5.GetItemText(comboBox5.Items[e.Index]);
                e.DrawBackground();
                using (SolidBrush br = new SolidBrush(e.ForeColor))
                {
                    e.Graphics.DrawString(text, e.Font, br, e.Bounds);
                }

                if ((e.State & DrawItemState.Selected) == DrawItemState.Selected)
                {
                    //this.toolTip1.Show(text, comboBox5, e.Bounds.Right, e.Bounds.Bottom);
                    this.toolTip1.Show(text, comboBox5, 0 + comboBox5.Width, 0);
                }
                else
                {
                    this.toolTip1.Hide(comboBox5);
                }
                e.DrawFocusRectangle();
            }
            else this.toolTip1.Hide(comboBox5);
        }
    }
}
