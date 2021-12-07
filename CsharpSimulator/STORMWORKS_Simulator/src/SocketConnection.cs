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
using System.Collections.Concurrent;

namespace STORMWORKS_Simulator
{


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
        public event EventHandler<string> OnLineRead;
        public event EventHandler OnPipeClosed;
        public bool IsActive { get; set; } = true;

        private DateTime _StartTime = DateTime.UtcNow;
        private IAsyncResult _SocketReadTask;
        private TcpClient _Client;

        public SocketConnection(MainVM viewmodel)
        {
            _SocketReadTask = Task.Run(() =>
            {
                try
                {
                    var listener = new TcpListener(IPAddress.Parse("127.0.0.1"), 14238);
                    listener.Start();

                    _Client = listener.AcceptTcpClient();
                    var stream = _Client.GetStream();
                    var reader = new SocketReadBuffer(2048);

                    Logger.Log("Beginning Message Loop");
                    while (IsActive)
                    {
                        var message = reader.ReadNextMessage(stream);
                        Logger.Log($"Message: {message}");

                        OnLineRead?.Invoke(this, message);
                    }
                    _Client.Close();
                    listener.Stop();
                    OnPipeClosed?.Invoke(this, new EventArgs());
                }
                catch (Exception e)
                {
                    Logger.Error($"[Read] Caught Exception: {e}");
                    OnPipeClosed?.Invoke(this, new EventArgs());
#if DEBUG
                    throw e;
#endif
                }
            });
        }

        public void SendMessage(string commandName, params object[] args)
        {
            try
            {
                if (_Client != null && _Client.Connected)
                {
                    var stringArgs = string.Join("|", args.Select(x => x.ToString()));
                    var output = $"{commandName}|{stringArgs}";

                    var buffer = System.Text.Encoding.UTF8.GetBytes(output);
                    var lenBuffer = System.Text.Encoding.UTF8.GetBytes(buffer.Length.ToString("0000"));
                    _Client.GetStream().Write(lenBuffer, 0, lenBuffer.Length);
                    _Client.GetStream().Write(buffer, 0, buffer.Length);
                }
            }
            catch (Exception e)
            {
                Logger.Error($"[Write] Caught Exception: {e}");
                OnPipeClosed?.Invoke(this, new EventArgs());

#if DEBUG
                throw e;
#endif
            }
        }
    }
}
