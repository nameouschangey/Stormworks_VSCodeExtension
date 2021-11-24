using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace STORMWORKS_Simulator
{
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

    public class ScreenVM : INotifyPropertyChanged
    {
        public readonly double DrawScale = 5.0f;
        public static List<string> ScreenDescriptionsList { get; private set; } = new List<string>() { "1x1", "2x1", "2x2", "3x2", "3x3", "5x3", "9x5" };

        public event PropertyChangedEventHandler PropertyChanged;
        public event EventHandler<ScreenVM> OnResolutionChanged;
        public event EventHandler<ScreenVM> OnTouchChanged;
        public event EventHandler<ScreenVM> OnPowerChanged;

        public string ScreenResolutionDescription
        {
            // using Strings for screen resolution as we also need to handle this from a text based pipe, and it's an extremely
            // tight-scoped application, so no reason to over-do things.
            get
            {
                return $"{Monitor.Size.X}x{Monitor.Size.Y}";
            }

            set
            {
                var splits = value.Split('x');
                var width = int.Parse(splits[0]) * 32;
                var height = int.Parse(splits[1]) * 32;

                ScreenResolutionDescriptionIndex = ScreenDescriptionsList.IndexOf(value);

                Monitor.Size = new Point(width, height);
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));

                if (IsPowered)
                {
                    OnResolutionChanged?.Invoke(this, this);
                }
            }
        }

        public int ScreenResolutionDescriptionIndex { get; set; }

        public Point CanvasSize
        {
            get => new Point(Monitor.Size.X * DrawScale,
                             Monitor.Size.Y * DrawScale);
        }

        public float CanvasRotation
        {
            get => IsPortrait ? 90 : 0;
        }

        public bool IsPortrait
        {
            get { return _IsPortrait; }
            set
            {
                _IsPortrait = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
            }
        }

        public bool IsPowered
        {
            get { return _IsPowered; }
            set
            {
                _IsPowered = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
                OnPowerChanged?.Invoke(this, this);
            }
        }

        public StormworksMonitor Monitor { get; private set; }

        public WriteableBitmap FrontBuffer { get; set; }
        public WriteableBitmap BackBuffer { get; set; }

        public int ScreenNumber { get; private set; }

        private bool _IsPortrait = false;
        private bool _IsPowered = true;

        // touch data
        public string LastTouchCommand = "";
        public Point TouchPosition = new Point(0, 0);
        public bool IsLDown { get => _IsLDown && _IsInCanvas; }
        public bool IsRDown { get => _IsRDown && _IsInCanvas; }

        private bool _IsLDown = false;
        private bool _IsRDown = false;
        private bool _IsInCanvas = false;

        public ScreenVM(int screenNumber)
        {
            ScreenNumber = screenNumber;
            Monitor = new StormworksMonitor();
            ScreenResolutionDescription = ScreenDescriptionsList[0];

            FrontBuffer = new WriteableBitmap((int)Monitor.Size.X, (int)Monitor.Size.Y, 96, 96, PixelFormats.Pbgra32, null);
            BackBuffer = new WriteableBitmap((int)Monitor.Size.X, (int)Monitor.Size.Y, 96, 96, PixelFormats.Pbgra32, null);
        }

        public void SwapFrameBuffers()
        {
            BackBuffer.Unlock();
            FrontBuffer = BackBuffer;
            BackBuffer = new WriteableBitmap((int)Monitor.Size.X, (int)Monitor.Size.Y, 96, 96, PixelFormats.Pbgra32, null);
            BackBuffer.Lock();

            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
        }

        public void ClearScreen()
        {
        }

        // mouse event handling
        public void OnMouseEnter(Canvas canvas, MouseEventArgs e)
        {
            _IsInCanvas = true;
            UpdateTouchPosition(canvas, e);
        }

        public void OnMouseLeave(Canvas canvas, MouseEventArgs e)
        {
            _IsInCanvas = false;
            UpdateTouchPosition(canvas, e);
        }

        public void OnMouseMove(Canvas canvas, MouseEventArgs e)
        {
            UpdateTouchPosition(canvas, e);
        }

        public void OnRightButtonDown(Canvas canvas, MouseButtonEventArgs e)
        {
            _IsRDown = true;
            UpdateTouchPosition(canvas, e);
        }

        public void OnLeftButtonDown(Canvas canvas, MouseButtonEventArgs e)
        {
            _IsLDown = true;
            UpdateTouchPosition(canvas, e);
        }

        public void OnLeftButtonUp(Canvas canvas, MouseButtonEventArgs e)
        {
            _IsLDown = false;
            UpdateTouchPosition(canvas, e);
        }

        public void OnRightButtonUp(Canvas canvas, MouseButtonEventArgs e)
        {
            _IsRDown = false;
            UpdateTouchPosition(canvas, e);
        }

        private void UpdateTouchPosition(Canvas canvas, MouseEventArgs e)
        {
            // Stormworks only updates positions when buttons are being pressed
            // There is no on-hover
            if (IsRDown || IsLDown)
            {
                TouchPosition = e.GetPosition(canvas);
                TouchPosition.X = Math.Floor(TouchPosition.X / DrawScale);
                TouchPosition.Y = Math.Floor(TouchPosition.Y / DrawScale);
            }

            if (IsPowered)
            {
                OnTouchChanged?.Invoke(this, this);
            }
        }
    }
}
