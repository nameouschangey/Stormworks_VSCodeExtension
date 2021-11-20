using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.IO.Pipes;
using System.IO;
using System.Windows.Controls;
using System.ComponentModel.Composition;
using System.ComponentModel.Composition.Hosting;

namespace STORMWORKS_Simulator
{
    public interface IPipeCommandHandler
    {
        bool CanHandle(string commandName);
        void Handle(MainVM vm, string[] commandParts);
    }

    public class PipeConnection
    {
        public bool IsActive { get; set; } = true;

        private MainVM _Viewmodel;

        [ImportMany(typeof(IPipeCommandHandler))]
        private IEnumerable<Lazy<IPipeCommandHandler>> _CommandHandlers;

        public PipeConnection(string pipeName, MainVM viewmodel)
        {
            _Viewmodel = viewmodel;
           LoadMEFCommands();

           Task.Run(() =>
           {
               var server = new NamedPipeServerStream(pipeName);

               StreamReader reader = new StreamReader(server);
               server.WaitForConnection();

               while (IsActive)
               {
                   var line = reader.ReadLine();
                   OnLineRead(line);
               }
           });
        }

        public void OnLineRead(string line)
        {
            // format is: COMMAND|PARAM|PARAM|PARAM|...
            var splits = line.Split('|');
            if(splits.Length < 1)
            {
                return;
            }

            var command = splits[0];
            foreach(var commandHandler in _CommandHandlers)
            {
                if (commandHandler.Value.CanHandle(command))
                {
                    commandHandler.Value.Handle(_Viewmodel, splits);
                }
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
