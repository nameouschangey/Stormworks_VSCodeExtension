-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- An exercise to try, to get the hang of onTick and functions
-- Write your code and hit F6 to run
-- Solution at the bottom.

-- 1. in the onTick function, change the `condition` variable, so it's true once every 10 seconds (600 ticks)
--    which will mean the debug message is sent once per 600 ticks
--
--    tip: you'll want to use the "modulo" operator ( a % b ) which returns the remainder of division, aka, "wraps a into the range 0->b"

ticks = 0
onTick = function()
    ticks = ticks + 1

    condition = false -- change me, make me useful

    if condition then
        -- this code only runs when `condition` is NOT false or nil (in this example, we set it to be false - you should change that)
        debug.log("This should output once every 10 seconds, if you've changed the condition correctly.")
    end
end


-- note, if you succeeded; you've now learned how to make something run "once every x ticks"