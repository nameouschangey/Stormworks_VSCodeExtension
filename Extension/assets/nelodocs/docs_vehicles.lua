-- Auto generated docs by StormworksLuaDocsGen (https://github.com/Rene-Sackers/StormworksLuaDocsGen)
-- Based on data in: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go
-- Notice issues/missing info? Please contribute here: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go, then create an issue on the GitHub repo

-- Minor edits by NameousChangey to bring this up to date

--- @diagnostic disable: lowercase-global

input = {}
output = {}
property = {}
screen = {}
map = {}
async = {}
debug = {}

--- Prints a message to the debug log, see DebugViewer by SysInternals (google)
--- In the simulator, prints the message using regular "print"
--- @varargs same parameters as print
function debug.log(...) end

--- Read an on/off value from the composite input
--- @param index number The composite index to read from
--- @return boolean value
function input.getBool(index) end

--- Read a number value from the composite input
--- @param index number The composite index to read from
--- @return number value
function input.getNumber(index) end

--- Set an on/off value on the composite output
--- @param index number The composite index to write to
--- @param value boolean The on/off value to write
function output.setBool(index, value) end

--- Set a number value on the composite output
--- @param index number The composite index to write to
--- @param value number The number value to write
function output.setNumber(index, value) end

--- Get a number value from a property
--- @param label string The name of the property to read
--- @return number value
function property.getNumber(label) end

--- Get a bool value from a property
--- @param label string The name of the property to read
--- @return boolean value
function property.getBool(label) end

--- Get a text value from a property
--- @param label string The name of the property to read
--- @return string value
function property.getText(label) end

--- Set the current drawing color
--- @param r number The red value of the color (0 - 255)
--- @param g number The green value of the color (0 - 255)
--- @param b number The blue value of the color (0 - 255)
--- @param a number|nil The alpha (transparency) value of the color (0 - 255)
function screen.setColor(r, g, b, a) end

--- Clear the screen with the current color
function screen.drawClear() end

--- Draws a line on the screen from x1, y1 to x2, y2
--- @param x1 number The X coordinate of the start of the line
--- @param y1 number The Y coordinate of the start of the line
--- @param x2 number The X coordinate of the end of the line
--- @param y2 number The Y coordinate of the end of the line
function screen.drawLine(x1, y1, x2, y2) end

--- Draws an outlined circle on the screen
--- @param x number The X coordinate of the center of the circle
--- @param y number The Y coordinate of the center of the circle
--- @param radius number The radius of the circle
function screen.drawCircle(x, y, radius) end

--- Draws a filled circle on the screen
--- @param x number The X coordinate of the center of the circle
--- @param y number The Y coordinate of the center of the circle
--- @param radius number The radius of the circle
function screen.drawCircleF(x, y, radius) end

--- Draws an outlined rectangle on the screen
--- @param x number The top left X coordinate of the rectangle
--- @param y number The top left Y coordinate of the rectangle
--- @param width number The width of the rectangle
--- @param height number The height of the rectangle
function screen.drawRect(x, y, width, height) end

--- Draws a filled rectangle on the screen
--- @param x number The top left X coordinate of the rectangle
--- @param y number The top left Y coordinate of the rectangle
--- @param width number The width of the rectangle
--- @param height number The height of the rectangle
function screen.drawRectF(x, y, width, height) end

--- Draws a triangle on the screen
--- @param x1 number The X coordinate of the first point of the triangle
--- @param y1 number The Y coordinate of the first point of the triangle
--- @param x2 number The X coordinate of the second point of the triangle
--- @param y2 number The Y coordinate of the second point of the triangle
--- @param x3 number The X coordinate of the third point of the triangle
--- @param y3 number The Y coordinate of the third point of the triangle
function screen.drawTriangle(x1, y1, x2, y2, x3, y3) end

--- Draws a filled triangle on the screen
--- @param x1 number The X coordinate of the first point of the triangle
--- @param y1 number The Y coordinate of the first point of the triangle
--- @param x2 number The X coordinate of the second point of the triangle
--- @param y2 number The Y coordinate of the second point of the triangle
--- @param x3 number The X coordinate of the third point of the triangle
--- @param y3 number The Y coordinate of the third point of the triangle
function screen.drawTriangleF(x1, y1, x2, y2, x3, y3) end

--- Draws text on the screen
--- @param x number The X coordinate of the top left of the text
--- @param y number The Y coordinate of the top left of the text
--- @param text string The text to draw
function screen.drawText(x, y, text) end

--- Draw text within a rectangle
--- @param x number The X coordinate of the top left of the textbox
--- @param y number The Y coordinate of the top left of the textbox
--- @param width number The width of the textbox
--- @param height number The height of the textbox
--- @param text string The text to draw
--- @param horizontalAlign number How to align the text horizontally (-1 = left, 0 = center, 1 = right)
--- @param verticalAlign number How to align the text vertically (-1 = top, 0 = center, 1 = bottom)
function screen.drawTextBox(x, y, width, height, text, horizontalAlign, verticalAlign) end

--- Draw a map on the screen
--- @param x number The world X coordinate to center the map on
--- @param y number The world Y coordinate to center the map on
--- @param zoom number The zoom (0.1 - 50, 0.1 = max zoom in, 50 = max zoom out)
function screen.drawMap(x, y, zoom) end

--- Sets the color of the ocean on the drawn map
--- @param r number The red value of the color (0 - 255)
--- @param g number The green value of the color (0 - 255)
--- @param b number The blue value of the color (0 - 255)
--- @param a number|nil The alpha (transparency) value of the color (0 - 255)
function screen.setMapColorOcean(r, g, b, a) end

--- Sets the color of the shallows on the drawn map
--- @param r number The red value of the color (0 - 255)
--- @param g number The green value of the color (0 - 255)
--- @param b number The blue value of the color (0 - 255)
--- @param a number|nil The alpha (transparency) value of the color (0 - 255)
function screen.setMapColorShallows(r, g, b, a) end

--- Sets the color of the land on the drawn map
--- @param r number The red value of the color (0 - 255)
--- @param g number The green value of the color (0 - 255)
--- @param b number The blue value of the color (0 - 255)
--- @param a number|nil The alpha (transparency) value of the color (0 - 255)
function screen.setMapColorLand(r, g, b, a) end

--- Sets the color of the grass on the drawn map
--- @param r number The red value of the color (0 - 255)
--- @param g number The green value of the color (0 - 255)
--- @param b number The blue value of the color (0 - 255)
--- @param a number|nil The alpha (transparency) value of the color (0 - 255)
function screen.setMapColorGrass(r, g, b, a) end

--- Sets the color of the sand on the drawn map
--- @param r number The red value of the color (0 - 255)
--- @param g number The green value of the color (0 - 255)
--- @param b number The blue value of the color (0 - 255)
--- @param a number|nil The alpha (transparency) value of the color (0 - 255)
function screen.setMapColorSand(r, g, b, a) end

--- Sets the color of the snow on the drawn map
--- @param r number The red value of the color (0 - 255)
--- @param g number The green value of the color (0 - 255)
--- @param b number The blue value of the color (0 - 255)
--- @param a number|nil The alpha (transparency) value of the color (0 - 255)
function screen.setMapColorSnow(r, g, b, a) end

--- Gets the width of the screen (pixels)
--- @return number width
function screen.getWidth() end

--- Gets the height of the screen (pixels)
--- @return number height
function screen.getHeight() end

--- Translate pixel coordinates into world coordinates
--- @param mapX number The current X world coordinate of the drawn map
--- @param mapY number The current Y world coordinate of the drawn map
--- @param zoom number The current zoom of the drawn map
--- @param screenWidth number The width of the screen
--- @param screenHeight number The height of the screen
--- @param pixelX number The pixel's X coordinate to translate to a world coordinate
--- @param pixelY number The pixel's Y coordinate to translate to a world coordinate
--- @return number worldX, number worldY
function map.screenToMap(mapX, mapY, zoom, screenWidth, screenHeight, pixelX, pixelY) end

--- Translate world coordinates into screen pixel coordinates
--- @param mapX number The current X world coordinate of the drawn map
--- @param mapY number The current Y world coordinate of the drawn map
--- @param zoom number The current zoom of the drawn map
--- @param screenWidth number The width of the screen
--- @param screenHeight number The height of the screen
--- @param worldX number The world X coordinate to translate to a pixel coordinate
--- @param worldY number The world Y coordinate to translate to a pixel coordinate
--- @return number pixelX, number pixelY
function map.mapToScreen(mapX, mapY, zoom, screenWidth, screenHeight, worldX, worldY) end

--- Executes a HTTP GET request on the local machine
--- @param port number The port number to execute the request on
--- @param url string The URL to execute the request on
function async.httpGet(port, url) end

