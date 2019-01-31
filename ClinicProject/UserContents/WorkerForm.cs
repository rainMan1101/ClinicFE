using System;
using System.Windows.Forms;
using ClinicProject.Classes;


namespace ClinicProject.UserContents
{
    public partial class WorkerForm : Form
    {
        private UserControl[] contents;
        public WorkerForm()
        {
            InitializeComponent();
            contents = new UserControl[] { new Login(), new WorkSpace()};
            this.Controls.AddRange(contents);
            LoginInfo.account = 'N';
            contents[1].Dock = DockStyle.Fill;
            contents[0].Dock = DockStyle.Fill;
            contents[0].VisibleChanged += new System.EventHandler(this.CloseLogin_MeakeContent);
            contents[0].Visible = true;
        }

        //перехват закрытия Логин - контента
        private void CloseLogin_MeakeContent(object sender, EventArgs e)
        {
            if (LoginInfo.account == 'G' || LoginInfo.account == 'Z' || LoginInfo.account == 'R')
            {
                int count;
                switch (LoginInfo.account)
                {
                    case 'G':
                        //подгружаю меню 
                        ((WorkSpace)contents[1]).panel2.Controls.Add(new MyMenu(
                                "Просмотр информации о сотрудниках",
                                "Зачислить сотрудника в штат"));
                        //подгружаю контент
                        UserControl[] cont_head = new UserControl[] { new Head.Content1(), new Head.Content2() };
                        ((WorkSpace)contents[1]).panel3.Controls.AddRange(cont_head);
                        break;
                    case 'Z':
                        ((WorkSpace)contents[1]).panel2.Controls.Add(new MyMenu(
                                "Просмотр и изменение графиков работы врачей",
                                "Составление графиков работы врачей"));
                        UserControl[] cont_admin = new UserControl[] {
                            new HeadOfDepartment.Content1(), new HeadOfDepartment.Content2()
                        };
                        ((WorkSpace)contents[1]).panel3.Controls.AddRange(cont_admin);
                        break;
                    case 'R':
                        ((WorkSpace)contents[1]).panel2.Controls.Add(new MyMenu(
                                "Регистрация пациента",
                                "Запись пациента на прием к участковому врачу",
                                "Пациенты",
                                "Просмотр расписания врачей"));
                        UserControl[] cont_registrator = new UserControl[] {
                            new Registrar.Content1(), new Registrar.Content2(),
                            new Registrar.Content3(), new Registrar.Content4()
                        };
                        ((WorkSpace)contents[1]).panel3.Controls.AddRange(cont_registrator);
                        break;
                }

                //скрываю контент при запуске
                count = ((WorkSpace)contents[1]).panel3.Controls.Count;
                for (int i = 0; i < count; i++) ((WorkSpace)contents[1]).panel3.Controls[i].Visible = false;
                //устанавливаю для всех кнопок меню один обработчик
                count = ((WorkSpace)contents[1]).panel2.Controls[0].Controls.Count;
                for (int i = 0; i < count; i++)
                {
                    ((WorkSpace)contents[1]).panel2.Controls[0].Controls[i].Click +=
                        new System.EventHandler(((WorkSpace)contents[1]).ClickMenu);
                }
                //отображаю личные данные в верху формы
                ((WorkSpace)contents[1]).panel6.Controls["label2"].Text = LoginInfo.last_name + " " +
                    LoginInfo.first_name.Substring(0,1) + "." + LoginInfo.middle_name.Substring(0, 1) + ".";
                ((WorkSpace)contents[1]).panel6.Controls["label3"].Text = LoginInfo.post;
            }
        }
    }
}
