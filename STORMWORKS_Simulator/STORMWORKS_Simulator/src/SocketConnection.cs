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
using System.Net.Sockets;
using System.Net;
using System.Linq;

namespace STORMWORKS_Simulator
{
    public interface IPipeCommandHandler
    {
        bool CanHandle(string commandName);
        void Handle(MainVM vm, string[] commandParts);
    }

    public class SocketReadBuffer
    {
        public byte[] Buffer;

        public SocketReadBuffer(int bufferSize)
        {
            Buffer = new byte[bufferSize];
        }

        public int ReadInt(NetworkStream stream)
        {
            ReadIntoBuffer(stream, 4);
            return Convert.ToInt32(BitConverter.ToUInt32(Buffer, 0));
        }

        public string ReadNextMessage(NetworkStream stream)
        {
            var length = int.Parse(ReadString(stream, 4));
            return ReadString(stream, length);
        }

        public string ReadString(NetworkStream stream, int lengthToRead)
        {
            ReadIntoBuffer(stream, lengthToRead);
            return System.Text.Encoding.UTF8.GetString(Buffer, 0, lengthToRead);
        }

        private void ReadIntoBuffer(NetworkStream stream, int lengthToRead)
        {
            var bytesRead = 0;
            while(bytesRead < lengthToRead)
            {
                bytesRead = stream.Read(Buffer, bytesRead, lengthToRead - bytesRead);
            }
        }
    }

    public class SocketConnection
    {
        public event EventHandler OnPipeClosed;
        public bool IsActive { get; set; } = true;

        private DateTime _StartTime = DateTime.UtcNow;
        private MainVM _Viewmodel;
        private IAsyncResult _RunningTask;
        private TcpClient Client;

        [ImportMany(typeof(IPipeCommandHandler))]
        private IEnumerable<Lazy<IPipeCommandHandler>> _CommandHandlers;

        public SocketConnection(MainVM viewmodel)
        {
            _Viewmodel = viewmodel;
            LoadMEFCommands();

            _RunningTask = Task.Run(() =>
            {
                try
                {
                    var listener = new TcpListener(IPAddress.Parse("127.0.0.1"), 14238);
                    listener.Start();

                    Client = listener.AcceptTcpClient();
                    var stream = Client.GetStream();
                    var reader = new SocketReadBuffer(2048);

                    Logger.Log("Beginning Message Loop");
                    while (IsActive)
                    {
                        var message = reader.ReadNextMessage(stream);
                        Logger.Log($"Message: {message}");
                        OnLineRead(message);
                    }
                    Client.Close();
                    listener.Stop();
                    OnPipeClosed?.Invoke(this, new EventArgs());
                }
                catch (Exception e)
                {
                    Logger.Log($"[Read] Caught Exception: {e}");
                    OnPipeClosed?.Invoke(this, new EventArgs());
                    throw e;
                }
            });
        }

        public void SendMessage(string commandName, params object[] args)
        {
            try
            {
                if (Client != null && Client.Connected)
                {
                    var stringArgs = string.Join("|", args.Select(x => x.ToString()));
                    var output = $"{commandName}|{stringArgs}";

                    var buffer = System.Text.Encoding.UTF8.GetBytes(output);
                    var lenBuffer = System.Text.Encoding.UTF8.GetBytes(buffer.Length.ToString("0000"));
                    Client.GetStream().Write(lenBuffer, 0, lenBuffer.Length);
                    Client.GetStream().Write(buffer, 0, buffer.Length);
                }
            }
            catch (Exception e)
            {
                Logger.Log($"[Write] Caught Exception: {e}");
                OnPipeClosed?.Invoke(this, new EventArgs());
                throw e;
            }
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
                // this will be called when non-standard commands get sent etc.
                Logger.Log($"Caught Parsing Exception: {e}");
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
