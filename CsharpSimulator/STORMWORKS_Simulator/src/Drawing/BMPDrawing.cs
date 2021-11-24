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

namespace STORMWORKS_Simulator.src.Drawing
{
    class BMPDrawing
    {

        public void ExampleDraw(int width, int height, int dpi)
        {
            byte[] _buffer = null;

            WriteableBitmap bitmap = new WriteableBitmap(width, height, dpi, dpi, PixelFormats.Pbgra32, null);

            if (_buffer == null)
            {
                _buffer = new byte[bitmap.BackBufferStride * height];
            }

            for (int i = 0; i < 1000; i++)
            {
                var x = _random.Next(bitmap.Width);
                var y = _random.Next(bitmap.Height);

                var red = (byte)_random.Next(byte.MaxValue);
                var green = (byte)_random.Next(byte.MaxValue);
                var blue = (byte)_random.Next(byte.MaxValue);
                var alpha = (byte)_random.Next(byte.MaxValue);

                _buffer[y * bitmap.BackBufferStride + x * 4] = blue;
                _buffer[y * bitmap.BackBufferStride + x * 4 + 1] = green;
                _buffer[y * bitmap.BackBufferStride + x * 4 + 2] = red;
                _buffer[y * bitmap.BackBufferStride + x * 4 + 3] = alpha;
            }

            bitmap.WritePixels(new System.Windows.Int32Rect(0, 0, bitmap.PixelWidth, bitmap.PixelHeight),
                _buffer, bitmap.PixelWidth * bitmap.Format.BitsPerPixel / 8, 0);
        }
    }
}
