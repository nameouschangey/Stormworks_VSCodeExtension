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
using System.Windows.Threading;
using System.Threading;
using System.Collections;
using System.IO.Pipes;
using System.IO;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;
using System.Net.Sockets;
using System.Net;

namespace STORMWORKS_Simulator
{
    public interface IPipeCommandHandler
    {
        string Command { get; }
        void Handle(MainVM vm, string[] commandParts);

    }
    public class TickHandler
    {
        private MainVM _ViewModel;

        [ImportMany(typeof(IPipeCommandHandler))]
        private IEnumerable<Lazy<IPipeCommandHandler>> _CommandHandlers;
        private Dictionary<string, IPipeCommandHandler> _CommandHandlersLookup = new Dictionary<string, IPipeCommandHandler>();

        private List<string> Messages = new List<string>();
        private bool IsRendering = false;

        public TickHandler(MainVM vm)
        {
            _ViewModel = vm;
            LoadMEFComponents();
        }

        public void OnLineRead(object sender, string messageFromVS)
        {
            if (!messageFromVS.StartsWith("TICKEND"))
            {
                Messages.Add(messageFromVS);
            }
            else
            {
                var messagesToProcess = new List<string>(Messages);
                Messages.Clear();
                if (!IsRendering)
                {   // near impossible to recieve 2 TICKEND commands between these 2 commands
                    // but you know, if it does happen - happy Race Condition Day.
                    IsRendering = true;
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        try
                        {
                            foreach (var message in messagesToProcess)
                            {
                            // format is: COMMAND|PARAM|PARAM|PARAM|...
                            var splits = message.Split('|');
                                if (splits.Length < 1)
                                {
                                    return;
                                }

                                var command = splits[0];
                                if (_CommandHandlersLookup.TryGetValue(command, out var handler))
                                {
                                    handler.Handle(_ViewModel, splits);
                                }
                            }

                        }
                        catch (Exception e)
                        {
                        // keep the UI running, despite any issue that arise
                        // this will be called when non-standard commands get sent etc.
                        Logger.Log($"Caught Parsing Exception: {e}");
                        }
                        IsRendering = false;
                    });
                }
                else
                {
                    var a = 1;
                }
            }
        }

        private void LoadMEFComponents()
        {
            CompositionContainer _container;

            try
            {
                // An aggregate catalog that combines multiple catalogs.
                var catalog = new AggregateCatalog();
                // Adds all the parts found in the same assembly as the Program class.
                catalog.Catalogs.Add(new AssemblyCatalog(typeof(MainWindow).Assembly));

                // Create the CompositionContainer with the parts in the catalog.
                _container = new CompositionContainer(catalog);
                _container.ComposeParts(this);

                foreach (var handler in _CommandHandlers)
                {
                    _CommandHandlersLookup[handler.Value.Command] = handler.Value;
                }
            }
            catch (CompositionException compositionException)
            {
                Console.WriteLine(compositionException.ToString());
            }
        }
    }

    public partial class MainWindow : Window
    {
        public StormworksMonitor Monitor;
        public MainVM ViewModel;
        public SocketConnection VSConnection;
        public Timer KeepAliveTimer;
        public TickHandler TickHandler;

        public MainWindow()
        {
            Logger.SetLog(@"C:\personal\STORMWORKS_VSCodeExtension\debug.txt");
            Logger.Enabled = false;

            InitializeComponent();

            ViewModel = new MainVM();
            TickHandler = new TickHandler(ViewModel);
            VSConnection = new SocketConnection(ViewModel);
            VSConnection.OnPipeClosed += Pipe_OnPipeClosed;
            VSConnection.OnLineRead += TickHandler.OnLineRead;


            ViewModel.OnScreenResolutionChanged += (s, vm) => CanvasZoom.Reset();
            ViewModel.OnScreenResolutionChanged += (s, vm) => VSConnection.SendMessage("SCREENSIZE", $"{vm.ScreenNumber + 1}|{vm.Monitor.Size.X}|{vm.Monitor.Size.Y}");
            ViewModel.OnScreenTouchChanged += SendTouchDataIfChanged;
            ViewModel.OnPowerChanged += (s, vm) => VSConnection.SendMessage("SCREENPOWER", $"{vm.ScreenNumber + 1}|{ (vm.IsPowered ? "1" : "0") }");

            DataContext = ViewModel;

            KeepAliveTimer = new Timer(OnKeepAliveTimer, null, 100, 100);
            
            ViewModel.GetOrAddScreen(1);
        }

        private void OnKeepAliveTimer(object state)
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

        private void SendTouchDataIfChanged(object sender, ScreenVM vm)
        {
            // only send the update if things actually changed
            var newCommand = $"{vm.ScreenNumber + 1}|{(vm.IsLDown ? '1' : '0') }|{ (vm.IsRDown ? '1' : '0') }|{vm.TouchPosition.X}|{vm.TouchPosition.Y}";
            if (newCommand != vm.LastTouchCommand)
            {
                vm.LastTouchCommand = newCommand;
                VSConnection.SendMessage("TOUCH", newCommand);
            }
        }

        private void OnAddScreenClicked(object sender, RoutedEventArgs e)
        {
            ViewModel.GetOrAddScreen(ViewModel.ScreenVMs.Count + 1);
        }

        // dirty event handling, but easier than going through all the bindings for this; as they're not designed to work with commands by default
        // redirect the event manually, to the correct screenVM
        private void Canvas_MouseRightButtonUp(object sender, MouseButtonEventArgs e) { ((sender as Canvas).DataContext as ScreenVM).OnRightButtonUp(sender as Canvas, e);}

        private void Canvas_MouseLeftButtonUp(object sender, MouseButtonEventArgs e) { ((sender as Canvas).DataContext as ScreenVM).OnLeftButtonUp(sender as Canvas, e); }

        private void Canvas_MouseRightButtonDown(object sender, MouseButtonEventArgs e) { ((sender as Canvas).DataContext as ScreenVM).OnRightButtonDown(sender as Canvas, e); }

        private void Canvas_MouseLeftButtonDown(object sender, MouseButtonEventArgs e) { ((sender as Canvas).DataContext as ScreenVM).OnLeftButtonDown(sender as Canvas, e); }

        private void Canvas_MouseLeave(object sender, MouseEventArgs e) { ((sender as Canvas).DataContext as ScreenVM).OnMouseLeave(sender as Canvas, e); }

        private void Canvas_MouseEnter(object sender, MouseEventArgs e) { ((sender as Canvas).DataContext as ScreenVM).OnMouseEnter(sender as Canvas, e); }

        private void Canvas_MouseMove(object sender, MouseEventArgs e) { ((sender as Canvas).DataContext as ScreenVM).OnMouseMove(sender as Canvas, e); }
    }
}
