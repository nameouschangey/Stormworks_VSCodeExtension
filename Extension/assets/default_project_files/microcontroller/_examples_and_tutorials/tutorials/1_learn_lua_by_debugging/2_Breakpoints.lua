-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
    If you ran the first file, you probably saw that it ran to the end, really quickly
        and didn't give you a chance to see what it was doing

    This example shows you how to use "Breakpoints", a really powerful debugger tool
    
    You can use these to see how the code runs, line by line, in every example!
]]

--INSTRUCTIONS
    -- 1. Click to the left of the line-number (the "18" to the left of this text)
    --      It will add a little red circle
    --    This is called a "Breakpoint"
    --      When the file is running (F6), it will pause when it reaches any lines with a "breakpoint" on them

    -- 2. Press F6 to run this file

    -- 3. Notice it's stopped running at the breakpoint, that line has gone yellow (this shows it's the current instruction)

    -- 4. Look for the play/pause/stop controls at the top of this VSCode editor screen 

    -- 5. Use the different controls ("Step Over" and "Step Into") to run code 1 line at a time

    -- 6. Hover your cursor over any variables (don't worry), to see their values
    --      It'll make sense when you try it.


-- here are some example lines of code, stick breakpoints and see how it runs:

debug.log("Breakpoints tutorial now running!")

a = 22      -- "a" is a variable (think "box with a label on the front"), and we assign the value 22 into it.
b = 1123    -- don't worry for now, but just know - the '=' in lua is 'assign value' NOT mathematic 'equals'

c = a + b

d = (100 * 10)
d = 123 + 123
d = 55

e = 1
e = e + 1 -- see how the right hand side resolves into a simple number value, so we can "stick it in the box" (assign it to the variable)
-- remember, each instruction runs 1 at a time, like a recipe book. That's all it's doing.

e = e * 10


myBoolean = true

-- don't stress over this, it'll make sense later, but an if statement runs the instruction inside it; IF the boolean is not nil or false
if myBoolean then
    debug.log("Calling the function `log`, stored in the table `debug`, because `myBoolean` wasnt nil and wasnt false")
else
    debug.log("This will only run if myBoolean was nil or false")
end


debug.log("as a note: you can also add/remove breakpoints while the code is running. Or while it's paused.")
debug.log("of course, if you have none set to start, this file will probably finish a bit too quick!")

-- Don't stress over how the specifics above work

-- The aim is just to see the following:
--      1. Code runs like a recipe book; one instruction at a time
--      2. Breakpoints let you pause the code, so you can run it one instruction at a time
--      3. Clicking to the left of the line number is how you set a breakpoint
--      4. Hovering the cursor over variables, lets you see their values


debug.log("Because there's nothing for the game to hook into here, nothing more will happen after here")
debug.log("So you can close the simulator, and move onto the next step - where we learn how to run things each tick")