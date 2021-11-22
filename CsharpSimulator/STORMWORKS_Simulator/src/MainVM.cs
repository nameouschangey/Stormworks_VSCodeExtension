using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

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


    public class ScreenVM : INotifyPropertyChanged
    {
        public readonly double DrawScale = 5.0f;
        public static List<string> ScreenDescriptionsList { get; private set; } = new List<string>() { "1x1", "2x1", "2x2", "3x2", "3x3", "5x3", "9x5" };

        public event PropertyChangedEventHandler PropertyChanged;
        public event EventHandler OnResolutionChanged;
        public event EventHandler OnTouchChanged;

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

                Monitor.Size = new Point(width, height);
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));

                if (IsActive)
                {
                    OnResolutionChanged?.Invoke(this, new EventArgs());
                }
            }
        }

        public Point CanvasSize
        {
            get => new Point(Monitor.Size.X * DrawScale, Monitor.Size.Y * DrawScale);
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

        public StormworksMonitor Monitor { get; private set; }
        public bool IsActive { get; set; }
        public ObservableCollection<UIElement> CanvasChildren { get; private set; }
        public int ScreenNumber { get; private set; }

        private bool _IsPortrait;
        private bool _EnablePan = true;
        private int NextZIndex = 0;

        // touch data
        private string _LastTouchCommand = "";
        private Point _TouchPosition = new Point(0, 0);
        private bool _IsDown;
        private bool _IsRDown;
        private bool _IsActive = true;
        
        private ItemsControl _UIParent;

        public ScreenVM(int screenNumber)
        {
            ScreenNumber = screenNumber;
            Monitor = new StormworksMonitor();
            ScreenResolutionDescription = ScreenDescriptionsList[0];
        }


        private void Canvas_MouseMove(object sender, MouseEventArgs e)
        {
            throw new NotImplementedException();
        }

        private void Canvas_MouseRightButtonDown(object sender, MouseButtonEventArgs e)
        {
            throw new NotImplementedException();
        }

        private void Canvas_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            throw new NotImplementedException();
        }

        public void Draw(UIElement shape)
        {
            Panel.SetZIndex(shape, NextZIndex++);
            CanvasChildren.Add(shape);
        }

        public void ClearScreen()
        {
            NextZIndex = 0;
            CanvasChildren.Clear();
        }


        private void SendTouchDataIfChanged()
        {
            // only send the update if things actually changed
            var newCommand = $"{ (_IsDown ? '1' : '0') }|{ (_IsRDown ? '1' : '0') }|{_TouchPosition.X}|{_TouchPosition.Y}";
            if (newCommand != _LastTouchCommand)
            {
                _LastTouchCommand = newCommand;

                //VSConnection.SendMessage("TOUCH", newCommand);
            }
        }

        private void UpdateTouchPosition(MouseEventArgs e)
        {
            //_TouchPosition = e.GetPosition(e.Source);
            //_TouchPosition.X = Math.Floor(_TouchPosition.X / DrawScale);
            //_TouchPosition.Y = Math.Floor(_TouchPosition.Y / DrawScale);
            //
            //if (_TouchPosition.X < 0 || _TouchPosition.X >= Monitor.Size.X
            //   || _TouchPosition.Y < 0 || _TouchPosition.Y >= Monitor.Size.Y)
            //{
            //    _IsDown = false;
            //    _TouchPosition.X = Math.Max(0, Math.Min(Monitor.Size.X - 1, _TouchPosition.X));
            //    _TouchPosition.Y = Math.Max(0, Math.Min(Monitor.Size.Y - 1, _TouchPosition.Y));
            //}
        }

        private void DrawableCanvas_MouseDown(object sender, MouseButtonEventArgs e)
        {
            _IsDown = true;
            UpdateTouchPosition(e);
            SendTouchDataIfChanged();
        }

        private void DrawableCanvas_MouseUp(object sender, MouseButtonEventArgs e)
        {
            _IsDown = false;
            SendTouchDataIfChanged();
        }

        private void DrawableCanvas_MouseMove(object sender, MouseEventArgs e)
        {
            // mouse moved out of canvas
            //if (!Canvas.IsMouseOver)
            //{
            //    _IsDown = false;
            //    _IsRDown = false;
            //}
            //
            //// Stormworks only updates mouse position while being clicked
            //if (_IsDown || _IsRDown)
            //{
            //    UpdateTouchPosition(e);
            //}
            //
            //SendTouchDataIfChanged();
        }

        private void DrawableCanvas_RMouseDown(object sender, MouseButtonEventArgs e)
        {
            _IsRDown = true;
            UpdateTouchPosition(e);
            SendTouchDataIfChanged();
        }

        private void DrawableCanvas_RMouseUp(object sender, MouseButtonEventArgs e)
        {
            _IsRDown = false;
            SendTouchDataIfChanged();
        }
    }

    public class MainVM : INotifyPropertyChanged
    {
        public event EventHandler OnViewReset;
        public event PropertyChangedEventHandler PropertyChanged;

        public ObservableCollection<StormworksInputOutput> Inputs { get; private set; }
        public ObservableCollection<StormworksInputOutput> Outputs { get; private set; }
        public ObservableCollection<ScreenVM> ScreenVMs { get; private set; }

        public bool EnablePan
        {
            get { return _EnablePan; }
            set
            {
                _EnablePan = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
            }
        }

        private bool _EnablePan = true;
        private ItemsControl _UIParent;

        public MainVM(ItemsControl uiParent)
        {
            _UIParent = uiParent;

            Inputs = new ObservableCollection<StormworksInputOutput>();
            Outputs = new ObservableCollection<StormworksInputOutput>();
            ScreenVMs = new ObservableCollection<ScreenVM>();

            for (var i = 0; i < 32; ++i)
            {
                Inputs.Add(new StormworksInputOutput($"[{i + 1}]"));
                Outputs.Add(new StormworksInputOutput($"[{i + 1}]"));
            }
        }

        public ScreenVM AddScreen(int screenNumber)
        {
            screenNumber = screenNumber - 1;

            if (ScreenVMs.Count > screenNumber)
            {
                return ScreenVMs[screenNumber];
            }
            else if(ScreenVMs.Count == screenNumber)
            {
                var screen = new ScreenVM(screenNumber);
                ScreenVMs.Add(screen);
                return screen;
            }
            else
            {
                throw new Exception($"Attempt to create a new screen index {screenNumber} but currently only have {ScreenVMs.Count} screens. Must be done in order.");
            }
        }
    }
}
