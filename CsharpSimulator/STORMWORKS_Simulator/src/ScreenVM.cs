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
using System.IO;
using System.Drawing.Imaging;
using SkiaSharp;

namespace STORMWORKS_Simulator
{
    public class StormworksMonitor
    { // redundant can be removed
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

        private Point _Size;

        public StormworksMonitor()
        {
            Size = new Point(32, 32);
        }
    }

    public class ScreenVM : INotifyPropertyChanged
    {
        public readonly double CanvasScale = 5.0f;
        public static List<string> ScreenDescriptionsList { get; private set; } = new List<string>() { "1x1", "2x1", "2x2", "3x2", "3x3", "5x3", "9x5" };

        public event PropertyChangedEventHandler PropertyChanged;
        public event EventHandler<ScreenVM> OnResolutionChanged;
        public event EventHandler<ScreenVM> OnTouchChanged;
        public event EventHandler<ScreenVM> OnPowerChanged;

        #region ScreenInfo
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

                _Buffer1 = new WriteableBitmap((int)Monitor.Size.X, (int)Monitor.Size.Y, 96, 96, PixelFormats.Bgra32, null);
                _Buffer2 = new WriteableBitmap((int)Monitor.Size.X, (int)Monitor.Size.Y, 96, 96, PixelFormats.Bgra32, null);

                FrontBuffer = _Buffer1;
                _BackBuffer = _Buffer2;

                PrepareBackBufferForDrawing();

                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));

                if (IsPowered)
                {
                    OnResolutionChanged?.Invoke(this, this);
                }
            }
        }
        public int ScreenResolutionDescriptionIndex { get; set; }

        public StormworksMonitor Monitor { get; private set; }

        public double CanvasRotation
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

        private bool _IsPortrait = false;
        private bool _IsPowered = true;
        #endregion



        #region Drawing
        public Point CanvasSize { get => new Point(Monitor.Size.X * CanvasScale, Monitor.Size.Y * CanvasScale); }
        public WriteableBitmap BitmapCanvas; // for removal

        public WriteableBitmap FrontBuffer { get; private set; }
        public SKSurface DrawingCanvas { get; private set; }
        private WriteableBitmap _BackBuffer;
        private WriteableBitmap _Buffer1;
        private WriteableBitmap _Buffer2;
        #endregion


        public int ScreenNumber { get; private set; }



        #region Touches
        // touch data
        public string LastTouchCommand = "";
        public Point TouchPosition = new Point(0, 0);
        public bool IsLDown { get => _IsLDown && _IsInCanvas; }
        public bool IsRDown { get => _IsRDown && _IsInCanvas; }

        public Canvas _Canvas { private get; set; }
        private bool _IsLDown = false;
        private bool _IsRDown = false;
        private bool _IsInCanvas = false;
        #endregion


        public ScreenVM(int screenNumber)
        {
            ScreenNumber = screenNumber;
            Monitor = new StormworksMonitor();
            ScreenResolutionDescription = ScreenDescriptionsList[0];
        }

        public void SwapFrameBuffers()
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));

            _BackBuffer.AddDirtyRect(new Int32Rect(0, 0, (int)_BackBuffer.Width, (int)_BackBuffer.Height));
            _BackBuffer.Unlock();

            var temp = FrontBuffer;
            FrontBuffer = _BackBuffer;
            _BackBuffer = temp;

            PrepareBackBufferForDrawing();


            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
        }

        public void PrepareBackBufferForDrawing()
        {
            if (DrawingCanvas != null)
            {
                DrawingCanvas.Dispose();
            }

            var skImageInfo = new SKImageInfo()
            {
                Width = (int)_BackBuffer.Width,
                Height = (int)_BackBuffer.Height,
                ColorType = SKColorType.Bgra8888,
                AlphaType = SKAlphaType.Premul,
                ColorSpace = SKColorSpace.CreateSrgb()
            };
            _BackBuffer.Lock();
            DrawingCanvas = SKSurface.Create(skImageInfo, _BackBuffer.BackBuffer);
        }


        public void Test()
        {
            SKCanvas canvas = DrawingCanvas.Canvas;
            canvas.Clear(new SKColor(255, 130, 130));
            canvas.DrawRect(5, 5, 10, 10, new SKPaint() { Color = new SKColor(125, 125, 125, 125) });
            canvas.DrawText("SkiaSharp in Wpf!", 5, 10, new SKPaint() { Color = new SKColor(0, 0, 0), TextSize = 5 });
            canvas.DrawText("Using SkiaSharp for making graphs in WPF", new SKPoint(5, 20), new SKPaint(new SKFont(SKTypeface.FromFamilyName("Microsoft YaHei UI"))));
        }       

        public void Clear()
        {
            _BackBuffer.Clear();
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
            _IsLDown = e.LeftButton == MouseButtonState.Pressed;
            _IsRDown = e.RightButton == MouseButtonState.Pressed;
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
                TouchPosition.X = Math.Floor(TouchPosition.X / CanvasScale);
                TouchPosition.Y = Math.Floor(TouchPosition.Y / CanvasScale);
            }

            if (IsPowered)
            {
                OnTouchChanged?.Invoke(this, this);
            }
        }
    }
}
