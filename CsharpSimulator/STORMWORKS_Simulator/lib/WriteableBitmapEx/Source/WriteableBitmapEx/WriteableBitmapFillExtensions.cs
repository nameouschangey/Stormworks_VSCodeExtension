#region Header
//
//   Project:           WriteableBitmapEx - WriteableBitmap extensions
//   Description:       Collection of extension methods for the WriteableBitmap class.
//
//   Changed by:        $Author: unknown $
//   Changed on:        $Date: 2015-03-05 21:21:11 +0100 (Do, 05 Mrz 2015) $
//   Changed in:        $Revision: 113194 $
//   Project:           $URL: https://writeablebitmapex.svn.codeplex.com/svn/trunk/Source/WriteableBitmapEx/WriteableBitmapFillExtensions.cs $
//   Id:                $Id: WriteableBitmapFillExtensions.cs 113194 2015-03-05 20:21:11Z unknown $
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
namespace Windows.UI.Xaml.Media.Imaging
#else
namespace System.Windows.Media.Imaging
#endif
{
    /// <summary>
    /// Collection of extension methods for the WriteableBitmap class.
    /// </summary>
    public
#if WPF
 unsafe
#endif
 static partial class WriteableBitmapExtensions
    {
        #region Methods

        #region Fill Shapes

        #region Rectangle


        /// Draws a single pixel, needed for circles with small radiuses to match Stormworks
        public static void DrawSinglePoint(this WriteableBitmap bmp, int x, int y, int color, bool doAlphaBlend = true)
        {
            using (var context = bmp.GetBitmapContext())
            {
                // Use refs for faster access (really important!) speeds up a lot!
                var w = context.Width;
                var h = context.Height;

                int sa = ((color >> 24) & 0xff);
                int sr = ((color >> 16) & 0xff);
                int sg = ((color >> 8) & 0xff);
                int sb = ((color) & 0xff);

                bool noBlending = !doAlphaBlend || sa == 255;

                var pixels = context.Pixels;

                if (x >= 0 && x < w && y >= 0 && y < h)
                {
                    pixels[y * w + x] = AlphaBlendColors(pixels[y * w + x], sa, sr, sg, sb);
                }
            }
        }

        /// <summary>
        /// Draws a filled rectangle with or without alpha blending (default = false).
        /// x2 has to be greater than x1 and y2 has to be greater than y1.
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="x1">The x-coordinate of the bounding rectangle's left side.</param>
        /// <param name="y1">The y-coordinate of the bounding rectangle's top side.</param>
        /// <param name="x2">The x-coordinate of the bounding rectangle's right side.</param>
        /// <param name="y2">The y-coordinate of the bounding rectangle's bottom side.</param>
        /// <param name="color">The color.</param>
        /// <param name="doAlphaBlend">True if alpha blending should be performed or false if not.</param>
        public static void FillRectangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color, bool doAlphaBlend = true)
        {
            using (var context = bmp.GetBitmapContext())
            {
                // Use refs for faster access (really important!) speeds up a lot!
                var w = context.Width;
                var h = context.Height;

                int sa = ((color >> 24) & 0xff);
                int sr = ((color >> 16) & 0xff);
                int sg = ((color >> 8) & 0xff);
                int sb = ((color) & 0xff);

                bool noBlending = !doAlphaBlend || sa == 255;

                var pixels = context.Pixels;

                // Check boundaries
                if ((x1 < 0 && x2 < 0) || (y1 < 0 && y2 < 0)
                 || (x1 >= w && x2 >= w) || (y1 >= h && y2 >= h))
                {
                    return;
                }

                // Clamp boundaries
                if (x1 < 0) { x1 = 0; }
                if (y1 < 0) { y1 = 0; }
                if (x2 < 0) { x2 = 0; }
                if (y2 < 0) { y2 = 0; }
                if (x1 > w) { x1 = w; }
                if (y1 > h) { y1 = h; }
                if (x2 > w) { x2 = w; }
                if (y2 > h) { y2 = h; }

                //swap values
                if (y1 > y2)
                {
                    y2 -= y1;
                    y1 += y2;
                    y2 = (y1 - y2);
                }

                // Fill first line
                var startY = y1 * w;
                var startYPlusX1 = startY + x1;
                var endOffset = startY + x2;
                for (var idx = startYPlusX1; idx < endOffset; idx++)
                {
                    pixels[idx] = noBlending ? color : AlphaBlendColors(pixels[idx], sa, sr, sg, sb);
                }

                // Copy first line
                var len = (x2 - x1);
                var srcOffsetBytes = startYPlusX1 * SizeOfArgb;
                var offset2 = y2 * w + x1;
                for (var y = startYPlusX1 + w; y < offset2; y += w)
                {
                    if (noBlending)
                    {
                        BitmapContext.BlockCopy(context, srcOffsetBytes, context, y * SizeOfArgb, len * SizeOfArgb);
                        continue;
                    }

                    // Alpha blend line
                    for (int i = 0; i < len; i++)
                    {
                        int idx = y + i;
                        pixels[idx] = AlphaBlendColors(pixels[idx], sa, sr, sg, sb);
                    }
                }
            }
        }

        public static int AlphaBlendColors(int pixel, int sa, int sr, int sg, int sb)
        {
            // Alpha blend
            int destPixel = pixel;
            int da = ((destPixel >> 24) & 0xff);
            int dr = ((destPixel >> 16) & 0xff);
            int dg = ((destPixel >> 8) & 0xff);
            int db = ((destPixel) & 0xff);

            destPixel = ((sa + (((da * (255 - sa)) * 0x8081) >> 23)) << 24) |
                                     ((sr + (((dr * (255 - sa)) * 0x8081) >> 23)) << 16) |
                                     ((sg + (((dg * (255 - sa)) * 0x8081) >> 23)) << 8) |
                                     ((sb + (((db * (255 - sa)) * 0x8081) >> 23)));

            return destPixel;
        }


        #endregion

        #region Ellipse


        /// <summary>
        /// A Fast Bresenham Type Algorithm For Drawing filled ellipses http://homepage.smc.edu/kennedy_john/belipse.pdf  
        /// With or without alpha blending (default = false).
        /// Uses a different parameter representation than DrawEllipse().
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="xc">The x-coordinate of the ellipses center.</param>
        /// <param name="yc">The y-coordinate of the ellipses center.</param>
        /// <param name="xr">The radius of the ellipse in x-direction.</param>
        /// <param name="yr">The radius of the ellipse in y-direction.</param>
        /// <param name="color">The color for the line.</param>
        /// <param name="doAlphaBlend">True if alpha blending should be performed or false if not.</param>
        public static void FillEllipseCentered(this WriteableBitmap bmp, int xc, int yc, int xr, int yr, int color, bool doAlphaBlend = true)
        {
            // Use refs for faster access (really important!) speeds up a lot!
            using (var context = bmp.GetBitmapContext())
            {
                var pixels = context.Pixels;
                int w = context.Width;
                int h = context.Height;

                // Avoid endless loop
                if (xr < 1 || yr < 1)
                {
                    return;
                }

                // Skip completly outside objects
                if (   xc - xr >= w
                    || xc + xr < 0
                    || yc - yr >= h
                    || yc + yr < 0)
                {
                    return;
                }

                // Init vars
                int uh, lh, uy, ly, lx, rx;
                int x = xr;
                int y = 0;
                int xrSqTwo = (xr * xr) << 1;
                int yrSqTwo = (yr * yr) << 1;
                int xChg = yr * yr * (1 - (xr << 1));
                int yChg = xr * xr;
                int err = 0;
                int xStopping = yrSqTwo * xr;
                int yStopping = 0;

                int sa = ((color >> 24) & 0xff);
                int sr = ((color >> 16) & 0xff);
                int sg = ((color >> 8) & 0xff);
                int sb = ((color) & 0xff);

                bool noBlending = !doAlphaBlend || sa == 255;

                // Draw first set of points counter clockwise where tangent line slope > -1.
                while (xStopping >= yStopping)
                {
                    // Draw 4 quadrant points at once
                    // Upper half
                    uy = yc + y;
                    // Lower half
                    ly = yc - y - 1;

                    // Clip
                    if (uy < 0) uy = 0;
                    if (uy >= h) uy = h - 1;
                    if (ly < 0) ly = 0;
                    if (ly >= h) ly = h - 1;

                    // Upper half
                    uh = uy * w;
                    // Lower half
                    lh = ly * w;

                    rx = xc + x;
                    lx = xc - x;

                    // Clip
                    if (rx < 0) rx = 0;
                    if (rx >= w) rx = w - 1;
                    if (lx < 0) lx = 0;
                    if (lx >= w) lx = w - 1;

                    // Draw line
                    if (noBlending)
                    {
                        for (int i = lx; i <= rx; i++)
                        {
                            pixels[i + uh] = color; // Quadrant II to I (Actually two octants)
                            pixels[i + lh] = color; // Quadrant III to IV
                        }
                    }
                    else
                    {
                        for (int i = lx; i <= rx; i++)
                        {
                            // Quadrant II to I (Actually two octants)
                            pixels[i + uh] = AlphaBlendColors(pixels[i + uh], sa, sr, sg, sb);

                            // Quadrant III to IV
                            pixels[i + lh] = AlphaBlendColors(pixels[i + lh], sa, sr, sg, sb);
                        }
                    }


                    y++;
                    yStopping += xrSqTwo;
                    err += yChg;
                    yChg += xrSqTwo;
                    if ((xChg + (err << 1)) > 0)
                    {
                        x--;
                        xStopping -= yrSqTwo;
                        err += xChg;
                        xChg += yrSqTwo;
                    }
                }

                // ReInit vars
                x = 0;
                y = yr;

                // Upper half
                uy = yc + y;
                // Lower half
                ly = yc - y;

                // Clip
                if (uy < 0) uy = 0;
                if (uy >= h) uy = h - 1;
                if (ly < 0) ly = 0;
                if (ly >= h) ly = h - 1;

                // Upper half
                uh = uy * w;
                // Lower half
                lh = ly * w;

                xChg = yr * yr;
                yChg = xr * xr * (1 - (yr << 1));
                err = 0;
                xStopping = 0;
                yStopping = xrSqTwo * yr;

                // Draw second set of points clockwise where tangent line slope < -1.
                while (xStopping <= yStopping)
                {
                    // Draw 4 quadrant points at once
                    rx = xc + x;
                    lx = xc - x;

                    // Clip
                    if (rx < 0) rx = 0;
                    if (rx >= w) rx = w - 1;
                    if (lx < 0) lx = 0;
                    if (lx >= w) lx = w - 1;

                    // Draw line
                    if (noBlending)
                    {
                        for (int i = lx; i <= rx; i++)
                        {
                            pixels[i + uh] = color; // Quadrant II to I (Actually two octants)
                            pixels[i + lh] = color; // Quadrant III to IV
                        }
                    }
                    else
                    {
                        for (int i = lx; i <= rx; i++)
                        {
                            // Quadrant II to I (Actually two octants)
                            pixels[i + uh] = AlphaBlendColors(pixels[i + uh], sa, sr, sg, sb);

                            // Quadrant III to IV
                            pixels[i + lh] = AlphaBlendColors(pixels[i + lh], sa, sr, sg, sb);
                        }
                    }

                    x++;
                    xStopping += yrSqTwo;
                    err += xChg;
                    xChg += yrSqTwo;
                    if ((yChg + (err << 1)) > 0)
                    {
                        y--;
                        uy = yc + y; // Upper half
                        ly = yc - y; // Lower half
                        if (uy < 0) uy = 0; // Clip
                        if (uy >= h) uy = h - 1; // ...
                        if (ly < 0) ly = 0;
                        if (ly >= h) ly = h - 1;
                        uh = uy * w; // Upper half
                        lh = ly * w; // Lower half
                        yStopping -= xrSqTwo;
                        err += yChg;
                        yChg += xrSqTwo;
                    }
                }
            }
        }

        #endregion

        #region Polygon, Triangle, Quad

        /// <summary>
        /// Draws a filled polygon with or without alpha blending (default = false). 
        /// Add the first point also at the end of the array if the line should be closed.
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="points">The points of the polygon in x and y pairs, therefore the array is interpreted as (x1, y1, x2, y2, ..., xn, yn).</param>
        /// <param name="color">The color for the line.</param>
        /// <param name="doAlphaBlend">True if alpha blending should be performed or false if not.</param>
        public static void FillPolygon(this WriteableBitmap bmp, int[] points, int color, bool doAlphaBlend = true)
        {
            using (var context = bmp.GetBitmapContext())
            {
                // Use refs for faster access (really important!) speeds up a lot!
                int w = context.Width;
                int h = context.Height;

                int sa = ((color >> 24) & 0xff);
                int sr = ((color >> 16) & 0xff);
                int sg = ((color >> 8) & 0xff);
                int sb = ((color) & 0xff);

                bool noBlending = !doAlphaBlend || sa == 255;

                var pixels = context.Pixels;
                int pn = points.Length;
                int pnh = points.Length >> 1;
                int[] intersectionsX = new int[pnh];

                // Find y min and max (slightly faster than scanning from 0 to height)
                int yMin = h;
                int yMax = 0;
                for (int i = 1; i < pn; i += 2)
                {
                    int py = points[i];
                    if (py < yMin) yMin = py;
                    if (py > yMax) yMax = py;
                }
                if (yMin < 0) yMin = 0;
                if (yMax >= h) yMax = h - 1;


                // Scan line from min to max
                for (int y = yMin; y <= yMax; y++)
                {
                    // Initial point x, y
                    float vxi = points[0];
                    float vyi = points[1];

                    // Find all intersections
                    // Based on http://alienryderflex.com/polygon_fill/
                    int intersectionCount = 0;
                    for (int i = 2; i < pn; i += 2)
                    {
                        // Next point x, y
                        float vxj = points[i];
                        float vyj = points[i + 1];

                        // Is the scanline between the two points
                        if (vyi < y && vyj >= y
                         || vyj < y && vyi >= y)
                        {
                            // Compute the intersection of the scanline with the edge (line between two points)
                            intersectionsX[intersectionCount++] = (int)(vxi + (y - vyi) / (vyj - vyi) * (vxj - vxi));
                        }
                        vxi = vxj;
                        vyi = vyj;
                    }

                    // Sort the intersections from left to right using Insertion sort 
                    // It's faster than Array.Sort for this small data set
                    int t, j;
                    for (int i = 1; i < intersectionCount; i++)
                    {
                        t = intersectionsX[i];
                        j = i;
                        while (j > 0 && intersectionsX[j - 1] > t)
                        {
                            intersectionsX[j] = intersectionsX[j - 1];
                            j = j - 1;
                        }
                        intersectionsX[j] = t;
                    }

                    // Fill the pixels between the intersections
                    for (int i = 0; i < intersectionCount - 1; i += 2)
                    {
                        int x0 = intersectionsX[i];
                        int x1 = intersectionsX[i + 1];

                        // Check boundary
                        if (x1 > 0 && x0 < w)
                        {
                            if (x0 < 0) x0 = 0;
                            if (x1 >= w) x1 = w - 1;

                            // Fill the pixels
                            for (int x = x0; x < x1; x++)
                            {
                                int idx = y * w + x;

                                pixels[idx] = noBlending ? color : AlphaBlendColors(pixels[idx], sa, sr, sg, sb);
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Draws a filled triangle.
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="x1">The x-coordinate of the 1st point.</param>
        /// <param name="y1">The y-coordinate of the 1st point.</param>
        /// <param name="x2">The x-coordinate of the 2nd point.</param>
        /// <param name="y2">The y-coordinate of the 2nd point.</param>
        /// <param name="x3">The x-coordinate of the 3rd point.</param>
        /// <param name="y3">The y-coordinate of the 3rd point.</param>
        /// <param name="color">The color.</param>
        public static void FillTriangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int x3, int y3, int color, bool alphaBlend = true)
        {
            bmp.FillPolygon(new int[] { x1, y1, x2, y2, x3, y3, x1, y1 }, color, alphaBlend);
        }

        #endregion

        #endregion

        #endregion
    }
}
