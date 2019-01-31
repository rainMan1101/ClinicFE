using System.Linq;
using System.Windows.Forms;
using PatientProject.UserContents;


namespace PatientProject
{
    public partial class UserForm : Form
    {
        private UserControl[] contents;
        public UserForm()
        {
            InitializeComponent();
            contents = new UserControl[] { new Preview(), new Login(),
                new Rasp(), new AllDoctors(), new Talon(),
                new Doctor(), new Record() };
            this.Controls.AddRange(contents);
            for (int i=0; i < contents.Count(); i++)
            {
                contents[i].Visible = false;
                contents[i].Dock = DockStyle.Fill;
            }
            contents[0].Visible = true;
        }

        public void NextPage(int index)
        {
            contents[index].Visible = true;
        }
    }
}
