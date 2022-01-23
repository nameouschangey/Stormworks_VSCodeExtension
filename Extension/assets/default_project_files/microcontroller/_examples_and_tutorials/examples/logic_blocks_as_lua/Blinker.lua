-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- F6 to run, example blinker

ticks = 1

numTicksToStayOff = 120 -- off for two seconds
numTicksToStayOn = 60 -- on for one second
isBlinkerOnToggle = false -- is the blinker on or off

onTick = function ()
    ticks = ticks + 1

    blinkerTick = ticks % (numTicksToStayOff + numTicksToStayOn) -- wraps it into the timing range we want
    isBlinkerOnToggle = blinkerTick > numTicksToStayOff -- starts off, then after 120 ticks, will be on, until it wraps back to 0
end

onDraw = function ()
    
    -- example drawing based on the blinker
    if isBlinkerOnToggle then
        screen.setColor(255,100,100)
        screen.drawRect(5,5,20,20)
    else
        screen.setColor(100,255,100)
        screen.drawRectF(5,5,20,20)
    end
end

