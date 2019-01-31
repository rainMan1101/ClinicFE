using System;
using System.Windows.Forms;
using PatientProject.Classes;


namespace PatientProject.UserContents
{
    public partial class AllDoctors : UserControl
    {
        public AllDoctors()
        {
            InitializeComponent();
        }

        private void Next()
        {
            History.Values.Push(3);
            ((UserForm)this.Parent).NextPage(5);
            this.Hide();
        }

        private void button1_Click(object sender, EventArgs e) { Info.Post = 1; Next(); }
        private void button22_Click(object sender, EventArgs e) { Info.Post = 2; Next(); }
        private void button21_Click(object sender, EventArgs e) { Info.Post = 3; Next(); }
        private void button20_Click(object sender, EventArgs e) { Info.Post = 4; Next(); }
        private void button19_Click(object sender, EventArgs e) { Info.Post = 5; Next(); }
        private void button18_Click(object sender, EventArgs e) { Info.Post = 6; Next(); }
        private void button17_Click(object sender, EventArgs e) { Info.Post = 7; Next(); }
        private void button16_Click(object sender, EventArgs e) { Info.Post = 8; Next(); }
        private void button15_Click(object sender, EventArgs e) { Info.Post = 9; Next(); }
        private void button14_Click(object sender, EventArgs e) { Info.Post = 10; Next(); }
        private void button13_Click(object sender, EventArgs e) { Info.Post = 11; Next(); }
        private void button12_Click(object sender, EventArgs e) { Info.Post = 12; Next(); }
        private void button11_Click(object sender, EventArgs e) { Info.Post = 13; Next(); }
        private void button10_Click(object sender, EventArgs e) { Info.Post = 14; Next(); }
        private void button9_Click(object sender, EventArgs e) { Info.Post = 15; Next(); }
        private void button8_Click(object sender, EventArgs e) { Info.Post = 16; Next(); }
        private void button7_Click(object sender, EventArgs e) { Info.Post = 17; Next(); }
        private void button6_Click(object sender, EventArgs e) { Info.Post = 18; Next(); }
        private void button2_Click(object sender, EventArgs e) { Info.Post = 19; Next(); }
        private void button3_Click(object sender, EventArgs e) { Info.Post = 20; Next(); }
        private void button4_Click(object sender, EventArgs e) { Info.Post = 21; Next(); }
        private void button5_Click(object sender, EventArgs e) { Info.Post = 22; Next(); }

        private void button23_Click(object sender, EventArgs e)
        {
            ((UserForm)this.Parent).NextPage(History.Values.Pop());
            this.Hide();
        }
    }
}
