using System;
using System.Web.Services;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Configuration;


namespace ImageService
{
    [WebService(Namespace = "http://tempuri.org/")]
    public class ImageService : System.Web.Services.WebService
    {
        private string imagePath = ConfigurationManager.AppSettings["ImagePath"];

        // filePath - название фйла, хранимого в базе
        // imagePath - папка с изображениями на сервере

        // Загрузка и сохранение изображения на сервере
        [WebMethod]
        public string SaveImage(byte[] binary_array, string format_string)
        {
            ImageFormat format;
            if (format_string == ".png") format = ImageFormat.Png;
            else if (format_string == ".jpg") format = ImageFormat.Jpeg;
            else if (format_string == ".bmp") format = ImageFormat.Bmp;
            else return ""; //!!!

            //make Image object
            MemoryStream memoryStream = new MemoryStream();
            foreach (byte b in binary_array) memoryStream.WriteByte(b);
            Image image = Image.FromStream(memoryStream);

            //check Dir
            //string path = @"/home/user/Clinic/Images";
            if (!Directory.Exists(imagePath))
                Directory.CreateDirectory(imagePath);

            //make Filename
            string[] dirs = Directory.GetFiles(imagePath, "image_*");
            string file;
            int counter = 0;
            do
            {
                int number_of_file = dirs.Length + counter;
                file = "image_" + number_of_file + format_string;
                counter++;
            } while (File.Exists(imagePath + file));

            //Save file
            image.Save(imagePath + file, format);
            return file;
        }


        //  Получение изображения с сервера
        [WebMethod]
        public byte[] LoadImage(string file_path)
        {
            file_path = imagePath + file_path;

            if (File.Exists(file_path))
            {
                //get Format of image
                ImageFormat format;
                int index = file_path.LastIndexOf('.');
                string format_string = file_path.Substring(index, file_path.Length - index);

                if (format_string == ".png") format = ImageFormat.Png;
                else if (format_string == ".jpg") format = ImageFormat.Jpeg;
                else if (format_string == ".bmp") format = ImageFormat.Bmp;
                else return null; //!!!

                //Image to binary array
                Image image = Image.FromFile(file_path);
                MemoryStream memoryStream = new MemoryStream();
                image.Save(memoryStream, format);
                byte[] binary_array = memoryStream.ToArray();
                return binary_array;
            }
            else return null;
        }


        // Удаление изображения с сервера
        [WebMethod]
        public void RemoveImage(string file_path)
        {
            if (File.Exists(imagePath + file_path))
                File.Delete(imagePath + file_path);
        }
    }
}
