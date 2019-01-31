using System;
using System.Windows.Forms;
using PatientProject.Classes;


namespace PatientProject.UserContents
{
    public partial class Preview : UserControl
    {
        public Preview()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            History.Values.Push(0);
            ((UserForm)this.Parent).NextPage(2);
            this.Hide();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Info.Page = 3; // Страница, на которую нужно зайти после логина
            History.Values.Push(0);
            ((UserForm)this.Parent).NextPage(1); // 1 - Страница логина
            this.Hide();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            Info.Page = 4;
            History.Values.Push(0);
            ((UserForm)this.Parent).NextPage(1);
            this.Hide();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            Info.Page = 100;
            History.Values.Push(0);
            ((UserForm)this.Parent).NextPage(1);
            this.Hide();
        }
    }
}
