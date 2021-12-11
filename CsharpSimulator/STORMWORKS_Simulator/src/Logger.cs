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
        public static bool InfoEnabled;
        public static bool ErrorEnabled = true;
        public static object LogLock = new object();

        public static void SetLog(string path, bool enabled = true, bool errorEnabled = true)
        {
            InfoEnabled = enabled;
            ErrorEnabled = errorEnabled;
            Logfile = path;

            if (enabled && Logfile != null)
            {
                System.IO.File.WriteAllText(Logfile, "");
            }
        }

        public static void Log(string message)
        {
            if (InfoEnabled && Logfile != null)
            {
                lock (LogLock)
                {
                    System.IO.File.AppendAllText(Logfile, DateTime.UtcNow.ToString() + " " + message + "\n");
                }
            }
        }

        public static void Error(string message)
        {
            if (ErrorEnabled && Logfile != null)
            {
                lock (LogLock)
                {
                    System.IO.File.AppendAllText(Logfile, "\n" + DateTime.UtcNow.ToString() + " " + message + "\n\n");
                }
            }
        }
    }
}
