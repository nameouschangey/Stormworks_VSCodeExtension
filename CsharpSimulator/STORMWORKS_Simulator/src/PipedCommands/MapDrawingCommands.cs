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

            var screenNumber = int.Parse(commandParts[1], CultureInfo.InvariantCulture);
            var screen = vm.GetScreen(screenNumber);

            var x = float.Parse(commandParts[2], CultureInfo.InvariantCulture);
            var y = float.Parse(commandParts[3], CultureInfo.InvariantCulture);
            var zoom = 1 - (float.Parse(commandParts[4], CultureInfo.InvariantCulture) / 50);  // 0.1 -> 50

            x *= zoom * 50;
            y *= zoom * 50;

            
            var screenWidth = (float)screen.Monitor.Size.X;
            var screenHeight = (float)screen.Monitor.Size.Y;

            var paint =
            new SKPaint {
                Style=SKPaintStyle.StrokeAndFill
            };

            var canvas = screen.DrawingCanvas.Canvas;

            // draw the ocean
            paint.Color = vm.MapOceanColour;
            screen.DrawingCanvas.Canvas.DrawRect(0, 0, screenWidth, screenHeight, paint);

            // draw a bunch of janky overlapping ovals to represent the "islands"
            // it's better than nothing
            DrawIsland(vm, paint, canvas, (x/50000 * screenWidth) + (screenWidth / 5), (y / 50000 * screenHeight) + screenHeight / 5,     zoom * screenWidth / 5, zoom * screenHeight / 3);
            DrawIsland(vm, paint, canvas, (x/50000 * screenWidth) + (2 * screenWidth / 3), (y / 50000 * screenHeight) + 2 * screenHeight / 3, zoom * screenWidth / 3, zoom * screenHeight / 5);
        }

        private void DrawIsland(MainVM vm, SKPaint paint, SKCanvas canvas, float x, float y, float width, float length)
        {
            paint.Color = vm.MapShallowsColour;
            canvas.DrawOval(x, y, width * 0.9f, length * 0.9f, paint);

            paint.Color = vm.MapSandColour;
            canvas.DrawOval(x, y, width * 0.8f, length * 0.8f, paint);

            paint.Color = vm.MapLandColour;
            canvas.DrawOval(x, y, width * 0.7f, length * 0.7f, paint);

            paint.Color = vm.MapGrassColour;
            canvas.DrawOval(x, y, width * 0.6f, length * 0.6f, paint);

            paint.Color = vm.MapSnowColour;
            canvas.DrawOval(x+width * 0.1f, y+length * 0.1f, width * 0.1f, length * 0.1f, paint);
        }
    }


}

