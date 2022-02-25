-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

-- Using API Signatures and Lua Doc commants from Rene Sackers
--      Auto generated docs by StormworksLuaDocsGen (https://github.com/Rene-Sackers/StormworksLuaDocsGen)
--      Based on data in: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go
--      Notice issues/missing info? Please contribute here: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go, then create an issue on the GitHub repo

---@diagnostic disable: undefined-doc-param

LifeBoatAPI.Tools.AreNumbersNan = function(...)
    for _,v in ipairs({...}) do
        if v == math.huge or v == -math.huge or v ~= v then
            return true
        end
    end
    return false
end;

LifeBoatAPI.Tools.SelectNumber = function(index, default, ...)
    local value = select(index, ...)
    if not value or type(value) ~= "number" then
        return default
    else
        return value
    end 
end;


---@diagnostic disable: undefined-global
---@diagnostic disable: lowercase-global

---@class Simulator_ScreenAPI
---@field _simulator Simulator simulator connection
screen = {
    _simulator = nil;

    _ensureIsRendering = function()
        if not screen._simulator or not screen._simulator._isRendering then
            error("Cannot use screen functions outside of onDraw.")
        end
    end;

    _setSimulator = function (simulator)
        screen._simulator = simulator
    end;

    _getSimulatorScreenIndex = function ()
        return screen._simulator._currentScreen.screenNumber
    end;

    _setColorBase = function (...)
        if select("#",...) < 3 then return end
        screen._ensureIsRendering()

        local r = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local g = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local b = LifeBoatAPI.Tools.SelectNumber(3,0, ...)
        local a = LifeBoatAPI.Tools.SelectNumber(4,0, ...)

        if select("#", ...) < 4 then a = 255 end

        if LifeBoatAPI.Tools.AreNumbersNan(r,g,b,a) then return end

        -- wrap numbers to 0->255 range before correction
        r = r % 256
        g = g % 256
        b = b % 256
        a = a % 256
        
        --- the game applies gamma - which we need to replicate
        --- makes all colours far more washed out.
        --- see: https://steamcommunity.com/sharedfiles/filedetails/?id=2273112890
        local correctColor = function (c)
            local A = 1/0.85
            local Y = 1/2.4

            c = c / 255
            return 255 * (A*c)^Y
        end

        r = correctColor(r)
        g = correctColor(g)
        b = correctColor(b)

        return r, g, b, a
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
    setColor = function(...)
        local r,g,b,a = screen._setColorBase(...)
        if not r then return end
        screen._simulator._connection:sendCommand("COLOUR", r,g,b,a)
    end;

    --- Clear the screen with the current color
    drawClear = function()
        screen._ensureIsRendering()
        screen._simulator._connection:sendCommand("CLEAR", screen._getSimulatorScreenIndex())
    end;

    --- Draws a line on the screen from x1, y1 to x2, y2
    --- @param x1 number The X coordinate of the start of the line
    --- @param y1 number The Y coordinate of the start of the line
    --- @param x2 number The X coordinate of the end of the line
    --- @param y2 number The Y coordinate of the end of the line
    drawLine = function(...)
        if select("#",...) < 4 then return end
        screen._ensureIsRendering()

        local x1 = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local y1 = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local x2 = LifeBoatAPI.Tools.SelectNumber(3,0, ...)
        local y2 = LifeBoatAPI.Tools.SelectNumber(4,0, ...)

        if LifeBoatAPI.Tools.AreNumbersNan(x1, y1, x2, y2) then return end

        screen._simulator._connection:sendCommand("LINE", screen._getSimulatorScreenIndex(), x1, y1, x2, y2)
    end;

    --- Draws an outlined circle on the screen
    --- @param x number The X coordinate of the center of the circle
    --- @param y number The Y coordinate of the center of the circle
    --- @param radius number The radius of the circle
    drawCircle = function(...)
        if select("#", ...) < 3 then return end
        screen._ensureIsRendering()

        local x         = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local y         = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local radius    = LifeBoatAPI.Tools.SelectNumber(3,0, ...)

        if LifeBoatAPI.Tools.AreNumbersNan(x, y, radius) then return end
        
        screen._simulator._connection:sendCommand("CIRCLE", screen._getSimulatorScreenIndex(), "0", x, y, radius)
    end;

    --- Draws a filled circle on the screen
    --- @param x number The X coordinate of the center of the circle
    --- @param y number The Y coordinate of the center of the circle
    --- @param radius number The radius of the circle
    drawCircleF = function(...)
        if select("#", ...) < 3 then return end
        screen._ensureIsRendering()

        local x         = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local y         = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local radius    = LifeBoatAPI.Tools.SelectNumber(3,0, ...)

        if LifeBoatAPI.Tools.AreNumbersNan(x, y, radius) then return end

        screen._simulator._connection:sendCommand("CIRCLE", screen._getSimulatorScreenIndex(), "1", x, y, radius)
    end;

    --- Draws an outlined rectangle on the screen
    --- @param x number The top left X coordinate of the rectangle
    --- @param y number The top left Y coordinate of the rectangle
    --- @param width number The width of the rectangle
    --- @param height number The height of the rectangle
    drawRect = function(...)
        if select("#", ...) < 4 then return end
        screen._ensureIsRendering()

        local x         = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local y         = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local width     = LifeBoatAPI.Tools.SelectNumber(3,0, ...)
        local height    = LifeBoatAPI.Tools.SelectNumber(4,0, ...)

        if LifeBoatAPI.Tools.AreNumbersNan(x, y, width, height) then return end

        screen._simulator._connection:sendCommand("RECT", screen._getSimulatorScreenIndex(), "0", x, y, width, height)
    end;

    --- Draws a filled rectangle on the screen
    --- @param x number The top left X coordinate of the rectangle
    --- @param y number The top left Y coordinate of the rectangle
    --- @param width number The width of the rectangle
    --- @param height number The height of the rectangle
    drawRectF = function(...)
        if select("#", ...) < 4 then return end
        screen._ensureIsRendering()

        local x         = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local y         = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local width     = LifeBoatAPI.Tools.SelectNumber(3,0, ...)
        local height    = LifeBoatAPI.Tools.SelectNumber(4,0, ...)

        if LifeBoatAPI.Tools.AreNumbersNan(x, y, width, height) then return end

        screen._simulator._connection:sendCommand("RECT", screen._getSimulatorScreenIndex(), "1", x, y, width, height)
    end;

    --- Draws a triangle on the screen
    --- @param x1 number The X coordinate of the first point of the triangle
    --- @param y1 number The Y coordinate of the first point of the triangle
    --- @param x2 number The X coordinate of the second point of the triangle
    --- @param y2 number The Y coordinate of the second point of the triangle
    --- @param x3 number The X coordinate of the third point of the triangle
    --- @param y3 number The Y coordinate of the third point of the triangle
    drawTriangle = function(...)
        if select("#", ...) < 6 then return end
        screen._ensureIsRendering()

        local x1    = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local y1    = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local x2    = LifeBoatAPI.Tools.SelectNumber(3,0, ...)
        local y2    = LifeBoatAPI.Tools.SelectNumber(4,0, ...)
        local x3    = LifeBoatAPI.Tools.SelectNumber(5,0, ...)
        local y3    = LifeBoatAPI.Tools.SelectNumber(6,0, ...)

        if LifeBoatAPI.Tools.AreNumbersNan(x1, y1, x2, y2, x3, y3) then return end

        screen._simulator._connection:sendCommand("TRIANGLE", screen._getSimulatorScreenIndex(), "0", x1, y1, x2, y2, x3, y3)
    end;

    --- Draws a filled triangle on the screen
    --- @param x1 number The X coordinate of the first point of the triangle
    --- @param y1 number The Y coordinate of the first point of the triangle
    --- @param x2 number The X coordinate of the second point of the triangle
    --- @param y2 number The Y coordinate of the second point of the triangle
    --- @param x3 number The X coordinate of the third point of the triangle
    --- @param y3 number The Y coordinate of the third point of the triangle
    drawTriangleF = function(...)
        if select("#", ...) < 6 then return end
        screen._ensureIsRendering()

        local x1    = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local y1    = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local x2    = LifeBoatAPI.Tools.SelectNumber(3,0, ...)
        local y2    = LifeBoatAPI.Tools.SelectNumber(4,0, ...)
        local x3    = LifeBoatAPI.Tools.SelectNumber(5,0, ...)
        local y3    = LifeBoatAPI.Tools.SelectNumber(6,0, ...)

        if LifeBoatAPI.Tools.AreNumbersNan(x1, y1, x2, y2, x3, y3) then return end

        screen._simulator._connection:sendCommand("TRIANGLE", screen._getSimulatorScreenIndex(), "1", x1, y1, x2, y2, x3, y3)
    end;

    --- Draws text on the screen
    --- @param x number The X coordinate of the top left of the text
    --- @param y number The Y coordinate of the top left of the text
    --- @param text string The text to draw
    drawText = function(...)
        if select("#", ...) < 3 then return end
        screen._ensureIsRendering()

        local x    = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local y    = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local text = select(3, ...)

        if type(text) ~= "string" then return end

        if LifeBoatAPI.Tools.AreNumbersNan(x,y) then return end

        screen._simulator._connection:sendCommand("TEXT", screen._getSimulatorScreenIndex(), x, y, text)
    end;

    --- Draw text within a rectangle
    --- @param x number The X coordinate of the top left of the textbox
    --- @param y number The Y coordinate of the top left of the textbox
    --- @param width number The width of the textbox
    --- @param height number The height of the textbox
    --- @param text string The text to draw
    --- @param horizontalAlign number How to align the text horizontally (-1 = left, 0 = center, 1 = right)
    --- @param verticalAlign number How to align the text vertically (-1 = top, 0 = center, 1 = bottom)
    drawTextBox = function(...)
        if select("#", ...) < 5 then return end
        screen._ensureIsRendering()

        local x                 = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local y                 = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local width             = LifeBoatAPI.Tools.SelectNumber(3,0, ...)
        local height            = LifeBoatAPI.Tools.SelectNumber(4,0, ...)
        local text              = select(5, ...)
        local horizontalAlign   = LifeBoatAPI.Tools.SelectNumber(6,-1, ...)
        local verticalAlign     = LifeBoatAPI.Tools.SelectNumber(7,-1, ...)

        if type(text) ~= "string" then return end

        if LifeBoatAPI.Tools.AreNumbersNan(x, y, width, height, horizontalAlign, verticalAlign) then return end

        screen._simulator._connection:sendCommand("TEXTBOX", screen._getSimulatorScreenIndex(), x, y, width, height, horizontalAlign, verticalAlign, text)
    end;

    --- Draw a map on the screen
    --- @param x number The world X coordinate to center the map on
    --- @param y number The world Y coordinate to center the map on
    --- @param zoom number The zoom (0.1 - 50, 0.1 = max zoom in, 50 = max zoom out), width of screen at zoom 1 is 1Km
    drawMap = function(...)
        if select("#", ...) < 3 then return end
        screen._ensureIsRendering()

        local x     = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local y     = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local zoom  = LifeBoatAPI.Tools.SelectNumber(3,1, ...)

        if LifeBoatAPI.Tools.AreNumbersNan(x, y, zoom) then return end
  
        screen._simulator._connection:sendCommand("MAP", screen._getSimulatorScreenIndex(), x, y, zoom)
    end;

    --- Sets the color of the ocean on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorOcean = function(...)
        local r,g,b,a = screen._setColorBase(...)
        if not r then return end
        screen._simulator._connection:sendCommand("MAPOCEAN", r,g,b,a)
    end;

    --- Sets the color of the shallows on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorShallows = function(...)
        local r,g,b,a = screen._setColorBase(...)
        if not r then return end
        screen._simulator._connection:sendCommand("MAPSHALLOWS", r,g,b,a)
    end;

    --- Sets the color of the land on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorLand = function(...)
        local r,g,b,a = screen._setColorBase(...)
        if not r then return end
        screen._simulator._connection:sendCommand("MAPLAND", r,g,b,a)
    end;

    --- Sets the color of the grass on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorGrass = function(...)
        local r,g,b,a = screen._setColorBase(...)
        if not r then return end
        screen._simulator._connection:sendCommand("MAPGRASS", r,g,b,a)
    end;

    --- Sets the color of the sand on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorSand = function(...)
        local r,g,b,a = screen._setColorBase(...)
        if not r then return end
        screen._simulator._connection:sendCommand("MAPSAND", r,g,b,a)
    end;

    --- Sets the color of the snow on the drawn map
    --- NOTE: Not yet implemented in LBSimulator
    --- @param r number The red value of the color (0 - 255)
    --- @param g number The green value of the color (0 - 255)
    --- @param b number The blue value of the color (0 - 255)
    --- @param a number|nil The alpha (transparency) value of the color (0 - 255)
    setMapColorSnow = function(...)
        local r,g,b,a = screen._setColorBase(...)
        if not r then return end
        screen._simulator._connection:sendCommand("MAPSNOW", r,g,b,a)
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
    screenToMap = function(...)
        if select("#", ...) < 7 then return end

        local mapX          = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local mapY          = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local zoom          = LifeBoatAPI.Tools.SelectNumber(3,1, ...)
        local screenWidth   = LifeBoatAPI.Tools.SelectNumber(4,0, ...)
        local screenHeight  = LifeBoatAPI.Tools.SelectNumber(5,0, ...)
        local pixelX        = LifeBoatAPI.Tools.SelectNumber(6,0, ...)
        local pixelY        = LifeBoatAPI.Tools.SelectNumber(7,0, ...)

        if LifeBoatAPI.Tools.AreNumbersNan(mapX, mapY, zoom, screenWidth, screenHeight, pixelX, pixelY) then return end

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
    mapToScreen = function(...)
        if select("#", ...) < 7 then return end

        local mapX          = LifeBoatAPI.Tools.SelectNumber(1,0, ...)
        local mapY          = LifeBoatAPI.Tools.SelectNumber(2,0, ...)
        local zoom          = LifeBoatAPI.Tools.SelectNumber(3,1, ...)
        local screenWidth   = LifeBoatAPI.Tools.SelectNumber(4,0, ...)
        local screenHeight  = LifeBoatAPI.Tools.SelectNumber(5,0, ...)
        local worldX        = LifeBoatAPI.Tools.SelectNumber(6,0, ...)
        local worldY        = LifeBoatAPI.Tools.SelectNumber(7,0, ...)

        if LifeBoatAPI.Tools.AreNumbersNan(mapX, mapY, zoom, screenWidth, screenHeight, worldX, worldY) then return end

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