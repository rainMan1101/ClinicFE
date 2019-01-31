using System;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;


namespace PatientProject.UserContents
{
    public partial class MyMenu : UserControl
    {
        public MyMenu(params string[] text)
        {
            InitializeComponent();
            //this.Pa

            for (int i = text.Count() - 1; i >= 0; i--)
            {
                Label label = new Label();
                label.Dock = DockStyle.Top;
                label.Name = "label" + Convert.ToString(i + 1);//!!
                label.Padding = new Padding(12, 0, 12, 0);
                label.Size = new Size(150, 70);
                label.TabIndex = i;//!!
                label.Text = text[i];//!!
                label.TextAlign = ContentAlignment.MiddleCenter;
                label.Click += new EventHandler(this.label_Click);
                this.Controls.Add(label);
            }
        }

        private void label_Click(object sender, EventArgs e)
        {
            set_all();
            ((Label)sender).BackColor = Color.Purple;
            ((Label)sender).ForeColor = Color.White;
        }

        private void set_all()
        {
            for (int i = 0; i < this.Controls.Count; i++)
            {
                ((Label)this.Controls[i]).BackColor = Color.White;
                ((Label)this.Controls[i]).ForeColor = Color.Black;
            }
        }
    }
}
