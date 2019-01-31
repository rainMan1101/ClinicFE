using System.Collections.Generic;

namespace PatientProject.Classes
{
    /*                  История переходов пациента страницам            */
    public class History
    {
        private static Stack<int> values = new Stack<int>();

        public static Stack<int> Values { get { return values; } }
    }
}
