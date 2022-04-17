-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Exercise
-- 1. Add drawing commands to the `drawTextInABox` function
--    This function is called from the onDraw function
--    Putting this code in a function like this, means we don't need to write it out 3 times with different numbers


drawTextInABox = function(x,y,width,height,text)
    -- your code here
    -- type `screen.` to see the available drawing functions
    -- use the parameter variables from above
end


onDraw = function()
    -- don't change this for this exercise
    drawTextInABox(5,5,10,10, "ONE")

    drawTextInABox(5,15,15,10, "TWO")  

    drawTextInABox(5,25,10,15, "THREE")
end