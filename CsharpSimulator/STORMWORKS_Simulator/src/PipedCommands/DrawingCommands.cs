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
    public class DrawRect : IPipeCommandHandler
    {
        public string Command => "RECT";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 7)
            {
                return;
            }

            var screenNumber = int.Parse(commandParts[1]);
            var screen = vm.GetScreen(screenNumber);

            var filled = commandParts[2] == "1";
            var x       = double.Parse(commandParts[3]);
            var y       = double.Parse(commandParts[4]);
            var width   = double.Parse(commandParts[5]);
            var height  = double.Parse(commandParts[6]);

            if (filled)
            {
                screen.BackBuffer.FillRectangle((int)x, (int)y, (int)(x + width), (int)(y + height), screen.Monitor.Color);
            }
            else
            {
                screen.BackBuffer.DrawRectangle((int)x, (int)y, (int)(x + width), (int)(y + height), screen.Monitor.Color);
            }
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class DrawCircle : IPipeCommandHandler
    {
        public string Command => "CIRCLE";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 6)
            {
                return;
            }

            var screenNumber = int.Parse(commandParts[1]);
            var screen = vm.GetScreen(screenNumber);

            var filled = commandParts[2] == "1";
            var x       = double.Parse(commandParts[3]);
            var y       = double.Parse(commandParts[4]);
            var radius  = double.Parse(commandParts[5]) + 0.5;

            if (filled)
            {
                screen.BackBuffer.FillEllipse((int)(x - radius),(int)(y-radius),(int)(x + radius), (int)(y + radius), screen.Monitor.Color);
            }
            else
            {
                screen.BackBuffer.DrawEllipse((int)(x - radius), (int)(y - radius), (int)(x + radius), (int)(y + radius), screen.Monitor.Color);
            }
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class DrawLine : IPipeCommandHandler
    {
        public string Command => "LINE";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 6)
            {
                return;
            }

            var screenNumber = int.Parse(commandParts[1]);
            var screen = vm.GetScreen(screenNumber);

            var x   = double.Parse(commandParts[2]);
            var y   = double.Parse(commandParts[3]);
            var x2  = double.Parse(commandParts[4]);
            var y2  = double.Parse(commandParts[5]);

            screen.BackBuffer.DrawLine((int)x, (int)y, (int)x2, (int)y2, screen.Monitor.Color);
        }
    }


    // todo: from here downards
    [Export(typeof(IPipeCommandHandler))]
    public class DrawText : IPipeCommandHandler
    {
        public static FontFamily MonitorFont = new FontFamily(new Uri("pack://application:,,,/"), "./Fonts/#PixelFont");

        public string Command => "TEXT";

        public void Handle(MainVM vm, string[] commandParts)
        {
            //if (commandParts.Length < 5)
            //{
            //    return;
            //}
            //
            //var screenNumber = int.Parse(commandParts[1]);
            //var screen = vm.GetScreen(screenNumber);
            //
            //var x = (double.Parse(commandParts[2]))   * screen.DrawScale;
            //var y = (double.Parse(commandParts[3])-1) * screen.DrawScale;
            //var text = commandParts[4];
            //
            //var textBlock = new TextBlock();
            //textBlock.Text = text;
            //textBlock.Foreground = screen.Monitor.Color;
            //textBlock.FontSize   = 5 * screen.DrawScale;
            //textBlock.FontFamily = MonitorFont;
            //textBlock.HorizontalAlignment = HorizontalAlignment.Left;
            //textBlock.VerticalAlignment = VerticalAlignment.Top;
            //
            //Canvas.SetLeft(textBlock, x);
            //Canvas.SetTop(textBlock, y);
            //
            //screen.Draw(textBlock);
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class DrawTextbox : IPipeCommandHandler
    {
        public static FontFamily MonitorFont = new FontFamily(new Uri("pack://application:,,,/"), "./Fonts/#PixelFont");

        public string Command => "TEXTBOX";

        public void Handle(MainVM vm, string[] commandParts)
        {
            //if (commandParts.Length < 9)
            //{
            //    return;
            //}
            //
            //var screenNumber = int.Parse(commandParts[1]);
            //var screen = vm.GetScreen(screenNumber);
            //
            //var x               = double.Parse(commandParts[2]) * screen.DrawScale;
            //var y               = (double.Parse(commandParts[3])-1) * screen.DrawScale;
            //var width           = double.Parse(commandParts[4]) * screen.DrawScale;
            //var height          = double.Parse(commandParts[5]) * screen.DrawScale;
            //var horizontalAlign = (int)double.Parse(commandParts[6]);
            //var verticalAlign   = (int)double.Parse(commandParts[7]);
            //var text            = commandParts[8];
            //
            //var textBlock = new TextBlock();
            //textBlock.Text = text;
            //textBlock.TextWrapping = TextWrapping.Wrap;
            //textBlock.HorizontalAlignment = (HorizontalAlignment)(horizontalAlign - 1);
            //textBlock.VerticalAlignment = (VerticalAlignment)(verticalAlign - 1);
            //textBlock.Width = width;
            //textBlock.Height = height;
            //textBlock.Foreground = screen.Monitor.Color;
            //textBlock.FontSize = 8 * screen.DrawScale;
            //textBlock.FontFamily = MonitorFont;
            //
            //Canvas.SetLeft(textBlock, x);
            //Canvas.SetTop(textBlock, y);
            //
            //screen.Draw(textBlock);
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class DrawTriangle : IPipeCommandHandler
    {
        public string Command => "TRIANGLE";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 9)
            {
                return;
            }

            var screenNumber = int.Parse(commandParts[1]);
            var screen = vm.GetScreen(screenNumber);

            var filled = commandParts[1] == "1";
            var p1x = double.Parse(commandParts[3]);
            var p1y = double.Parse(commandParts[4]);
                                     
            var p2x = double.Parse(commandParts[5]);
            var p2y = double.Parse(commandParts[6]);
                                              
            var p3x = double.Parse(commandParts[7]);
            var p3y = double.Parse(commandParts[8]);

            if (filled)
            {
                screen.BackBuffer.DrawTriangle((int)p1x, (int)p1y, (int)p2x, (int)p2y, (int)p3x, (int)p3y, screen.Monitor.Color);
            }
            else
            {
                screen.BackBuffer.FillTriangle((int)p1x, (int)p1y, (int)p2x, (int)p2y, (int)p3x, (int)p3y, screen.Monitor.Color);
            }
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class SetColour : IPipeCommandHandler
    {
        public string Command => "COLOUR";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 6)
            {
                return;
            }

            var screenNumber = int.Parse(commandParts[1]);
            var screen = vm.GetScreen(screenNumber);

            var r = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[2]))));
            var g = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[3]))));
            var b = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[4]))));
            var a = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[5]))));

            screen.Monitor.Color = Color.FromArgb(a, r, g, b);
        }
    }

    [Export(typeof(IPipeCommandHandler))]
    public class ClearScreen : IPipeCommandHandler
    {
        public string Command => "CLEAR";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 2)
            {
                return;
            }

            var screenNumber = int.Parse(commandParts[1]);
            var screen = vm.GetScreen(screenNumber);

            screen.BackBuffer.Clear();
        }
    }
}
