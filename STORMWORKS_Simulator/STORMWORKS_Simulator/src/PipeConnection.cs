using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.IO.Pipes;
using System.IO;
using System.Windows.Controls;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;
using System.Threading;
using System.Windows;

namespace STORMWORKS_Simulator
{
    public interface IPipeCommandHandler
    {
        bool CanHandle(string commandName);
        void Handle(MainVM vm, string[] commandParts);
    }

    public class PipeConnection
    {
        public event EventHandler OnPipeClosed;

        public bool IsActive { get; set; } = true;

        private DateTime _StartTime = DateTime.UtcNow;
        private MainVM _Viewmodel;
        private IAsyncResult RunningTask;

        [ImportMany(typeof(IPipeCommandHandler))]
        private IEnumerable<Lazy<IPipeCommandHandler>> _CommandHandlers;

        public PipeConnection(MainVM viewmodel)
        {

            _Viewmodel = viewmodel;
            LoadMEFCommands();

            RunningTask = Task.Run(() =>
            {
               while (true)
               {
                   var line = Console.In.ReadLine();

                   if (line == null)
                   {
                       Thread.Sleep(1000);
                   }
                   else if (line.StartsWith("END_PIPE"))
                   {
                       IsActive = false;
                   }
                   else
                   {
                       OnLineRead(line);
                   }
               }

               OnPipeClosed?.Invoke(this, new EventArgs());
            });
        }

        public void WriteDataBack(StormworksMonitor monitor)
        {
            var pipePath = Path.GetDirectoryName(System.Reflection.Assembly.GetEntryAssembly().Location);
            pipePath += "/_SWSimulator.pipe";

            var output = $"{monitor.Size.X}|{monitor.Size.Y}|{(DateTime.UtcNow - _StartTime).TotalMilliseconds}";
            File.WriteAllText(pipePath, output);
        }

        public void OnLineRead(string line)
        {
            try
            {
                // format is: COMMAND|PARAM|PARAM|PARAM|...
                var splits = line.Split('|');
                if (splits.Length < 1)
                {
                    return;
                }

                var command = splits[0];
                foreach (var commandHandler in _CommandHandlers)
                {
                    if (commandHandler.Value.CanHandle(command))
                    {
                        Application.Current.Dispatcher.Invoke(new Action(() =>
                        {
                            commandHandler.Value.Handle(_Viewmodel, splits);
                        }));
                    }
                }

            }
            catch(Exception e)
            {
                // keep the UI running, despite any issue that arise
            }
        }

        private void LoadMEFCommands()
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
            }
            catch (CompositionException compositionException)
            {
                Console.WriteLine(compositionException.ToString());
            }
        }
    }
}
