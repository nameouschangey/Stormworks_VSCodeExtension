#region Header
//
//   Project:           WriteableBitmapEx - WriteableBitmap extensions
//   Description:       Collection of extension methods for the WriteableBitmap class.
//
//   Changed by:        $Author: unknown $
//   Changed on:        $Date: 2015-07-20 11:44:36 +0200 (Mo, 20 Jul 2015) $
//   Changed in:        $Revision: 114480 $
//   Project:           $URL: https://writeablebitmapex.svn.codeplex.com/svn/trunk/Source/WriteableBitmapEx/WriteableBitmapShapeExtensions.cs $
//   Id:                $Id: WriteableBitmapShapeExtensions.cs 114480 2015-07-20 09:44:36Z unknown $
//
//
//   Copyright © 2009-2015 Rene Schulte and WriteableBitmapEx Contributors
//
//   This code is open source. Please read the License.txt for details. No worries, we won't sue you! ;)
//
#endregion

using System;

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

        #region Draw Shapes

        #region Polyline, Triangle, Quad

        /// <summary>
        /// Draws a polyline anti-aliased. Add the first point also at the end of the array if the line should be closed.
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="points">The points of the polyline in x and y pairs, therefore the array is interpreted as (x1, y1, x2, y2, ..., xn, yn).</param>
        /// <param name="color">The color for the line.</param>
        public static void DrawPolyline(this WriteableBitmap bmp, int[] points, int color)
        {
            using (var context = bmp.GetBitmapContext())
            {
                // Use refs for faster access (really important!) speeds up a lot!
                var w = context.Width;
                var h = context.Height;
                var x1 = points[0];
                var y1 = points[1];

                for (var i = 2; i < points.Length; i += 2)
                {
                    var x2 = points[i];
                    var y2 = points[i + 1];

                    DrawLine(context, w, h, x1, y1, x2, y2, color);
                    x1 = x2;
                    y1 = y2;
                }
            }
        }

        /// <summary>
        /// Draws a triangle.
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="x1">The x-coordinate of the 1st point.</param>
        /// <param name="y1">The y-coordinate of the 1st point.</param>
        /// <param name="x2">The x-coordinate of the 2nd point.</param>
        /// <param name="y2">The y-coordinate of the 2nd point.</param>
        /// <param name="x3">The x-coordinate of the 3rd point.</param>
        /// <param name="y3">The y-coordinate of the 3rd point.</param>
        /// <param name="color">The color.</param>
        public static void DrawTriangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int x3, int y3, int color)
        {
            using (var context = bmp.GetBitmapContext())
            {
                // Use refs for faster access (really important!) speeds up a lot!
                int w = context.Width;
                int h = context.Height;

                DrawLine(context, w, h, x1, y1, x2, y2, color);
                DrawLine(context, w, h, x2, y2, x3, y3, color);
                DrawLine(context, w, h, x3, y3, x1, y1, color);
            }
        }

        #endregion

        #region Rectangle
        /// <summary>
        /// Draws a rectangle.
        /// x2 has to be greater than x1 and y2 has to be greater than y1.
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="x1">The x-coordinate of the bounding rectangle's left side.</param>
        /// <param name="y1">The y-coordinate of the bounding rectangle's top side.</param>
        /// <param name="x2">The x-coordinate of the bounding rectangle's right side.</param>
        /// <param name="y2">The y-coordinate of the bounding rectangle's bottom side.</param>
        /// <param name="color">The color.</param>
        public static void DrawRectangle(this WriteableBitmap bmp, int x1, int y1, int x2, int y2, int color)
        {
            using (var context = bmp.GetBitmapContext())
            {
                // Use refs for faster access (really important!) speeds up a lot!
                var w = context.Width;
                var h = context.Height;
                var pixels = context.Pixels;

                int sa = ((color >> 24) & 0xff);
                int sr = ((color >> 16) & 0xff);
                int sg = ((color >> 8) & 0xff);
                int sb = ((color) & 0xff);

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
                if (x1 >= w) { x1 = w - 1; }
                if (y1 >= h) { y1 = h - 1; }
                if (x2 >= w) { x2 = w - 1; }
                if (y2 >= h) { y2 = h - 1; }

                var startY = y1 * w;
                var endY = y2 * w;

                var offset2 = endY + x1;
                var endOffset = startY + x2;
                var startYPlusX1 = startY + x1;

                // top and bottom horizontal scanlines
                for (var x = startYPlusX1; x <= endOffset; x++)
                {
                    pixels[x] = AlphaBlendColors(pixels[x], sa, sr, sg, sb); // top horizontal line
                    pixels[offset2] = AlphaBlendColors(pixels[offset2], sa, sr, sg, sb); // bottom horizontal line
                    offset2++;
                }

                // offset2 == endY + x2

                // vertical scanlines
                endOffset = startYPlusX1 + w;
                offset2 -= w;

                for (var y = startY + x2 + w; y <= offset2; y += w)
                {
                    pixels[y] = AlphaBlendColors(pixels[y], sa, sr, sg, sb); // right vertical line
                    pixels[endOffset] = AlphaBlendColors(pixels[endOffset], sa, sr, sg, sb); // left vertical line
                    endOffset += w;
                }
            }
        }

        #endregion

        #region Ellipse
        /// <summary>
        /// A Fast Bresenham Type Algorithm For Drawing Ellipses http://homepage.smc.edu/kennedy_john/belipse.pdf 
        /// Uses a different parameter representation than DrawEllipse().
        /// </summary>
        /// <param name="bmp">The WriteableBitmap.</param>
        /// <param name="xc">The x-coordinate of the ellipses center.</param>
        /// <param name="yc">The y-coordinate of the ellipses center.</param>
        /// <param name="xr">The radius of the ellipse in x-direction.</param>
        /// <param name="yr">The radius of the ellipse in y-direction.</param>
        /// <param name="color">The color for the line.</param>
        public static void DrawEllipseCentered(this WriteableBitmap bmp, int xc, int yc, int xr, int yr, int color)
        {
            // Use refs for faster access (really important!) speeds up a lot!
            using (var context = bmp.GetBitmapContext())
            {

                var pixels = context.Pixels;
                var w = context.Width;
                var h = context.Height;

                int sa = ((color >> 24) & 0xff);
                int sr = ((color >> 16) & 0xff);
                int sg = ((color >> 8) & 0xff);
                int sb = ((color) & 0xff);

                // Avoid endless loop
                if (xr < 1 || yr < 1)
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

                // Draw first set of points counter clockwise where tangent line slope > -1.
                while (xStopping >= yStopping)
                {
                    // Draw 4 quadrant points at once
                    uy = yc + y;                  // Upper half
                    ly = yc - y;                  // Lower half

                    rx = xc + x;
                    lx = xc - x;

                    if (0 <= uy && uy < h)
                    {
                        uh = uy * w;              // Upper half
                        if (0 <= rx && rx < w) pixels[rx + uh] = AlphaBlendColors(pixels[x], sa, sr, sg, sb);      // Quadrant I (Actually an octant)
                        if (0 <= lx && lx < w) pixels[lx + uh] = AlphaBlendColors(pixels[x], sa, sr, sg, sb);      // Quadrant II
                    }

                    if (0 <= ly && ly < h)
                    {
                        lh = ly * w;              // Lower half
                        if (0 <= lx && lx < w) pixels[lx + lh] = AlphaBlendColors(pixels[x], sa, sr, sg, sb);      // Quadrant III
                        if (0 <= rx && rx < w) pixels[rx + lh] = AlphaBlendColors(pixels[x], sa, sr, sg, sb);      // Quadrant IV
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
                uy = yc + y;                  // Upper half
                ly = yc - y;                  // Lower half
                uh = uy * w;                  // Upper half
                lh = ly * w;                  // Lower half
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
                    if (0 <= rx && rx < w)
                    {
                        if (0 <= uy && uy < h) pixels[rx + uh] = AlphaBlendColors(pixels[x], sa, sr, sg, sb);      // Quadrant I (Actually an octant)
                        if (0 <= ly && ly < h) pixels[rx + lh] = AlphaBlendColors(pixels[x], sa, sr, sg, sb);      // Quadrant IV
                    }

                    lx = xc - x;
                    if (0 <= lx && lx < w)
                    {
                        if (0 <= uy && uy < h) pixels[lx + uh] = AlphaBlendColors(pixels[x], sa, sr, sg, sb);      // Quadrant II
                        if (0 <= ly && ly < h) pixels[lx + lh] = AlphaBlendColors(pixels[x], sa, sr, sg, sb);      // Quadrant III
                    }

                    x++;
                    xStopping += yrSqTwo;
                    err += xChg;
                    xChg += yrSqTwo;
                    if ((yChg + (err << 1)) > 0)
                    {
                        y--;
                        uy = yc + y;                  // Upper half
                        ly = yc - y;                  // Lower half
                        uh = uy * w;                  // Upper half
                        lh = ly * w;                  // Lower half
                        yStopping -= xrSqTwo;
                        err += yChg;
                        yChg += xrSqTwo;
                    }
                }
            }
        }

        #endregion

        #endregion

        #endregion
    }
}
