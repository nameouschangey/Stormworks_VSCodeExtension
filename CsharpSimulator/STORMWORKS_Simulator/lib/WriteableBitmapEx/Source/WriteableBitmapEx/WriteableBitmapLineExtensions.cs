#region Header
//
//   Project:           WriteableBitmapEx - WriteableBitmap extensions
//   Description:       Collection of draw line extension and helper methods for the WriteableBitmap class.
//
//   Changed by:        $Author: unknown $
//   Changed on:        $Date: 2015-02-24 20:36:41 +0100 (Di, 24 Feb 2015) $
//   Changed in:        $Revision: 112951 $
//   Project:           $URL: https://writeablebitmapex.svn.codeplex.com/svn/trunk/Source/WriteableBitmapEx/WriteableBitmapTransformationExtensions.cs $
//   Id:                $Id: WriteableBitmapTransformationExtensions.cs 112951 2015-02-24 19:36:41Z unknown $
//
//
//   Copyright © 2009-2015 Rene Schulte and WriteableBitmapEx Contributors
//
//   This code is open source. Please read the License.txt for details. No worries, we won't sue you! ;)
//
#endregion

using System;
using System.Collections.Generic;

#if NETFX_CORE
using Windows.Foundation;

namespace Windows.UI.Xaml.Media.Imaging
#else
namespace System.Windows.Media.Imaging
#endif
{
    public
#if WPF
        unsafe
#endif
 static partial class WriteableBitmapExtensions
    {
        #region Normal line

        /// <summary>
        /// Draws a colored line by connecting two points using the Bresenham algorithm.
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="x1">The x-coordinate of the start point.</param>
        /// <param name="y1">The y-coordinate of the start point.</param>
        /// <param name="x2">The x-coordinate of the end point.</param>
        /// <param name="y2">The y-coordinate of the end point.</param>
        /// <param name="color">The color for the line.</param>
        /// <param name="clipRect">The region in the image to restrict drawing to.</param>
        public static void DrawLineBresenham(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, Color color, Rect? clipRect = null)
        {
            var col = ConvertColor(color);
            bmp.DrawLineBresenham(x1, y1, x2, y2, col, clipRect);
        }

        /// <summary>
        /// Draws a colored line by connecting two points using the Bresenham algorithm.
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="x1">The x-coordinate of the start point.</param>
        /// <param name="y1">The y-coordinate of the start point.</param>
        /// <param name="x2">The x-coordinate of the end point.</param>
        /// <param name="y2">The y-coordinate of the end point.</param>
        /// <param name="color">The color for the line.</param>
        /// <param name="clipRect">The region in the image to restrict drawing to.</param>
        public static void DrawLineBresenham(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color, Rect? clipRect = null)
        {
            using (var context = bmp.GetBitmapContext())
            {
                // Use refs for faster access (really important!) speeds up a lot!
                int w = context.Width;
                int h = context.Height;
                var pixels = context.Pixels;

                // Get clip coordinates
                int clipX1 = 0;
                int clipX2 = w;
                int clipY1 = 0;
                int clipY2 = h;
                if (clipRect.HasValue)
                {
                    var c = clipRect.Value;
                    clipX1 = (int)c.X;
                    clipX2 = (int)(c.X + c.Width);
                    clipY1 = (int)c.Y;
                    clipY2 = (int)(c.Y + c.Height);
                }

                // Distance start and end point
                int dx = x2 - x1;
                int dy = y2 - y1;

                // Determine sign for direction x
                int incx = 0;
                if (dx < 0)
                {
                    dx = -dx;
                    incx = -1;
                }
                else if (dx > 0)
                {
                    incx = 1;
                }

                // Determine sign for direction y
                int incy = 0;
                if (dy < 0)
                {
                    dy = -dy;
                    incy = -1;
                }
                else if (dy > 0)
                {
                    incy = 1;
                }

                // Which gradient is larger
                int pdx, pdy, odx, ody, es, el;
                if (dx > dy)
                {
                    pdx = incx;
                    pdy = 0;
                    odx = incx;
                    ody = incy;
                    es = dy;
                    el = dx;
                }
                else
                {
                    pdx = 0;
                    pdy = incy;
                    odx = incx;
                    ody = incy;
                    es = dx;
                    el = dy;
                }

                int sa = ((color >> 24) & 0xff);
                int sr = ((color >> 16) & 0xff);
                int sg = ((color >> 8) & 0xff);
                int sb = ((color) & 0xff);

                // Init start
                int x = x1;
                int y = y1;
                int error = el >> 1;
                if (y < clipY2 && y >= clipY1 && x < clipX2 && x >= clipX1)
                {
                    pixels[y * w + x] = AlphaBlendColors(pixels[y * w + x], sa, sr, sg, sb);
                }

                // Walk the line!
                for (int i = 0; i < el; i++)
                {
                    // Update error term
                    error -= es;

                    // Decide which coord to use
                    if (error < 0)
                    {
                        error += el;
                        x += odx;
                        y += ody;
                    }
                    else
                    {
                        x += pdx;
                        y += pdy;
                    }

                    // Set pixel
                    if (y < clipY2 && y >= clipY1 && x < clipX2 && x >= clipX1)
                    {
                        pixels[y * w + x] = AlphaBlendColors(pixels[y * w + x], sa, sr, sg, sb);;
                    }
                }
            }
        }

        /// <summary>
        /// Draws a colored line by connecting two points using a DDA algorithm (Digital Differential Analyzer).
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="x1">The x-coordinate of the start point.</param>
        /// <param name="y1">The y-coordinate of the start point.</param>
        /// <param name="x2">The x-coordinate of the end point.</param>
        /// <param name="y2">The y-coordinate of the end point.</param>
        /// <param name="color">The color for the line.</param>
        /// <param name="clipRect">The region in the image to restrict drawing to.</param>
        public static void DrawLineDDA(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, Color color, Rect? clipRect = null)
        {
            var col = ConvertColor(color);
            bmp.DrawLineDDA(x1, y1, x2, y2, col, clipRect);
        }

        /// <summary>
        /// Draws a colored line by connecting two points using a DDA algorithm (Digital Differential Analyzer).
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="x1">The x-coordinate of the start point.</param>
        /// <param name="y1">The y-coordinate of the start point.</param>
        /// <param name="x2">The x-coordinate of the end point.</param>
        /// <param name="y2">The y-coordinate of the end point.</param>
        /// <param name="color">The color for the line.</param>
        /// <param name="clipRect">The region in the image to restrict drawing to.</param>
        public static void DrawLineDDA(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color, Rect? clipRect = null)
        {
            using (var context = bmp.GetBitmapContext())
            {
                // Use refs for faster access (really important!) speeds up a lot!
                int w = context.Width;
                int h = context.Height;
                var pixels = context.Pixels;

                // Get clip coordinates
                int clipX1 = 0;
                int clipX2 = w;
                int clipY1 = 0;
                int clipY2 = h;
                if (clipRect.HasValue)
                {
                    var c = clipRect.Value;
                    clipX1 = (int)c.X;
                    clipX2 = (int)(c.X + c.Width);
                    clipY1 = (int)c.Y;
                    clipY2 = (int)(c.Y + c.Height);
                }

                // Distance start and end point
                int dx = x2 - x1;
                int dy = y2 - y1;

                // Determine slope (absolute value)
                int len = dy >= 0 ? dy : -dy;
                int lenx = dx >= 0 ? dx : -dx;
                if (lenx > len)
                {
                    len = lenx;
                }

                // Prevent division by zero
                if (len != 0)
                {
                    // Init steps and start
                    float incx = dx / (float)len;
                    float incy = dy / (float)len;
                    float x = x1;
                    float y = y1;

                    // Walk the line!
                    for (int i = 0; i < len; i++)
                    {
                        if (y < clipY2 && y >= clipY1 && x < clipX2 && x >= clipX1)
                        {
                            pixels[(int)y * w + (int)x] = color;
                        }
                        x += incx;
                        y += incy;
                    }
                }
            }
        }

        /// <summary>
        /// Draws a colored line by connecting two points using an optimized DDA.
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="x1">The x-coordinate of the start point.</param>
        /// <param name="y1">The y-coordinate of the start point.</param>
        /// <param name="x2">The x-coordinate of the end point.</param>
        /// <param name="y2">The y-coordinate of the end point.</param>
        /// <param name="color">The color for the line.</param>
        /// <param name="clipRect">The region in the image to restrict drawing to.</param>
        public static void DrawLine(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, Color color, Rect? clipRect = null)
        {
            var col = ConvertColor(color);
            bmp.DrawLine(x1, y1, x2, y2, col, clipRect);
        }

        /// <summary>
        /// Draws a colored line by connecting two points using an optimized DDA.
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="x1">The x-coordinate of the start point.</param>
        /// <param name="y1">The y-coordinate of the start point.</param>
        /// <param name="x2">The x-coordinate of the end point.</param>
        /// <param name="y2">The y-coordinate of the end point.</param>
        /// <param name="color">The color for the line.</param>
        /// <param name="clipRect">The region in the image to restrict drawing to.</param>
        public static void DrawLine(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color, Rect? clipRect = null)
        {
            using (var context = bmp.GetBitmapContext())
            {
                DrawLine(context, context.Width, context.Height, x1, y1, x2, y2, color, clipRect);
            }
        }

        /// <summary>
        /// Draws a colored line by connecting two points using an optimized DDA. 
        /// Uses the pixels array and the width directly for best performance.
        /// </summary>
        /// <param name="context">The context containing the pixels as int RGBA value.</param>
        /// <param name="pixelWidth">The width of one scanline in the pixels array.</param>
        /// <param name="pixelHeight">The height of the bitmap.</param>
        /// <param name="x1">The x-coordinate of the start point.</param>
        /// <param name="y1">The y-coordinate of the start point.</param>
        /// <param name="x2">The x-coordinate of the end point.</param>
        /// <param name="y2">The y-coordinate of the end point.</param>
        /// <param name="color">The color for the line.</param>
        /// <param name="clipRect">The region in the image to restrict drawing to.</param>
        public static void DrawLine(BitmapContext context, int pixelWidth, int pixelHeight, int x1, int y1, int x2, int y2, int color, Rect? clipRect = null)
        {
            // Get clip coordinates
            int clipX1 = 0;
            int clipX2 = pixelWidth;
            int clipY1 = 0;
            int clipY2 = pixelHeight;
            if (clipRect.HasValue)
            {
                var c = clipRect.Value;
                clipX1 = (int)c.X;
                clipX2 = (int)(c.X + c.Width);
                clipY1 = (int)c.Y;
                clipY2 = (int)(c.Y + c.Height);
            }

            // Perform cohen-sutherland clipping if either point is out of the viewport
            if (!CohenSutherlandLineClip(new Rect(clipX1, clipY1, clipX2 - clipX1, clipY2 - clipY1), ref x1, ref y1, ref x2, ref y2)) return;

            var pixels = context.Pixels;

            int sa = ((color >> 24) & 0xff);
            int sr = ((color >> 16) & 0xff);
            int sg = ((color >> 8) & 0xff);
            int sb = ((color) & 0xff);

            // Distance start and end point
            int dx = x2 - x1;
            int dy = y2 - y1;

            const int PRECISION_SHIFT = 8;

            // Determine slope (absolute value)
            int lenX, lenY;
            if (dy >= 0)
            {
                lenY = dy;
            }
            else
            {
                lenY = -dy;
            }

            if (dx >= 0)
            {
                lenX = dx;
            }
            else
            {
                lenX = -dx;
            }

            if (lenX > lenY)
            { // x increases by +/- 1
                if (dx < 0)
                {
                    int t = x1;
                    x1 = x2;
                    x2 = t;
                    t = y1;
                    y1 = y2;
                    y2 = t;
                }

                // Init steps and start
                int incy = (dy << PRECISION_SHIFT) / dx;

                int y1s = y1 << PRECISION_SHIFT;
                int y2s = y2 << PRECISION_SHIFT;
                int hs = pixelHeight << PRECISION_SHIFT;

                if (y1 < y2)
                {
                    if (y1 >= clipY2 || y2 < clipY1)
                    {
                        return;
                    }
                    if (y1s < 0)
                    {
                        if (incy == 0)
                        {
                            return;
                        }
                        int oldy1s = y1s;
                        // Find lowest y1s that is greater or equal than 0.
                        y1s = incy - 1 + ((y1s + 1) % incy);
                        x1 += (y1s - oldy1s) / incy;
                    }
                    if (y2s >= hs)
                    {
                        if (incy != 0)
                        {
                            // Find highest y2s that is less or equal than ws - 1.
                            // y2s = y1s + n * incy. Find n.
                            y2s = hs - 1 - (hs - 1 - y1s) % incy;
                            x2 = x1 + (y2s - y1s) / incy;
                        }
                    }
                }
                else
                {
                    if (y2 >= clipY2 || y1 < clipY1)
                    {
                        return;
                    }
                    if (y1s >= hs)
                    {
                        if (incy == 0)
                        {
                            return;
                        }
                        int oldy1s = y1s;
                        // Find highest y1s that is less or equal than ws - 1.
                        // y1s = oldy1s + n * incy. Find n.
                        y1s = hs - 1 + (incy - (hs - 1 - oldy1s) % incy);
                        x1 += (y1s - oldy1s) / incy;
                    }
                    if (y2s < 0)
                    {
                        if (incy != 0)
                        {
                            // Find lowest y2s that is greater or equal than 0.
                            // y2s = y1s + n * incy. Find n.
                            y2s = y1s % incy;
                            x2 = x1 + (y2s - y1s) / incy;
                        }
                    }
                }

                if (x1 < 0)
                {
                    y1s -= incy * x1;
                    x1 = 0;
                }
                if (x2 >= pixelWidth)
                {
                    x2 = pixelWidth - 1;
                }

                int ys = y1s;

                // Walk the line!
                int y = ys >> PRECISION_SHIFT;
                int previousY = y;
                int index = x1 + y * pixelWidth;
                int k = incy < 0 ? 1 - pixelWidth : 1 + pixelWidth;
                for (int x = x1; x <= x2; ++x)
                {
                    pixels[index] = AlphaBlendColors(pixels[index], sa, sr, sg, sb);
                    ys += incy;
                    y = ys >> PRECISION_SHIFT;
                    if (y != previousY)
                    {
                        previousY = y;
                        index += k;
                    }
                    else
                    {
                        ++index;
                    }
                }
            }
            else
            {
                // Prevent division by zero
                if (lenY == 0)
                {
                    return;
                }
                if (dy < 0)
                {
                    int t = x1;
                    x1 = x2;
                    x2 = t;
                    t = y1;
                    y1 = y2;
                    y2 = t;
                }

                // Init steps and start
                int x1s = x1 << PRECISION_SHIFT;
                int x2s = x2 << PRECISION_SHIFT;
                int ws = pixelWidth << PRECISION_SHIFT;

                int incx = (dx << PRECISION_SHIFT) / dy;

                if (x1 < x2)
                {
                    if (x1 >= clipX2 || x2 < clipX1)
                    {
                        return;
                    }
                    if (x1s < 0)
                    {
                        if (incx == 0)
                        {
                            return;
                        }
                        int oldx1s = x1s;
                        // Find lowest x1s that is greater or equal than 0.
                        x1s = incx - 1 + ((x1s + 1) % incx);
                        y1 += (x1s - oldx1s) / incx;
                    }
                    if (x2s >= ws)
                    {
                        if (incx != 0)
                        {
                            // Find highest x2s that is less or equal than ws - 1.
                            // x2s = x1s + n * incx. Find n.
                            x2s = ws - 1 - (ws - 1 - x1s) % incx;
                            y2 = y1 + (x2s - x1s) / incx;
                        }
                    }
                }
                else
                {
                    if (x2 >= clipX2 || x1 < clipX1)
                    {
                        return;
                    }
                    if (x1s >= ws)
                    {
                        if (incx == 0)
                        {
                            return;
                        }
                        int oldx1s = x1s;
                        // Find highest x1s that is less or equal than ws - 1.
                        // x1s = oldx1s + n * incx. Find n.
                        x1s = ws - 1 + (incx - (ws - 1 - oldx1s) % incx);
                        y1 += (x1s - oldx1s) / incx;
                    }
                    if (x2s < 0)
                    {
                        if (incx != 0)
                        {
                            // Find lowest x2s that is greater or equal than 0.
                            // x2s = x1s + n * incx. Find n.
                            x2s = x1s % incx;
                            y2 = y1 + (x2s - x1s) / incx;
                        }
                    }
                }

                if (y1 < 0)
                {
                    x1s -= incx * y1;
                    y1 = 0;
                }
                if (y2 >= pixelHeight)
                {
                    y2 = pixelHeight - 1;
                }

                long index = x1s;
                int indexBaseValue = y1 * pixelWidth;

                // Walk the line!
                var inc = (pixelWidth << PRECISION_SHIFT) + incx;
                for (int y = y1; y <= y2; ++y)
                {
                    pixels[indexBaseValue + (index >> PRECISION_SHIFT)] = AlphaBlendColors(pixels[indexBaseValue + (index >> PRECISION_SHIFT)], sa, sr, sg, sb);
                    index += inc;
                }
            }
        }
        #endregion

        /// <summary>
        /// Bitfields used to partition the space into 9 regions
        /// </summary>
        private const byte INSIDE = 0; // 0000
        private const byte LEFT = 1;   // 0001
        private const byte RIGHT = 2;  // 0010
        private const byte BOTTOM = 4; // 0100
        private const byte TOP = 8;    // 1000

        /// <summary>
        /// Compute the bit code for a point (x, y) using the clip rectangle
        /// bounded diagonally by (xmin, ymin), and (xmax, ymax)
        /// ASSUME THAT xmax , xmin , ymax and ymin are global constants.
        /// </summary>
        /// <param name="extents">The extents.</param>
        /// <param name="x">The x.</param>
        /// <param name="y">The y.</param>
        /// <returns></returns>
        private static byte ComputeOutCode(Rect extents, double x, double y)
        {
            // initialized as being inside of clip window
            byte code = INSIDE;

            if (x < extents.Left)           // to the left of clip window
                code |= LEFT;
            else if (x > extents.Right)     // to the right of clip window
                code |= RIGHT;
            if (y > extents.Bottom)         // below the clip window
                code |= BOTTOM;
            else if (y < extents.Top)       // above the clip window
                code |= TOP;

            return code;
        }

        #region Helper

        internal static bool CohenSutherlandLineClipWithViewPortOffset(Rect viewPort, ref float xi0, ref float yi0, ref float xi1, ref float yi1, int offset)
        {
            var viewPortWithOffset = new Rect(viewPort.X - offset, viewPort.Y - offset, viewPort.Width + 2 * offset, viewPort.Height + 2 * offset);

            return CohenSutherlandLineClip(viewPortWithOffset, ref xi0, ref yi0, ref xi1, ref yi1);
        }

        internal static bool CohenSutherlandLineClip(Rect extents, ref float xi0, ref float yi0, ref float xi1, ref float yi1)
        {
            // Fix #SC-1555: Log(0) issue
            // CohenSuzerland line clipping algorithm returns NaN when point has infinity value
            double x0 = ClipToInt(xi0);
            double y0 = ClipToInt(yi0);
            double x1 = ClipToInt(xi1);
            double y1 = ClipToInt(yi1);

            var isValid = CohenSutherlandLineClip(extents, ref x0, ref y0, ref x1, ref y1);

            // Update the clipped line
            xi0 = (float)x0;
            yi0 = (float)y0;
            xi1 = (float)x1;
            yi1 = (float)y1;

            return isValid;
        }

        private static float ClipToInt(float d)
        {
            if (d > int.MaxValue)
                return int.MaxValue;

            if (d < int.MinValue)
                return int.MinValue;

            return d;
        }

        internal static bool CohenSutherlandLineClip(Rect extents, ref int xi0, ref int yi0, ref int xi1, ref int yi1)
        {
            double x0 = xi0;
            double y0 = yi0;
            double x1 = xi1;
            double y1 = yi1;

            var isValid = CohenSutherlandLineClip(extents, ref x0, ref y0, ref x1, ref y1);

            // Update the clipped line
            xi0 = (int)x0;
            yi0 = (int)y0;
            xi1 = (int)x1;
            yi1 = (int)y1;

            return isValid;
        }

        /// <summary>
        /// Cohen–Sutherland clipping algorithm clips a line from
        /// P0 = (x0, y0) to P1 = (x1, y1) against a rectangle with 
        /// diagonal from (xmin, ymin) to (xmax, ymax).
        /// </summary>
        /// <remarks>See http://en.wikipedia.org/wiki/Cohen%E2%80%93Sutherland_algorithm for details</remarks>
        /// <returns>a list of two points in the resulting clipped line, or zero</returns>
        internal static bool CohenSutherlandLineClip(Rect extents, ref double x0, ref double y0, ref double x1, ref double y1)
        {
            // compute outcodes for P0, P1, and whatever point lies outside the clip rectangle
            byte outcode0 = ComputeOutCode(extents, x0, y0);
            byte outcode1 = ComputeOutCode(extents, x1, y1);

            // No clipping if both points lie inside viewport
            if (outcode0 == INSIDE && outcode1 == INSIDE)
                return true;

            bool isValid = false;

            while (true)
            {
                // Bitwise OR is 0. Trivially accept and get out of loop
                if ((outcode0 | outcode1) == 0)
                {
                    isValid = true;
                    break;
                }
                // Bitwise AND is not 0. Trivially reject and get out of loop
                else if ((outcode0 & outcode1) != 0)
                {
                    break;
                }
                else
                {
                    // failed both tests, so calculate the line segment to clip
                    // from an outside point to an intersection with clip edge
                    double x, y;

                    // At least one endpoint is outside the clip rectangle; pick it.
                    byte outcodeOut = (outcode0 != 0) ? outcode0 : outcode1;

                    // Now find the intersection point;
                    // use formulas y = y0 + slope * (x - x0), x = x0 + (1 / slope) * (y - y0)
                    if ((outcodeOut & TOP) != 0)
                    {   // point is above the clip rectangle
                        x = x0 + (x1 - x0) * (extents.Top - y0) / (y1 - y0);
                        y = extents.Top;
                    }
                    else if ((outcodeOut & BOTTOM) != 0)
                    { // point is below the clip rectangle
                        x = x0 + (x1 - x0) * (extents.Bottom - y0) / (y1 - y0);
                        y = extents.Bottom;
                    }
                    else if ((outcodeOut & RIGHT) != 0)
                    {  // point is to the right of clip rectangle
                        y = y0 + (y1 - y0) * (extents.Right - x0) / (x1 - x0);
                        x = extents.Right;
                    }
                    else if ((outcodeOut & LEFT) != 0)
                    {   // point is to the left of clip rectangle
                        y = y0 + (y1 - y0) * (extents.Left - x0) / (x1 - x0);
                        x = extents.Left;
                    }
                    else
                    {
                        x = double.NaN;
                        y = double.NaN;
                    }

                    // Now we move outside point to intersection point to clip
                    // and get ready for next pass.
                    if (outcodeOut == outcode0)
                    {
                        x0 = x;
                        y0 = y;
                        outcode0 = ComputeOutCode(extents, x0, y0);
                    }
                    else
                    {
                        x1 = x;
                        y1 = y;
                        outcode1 = ComputeOutCode(extents, x1, y1);
                    }
                }
            }

            return isValid;
        }

        /// <summary>
        /// Alpha blends 2 premultiplied colors with each other
        /// </summary>
        /// <param name="sa">Source alpha color component</param>
        /// <param name="sr">Premultiplied source red color component</param>
        /// <param name="sg">Premultiplied source green color component</param>
        /// <param name="sb">Premultiplied source blue color component</param>
        /// <param name="destPixel">Premultiplied destination color</param>
        /// <returns>Premultiplied blended color value</returns>
        public static int AlphaBlend(int sa, int sr, int sg, int sb, int destPixel)
        {
            int dr, dg, db;
            int da;
            da = ((destPixel >> 24) & 0xff);
            dr = ((destPixel >> 16) & 0xff);
            dg = ((destPixel >> 8) & 0xff);
            db = ((destPixel) & 0xff);

            destPixel = ((sa + (((da * (255 - sa)) * 0x8081) >> 23)) << 24) |
               ((sr + (((dr * (255 - sa)) * 0x8081) >> 23)) << 16) |
               ((sg + (((dg * (255 - sa)) * 0x8081) >> 23)) << 8) |
               ((sb + (((db * (255 - sa)) * 0x8081) >> 23)));

            return destPixel;
        }

        #endregion
    }
}
