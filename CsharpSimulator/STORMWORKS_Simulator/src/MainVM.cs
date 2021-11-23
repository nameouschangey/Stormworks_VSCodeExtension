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
            set { _NumberValue = value; PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(null)); }
        }

        private string _Name;
        private bool _BoolValue;
        private double _NumberValue;

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

        public MainVM()
        {
            Inputs = new ObservableCollection<StormworksInputOutput>();
            Outputs = new ObservableCollection<StormworksInputOutput>();
            ScreenVMs = new ObservableCollection<ScreenVM>();

            for (var i = 0; i < 32; ++i)
            {
                Inputs.Add(new StormworksInputOutput($"[{i + 1}]"));
                Outputs.Add(new StormworksInputOutput($"[{i + 1}]"));
            }
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
                screen.OnTouchChanged += (s, vm) => OnScreenTouchChanged?.Invoke(s, vm);
                screen.OnPowerChanged += (s, vm) => OnPowerChanged?.Invoke(s, vm);

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
