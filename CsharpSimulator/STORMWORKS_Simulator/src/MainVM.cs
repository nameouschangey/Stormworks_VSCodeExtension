using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using SkiaSharp;
using System.Globalization;

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

        public float NumberValue
        {
            get => _NumberValue;
            set { _NumberValue = value; PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null)); }
        }

        private string _Name;
        private bool _BoolValue;
        private float _NumberValue;

        public StormworksInputOutput(string name)
        {
            Name = name;
        }
    }

    public class MainVM : INotifyPropertyChanged
    {
        public event EventHandler<ScreenVM> OnScreenTouchChanged;
        public event EventHandler<ScreenVM> OnScreenResolutionChanged;
        public event EventHandler<ScreenVM> OnPowerChanged;
        public event EventHandler<MainVM> OnTickrateChanged;

        public event PropertyChangedEventHandler PropertyChanged;

        public ObservableCollection<StormworksInputOutput> Inputs { get; private set; }
        public ObservableCollection<StormworksInputOutput> Outputs { get; private set; }
        public ObservableCollection<ScreenVM> ScreenVMs { get; private set; }

        public static List<string> FrameSkipOptions { get; private set; } = new List<string>() { "0", "2", "3", "5", "10", "30", "60" };
        public string FrameSkipOption
        {
            get => $"{FrameSkip}";
            set
            {
                FrameSkipIndex = FrameSkipOptions.IndexOf(value);
                FrameSkip = int.Parse(value, CultureInfo.InvariantCulture);
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
                OnTickrateChanged?.Invoke(this, this);
            }
        }
        public int FrameSkipIndex { get; set; }
        public int FrameSkip { get; private set; } = 0;

        // draw colour is shared between all screens
        public SKColor Color { get; set; }

        public SKColor MapOceanColour       { get; set; }
        public SKColor MapShallowsColour    { get; set; }
        public SKColor MapLandColour        { get; set; }
        public SKColor MapSandColour        { get; set; }
        public SKColor MapGrassColour       { get; set; }
        public SKColor MapSnowColour        { get; set; }

        public static List<string> TickRateOptions { get; private set; } = new List<string>() { "60", "1", "10", "30", "Unlimited"};
        public string TickRateOption
        {
            get => $"{TickRate}";
            set
            {
                TickRateIndex = TickRateOptions.IndexOf(value);
                if (value == "Unlimited")
                {
                    TickRate = 999;
                }
                else
                {
                    TickRateIndex = TickRateOptions.IndexOf(value);
                    TickRate = int.Parse(value, CultureInfo.InvariantCulture);
                }
                
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
                OnTickrateChanged?.Invoke(this, this);
            }
        }
        public int TickRateIndex { get; set; }
        public int TickRate { get; private set; } = 0;


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

        public bool AutoReset
        {
            get { return _AutoReset;}
            set
            {
                _AutoReset = value;
                Properties.Settings.Default.ResetZoomAutomatically = value;
                Properties.Settings.Default.Save();
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null));
            }
        }
        private bool _AutoReset = true;

        public MainVM()
        {
            _AutoReset = Properties.Settings.Default.ResetZoomAutomatically;

            Color = new SKColor(255,255,255,255);
            SetupMapColours();

            Inputs = new ObservableCollection<StormworksInputOutput>();
            Outputs = new ObservableCollection<StormworksInputOutput>();
            ScreenVMs = new ObservableCollection<ScreenVM>();

            for (var i = 0; i < 32; ++i)
            {
                Inputs.Add(new StormworksInputOutput($"[{i + 1}]"));
                Outputs.Add(new StormworksInputOutput($"[{i + 1}]"));
            }
        }

        public ScreenVM GetScreen(int screenNumber)
        {
            screenNumber = screenNumber - 1;
            return ScreenVMs[screenNumber];
        }

        public ScreenVM GetOrAddScreen(int screenNumber)
        {
            screenNumber = screenNumber - 1;

            if (ScreenVMs.Count > screenNumber)
            {
                return ScreenVMs[screenNumber];
            }
            else if(ScreenVMs.Count == screenNumber)
            {
                var screen = new ScreenVM(screenNumber);

                // re-route child events upwards
                screen.OnResolutionChanged  += (s, vm) => OnScreenResolutionChanged?.Invoke(s, vm);
                screen.OnTouchChanged       += (s, vm) => OnScreenTouchChanged?.Invoke(s, vm);
                screen.OnPowerChanged       += (s, vm) => OnPowerChanged?.Invoke(s, vm);

                ScreenVMs.Add(screen);
                return screen;
            }
            else
            {
                throw new Exception($"Attempt to create a new screen index {screenNumber} but currently only have {ScreenVMs.Count} screens. Must be done in order.");
            }
        }

        private void SetupMapColours()
        {
            MapOceanColour    = new SKColor(50,  150, 150, 255);
            MapShallowsColour = new SKColor(75,  170, 170, 255);
            MapLandColour     = new SKColor(220, 220, 220, 255);
            MapSandColour     = new SKColor(230, 230, 140, 255);
            MapGrassColour    = new SKColor(190, 215, 150, 255);
            MapSnowColour     = new SKColor(255, 255, 255, 255);
        }
    }
}
