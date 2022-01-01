-- Developed by Nameous Changey
--
-- Using API Signatures and Lua Doc commants from Rene Sackers
--      Auto generated docs by StormworksLuaDocsGen (https://github.com/Rene-Sackers/StormworksLuaDocsGen)
--      Based on data in: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go
--      Notice issues/missing info? Please contribute here: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go, then create an issue on the GitHub repo

---@diagnostic disable: undefined-global
---@diagnostic disable: lowercase-global

---@class Simulator_ScreenAPI
---@field _simulator Simulator simulator connection
screen = {
    _simulator = nil;

    _ensureIsRendering = function()
        if not screen._simulator or not screen._simulator.isRendering then
            error("Cannot use screen functions outside of onDraw.")
        end
    end;

    _setSimulator = function (simulator)
        screen._simulator = simulator
    end;

    getSimulatorScreenIndex = function ()
        return screen._simulator._currentScreen.screenNumber
    end;

    --- Gets the width of the screen (pixels)
    --- @return number width
    getWidth = function()
        screen._ensureIsRendering()
        return screen._simulator._currentScreen.width
    end;

    --- Gets the height of the screen (pixels)
    --- @return number height
    getHeight = function()
        screen._ensureIsRendering()
        return screen._simulator._currentScreen.height
    end;

    --- Set the current drawing color
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setColor = function(r, g, b, a)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("COLOUR", r or 0, g or 0, b or 0, a or 255)
    end;

    --- Clear the screen with the current color
    drawClear = function()
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("CLEAR", screen.getSimulatorScreenIndex())
    end;

    --- Draws a line on the screen from x1, y1 to x2, y2
    --- @param x1 number The X coordinate of the start of the line
    --- @param y1 number The Y coordinate of the start of the line
    --- @param x2 number The X coordinate of the end of the line
    --- @param y2 number The Y coordinate of the end of the line
    drawLine = function(x1, y1, x2, y2)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("LINE", screen.getSimulatorScreenIndex(), x1 or 0, y1 or 0, x2 or 0, y2 or 0)
    end;

    --- Draws an outlined circle on the screen
    --- @param x number The X coordinate of the center of the circle
    --- @param y number The Y coordinate of the center of the circle
    --- @param radius number The radius of the circle
    drawCircle = function(x, y, radius)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("CIRCLE", screen.getSimulatorScreenIndex(), "0", x or 0, y or 0, radius or 0)
    end;

    --- Draws a filled circle on the screen
    --- @param x number The X coordinate of the center of the circle
    --- @param y number The Y coordinate of the center of the circle
    --- @param radius number The radius of the circle
    drawCircleF = function(x, y, radius)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("CIRCLE", screen.getSimulatorScreenIndex(), "1", x or 0, y or 0, radius or 0)
    end;

    --- Draws an outlined rectangle on the screen
    --- @param x number The top left X coordinate of the rectangle
    --- @param y number The top left Y coordinate of the rectangle
    --- @param width number The width of the rectangle
    --- @param height number The height of the rectangle
    drawRect = function(x, y, width, height)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("RECT", screen.getSimulatorScreenIndex(), "0", x or 0, y or 0, width or 0, height or 0)
    end;

    --- Draws a filled rectangle on the screen
    --- @param x number The top left X coordinate of the rectangle
    --- @param y number The top left Y coordinate of the rectangle
    --- @param width number The width of the rectangle
    --- @param height number The height of the rectangle
    drawRectF = function(x, y, width, height)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("RECT", screen.getSimulatorScreenIndex(), "1", x or 0, y or 0, width or 0, height or 0)
    end;

    --- Draws a triangle on the screen
    --- @param x1 number The X coordinate of the first point of the triangle
    --- @param y1 number The Y coordinate of the first point of the triangle
    --- @param x2 number The X coordinate of the second point of the triangle
    --- @param y2 number The Y coordinate of the second point of the triangle
    --- @param x3 number The X coordinate of the third point of the triangle
    --- @param y3 number The Y coordinate of the third point of the triangle
    drawTriangle = function(x1, y1, x2, y2, x3, y3)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("TRIANGLE", screen.getSimulatorScreenIndex(), "0", x1 or 0, y1 or 0, x2 or 0, y2 or 0, x3 or 0, y3 or 0)
    end;

    --- Draws a filled triangle on the screen
    --- @param x1 number The X coordinate of the first point of the triangle
    --- @param y1 number The Y coordinate of the first point of the triangle
    --- @param x2 number The X coordinate of the second point of the triangle
    --- @param y2 number The Y coordinate of the second point of the triangle
    --- @param x3 number The X coordinate of the third point of the triangle
    --- @param y3 number The Y coordinate of the third point of the triangle
    drawTriangleF = function(x1, y1, x2, y2, x3, y3)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("TRIANGLE", screen.getSimulatorScreenIndex(), "1", x1 or 0, y1 or 0, x2 or 0, y2 or 0, x3 or 0, y3 or 0)
    end;

    --- Draws text on the screen
    --- @param x number The X coordinate of the top left of the text
    --- @param y number The Y coordinate of the top left of the text
    --- @param text string The text to draw
    drawText = function(x, y, text)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("TEXT", screen.getSimulatorScreenIndex(), x or 0, y or 0, text or 0)
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
        screen._ensureIsRendering()
        horizontalAlign = horizontalAlign or -1
        verticalAlign = verticalAlign or -1
        screen._simulator._connection:sendCommand("TEXTBOX", screen.getSimulatorScreenIndex(), x or 0, y or 0, width or 0, height or 0, horizontalAlign or -1, verticalAlign or -1, text or "")
    end;

    --- Draw a map on the screen
    --- @param x number The world X coordinate to center the map on
    --- @param y number The world Y coordinate to center the map on
    --- @param zoom number The zoom (0.1 - 50, 0.1 = max zoom in, 50 = max zoom out), width of screen at zoom 1 is 1Km
    drawMap = function(x, y, zoom)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("MAP", screen.getSimulatorScreenIndex(), x or 0, y or 0, zoom or 1)
    end;

    --- Sets the color of the ocean on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorOcean = function(r,g,b,a)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("MAPOCEAN", r or 0, g or 0, b or 0, a or 255)
    end;

    --- Sets the color of the shallows on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorShallows = function(r,g,b,a)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("MAPSHALLOWS", r or 0, g or 0, b or 0, a or 255)
    end;

    --- Sets the color of the land on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorLand = function(r,g,b,a)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("MAPLAND", r or 0, g or 0, b or 0, a or 255)
    end;

    --- Sets the color of the grass on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorGrass = function(r,g,b,a)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("MAPGRASS", r or 0, g or 0, b or 0, a or 255)
    end;

    --- Sets the color of the sand on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorSand = function(r,g,b,a)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("MAPSAND", r or 0, g or 0, b or 0, a or 255)
    end;

    --- Sets the color of the snow on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorSnow = function(r,g,b,a)
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("MAPSNOW", r or 0, g or 0, b or 0, a or 255)
    end;
}

map = {
    --- Translate pixel coordinates into world coordinates
    --- @param mapX number The current X world coordinate of the drawn map
    --- @param mapY number The current Y world coordinate of the drawn map
    --- @param zoom number The current zoom of the drawn map
    --- @param screenWidth number The width of the screen
    --- @param screenHeight number The height of the screen
    --- @param pixelX number The pixel's X coordinate to translate to a world coordinate
    --- @param pixelY number The pixel's Y coordinate to translate to a world coordinate
    --- @return number worldX, number worldY
    screenToMap = function(mapX, mapY, zoom, screenWidth, screenHeight, pixelX, pixelY)
        local metersPerPixel = (zoom * 1000) / screenWidth
        return math.floor(mapX + (metersPerPixel * (pixelX-screenWidth/2))), math.floor(mapY + (metersPerPixel * (pixelY-screenHeight/2)))
    end;

    --- Translate world coordinates into screen pixel coordinates
    --- @param mapX number The current X world coordinate of the drawn map
    --- @param mapY number The current Y world coordinate of the drawn map
    --- @param zoom number The current zoom of the drawn map
    --- @param screenWidth number The width of the screen
    --- @param screenHeight number The height of the screen
    --- @param worldX number The world X coordinate to translate to a pixel coordinate
    --- @param worldY number The world Y coordinate to translate to a pixel coordinate
    --- @return number pixelX, number pixelY
    mapToScreen = function(mapX, mapY, zoom, screenWidth, screenHeight, worldX, worldY)
        local pixelsPerMeter = screenWidth / (zoom * 1000)
        return math.floor((screenWidth/2) + (pixelsPerMeter * (worldX - mapX))), math.floor((screenHeight/2) + (pixelsPerMeter * (worldX - mapX)))
    end;
}

async = {
    --- Executes a HTTP GET request on the local machine
    --- NOTE: Not yet implemented in LBSimulator (and unlikely it ever will be)
    --- @param port number The port number to execute the request on
    --- @param url string The URL to execute the request on
    httpGet = function(port, url)
    end;
}


---@diagnostic enable: undefined-global
---@diagnostic enable: lowercase-global