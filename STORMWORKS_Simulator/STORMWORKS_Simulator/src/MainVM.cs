using System;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows;
using System.Collections.Specialized;

namespace STORMWORKS_Simulator
{
    public class StormworksInputOutput
    {
        public string Name { get; private set; }
        public bool  BoolValue { get; set; }
        public double NumberValue { get; set; }

        public StormworksInputOutput(string name)
        {
            Name = name;
        }
    }

    public class StormworksMonitor
    {
        public Point Size { get; set; }
        public SolidColorBrush Color { get; set; }

        public StormworksMonitor()
        {
            Size = new Point(32, 32);
            Color = Brushes.Black;
        }
    }

    public class MainVM : INotifyPropertyChanged
    {
        public readonly double DrawScale = 5.0f;
        public event EventHandler OnViewReset;
        public event PropertyChangedEventHandler PropertyChanged;

        public IList<StormworksInputOutput> Inputs { get; private set; }
        public IList<StormworksInputOutput> Outputs { get; private set; }

        // sw screen properties
        public string ScreenResolutionDescription {
            // using Strings for screen resolution as we also need to handle this from a text based pipe, and it's an extremely
            // tight-scoped application, so no reason to over-do things.
            get { return $"{Monitor.Size.X}x{Monitor.Size.Y}"; }
            set {
                var splits = value.Split('x');
                var width = int.Parse(splits[0]) * 32;
                var height = int.Parse(splits[1]) * 32;

                Monitor.Size = new Point(width, height);
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
                OnViewReset?.Invoke(this, new EventArgs());
            }
        }
        public List<string> ScreenDescriptionsList { get; private set; } = new List<string>() { "1x1",  "2x1",  "2x2", "3x2", "3x3", "5x3", "9x5" };
        public Point CanvasSize { get => new Point(Monitor.Size.X * DrawScale, Monitor.Size.Y * DrawScale);  }
        public float CanvasRotation { get => IsPortrait ? 90 : 0; }
        
        public bool IsPortrait
        {
            get { return _IsPortrait; }
            set
            {
                _IsPortrait = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
            }
        }

        public StormworksMonitor Monitor { get; set; }

        private bool _IsPortrait;
        public Canvas _Canvas; // drawing this way is easier, but annoyingly can't easily bind a child collection to a Canvas

        public MainVM(Canvas canvas)
        {
            _Canvas = canvas;

            Monitor = new StormworksMonitor();
            Inputs = new List<StormworksInputOutput>();
            Outputs = new List<StormworksInputOutput>();

            for (var i = 0; i < 32; ++i)
            {
                Inputs.Add(new StormworksInputOutput($"[{i + 1}]"));
                Outputs.Add(new StormworksInputOutput($"[{i + 1}]"));
            }

            ScreenResolutionDescription = ScreenDescriptionsList[0];
        }


        public void Draw(UIElement shape)
        {
            _Canvas.Children.Add(shape);
        }

        public void ClearScreen()
        {
            _Canvas.Children.Clear();
        }
    }
}
