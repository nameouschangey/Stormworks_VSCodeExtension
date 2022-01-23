-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


--- Solution/Explanation

myVariable = 123    -- assign 123 into the variable called `myVariable`

myVariable = function()  -- overwrite previous value `myVariable` had, with a function
    debug.log("Is this running every tick?") -- these instructions will display messages in the VSCode DEBUG CONSOLE
    debug.log("Printing another message")   
end

onTick = myVariable -- assign the value of myVariable (a function) into onTick

--[[
    Was it surprising that the function we originally assigned to myVariable, is being run every tick?

    We can use the basic ideas before, to see why.
    
    Every tick, in-game, the game will look for a variable called "onTick" containing a function.
        If it finds it, it will run that function.

    So it doesn't matter where the function came from originally.
    All that the game cares about, is each tick - did it find a variable called onTick that has a function in it
        and if so, it runs that function.

    That's all there is to it!
]]