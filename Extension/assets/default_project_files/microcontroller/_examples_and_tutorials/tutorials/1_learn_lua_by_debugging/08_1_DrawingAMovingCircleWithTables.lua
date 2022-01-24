-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- F6 to run!

-- Tables are just big collections of "keys" and "values".
-- Keys&Values can be any type of thing; text, numbers, booleans, functions, even other tables

-- remember, you've already actually used tables - `input` and `output` are tables themselves!
circleTable = {
    x = 0,
    y = 0
}

onTick = function()
    circleTable.x = circleTable.x + 1
    circleTable.y = circleTable.y + 1

    if circleTable.x > 32 then
        circleTable.x = 0
    end

    if circleTable.y > 32 then
        circleTable.y = 0
    end
end


onDraw = function()
    screen.setColor(255,100,100) -- set the drawing color for all future shapes (till the next setColor() call. Red, Green, Blue out of 255)
    screen.drawCircle(circleTable.x, circleTable.y, 5) -- draw a circle at x=16, y=16, with a radius that grows to 30 every 10 seconds
end

-- But why do this? isn't it easier with just "x" and "y" in the other example?
-- Next file shows the power of using a table - how you can write it once, and have it work for lots of things!

-- You can try making a second table for a second circle, then add the movement code in onTick, and drawing code in onDraw to show it!