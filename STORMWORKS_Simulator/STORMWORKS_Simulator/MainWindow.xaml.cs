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
        public PipeConnection Pipe;

        public MainWindow()
        {
            InitializeComponent();

            ViewModel = new MainVM(DrawableCanvas);
            Pipe = new PipeConnection(ViewModel);
            Pipe.OnPipeClosed += Pipe_OnPipeClosed;
            ViewModel.OnViewReset += (x, e) => CanvasContainer.Reset();

            DataContext = ViewModel;
        }

        private void Pipe_OnPipeClosed(object sender, EventArgs e)
        {
            Close();
        }

        private void OnResetClicked(object sender, RoutedEventArgs e)
        {
            CanvasContainer.Reset();
        }
    }
}
