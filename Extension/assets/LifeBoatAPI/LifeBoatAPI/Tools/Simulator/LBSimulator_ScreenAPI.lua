-- Developed by Nameous Changey
--
-- Using API Signatures and Lua Doc commants from Rene Sackers
--      Auto generated docs by StormworksLuaDocsGen (https://github.com/Rene-Sackers/StormworksLuaDocsGen)
--      Based on data in: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go
--      Notice issues/missing info? Please contribute here: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go, then create an issue on the GitHub repo

---@diagnostic disable: undefined-global

---@class LBSimulator_ScreenAPI
---@field _Width number screen width in Stormworks pixels
---@field _Height number screen height in Stormworks pixels
---@field _simulator LBSimulator simulator connection
screen = {
    _Width = 32;
    _Height = 32;
    _simulator = nil;

    setSimulator = function (simulator)
        screen._simulator = simulator

        screen._simulator:registerHandler("SCREENSIZE",
            function(_, width, height)
                if(screen) then
                    screen._Width = tonumber(width)
                    screen._Height = tonumber(height)
                end
            end)
    end;

    --- Gets the width of the screen (pixels)
    --- @return number width
    getWidth = function()
        return screen._Width
    end;

    --- Gets the height of the screen (pixels)
    --- @return number height
    getHeight = function()
        return screen._Height
    end;

    --- Set the current drawing color
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setColor = function(r, g, b, a)
        a = a or 255
        screen._simulator.connection:sendCommand("COLOUR", r, g, b, a)
    end;

    --- Clear the screen with the current color
    drawClear = function()
        screen._simulator.connection:sendCommand("CLEAR")
    end;

    --- Draws a line on the screen from x1, y1 to x2, y2
    --- @param x1 number The X coordinate of the start of the line
    --- @param y1 number The Y coordinate of the start of the line
    --- @param x2 number The X coordinate of the end of the line
    --- @param y2 number The Y coordinate of the end of the line
    drawLine = function(x1, y1, x2, y2)
        screen._simulator.connection:sendCommand("LINE", x1, y1, x2, y2)
    end;

    --- Draws an outlined circle on the screen
    --- @param x number The X coordinate of the center of the circle
    --- @param y number The Y coordinate of the center of the circle
    --- @param radius number The radius of the circle
    drawCircle = function(x, y, radius)
        screen._simulator.connection:sendCommand("CIRCLE", "0", x, y, radius)
    end;

    --- Draws a filled circle on the screen
    --- @param x number The X coordinate of the center of the circle
    --- @param y number The Y coordinate of the center of the circle
    --- @param radius number The radius of the circle
    drawCircleF = function(x, y, radius)
        screen._simulator.connection:sendCommand("CIRCLE", "1", x, y, radius)
    end;

    --- Draws an outlined rectangle on the screen
    --- @param x number The top left X coordinate of the rectangle
    --- @param y number The top left Y coordinate of the rectangle
    --- @param width number The width of the rectangle
    --- @param height number The height of the rectangle
    drawRect = function(x, y, width, height)
        screen._simulator.connection:sendCommand("RECT", "0", x, y, width, height)
    end;

    --- Draws a filled rectangle on the screen
    --- @param x number The top left X coordinate of the rectangle
    --- @param y number The top left Y coordinate of the rectangle
    --- @param width number The width of the rectangle
    --- @param height number The height of the rectangle
    drawRectF = function(x, y, width, height)
        screen._simulator.connection:sendCommand("RECT", "1", x, y, width, height)
    end;

    --- Draws a triangle on the screen
    --- @param x1 number The X coordinate of the first point of the triangle
    --- @param y1 number The Y coordinate of the first point of the triangle
    --- @param x2 number The X coordinate of the second point of the triangle
    --- @param y2 number The Y coordinate of the second point of the triangle
    --- @param x3 number The X coordinate of the third point of the triangle
    --- @param y3 number The Y coordinate of the third point of the triangle
    drawTriangle = function(x1, y1, x2, y2, x3, y3)
        screen._simulator.connection:sendCommand("TRIANGLE", "0", x1, y1, x2, y2, x3, y3)
    end;

    --- Draws a filled triangle on the screen
    --- @param x1 number The X coordinate of the first point of the triangle
    --- @param y1 number The Y coordinate of the first point of the triangle
    --- @param x2 number The X coordinate of the second point of the triangle
    --- @param y2 number The Y coordinate of the second point of the triangle
    --- @param x3 number The X coordinate of the third point of the triangle
    --- @param y3 number The Y coordinate of the third point of the triangle
    drawTriangleF = function(x1, y1, x2, y2, x3, y3)
        screen._simulator.connection:sendCommand("TRIANGLE", "1", x1, y1, x2, y2, x3, y3)
    end;

    --- Draws text on the screen
    --- @param x number The X coordinate of the top left of the text
    --- @param y number The Y coordinate of the top left of the text
    --- @param text string The text to draw
    drawText = function(x, y, text)
        screen._simulator.connection:sendCommand("TEXT", x, y, text)
    end;

    --- Draw text within a rectangle
    --- @param x number The X coordinate of the top left of the textbox
    --- @param y number The Y coordinate of the top left of the textbox
    --- @param width number The width of the textbox
    --- @param height number The height of the textbox
    --- @param text string The text to draw
    --- @param horizontalAlign number How to align the text horizontally (-1 = left, 0 = center, 1 = right)
    --- @param verticalAlign number How to align the text vertically (-1 = top, 0 = center, 1 = bottom)
    drawTextBox = function(x, y, width, height, text, horizontalAlign, verticalAlign)
        screen._simulator.connection:sendCommand("TEXTBOX", x, y, width, height, horizontalAlign, verticalAlign, text)
    end;

    drawMap = function(x, y, zoom)
        screen._simulator.connection:sendCommand("MAP", x, y, zoom)
    end;

    --- Sets the color of the ocean on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorOcean    = function(r,g,b,a)
    end;

    --- Sets the color of the shallows on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorShallows = function(r,g,b,a)
    end;

    --- Sets the color of the land on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorLand     = function(r,g,b,a)
    end;

    --- Sets the color of the grass on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorGrass    = function(r,g,b,a)
    end;

    --- Sets the color of the sand on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorSand     = function(r,g,b,a)
    end;

    --- Sets the color of the snow on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorSnow     = function(r,g,b,a)
    end;
}


-- can't really do much with these, as it's external
map = {
    --- Translate pixel coordinates into world coordinates
    --- NOTE: Not yet implemented in LBSimulator
    --- @param mapX number The current X world coordinate of the drawn map
    --- @param mapY number The current Y world coordinate of the drawn map
    --- @param zoom number The current zoom of the drawn map
    --- @param screenWidth number The width of the screen
    --- @param screenHeight number The height of the screen
    --- @param pixelX number The pixel's X coordinate to translate to a world coordinate
    --- @param pixelY number The pixel's Y coordinate to translate to a world coordinate
    --- @return number worldX, number worldY
    screenToMap = function(mapX, mapY,zoom, screenWidth, screenHeight, pixelX, pixelY)
        return 0,0
    end;

    --- Translate world coordinates into screen pixel coordinates
    --- NOTE: Not yet implemented in LBSimulator
    --- @param mapX number The current X world coordinate of the drawn map
    --- @param mapY number The current Y world coordinate of the drawn map
    --- @param zoom number The current zoom of the drawn map
    --- @param screenWidth number The width of the screen
    --- @param screenHeight number The height of the screen
    --- @param worldX number The world X coordinate to translate to a pixel coordinate
    --- @param worldY number The world Y coordinate to translate to a pixel coordinate
    --- @return number pixelX, number pixelY
    mapToScreen = function(mapX, mapY, zoom, screenWidth, screenHeight, worldX, worldY)
        return 0,0
    end;
}

async = {
    --- Executes a HTTP GET request on the local machine
    --- NOTE: Not yet implemented in LBSimulator
    --- @param port number The port number to execute the request on
    --- @param url string The URL to execute the request on
    httpGet = function(port, url)
    end;
}



