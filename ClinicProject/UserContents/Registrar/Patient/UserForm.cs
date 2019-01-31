using System;
using System.Linq;
using System.Windows.Forms;


namespace ClinicProject.UserContents.Registrar.Patient
{
    public partial class UserForm : Form
    {
        private UserControl[] contents;
        private string number_polis;
        
        public UserForm(string polis)
        {
            number_polis = polis;
            InitializeComponent();
            contents = new UserControl[] {
                new User.Content1(number_polis), new User.Content2(number_polis), new User.Content3(number_polis)
            };
            this.panel2.Controls.AddRange(contents);
            for (int i=0; i < contents.Count(); i++)
            {
                contents[i].Visible = false;
                contents[i].Dock = DockStyle.Fill;
            }
            contents[0].Visible = true;
            this.panel1.Controls.Add(new MyMenu(
                "Запись к врачу на прием",
                "Выдача талона"));

            ((Label)panel1.Controls[0].Controls[0]).Click += new System.EventHandler(this.ClickMenu);
            ((Label)panel1.Controls[0].Controls[1]).Click += new System.EventHandler(this.ClickMenu);
        }

        public void ClickMenu(object sender, EventArgs e)
        {
            int index = 0; 
            for (int i = 0; i < this.panel1.Controls[0].Controls.Count; i++)
                if (this.panel1.Controls[0].Controls[i] == sender)
                { index = Convert.ToInt32((((Label)sender).Name).Replace("label", "")) - 1; break; }
            //все элементы меню должны иметь имя label с последовательной нумерацией

            for (int i = 0; i < this.panel2.Controls.Count; i++) this.panel2.Controls[i].Visible = false;
            this.panel2.Controls[index].Visible = true;
        }
    }
}
