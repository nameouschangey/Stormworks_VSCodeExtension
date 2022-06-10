-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Exercise
-- 1. add another variable for the monitor touch-y position (where vertically the monitor is being touched)
--    this will need to read the value in input number 4

-- 2. in onDraw, use these coordinates you've stored in variables (remember, you can't call `input` directly from onDraw)
--      change the x and y position of the circle in onDraw, to be the last position that was touched (the touch-y input)

-- Once done, run the simulator (F6) and click the monitor to move the circle around


onTick = function()
    tickCounter = tickCounter + 1 -- add 1 each tick, so we can count how many ticks

    monitorTouchX = input.getNumber(3) -- x coordinate that's being clicked on the monitor
end



onDraw = function()
    circleX = 12
    circleY = 12
    screen.drawCircle(circleX,circleY,10)
end