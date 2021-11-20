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
            Pipe = new PipeConnection("Unnnamed", ViewModel);

            ViewModel.OnViewReset += (x, e) => CanvasContainer.Reset();

            DataContext = ViewModel;

            //Pipe.OnLineRead("RECT|1|10|5|15|25");
            //Pipe.OnLineRead("LINE|1|1|32|32");
            Pipe.OnLineRead("COLOUR|255|255|255|100");
            Pipe.OnLineRead("TRIANGLE|1|1|1|1|10|32|32");
            Pipe.OnLineRead("TEXT|0|0|1234567812345678");
            Pipe.OnLineRead("TEXT|0|5|234567890123123123");
        }

        private void OnResetClicked(object sender, RoutedEventArgs e)
        {
            CanvasContainer.Reset();
        }
    }
}
