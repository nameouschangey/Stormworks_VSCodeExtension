-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Press F6 To Run
-- Make edits, see what happens, learn by doing

-- Aims:
--   Understand how Lua runs your code in game

debug.log("HowStormworksRuns example started")

debug.log("Instructions run one at a time, from the top of a file, down to the bottom")
debug.log("Like a recipe book.")

debug.log("In-game, the file is run when the MC is loaded. ONCE ONLY")
debug.log("That means in game, this part of the code would only run ONCE when the file loads")



---- QUICK REMINDER ON VARIABLES
exampleVariable = 123  -- assign the value 123 into the value "exampleVariable".
exampleVariable = 11   -- overwrites the previous value with the new one
abc123 = 22               -- a variable is like a box, with a label on the front. The box "abc123" now holds the NUMBER, 22
def456 = "my text"        -- and on this line, the box "def456" has the TEXT value "my text" put into it

debug.log("Note: The = sign means 'assign' NOT 'equals'. That means 'put the value from the right hand side, into the variable on the left")
------------------------------



tickCounter = 0 -- we'll use this in onTick

-- declare a variable called onTick containing a function
-- the game will look for this variable, so it can run out code every tick
onTick = function()
    
    -- STICK A BREAKPOINT HERE
    debug.log("STICK A BREAKPOINT HERE OR BE SPAMMED ENTERNALLY!")

    -- every in-game tick, the game looks for the variable "onTick" containing a function
    -- it then runs that function, which is where we are now
    debug.log("THIS CODE IS RUN EVERY TICK, BECAUSE THE GAME RUNS THE FUNCTION CALLED onTick OVER AND OVER AGAIN")

    -- a function is just a snippet of code
    -- it runs from the start of the function, down to the bottom of the function

    tickCounter = tickCounter + 1 -- add 1 to the tickCounter variable each tick
    debug.log("Current tickCounterValue: " .. tickCounter) -- ".." combines two pieces of text, or a piece of text with a number
end


onDraw = function ()
    -- the game also wants to find a variable called onDraw containing a function
    -- if it does, it will run this function each time the MC draws to a connected monitor
    debug.log("onDraw running here!")
end
