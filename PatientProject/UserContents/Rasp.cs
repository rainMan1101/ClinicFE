using System;
using System.Windows.Forms;
using PatientProject.Classes;
using DataBaseTools;
using DataBaseTools.FieldsInfo;


namespace PatientProject.UserContents
{
    public partial class Rasp : UserControl
    {
        private int menu;

        public Rasp()
        {
            InitializeComponent();
            menu = 1;
            ColumnsCreator.GetData(dataGridView1, "fun_sel_graph_with_office_and_date");

            dateTimePicker1.MinDate = DateTime.Today;
            dateTimePicker1.MaxDate = DateTime.Today.AddMonths(1);


            this.panel3.Controls.Add(new MyMenu(
                "Терапевтическое отделение",
                "Хирургическое отделение",
                "Детское отделение",
                "Стоматологическое отделение"
                 ));
            ((Label)panel3.Controls[0].Controls[0]).Click += new System.EventHandler(this.label5_Click);
            ((Label)panel3.Controls[0].Controls[1]).Click += new System.EventHandler(this.label4_Click);
            ((Label)panel3.Controls[0].Controls[2]).Click += new System.EventHandler(this.label3_Click);
            ((Label)panel3.Controls[0].Controls[3]).Click += new System.EventHandler(this.label2_Click);
        }

        private void label2_Click(object sender, EventArgs e)
        {
            menu = 1;
            dateTimePicker1_ValueChanged(sender, e);
        }

        private void label3_Click(object sender, EventArgs e)
        {
            menu = 2;
            dateTimePicker1_ValueChanged(sender, e);
        }

        private void label4_Click(object sender, EventArgs e)
        {
            menu = 3;
            dateTimePicker1_ValueChanged(sender, e);
        }

        private void label5_Click(object sender, EventArgs e)
        {
            menu = 4;
            dateTimePicker1_ValueChanged(sender, e);
        }

        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {
            dataGridView1.DataSource = DataBase.Select("fun_sel_graph_with_office_and_date", menu, dateTimePicker1.Value);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            dateTimePicker1.Value = DateTime.Today;
            label2_Click(sender, e);
            ((UserForm)this.Parent).NextPage(History.Values.Pop());
            this.Hide();
        }

        private void Rasp_VisibleChanged(object sender, EventArgs e)
        {
            if (this.Visible) dateTimePicker1.Value = DateTime.Today;
        }
    }
}
