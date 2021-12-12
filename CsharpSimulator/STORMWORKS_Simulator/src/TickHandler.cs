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
                var tickEndCommandParts = messageFromVS.Split('|');

                var messagesToProcess = new List<string>(Messages);
                Messages.Clear();
                if (!IsRendering)
                {   // near impossible to recieve 2 TICKEND commands between these 2 commands
                    // but you know, if it does happen - happy Race Condition Day.
                    var lastMessage = "";
                    IsRendering = true;
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        try
                        {
                            foreach (var message in messagesToProcess)
                            {
                                // format is: COMMAND|PARAM|PARAM|PARAM|...
                                lastMessage = message;
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

                            // TICKEND | ShouldSwapFrameBuffers (1 or 0)
                            if (tickEndCommandParts.Length < 2 || tickEndCommandParts[1] == "1")
                            {
                                foreach (var screen in _ViewModel.ScreenVMs)
                                {
                                    screen.SwapFrameBuffers();
                                    screen.Clear();
                                }
                            }
                        }
                        catch (Exception e)
                        {
                            // keep the UI running, despite any issue that arise
                            // this will be called when non-standard commands get sent etc.
                            Logger.Error($"TickHandler - OnLineRead - Exception Continuing - {lastMessage} - {e}");
                        }
                        IsRendering = false;
                    });
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
            catch (CompositionException e)
            {
                Logger.Error($"TickHandler - LoadMEFComponents - Unrecoverable Exception - Rethrowing - {e}");
                throw e;
            }
        }
    }
}
