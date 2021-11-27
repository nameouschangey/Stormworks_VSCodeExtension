using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace STORMWORKS_Simulator
{
    public static class Logger
    {
        private static string Logfile;
        public static bool Enabled;
        public static bool ErrorEnabled = true;

        public static void SetLog(string path, bool enabled = true, bool errorEnabled = true)
        {
            Enabled = enabled;
            ErrorEnabled = errorEnabled;
            Logfile = path;
#if DEBUG
            System.IO.File.WriteAllText(Logfile, "");
#endif
        }

        public static void Log(string message)
        {
#if DEBUG
            if (Enabled)
            {

                System.IO.File.AppendAllText(Logfile, message + "\n");

            }
#endif

        }

        public static void Error(string message)
        {
#if DEBUG
            if (ErrorEnabled)
            {

                System.IO.File.AppendAllText(Logfile, "ERROR: " + message + "\n");

            }
#endif
        }
    }
}
