-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Write your code and hit F6 to run
-- Solution at the bottom.


-- 1. in the onTick function, write an if statement that runs AFTER 300 ticks have passed
--      the instruction to run inside the if statement is: debug.log("THIS SHOULDNT RUN FOR THE FIRST 300 TICKS")
-- tip: think of how you could make a countdown

ticksToWait = 300
onTick = function()
    -- your code here:

end



-- don't be put off by it seeming "empty" to start
-- you can use what you had in the last exercise, and modify it - if that helps you get started.


-- (and when you succeed; you've figured out how to make a timer!)




















--[[
Example solution, of course there's many ways to do the same thing

ticksToWait = 300
onTick = function()
    ticksToWait = ticksToWait - 1   -- each tick, count down 1

    -- <= is less than or equal to, so when the ticksToWait reaches 0, and afterwards once it goes into the negatives - run this
    if ticksToWait <= 0 then
        debug.log("COUNTDOWN HAS FINISHED, RUNNING THIS CODE")
        -- could do other things here, like set your propeller, change the engine thrust etc.
    end
end


-- a slight variation on the above, which runs JUST ONCE after 300 ticks
--  would be to change the condition, from `ticksToWait <= 0`, to `ticksToWait == 0`
--  that means, the one time it reaches 0, do the action (debug.log)
--  but every tick after that, when it becomes -1, -2, etc. we don't do the action (debug.log())

]]