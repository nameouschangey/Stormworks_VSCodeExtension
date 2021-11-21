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

namespace STORMWORKS_Simulator
{
    public partial class MainWindow : Window
    {
        public StormworksMonitor Monitor;
        public MainVM ViewModel;
        public SocketConnection VSConnection;
        public System.Threading.Timer TickTimer;

        public MainWindow()
        {
            Logger.SetLog(@"C:\personal\STORMWORKS_VSCodeExtension\debug.txt");

            InitializeComponent();

            ViewModel = new MainVM(DrawableCanvas);
            VSConnection = new SocketConnection(ViewModel);
            VSConnection.OnPipeClosed += Pipe_OnPipeClosed;
            ViewModel.OnViewReset += (x, e) => CanvasContainer.Reset();

            DataContext = ViewModel;

            ViewModel.OnViewReset += ViewModel_OnViewReset;

            TickTimer = new System.Threading.Timer(OnTickTimer, null, 100, 100);
        }

        private void OnTickTimer(object state)
        {   // sends simple Alive message once every 100 millis, to ensure the connection is still alive
            // allows the UI to close sooner than it might otherwise, once the debugger ends
            try
            {
                VSConnection.SendMessage("ALIVE");
            }
            catch (Exception e)
            {   // squash the error or it will confuse users in VSCode wondering why there's a bright red error
                Application.Current.Dispatcher.Invoke(() =>
                {
                    Application.Current.Shutdown();
                });
            }
        }

        private void ViewModel_OnViewReset(object sender, EventArgs e)
        {
            VSConnection.SendMessage("SCREENSIZE", ViewModel.Monitor.Size.X, ViewModel.Monitor.Size.Y);
        }

        private void Pipe_OnPipeClosed(object sender, EventArgs e)
        {
            Application.Current.Dispatcher.Invoke(() =>
            {
                Application.Current.Shutdown();
            });
        }

        private void OnResetClicked(object sender, RoutedEventArgs e)
        {
            CanvasContainer.Reset();
        }


        // Janky mouse-state handling
        private string _LastTouchCommand = "";
        private Point _TouchPosition = new Point(0, 0);
        private bool _IsDown;
        private bool _IsRDown;

        private void SendTouchDataIfChanged()
        {
            // only send the update if things actually changed
            var newCommand = $"{ (_IsDown? '1' : '0') }|{ (_IsRDown ? '1' : '0') }|{_TouchPosition.X}|{_TouchPosition.Y}";
            if (newCommand != _LastTouchCommand)
            {
                _LastTouchCommand = newCommand;

                VSConnection.SendMessage("TOUCH", newCommand);
            }
        }

        private void UpdateTouchPosition(MouseEventArgs e)
        {
            _TouchPosition = e.GetPosition(DrawableCanvas);
            _TouchPosition.X = Math.Floor(_TouchPosition.X / ViewModel.DrawScale);
            _TouchPosition.Y = Math.Floor(_TouchPosition.Y / ViewModel.DrawScale);

            if(_TouchPosition.X < 0 || _TouchPosition.X >= ViewModel.Monitor.Size.X
               || _TouchPosition.Y < 0 || _TouchPosition.Y >= ViewModel.Monitor.Size.Y)
            {
                _IsDown = false;
                _TouchPosition.X = Math.Max(0, Math.Min(ViewModel.Monitor.Size.X-1, _TouchPosition.X));
                _TouchPosition.Y = Math.Max(0, Math.Min(ViewModel.Monitor.Size.Y-1, _TouchPosition.Y));
            }
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
            if(!DrawableCanvas.IsMouseOver)
            {
                _IsDown = false;
                _IsRDown = false;
            }

            // Stormworks only updates mouse position while being clicked
            if (_IsDown || _IsRDown)
            {
                UpdateTouchPosition(e);
            }

            SendTouchDataIfChanged();
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
}
