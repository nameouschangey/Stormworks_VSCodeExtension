-- Nameous Changey

-- Based on work by Rene-Sackers ('Nelo):
--      Auto generated docs by StormworksLuaDocsGen (https://github.com/Rene-Sackers/StormworksLuaDocsGen)
--      Based on data in: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go
--      Notice issues/missing info? Please contribute here: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go, then create an issue on the GitHub repo

---@diagnostic disable: undefined-global

---@class LBSimulator_ScreenAPI
---@field _Width number screen width in Stormworks pixels
---@field _Height number screen height in Stormworks pixels
---@field _Love2DWidth number simulator screen width in real pixels
---@field _Love2DHeight number simulator screen height in real pixels
screen = {
    _Width = 32;         -- CONFIG VALUE ONLY, DO NOT READ FROM THIS IN YOUR CODE
    _Height = 32;        -- CONFIG VALUE ONLY, DO NOT READ FROM THIS IN YOUR CODE

    _Love2DScreenWidth = 720;
    _Love2DScreenHeight = 640;
    _Love2DMarginX = 170;
    _Love2DMarginY = 40;

    _DrawableX = 0;
    _DrawableY = 0;
    _DrawableWidth = 0;
    _DrawableHeight = 0;

    love2D_recalculateScreen = function()
        local wAspectRatio = screen.getHeight() / screen.getWidth()
        local hAspectRatio = screen.getWidth() / screen.getHeight()

        local maxPossibleWidth = screen._Love2DScreenWidth - (screen._Love2DMarginX * 2)
        local maxPossibleHeight = screen._Love2DScreenHeight - (screen._Love2DMarginY * 2)

        screen._DrawableX = screen._Love2DMarginX
        screen._DrawableY = screen._Love2DMarginY

        if(maxPossibleWidth * wAspectRatio <= maxPossibleHeight) then
            screen._DrawableWidth = math.floor(maxPossibleWidth)
            screen._DrawableHeight = math.floor(maxPossibleWidth * wAspectRatio)
        elseif(maxPossibleHeight * hAspectRatio <= maxPossibleWidth) then
            screen._DrawableWidth = math.floor(maxPossibleHeight * hAspectRatio)
            screen._DrawableHeight = math.floor(maxPossibleHeight)
        else
            screen._DrawableWidth = 0
            screen._DrawableHeight = 0
        end
    end;

    love2D_width = function(x)
        return (x/screen.getWidth()) * screen._DrawableWidth
    end;

    love2D_height = function(y)
        return (y/screen.getHeight()) * screen._DrawableHeight
    end;

    love2D_x = function(x)
        return screen.love2D_width(x) + screen._DrawableX
    end;

    love2D_y = function(y)
        return screen.love2D_height(y) + screen._DrawableY
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
        a = a or 0
        love.graphics.setColor(r/255, g/255, b/255, 1.0 - (a/255))
    end;

    --- Clear the screen with the current color
    drawClear = function()
        screen.drawRectF(0, 0, screen.getWidth(), screen.getHeight())
    end;

    --- Draws a line on the screen from x1, y1 to x2, y2
    --- @param x1 number The X coordinate of the start of the line
    --- @param y1 number The Y coordinate of the start of the line
    --- @param x2 number The X coordinate of the end of the line
    --- @param y2 number The Y coordinate of the end of the line
    drawLine = function(x1, y1, x2, y2)
        love.graphics.line(screen.love2D_x(x1),screen.love2D_y(y1),screen.love2D_x(x2),screen.love2D_y(y2))
    end;

    --- Draws an outlined circle on the screen
    --- @param x number The X coordinate of the center of the circle
    --- @param y number The Y coordinate of the center of the circle
    --- @param radius number The radius of the circle
    drawCircle = function(x, y, radius)
        love.graphics.circle("line", screen.love2D_x(x), screen.love2D_y(y), screen.love2D_width(radius))
    end;

    --- Draws a filled circle on the screen
    --- @param x number The X coordinate of the center of the circle
    --- @param y number The Y coordinate of the center of the circle
    --- @param radius number The radius of the circle
    drawCircleF = function(x, y, radius)
        love.graphics.circle("fill", screen.love2D_x(x), screen.love2D_y(y), screen.love2D_width(radius))
    end;

    --- Draws an outlined rectangle on the screen
    --- @param x number The top left X coordinate of the rectangle
    --- @param y number The top left Y coordinate of the rectangle
    --- @param width number The width of the rectangle
    --- @param height number The height of the rectangle
    drawRect = function(x, y, width, height)
        love.graphics.rectangle("line", screen.love2D_x(x), screen.love2D_y(y), screen.love2D_width(width), screen.love2D_height(height))
    end;

    --- Draws a filled rectangle on the screen
    --- @param x number The top left X coordinate of the rectangle
    --- @param y number The top left Y coordinate of the rectangle
    --- @param width number The width of the rectangle
    --- @param height number The height of the rectangle
    drawRectF = function(x, y, width, height)
        love.graphics.rectangle("fill", screen.love2D_x(x), screen.love2D_y(y), screen.love2D_width(width), screen.love2D_height(height))
    end;

    --- Draws a triangle on the screen
    --- @param x1 number The X coordinate of the first point of the triangle
    --- @param y1 number The Y coordinate of the first point of the triangle
    --- @param x2 number The X coordinate of the second point of the triangle
    --- @param y2 number The Y coordinate of the second point of the triangle
    --- @param x3 number The X coordinate of the third point of the triangle
    --- @param y3 number The Y coordinate of the third point of the triangle
    drawTriangle = function(x1, y1, x2, y2, x3, y3)
        love.graphics.triangle("line", screen.love2D_x(x1),screen.love2D_y(y1),screen.love2D_x(x2),screen.love2D_y(y2), screen.love2D_x(x3),screen.love2D_y(y3))
    end;

    --- Draws a filled triangle on the screen
    --- @param x1 number The X coordinate of the first point of the triangle
    --- @param y1 number The Y coordinate of the first point of the triangle
    --- @param x2 number The X coordinate of the second point of the triangle
    --- @param y2 number The Y coordinate of the second point of the triangle
    --- @param x3 number The X coordinate of the third point of the triangle
    --- @param y3 number The Y coordinate of the third point of the triangle
    drawTriangleF = function(x1, y1, x2, y2, x3, y3)
        love.graphics.triangle("fill", screen.love2D_x(x1),screen.love2D_y(y1),screen.love2D_x(x2),screen.love2D_y(y2), screen.love2D_x(x3),screen.love2D_y(y3))
    end;

    --- Draws text on the screen
    --- @param x number The X coordinate of the top left of the text
    --- @param y number The Y coordinate of the top left of the text
    --- @param text string The text to draw
    drawText = function(x, y, text)
        love.graphics.print(text:upper(), screen.love2D_x(x), screen.love2D_y(y-1), 0, 0.5 * screen._DrawableWidth / screen.getWidth())
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
        love.graphics.printf(text, screen.love2D_x(x), screen.love2D_y(y-1), screen.love2D_width(width),  0, 0.5 * screen._DrawableWidth / screen.getWidth())
    end;

    drawMap             = function(...)end;
    setMapColorOcean    = function(...)end;
    setMapColorShallows = function(...)end;
    setMapColorLand     = function(...)end;
    setMapColorGrass    = function(...)end;
    setMapColorSand     = function(...)end;
    setMapColorSnow     = function(...)end;
}


-- can't really do much with these, as it's external
map = {
    screenToMap = function(...)end;
    mapToScreen = function(...)end;
}

async = {
    httpGet = function(...)end;
}



