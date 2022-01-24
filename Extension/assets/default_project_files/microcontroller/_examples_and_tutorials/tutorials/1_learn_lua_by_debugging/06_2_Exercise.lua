-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Exercise
-- 1. draw a bunch of different shapes in the onDraw function
--    type `screen.` to see the different drawing functions and the parameters they want


onDraw = function()
    circleX = 12
    circleY = 12
    screen.drawCircle(circleX,circleY,10)
end