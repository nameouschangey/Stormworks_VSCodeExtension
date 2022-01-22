-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------

-- F6 to run me!

--  Add a breakpoint (click to the left of the line number), next to one of the instructions below
--  When the debugger stops on that instruction, there will be controls at the top of the page to move it one instruction at a time
--  You can also hover over variables to see what their value is at that point in time

--  And in the "Run and Debug" tab on the left, you can see the callstack, and list of all global variables


function onTick()
    randomValue = math.random()

    if ticks % 100 == 0 then
        -- click to the left of the line-numbers to add a red circle
        -- this is a "breakpoint"
        a = 123
    end

    output.setNumber(10, randomValue);
end

