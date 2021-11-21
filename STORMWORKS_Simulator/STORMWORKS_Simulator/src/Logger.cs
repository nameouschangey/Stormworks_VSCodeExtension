﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace STORMWORKS_Simulator
{
    public static class Logger
    {
        private static string Logfile;

        public static void SetLog(string path)
        {
            Logfile = path;
#if DEBUG
            System.IO.File.WriteAllText(Logfile, "");
#endif
        }

        public static void Log(string message)
        {
#if DEBUG
            System.IO.File.AppendAllText(Logfile, message + "\n");
#endif
        }
    }
}