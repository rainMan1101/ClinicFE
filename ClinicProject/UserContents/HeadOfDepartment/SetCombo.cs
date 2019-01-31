using System;


namespace ClinicProject.UserContents.HeadOfDepartment
{
    internal class SetCombo
    {
        public static TimeSpan[] SetBegin()
        {
            return new TimeSpan[] {
                    new TimeSpan(9, 0, 0), new TimeSpan(9, 30, 0), new TimeSpan(10, 0, 0),
                    new TimeSpan(10, 30, 0), new TimeSpan(11, 0, 0), new TimeSpan(11, 30, 0),
                    new TimeSpan(12, 0, 0)
            };
        }

        public static TimeSpan[] SetEnd()
        {
            return new TimeSpan[] {
                    new TimeSpan(13, 0, 0), new TimeSpan(13, 30, 0), new TimeSpan(14, 0, 0),
                    new TimeSpan(14, 30, 0), new TimeSpan(15, 0, 0), new TimeSpan(15, 30, 0),
                    new TimeSpan(16, 0, 0), new TimeSpan(16, 30, 0), new TimeSpan(17, 0, 0),
                    new TimeSpan(18, 0, 0)
            };
        }

        public static int[] SetTime()
        {
            return new int[] { 10, 12, 15, 20, 25, 30 };
        }
    }
}
