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
            var x       = float.Parse(commandParts[3]);
            var y       = float.Parse(commandParts[4]);
            var width   = float.Parse(commandParts[5]);
            var height  = float.Parse(commandParts[6]);

            var paint = new SKPaint()
            {
                StrokeMiter = 0f,
                StrokeJoin = SKStrokeJoin.Miter,
                StrokeCap = SKStrokeCap.Butt,
                StrokeWidth = 1f,
                IsAntialias = false,
                BlendMode = SKBlendMode.SrcOver,
                Style = filled ? SKPaintStyle.Fill : SKPaintStyle.Stroke,
                Color = vm.Color
            };

            screen.DrawingCanvas.Canvas.DrawRect(x, y, width, height, paint);
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

            var filled  = commandParts[2] == "1";
            var x       = float.Parse(commandParts[3]);
            var y       = float.Parse(commandParts[4]);
            var radius  = float.Parse(commandParts[5]);

            var paint = new SKPaint()
            {
                StrokeMiter = 0f,
                StrokeJoin = SKStrokeJoin.Miter,
                StrokeCap = SKStrokeCap.Butt,
                StrokeWidth = 1f,
                IsAntialias = false,
                BlendMode = SKBlendMode.SrcOver,
                Style = filled ? SKPaintStyle.StrokeAndFill : SKPaintStyle.Stroke,
                Color = vm.Color
            };

            screen.DrawingCanvas.Canvas.DrawCircle(x, y, radius, paint);
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

            var x   = float.Parse(commandParts[2]);
            var y   = float.Parse(commandParts[3]);
            var x2  = float.Parse(commandParts[4]);
            var y2  = float.Parse(commandParts[5]);

            var paint = new SKPaint()
            {
                StrokeMiter = 0f,
                StrokeJoin = SKStrokeJoin.Miter,
                StrokeCap = SKStrokeCap.Butt,
                StrokeWidth = 1f,
                IsAntialias = false,
                BlendMode = SKBlendMode.SrcOver,
                Style = SKPaintStyle.Stroke,
                Color = vm.Color
            };

            screen.DrawingCanvas.Canvas.DrawLine(x, y, x2, y2, paint);
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
            if (commandParts.Length < 5)
            {
                return;
            }
            
            var screenNumber = int.Parse(commandParts[1]);
            var screen = vm.GetScreen(screenNumber);

            var x = (float.Parse(commandParts[2]));//   * screen.DrawScale;
            var y = (float.Parse(commandParts[3]) - 1);// * screen.DrawScale;
            var text = commandParts[4];
            
            var textBlock = new TextBlock();
            textBlock.Text = text.ToUpper();
            //textBlock.Foreground = vm.FontBrush;
            textBlock.FontSize   = 5 * screen.CanvasScale;
            textBlock.FontFamily = MonitorFont;
            textBlock.HorizontalAlignment = HorizontalAlignment.Left;
            textBlock.VerticalAlignment = VerticalAlignment.Top;
            
            Canvas.SetLeft(textBlock, x * screen.CanvasScale);
            Canvas.SetTop(textBlock, y * screen.CanvasScale);
            
           // screen.DrawText(textBlock);
        }
    }


    [Export(typeof(IPipeCommandHandler))]
    public class DrawTextbox : IPipeCommandHandler
    {
        public static FontFamily MonitorFont = new FontFamily(new Uri("pack://application:,,,/"), "./Fonts/#PixelFont");

        public string Command => "TEXTBOX";

        public void Handle(MainVM vm, string[] commandParts)
        {
            if (commandParts.Length < 9)
            {
                return;
            }
            
            var screenNumber    = int.Parse(commandParts[1]);
            var screen          = vm.GetScreen(screenNumber);

            var x               = float.Parse(commandParts[2]);
            var y               = float.Parse(commandParts[3]) - 1;
            var width           = float.Parse(commandParts[4]);
            var height          = float.Parse(commandParts[5]);
            var horizontalAlign = (int)float.Parse(commandParts[6]);
            var verticalAlign   = (int)float.Parse(commandParts[7]);
            var text            = commandParts[8];

            // custom wrapping
            var charsPerLine = (int)(Math.Max(1, width / 5));
            var lines = new List<string>();
            var index = 0;

            while (index < (text.Length - charsPerLine + 1))
            {
                var nextIndex = text.LastIndexOf(" ", index + charsPerLine + 1, charsPerLine + 1) + 1;
                if (nextIndex == -1
                    || nextIndex > index + charsPerLine)
                {
                    nextIndex = index + charsPerLine;
                }

                lines.Add(text.Substring(index, nextIndex - index));
                index = nextIndex;
            }

            if (index < text.Length)
            {
                lines.Add(text.Substring(index));
            }


            var container = new StackPanel();
            container.Orientation = Orientation.Vertical;
            container.Width = width * screen.CanvasScale;
            container.Height = (height/5) * 6 * screen.CanvasScale;
            container.ClipToBounds = true;
            //container.Background = Brushes.Yellow;
            Canvas.SetLeft(container, x * screen.CanvasScale);
            Canvas.SetTop(container, y * screen.CanvasScale);

            var align = TextAlignment.Center;
            if (horizontalAlign == -1)
            {
                align = TextAlignment.Left;
            }
            else if (horizontalAlign == 1)
            {
                align = TextAlignment.Right;
            }

            foreach (var line in lines)
            {
                var textBlock = new TextBlock();
                textBlock.Text = line.ToUpper();
                textBlock.TextWrapping = TextWrapping.NoWrap;
                textBlock.TextAlignment = align;
                textBlock.VerticalAlignment = (VerticalAlignment)(verticalAlign + 1);
                textBlock.Width = width * screen.CanvasScale;
                textBlock.Height = 6 * screen.CanvasScale;
                //textBlock.Foreground = vm.FontBrush;
                //textBlock.Background = Brushes.Red;
                textBlock.FontSize = 5 * screen.CanvasScale;
                textBlock.FontFamily = MonitorFont;

                container.Children.Add(textBlock);
            }

            //screen.DrawText(container);
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

            var filled = commandParts[2] == "1";
            var p1x = float.Parse(commandParts[3]);
            var p1y = float.Parse(commandParts[4]);
                                               
            var p2x = float.Parse(commandParts[5]);
            var p2y = float.Parse(commandParts[6]);
                                           
            var p3x = float.Parse(commandParts[7]);
            var p3y = float.Parse(commandParts[8]);

            var path = new SKPath { FillType = SKPathFillType.EvenOdd };
            path.MoveTo(p1x, p1y);
            path.LineTo(p2x, p2y);
            path.LineTo(p3x, p3y);
            path.Close();

            var paint = new SKPaint()
            {
                StrokeMiter = 0f,
                StrokeJoin = SKStrokeJoin.Miter,
                StrokeCap = SKStrokeCap.Butt,
                StrokeWidth = 1f,
                IsAntialias = false,
                BlendMode = SKBlendMode.SrcOver,
                Style = filled ? SKPaintStyle.StrokeAndFill : SKPaintStyle.Stroke,
                Color = vm.Color
            };

            screen.DrawingCanvas.Canvas.DrawPath(path, paint);
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

            var r = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[1]))));
            var g = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[2]))));
            var b = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[3]))));
            var a = Convert.ToByte(Math.Min(255, Math.Max(0, (int)double.Parse(commandParts[4]))));

            vm.Color = new SkiaSharp.SKColor(r,g,b,a);
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

            screen.Clear();
        }
    }
}
