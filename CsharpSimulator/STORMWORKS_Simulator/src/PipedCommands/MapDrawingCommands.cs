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

namespace STORMWORKS_Simulator
{
    [Export(typeof(IPipeCommandHandler))]
    public class DrawMap : IPipeCommandHandler
    {
        public string Command => "MAP";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 5)
            {
                return;
            }

            var screenNumber = int.Parse(commandParts[1]);
            var screen = vm.GetScreen(screenNumber);

            var x = double.Parse(commandParts[2]);
            var y = double.Parse(commandParts[3]);
            var zoom = 1 - (double.Parse(commandParts[4]) / 50);  // 0.1 -> 50

            x *= zoom * 50;
            y *= zoom * 50;

            var buffer = screen.BitmapCanvas;
            buffer.FillRectangle(0, 0, buffer.PixelWidth, buffer.PixelHeight, vm.MapOceanColour);

            DrawIsland(vm, buffer,(int)(x/50000 * buffer.PixelWidth) + (buffer.PixelWidth / 5), (int)(y / 50000 * buffer.PixelHeight) + buffer.PixelHeight / 5,     zoom * buffer.PixelWidth / 5, zoom * buffer.PixelHeight / 3);
            DrawIsland(vm, buffer,(int)(x/50000 * buffer.PixelWidth) + (2 * buffer.PixelWidth / 3), (int)(y / 50000 * buffer.PixelHeight) + 2 * buffer.PixelHeight / 3, zoom * buffer.PixelWidth / 3, zoom * buffer.PixelHeight / 5);
        }

        private void DrawIsland(MainVM vm, WriteableBitmap buffer, int x, int y, double width, double length)
        {
            buffer.FillEllipseCentered(x, y, (int)width, (int)length, vm.MapShallowsColour);

            buffer.FillEllipseCentered(x, y, (int)(width * 0.9), (int)(length * 0.9), vm.MapShallowsColour);
            buffer.FillEllipseCentered(x, y, (int)(width * 0.8), (int)(length * 0.8), vm.MapSandColour);
            buffer.FillEllipseCentered(x, y, (int)(width * 0.7), (int)(length * 0.7), vm.MapLandColour);
            buffer.FillEllipseCentered(x, y, (int)(width * 0.6), (int)(length * 0.6), vm.MapGrassColour);
            buffer.FillEllipseCentered((int)(x+width * 0.1), (int)(y+length * 0.1), (int)(width * 0.1), (int)(length * 0.1), vm.MapSnowColour);
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

            var r = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[1]))));
            var g = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[2]))));
            var b = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[3]))));
            var a = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[4]))));

            var colour = Color.FromArgb(a, r, g, b);

            vm.MapOceanColour = WriteableBitmapExtensions.ConvertColor(colour);
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

            var r = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[1]))));
            var g = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[2]))));
            var b = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[3]))));
            var a = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[4]))));

            var colour = Color.FromArgb(a, r, g, b);

            vm.MapShallowsColour = WriteableBitmapExtensions.ConvertColor(colour);
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

            var r = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[1]))));
            var g = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[2]))));
            var b = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[3]))));
            var a = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[4]))));

            var colour = Color.FromArgb(a, r, g, b);

            vm.MapLandColour = WriteableBitmapExtensions.ConvertColor(colour);
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

            var r = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[1]))));
            var g = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[2]))));
            var b = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[3]))));
            var a = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[4]))));

            var colour = Color.FromArgb(a, r, g, b);

            vm.MapSandColour = WriteableBitmapExtensions.ConvertColor(colour);
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

            var r = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[1]))));
            var g = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[2]))));
            var b = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[3]))));
            var a = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[4]))));

            var colour = Color.FromArgb(a, r, g, b);

            vm.MapGrassColour = WriteableBitmapExtensions.ConvertColor(colour);
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

            var r = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[1]))));
            var g = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[2]))));
            var b = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[3]))));
            var a = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[4]))));

            var colour = Color.FromArgb(a, r, g, b);

            vm.MapSnowColour = WriteableBitmapExtensions.ConvertColor(colour);
        }
    }
}

