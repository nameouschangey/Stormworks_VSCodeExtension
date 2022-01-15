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
using System.Globalization;

namespace STORMWORKS_Simulator
{
    [Export(typeof(IPipeCommandHandler))]
    public class SetInput : IPipeCommandHandler
    {
        public string Command => "INPUT";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 65)
            {
                return;
            }
            for (var i = 0; i < 32; ++i)
            {
                vm.Inputs[i].BoolValue = commandParts[(i * 2) + 1] == "1";

                var numberValue = commandParts[(i * 2) + 2];
                if(numberValue == "INF")
                {
                    vm.Inputs[i].NumberValue = float.PositiveInfinity;
                }
                else if(numberValue == "-INF")
                {
                    vm.Inputs[i].NumberValue = float.NegativeInfinity;
                }
                else if (numberValue.Contains("NAN"))
                {
                    vm.Inputs[i].NumberValue = float.NaN;
                }
                else
                {
                    vm.Inputs[i].NumberValue = float.Parse(numberValue, CultureInfo.InvariantCulture);
                }
            }
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class SetOutput : IPipeCommandHandler
    {
        public string Command => "OUTPUT";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 65)
            {
                return;
            }
            for (var i = 0; i < 32; ++i)
            {
                vm.Outputs[i].BoolValue = commandParts[(i * 2) + 1] == "1";

                var numberValue = commandParts[(i * 2) + 2];
                if (numberValue == "INF")
                {
                    vm.Inputs[i].NumberValue = float.PositiveInfinity;
                }
                else if (numberValue == "-INF")
                {
                    vm.Inputs[i].NumberValue = float.NegativeInfinity;
                }
                else if (numberValue.Contains("NAN"))
                {
                    vm.Inputs[i].NumberValue = float.NaN;
                }
                else
                {
                    vm.Inputs[i].NumberValue = float.Parse(numberValue, CultureInfo.InvariantCulture);
                }
            }
        }
    }
}
