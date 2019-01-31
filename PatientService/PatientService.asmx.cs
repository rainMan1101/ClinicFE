using System;
using System.Web.Services;
using System.Collections.Generic;
using System.Web.Configuration;
using System.IO;
using System.Data;
using PdfSharp.Pdf;
using PdfSharp.Drawing;
using PdfSharp.Fonts;
using PdfSharp.Pdf.IO;
using Npgsql;
using NpgsqlTypes;


namespace PatientService
{
    [WebService(Namespace = "http://tempuri.org/NumberService")]
    class PatientService : WebService
    {
        private NpgsqlConnection connection;
        private XFont font;
        private XBrush brush;
        private EZFontResolver fontResolver;

        private readonly string talonTemplatePath;
        private readonly string patientsTalonsDir;
        private readonly string couponsDir;
        private readonly string fontTempatePath;
        private readonly string medCard;


        public PatientService()
        {
            string homeDir = WebConfigurationManager.AppSettings["HomeDir"];
            talonTemplatePath = homeDir + WebConfigurationManager.AppSettings["PDFtemplatesDir"] + "talon.pdf";
            patientsTalonsDir = homeDir + WebConfigurationManager.AppSettings["PatientsTalonsDir"];
            couponsDir = WebConfigurationManager.AppSettings["CuponsDir"];

            connection = new NpgsqlConnection(WebConfigurationManager.ConnectionStrings["postgreSQL"].ConnectionString);

            fontTempatePath = homeDir + "times.ttf";
            medCard = "med_card.pdf";

            brush = XBrushes.Black;
            fontResolver = EZFontResolver.Get;
        }


        // Генерация(создание) файла талона на сервере
        [WebMethod]
        public void generateTalon(DateTime pdate, int pdoctor, string ppatient)
        {
            Init();
            PdfDocument document = PdfReader.Open(talonTemplatePath, PdfDocumentOpenMode.Modify);
            PdfPage page = document.Pages[0];
            XGraphics gfx = XGraphics.FromPdfPage(page);


            string coupon, nak, date_and_time, lgot,
            n_polis, snils, FIO_p, gender, birthday, addres,
            employement, FIO_d, date;

            coupon = nak = date_and_time = lgot =
            n_polis = snils = FIO_p = gender = birthday = addres =
            employement = FIO_d = date = "";

            NpgsqlCommand command = new NpgsqlCommand("clinic.fun_sel_talon", connection);
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue(NpgsqlDbType.Date, pdate);
            command.Parameters.AddWithValue(NpgsqlDbType.Integer, pdoctor);
            command.Parameters.AddWithValue(NpgsqlDbType.Char, ppatient);

            try
            {
                connection.Open();
                NpgsqlDataReader reader = command.ExecuteReader();

                while (reader.Read())
                {
                    coupon = Convert.ToString(reader[0]);
                    nak = Convert.ToString(reader[1]);
                    date_and_time = pdate.ToString("dd.MM.yyyy") + "  " + Convert.ToString(reader[2]);
                    lgot = Convert.ToString(reader[3]);
                    n_polis = Convert.ToString(reader[4]);
                    snils = Convert.ToString(reader[5]);
                    FIO_p = Convert.ToString(reader[6]);
                    gender = Convert.ToString(reader[7]);
                    DateTime datetime = Convert.ToDateTime(reader[8]);
                    birthday = datetime.ToString("dd.MM.yyyy");
                    addres = Convert.ToString(reader[9]);
                    employement = Convert.ToString(reader[10]);
                    FIO_d = Convert.ToString(reader[11]);
                }
            }
            finally { connection.Close(); }

            gfx.DrawString(coupon, font, brush, 440, 148);//Номер талона
            gfx.DrawString(nak, font, brush, 260, 165);//Номер АК
            gfx.DrawString(date_and_time, font, brush, 370, 165);//Дата         
            gfx.DrawString(lgot, font, brush, 180, 195);//
            gfx.DrawString(n_polis, font, brush, 240, 212);//Номер полиса
            gfx.DrawString(snils, font, brush, 100, 229);//Снилс
            gfx.DrawString(FIO_p, font, brush, 260, 249);//ФИО
            gfx.DrawString(gender, font, brush, 90, 265);//Пол
            gfx.DrawString(birthday, font, brush, 370, 265);//Дата рождения
            gfx.DrawString(addres, font, brush, 300, 300);//Адрес
            gfx.DrawString("Городской", font, brush, 120, 317);//-
            gfx.DrawString(employement, font, brush, 320, 333);//Занятость
            gfx.DrawString(FIO_d, font, brush, 310, 368);//ФИО врача
            gfx.DrawString("ОМС", font, brush, 140, 385);//-

            if (nak == null || nak == "") throw new Exception("empty NAK");
            string path = patientsTalonsDir + nak + couponsDir;
            if (!Directory.Exists(path)) Directory.CreateDirectory(path);

            path = path + Convert.ToString(pdoctor) + ";" + pdate.ToString("dd.MM.yyyy") + ".pdf";
            document.Save(path);
        }


        // Получение файла талона с сервера
        [WebMethod]
        public byte[] getTalon(DateTime pdate, int pdoctor, string ppatient)
        {
            Init();
            NpgsqlCommand command = new NpgsqlCommand("clinic.fun_scal_get_nak", connection);
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue(NpgsqlDbType.Char, ppatient);
            string nak = "";

            try
            {
                connection.Open();
                object obj = command.ExecuteScalar();
                if (obj != null) nak = Convert.ToString(obj);
            }
            finally { connection.Close(); }

            byte[] binary_array = null;
            if (nak == null || nak == "")
                throw new Exception("empty NAK");

            string path = patientsTalonsDir + nak + couponsDir;
            path = path + Convert.ToString(pdoctor) + ";" + pdate.ToString("dd.MM.yyyy") + ".pdf";

            if (File.Exists(path)) binary_array = File.ReadAllBytes(path);
            return binary_array;
        }


        // Получение файла медицинской карты с сервера
        [WebMethod]
        public byte[] getMedCard(string ppatient)
        {
            Init();
            NpgsqlCommand command = new NpgsqlCommand("clinic.fun_scal_get_nak", connection);
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue(NpgsqlDbType.Char, ppatient);
            string nak = "";

            try
            {
                connection.Open();
                object obj = command.ExecuteScalar();
                if (obj != null) nak = Convert.ToString(obj);
            }
            finally { connection.Close(); }

            byte[] binary_array = null;
            if (nak == null || nak == "")
                throw new Exception("empty NAK");
            string path = patientsTalonsDir + nak + medCard;

            if (File.Exists(path)) binary_array = File.ReadAllBytes(path);
            return binary_array;
        }

        private void Init()
        {

            GlobalFontSettings.FontResolver = fontResolver;
            fontResolver.AddFont("Times New Roman", XFontStyle.Regular, fontTempatePath, true, true);

            // Устанавливаю кодировку - UNICODE
            XPdfFontOptions options = new XPdfFontOptions(PdfFontEncoding.Unicode, PdfFontEmbedding.Always);
            // Устанавливаю шрифт
            font = new XFont("Times New Roman", 12);
        }
    }

    // Класс, для использования своего файла шрифтов для PDF - документа
    public class EZFontResolver : IFontResolver
    {
        private static EZFontResolver _singleton;
        private readonly Dictionary<string, EZFontInfo> _fonts = new Dictionary<string, EZFontInfo>();

        EZFontResolver() { }
        struct EZFontInfo
        {
            internal string FaceName;
            internal byte[] Data;
            internal bool SimulateBold;
            internal bool SimulateItalic;
        }

        public static EZFontResolver Get
        {
            get
            {
                return _singleton ?? (_singleton = new EZFontResolver());
            }
        }

        public void AddFont(string familyName, XFontStyle style, string filename,
            bool simulateBold = false, bool simulateItalic = false)
        {
            using (var fs = new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                var size = fs.Length;
                if (size > int.MaxValue)
                    throw new Exception("Font file is too big.");
                var length = (int)size;
                var data = new byte[length];
                var read = fs.Read(data, 0, length);
                if (length != read)
                    throw new Exception("Reading font file failed.");
                AddFont(familyName, style, data, simulateBold, simulateItalic);
            }
        }

        public void AddFont(string familyName, XFontStyle style, byte[] data,
            bool simulateBold = false, bool simulateItalic = false)
        {
            // Add the font as we get it.
            AddFontHelper(familyName, style, data, false, false);

            // If the font is not bold and bold simulation is requested, add that, too.
            if (simulateBold && (style & XFontStyle.Bold) == 0)
            {
                AddFontHelper(familyName, style | XFontStyle.Bold, data, true, false);
            }

            // Same for italic.
            if (simulateItalic && (style & XFontStyle.Italic) == 0)
            {
                AddFontHelper(familyName, style | XFontStyle.Italic, data, false, true);
            }

            // Same for bold and italic.
            if (simulateBold && (style & XFontStyle.Bold) == 0 &&
                simulateItalic && (style & XFontStyle.Italic) == 0)
            {
                AddFontHelper(familyName, style | XFontStyle.BoldItalic, data, true, true);
            }
        }

        void AddFontHelper(string familyName, XFontStyle style, byte[] data, bool simulateBold, bool simulateItalic)
        {
            // Currently we do not need FamilyName and Style.
            // FaceName is a combination of FamilyName and Style.
            var fi = new EZFontInfo
            {
                //FamilyName = familyName,
                FaceName = familyName.ToLower(),
                //Style = style,
                Data = data,
                SimulateBold = simulateBold,
                SimulateItalic = simulateItalic
            };
            if ((style & XFontStyle.Bold) != 0)
            {
                // TODO Create helper method to prevent having duplicate string literals?
                fi.FaceName += "|b";
            }
            if ((style & XFontStyle.Italic) != 0)
            {
                fi.FaceName += "|i";
            }

            // Check if we already have this font.
            var test = GetFont(fi.FaceName);
            if (test == null)
                _fonts.Add(fi.FaceName.ToLower(), fi);
        }

#region IFontResolver
        public FontResolverInfo ResolveTypeface(string familyName, bool isBold, bool isItalic)
        {
            string faceName = familyName.ToLower() +
                (isBold ? "|b" : "") +
                (isItalic ? "|i" : "");
            EZFontInfo item;
            if (_fonts.TryGetValue(faceName, out item))
            {
                var result = new FontResolverInfo(item.FaceName, item.SimulateBold, item.SimulateItalic);
                return result;
            }
            return null;
        }

        public byte[] GetFont(string faceName)
        {
            EZFontInfo item;
            if (_fonts.TryGetValue(faceName, out item))
            {
                return item.Data;
            }
            return null;
        }
#endregion
    }
}
