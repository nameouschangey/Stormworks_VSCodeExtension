-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Exercise
-- Read this code, guess what will happen, then run it to check (F6)
-- Explanation/Spoilers in the next file, if it doesn't make sense

myVariable = 123

myVariable = function()
    debug.log("Is this running every tick?")
    debug.log("Printing another message")
end

onTick = myVariable