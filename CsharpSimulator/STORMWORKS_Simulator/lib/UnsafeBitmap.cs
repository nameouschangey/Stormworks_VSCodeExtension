// http://www.nullskull.com/a/1618/image-manipulation-with-unsafe-code-in-c.aspx
// Peter Bromberg

using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;

namespace STORMWORKS_Simulator.lib
{
    public unsafe class UnsafeBitmap
    {
        Bitmap bitmap;

        int width;
        BitmapData bitmapData = null;
        Byte* pBase = null;

        public UnsafeBitmap(Bitmap bitmap)
        {
            this.bitmap = new Bitmap(bitmap);
        }

        public UnsafeBitmap(int width, int height)
        {
            this.bitmap = new Bitmap(width, height, PixelFormat.Format32bppArgb);
        }

        public void Dispose()
        {
            bitmap.Dispose();
        }

        public Bitmap Bitmap
        {
            get
            {
                return (bitmap);
            }
        }

        private Point PixelSize
        {
            get
            {
                GraphicsUnit unit = GraphicsUnit.Pixel;
                RectangleF bounds = bitmap.GetBounds(ref unit);
                return new Point((int)bounds.Width, (int)bounds.Height);
            }
        }

        public void LockBitmap()
        {
            GraphicsUnit unit = GraphicsUnit.Pixel;
            RectangleF boundsF = bitmap.GetBounds(ref unit);
            Rectangle bounds = new Rectangle((int)boundsF.X,
            (int)boundsF.Y,
            (int)boundsF.Width,
            (int)boundsF.Height);
            width = (int)boundsF.Width * sizeof(PixelData);
            if (width % 4 != 0)
            {
                width = 4 * (width / 4 + 1);
            }
            bitmapData =
            bitmap.LockBits(bounds, ImageLockMode.ReadWrite, PixelFormat.Format24bppRgb);
            pBase = (Byte*)bitmapData.Scan0.ToPointer();
        }

        public PixelData GetPixel(int x, int y)
        {
            PixelData returnValue = *PixelAt(x, y);
            return returnValue;
        }

        public void SetPixel(int x, int y, PixelData colour)
        {
            PixelData* pixel = PixelAt(x, y);
            *pixel = colour;
        }

        public void UnlockBitmap()
        {
            bitmap.UnlockBits(bitmapData);
            bitmapData = null;
            pBase = null;
        }
        public PixelData* PixelAt(int x, int y)
        {
            return (PixelData*)(pBase + y * width + x * sizeof(PixelData));
        }
    }
    public struct PixelData
    {
        public byte alpha;
        public byte blue;
        public byte green;
        public byte red;
    }
}
