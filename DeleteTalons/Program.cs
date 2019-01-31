using System;
using System.IO;

namespace DeleteTalons
{
    internal class MainClass
    {
        
        /*                      Программа, удаляющая талоны за пошедшую дату. 
         *      Вызывается каждую минуту утилитой cron. Расписание запуска в файле /etc/crontab
         */
        public static void Main(string[] args)
        {
			string path = @"/home/user/Clinic/Patients";

            //  Список папок, названия которых соответствуют номерам амбулаторных карт пациентов
			string[] list_dir =  Directory.GetDirectories(path);


			for (int i = 0; i < list_dir.Length; i++)
			{
				string current_path = list_dir[i] + @"/coupons/";

				if (Directory.Exists(current_path))
                {

                    //  Список названий талонов пациента
                    string[] list_files = Directory.GetFiles(current_path);

					for (int j = 0; j < list_files.Length; j++)
					{                  
						int second_point = list_files[j].LastIndexOf('.');
						int first_point = list_files[j].LastIndexOf('|') +1;

						if (second_point != -1 && first_point != -1) {
							DateTime dt;
							try
							{
                                //  Выделение даты талона из его названия
                                dt = DateTime.Parse(
                                    list_files[j].Substring(first_point, second_point - first_point)
                                    );
							}
							catch (Exception) { continue; }

                            //  Удаление, если талон за прошедшую дату
							if (dt < DateTime.Today){
								File.Delete(list_files[j]);
							} 
						}
						    
					}
				}
				else continue;
			}

        }
    }
}
