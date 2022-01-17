-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("_examples_and_tutorials.tutorials._intellisense_for_tutorials")

--[[
    The best way to learn is to RUN the file, and to try messing with things

    Remember, learning a new skill is hardest at the start - the fact you're doing this is impressive, it WILL get easier
    Right now, the more you learn - the more questions you'll have. It will be hard on your brain, but I promise you can do it.

    **There is no such thing as not being smart enough to code. No programmer is really that smart. It's just about putting time into it.**
]]

-- Hit F5 at any time, to run this file as a regular Lua file (without the Stormworks simulator).
--     You'll see debugger controls at the top of the window once it starts running.
--     Click StepInto to move 1 instruction at a time
--
--     You can use these to run 1 instruction at a time and see EXACTLY what lua is doing
--          * hovering over a variable tells you its current value
--          * clicking left of the line numbers will set a red circle ("breakpoint"). Pressing F5 will run all code up to that instruction.
--             you can use that to skip the parts you understand, and get straight to the "new" stuff each time

-- PS: If you noticed these green lines all start with "--", and don't seem to do anything. You've already intuitively figured out how comments work.


-------------------------------------------------------------------------------------------------------------
print("Notice how instructions")
print("Run from the top of the file")
print("To the bottom, where it stops")
print("Just like a cooking recipe book")
print("There is no magic, each instruction is run one at a time")
print("You can see these outputs in the DEBUG CONSOLE window at the bottom of VSCode")


-------------------------------------------------------------------------------------------------------------
print("-----Variables------")
-- these are variables
-- We assign values into variables using "=". This is assignment, *not* equality (it doesn't work like maths)
thisIsAVariable = 123                   -- numbers
thisIsAlsoAVariable = "this is text"    -- text (or "strings")
thisIsABoolean = true                   -- booleans can be true or false

a = 1 -- put the value 1 into the variable called a
a = 2 -- overwrite the previous value a had, with the number 2

b = 1 -- new variable b
c = a + b -- c will now be 3. (a was 2, b is 1, added together). Note that the addition is done first, then the result is put into c


-- what do you think this will do?
a = 5
a = a + 1
print("value of a: " .. a) -- note the .. is how we join two pieces of text together, or a piece of text and a number

-- one more time in case it wasn't clear
a = 10
b = 15
b = a * (b + a)
print("value of b: " .. b)

--[[ Note how this works (if you understand this, you understand 90% of coding):
        b = a * (b + a)     -- firstly, it substitutes the variables with their actual values
        b = 10 * (15 + 10)  -- then it resolves each part, starting in the brackets (like you'd expect)
        b = 10 * (25)
        b = 250 -- now we've got a simple value, it can be assigned into the variable b
]]

print("it shouldn't surprise you then, that this resolves to a single number before printing: " .. ((a + b) * 10) )



