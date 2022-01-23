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
    --      (Don't be alarmed if the breakpoint moves down - it just moves past the comments to the first "real" instruction, to help you.)

    -- 2. Press F6 to run this file
    --    (If anything ever goes wrong, just click the big red STOP square at the top, come back to this file and go again.)

    -- 3. Notice it's stopped running at the breakpoint, the yellow line is instruction to be executed next

    -- 4. Look for the continue/pause/stop controls at the top of this VSCode editor screen 

    -- 5. Click "Step Into" (F11) to run the code 1 line at a time

    -- 6. Hover your cursor over any variables (don't worry), to see their values
    --      It'll make sense when you try it.


-- here are some example lines of code, stick breakpoints and see how it runs:

debug.log("Breakpoints tutorial now running!") -- debug.log is just an instruction that writes text, to the DEBUG CONSOLE at the bottom of your VSCode screen

a = 22      -- "a" is a variable (think "box with a label on the front"), and we tell it to store the number 22
b = 1123    -- unlike maths, we're not making an equation, b is a box - we put a value in it. It overwrites whatever value was in it before. That's it.

c = a + b   -- hover over this while debugging (debug controls visible at the top of the screen) - to check what the value is


d = (100 * 10)  -- set d to 1000 (100 * 10)
d = 123 + 123   -- overwrite d with a new value, 246 (123 + 123)
d = 55          -- notice how we overwrite the last value of d each time. Each instruction runs without caring what ran before it. We're just putting values in boxes.


e = 1
e = e + 1 -- see how the right hand side resolves into a simple number value, so we can "stick it in the box" (assign it to the variable)
          -- remember, each instruction runs 1 at a time, like a recipe book. That's all it's doing.
          -- if it's not obvious: use the debugger, and hover over 'e' to see what it's doing
e = e * 10

debug.log("current value of e is: " .. e)



isMyHatFancy = true

if isMyHatFancy then
    -- code in this bit runs if the variable 'isMyHatFancy' holds any value that isn't `nil` or `false` (variables are all 'nil' until we give them a value)
    debug.log("My Hat is Fancy")
else
    -- code here runs if the variable `isMyHatFancy` has the value `false` or `nil`
    debug.log("This code won't run because right now, my hat is fancy...Unless you changed that above.")
end


-- Congratulations
--      That might have been a lot to take in - especially if "things went wrong", like it opening up other files etc.
--      The start is THE HARDEST part of learning to code. If the above made sense, even just some sense, celebrate. It gets easier from here.
--      Remember, it's fine to take breaks - your brain might feel overloaded really fast; and that's because you're learning a lot.
--      And if something doesn't make sense, take a break, come back - don't get frustrated or feel like you can't do it. It's normal to find it hard, it'll get easier.


-- So, to recap - the aim is just to notice the following:
--      1. Code runs like a recipe book; one instruction at a time
--      2. Breakpoints let you pause the code, so you can run it one instruction at a time
--      3. Clicking to the left of the line number is how you set a breakpoint
--      4. F6 lets you run the file
--      5. While debugging, hovering the cursor over variables, lets you see their values




















--ignore me---------------------------------------------------------------------------------------------------
simulator:exit() -- this isn't an in-game instruction, we're just using it to make your life easier