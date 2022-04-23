-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- F6 to run!
-- Try changing how fast the circle moves, right now it's 1px per tick
-- Can try drawing other shapes, that move as well

x = 0 -- we'll use these as the positions for drawing the circle
y = 0

onTick = function()
    x = x + 1
    y = y + 1

    -- check if x has gone off the screen, and if so, reset it's position
    if x > 32 then
        x = 0
    end

    if y > 32 then
        y = 0
    end
end


onDraw = function()
    screen.setColor(255,100,100) -- set the drawing color for all future shapes (till the next setColor() call. Red, Green, Blue out of 255)
    screen.drawCircle(x,y, 5) -- draw a circle at x=16, y=16, with a radius that grows to 30 every 10 seconds
end