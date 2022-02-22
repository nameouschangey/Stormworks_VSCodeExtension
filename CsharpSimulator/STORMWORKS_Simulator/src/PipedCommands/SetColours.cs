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
using System.Reflection;
using SkiaSharp;
using System.Globalization;

namespace STORMWORKS_Simulator
{
    public class ColourHelper
    {
        public static SKColor ColourFromCommandParts(string[] commandParts)
        {

            var r = Convert.ToByte(((int)float.Parse(commandParts[1], CultureInfo.InvariantCulture))%256);
            var g = Convert.ToByte(((int)float.Parse(commandParts[2], CultureInfo.InvariantCulture))%256);
            var b = Convert.ToByte(((int)float.Parse(commandParts[3], CultureInfo.InvariantCulture))%256);
            var a = Convert.ToByte(((int)float.Parse(commandParts[4], CultureInfo.InvariantCulture))%256);

            return new SKColor(r, g, b, a);
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class SetColour : IPipeCommandHandler
    {
        public string Command => "COLOUR";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 5)
            {
                return;
            }

            vm.Color = ColourHelper.ColourFromCommandParts(commandParts);
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class SetMapOceanColour : IPipeCommandHandler
    {
        public string Command => "MAPOCEAN";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 5)
            {
                return;
            }

            vm.MapOceanColour = ColourHelper.ColourFromCommandParts(commandParts);
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class SetMapShallows : IPipeCommandHandler
    {
        public string Command => "MAPSHALLOWS";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 5)
            {
                return;
            }

            vm.MapShallowsColour = ColourHelper.ColourFromCommandParts(commandParts);
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class SetMapLandColour : IPipeCommandHandler
    {
        public string Command => "MAPLAND";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 5)
            {
                return;
            }

            vm.MapLandColour = ColourHelper.ColourFromCommandParts(commandParts);
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class SetMapSandColour : IPipeCommandHandler
    {
        public string Command => "MAPSAND";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 5)
            {
                return;
            }

            vm.MapSandColour = ColourHelper.ColourFromCommandParts(commandParts);
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class SetMapGrassColour : IPipeCommandHandler
    {
        public string Command => "MAPGRASS";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 5)
            {
                return;
            }

            vm.MapGrassColour = ColourHelper.ColourFromCommandParts(commandParts);
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class SetMapSnowColour : IPipeCommandHandler
    {
        public string Command => "MAPSNOW";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 5)
            {
                return;
            }

            vm.MapSnowColour = ColourHelper.ColourFromCommandParts(commandParts);
        }
    }
}
