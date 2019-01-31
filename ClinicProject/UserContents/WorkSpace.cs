using System;
using System.Windows.Forms;


namespace ClinicProject.UserContents
{
    public partial class WorkSpace : UserControl
    {
        public WorkSpace()
        {
            InitializeComponent();
        }

        //перехват нажатий кнопок меню
        public void ClickMenu(object sender, EventArgs e)
        {
            int index = 0; //во избегании вылетов

            for (int i = 0; i < this.panel2.Controls[0].Controls.Count; i++)
                if (this.panel2.Controls[0].Controls[i] == sender)
                { index = Convert.ToInt32((((Label)sender).Name).Replace("label", ""))- 1; break; }
            //все элементы меню должны иметь имя label с последовательной нумерацией

            for (int i = 0; i < this.panel3.Controls.Count; i++) this.panel3.Controls[i].Visible = false;
            this.panel3.Controls[index].Visible = true;
        }
    }
}
