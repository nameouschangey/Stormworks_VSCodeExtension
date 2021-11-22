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

            ViewModel = new MainVM(CanvasContainer);
            VSConnection = new SocketConnection(ViewModel);
            VSConnection.OnPipeClosed += Pipe_OnPipeClosed;
            ViewModel.OnViewReset += (x, e) => CanvasZoom.Reset();

            DataContext = ViewModel;

            ViewModel.OnViewReset += ViewModel_OnViewReset;

            TickTimer = new System.Threading.Timer(OnTickTimer, null, 100, 100);

            ViewModel.AddScreen(1);
            ViewModel.AddScreen(2);
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
            //VSConnection.SendMessage("SCREENSIZE", ViewModel.Monitor.Size.X, ViewModel.Monitor.Size.Y);
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
            CanvasZoom.Reset();
        }


        // Janky mouse-state handling

        private void DrawableCanvas_MouseDown(object sender, MouseButtonEventArgs e)
        {
        }

        private void DrawableCanvas_MouseUp(object sender, MouseButtonEventArgs e)
        {
        }

        private void DrawableCanvas_MouseMove(object sender, MouseEventArgs e)
        {
        }

        private void DrawableCanvas_RMouseDown(object sender, MouseButtonEventArgs e)
        {
        }

        private void DrawableCanvas_RMouseUp(object sender, MouseButtonEventArgs e)
        {
        }
    }
}
