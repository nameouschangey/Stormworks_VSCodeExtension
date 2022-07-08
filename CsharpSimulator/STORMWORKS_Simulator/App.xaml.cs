using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;

namespace STORMWORKS_Simulator
{
    public class CommandLineArgs
    {
        public bool EnableLogging { get; private set; } = false;
        public string LogFilepath { get; private set; }

        public CommandLineArgs(string[] args)
        {
            for (var i = 0; i < args.Length; ++i)
            {
                var arg = args[i];

                if (arg == "-logfile")
                {
                    EnableLogging = true;
                    LogFilepath = args[++i];
                }
            }
        }
    }

    public partial class App : Application
    {
        MainWindow Window;

        public void AppStart(object sender, StartupEventArgs e)
        {
            //var info = System.Globalization.CultureInfo.GetCultureInfoByIetfLanguageTag("ru");
            //System.Globalization.CultureInfo.CurrentCulture = info;
            //System.Globalization.CultureInfo.DefaultThreadCurrentCulture = info;
            //System.Globalization.CultureInfo.DefaultThreadCurrentUICulture = info;

            var args = new CommandLineArgs(e.Args);
            Window = new MainWindow(args);
            Window.Show();
        }
    }
}
