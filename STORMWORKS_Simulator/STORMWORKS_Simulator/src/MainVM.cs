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
    public class StormworksInputOutput : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        public string Name
        {
            get => _Name;
            set { _Name = value; PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null)); }
        }

        public bool BoolValue
        {
            get => _BoolValue;
            set { _BoolValue = value; PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null)); }
        }

        public double NumberValue
        {
            get => _NumberValue;
            set { _NumberValue = value;PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null)); }
        }

        private string _Name;
        private bool _BoolValue;
        private double _NumberValue;

        public StormworksInputOutput(string name)
        {
            Name = name;
        }
    }

    public class StormworksMonitor
    {
        public event EventHandler OnMonitorSizeChanged;
        public Point Size
        {
            get
            {
                return _Size;
            }
            set
            {
                _Size = value;
                OnMonitorSizeChanged?.Invoke(this, new EventArgs());
            }
        }
        public SolidColorBrush Color { get; set; }

        private Point _Size;

        public StormworksMonitor()
        {
            Size = new Point(32, 32);
            Color = Brushes.White;
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

        public bool EnablePan
        {
            get { return _EnablePan; }
            set
            {
                _EnablePan = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
            }
        }

        public StormworksMonitor Monitor { get; set; }
        public Canvas Canvas; // drawing this way is easier, but annoyingly can't easily bind a child collection to a Canvas
        private bool _IsPortrait;
        private bool _EnablePan = true;

        public MainVM(Canvas canvas)
        {
            Canvas = canvas;

            Monitor = new StormworksMonitor();
            Inputs = new ObservableCollection<StormworksInputOutput>();
            Outputs = new ObservableCollection<StormworksInputOutput>();

            for (var i = 0; i < 32; ++i)
            {
                Inputs.Add(new StormworksInputOutput($"[{i + 1}]"));
                Outputs.Add(new StormworksInputOutput($"[{i + 1}]"));
            }

            ScreenResolutionDescription = ScreenDescriptionsList[0];
        }


        public void Draw(UIElement shape)
        {
            Canvas.Children.Add(shape);
        }

        public void ClearScreen()
        {
            Canvas.Children.Clear();
        }
    }
}
