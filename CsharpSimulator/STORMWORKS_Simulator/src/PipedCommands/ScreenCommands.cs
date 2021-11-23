using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.ComponentModel.Composition;

namespace STORMWORKS_Simulator
{
    [Export(typeof(IPipeCommandHandler))]
    public class ScreenPower : IPipeCommandHandler
    {
        public bool CanHandle(string commandName) => commandName == "SCREENCONFIG";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 5)
            {
                return;
            }

            var screenNumber = int.Parse(commandParts[1]);
            var isPowered       = commandParts[2] == "1";
            var sizeDescriptor  = commandParts[3];
            var isPortrait      = commandParts[4] == "1";

            var screen = vm.GetOrAddScreen(screenNumber);
            screen.IsPowered = isPowered;
            screen.ScreenResolutionDescription = sizeDescriptor;
            screen.IsPortrait = isPortrait;
        }
    }
}
