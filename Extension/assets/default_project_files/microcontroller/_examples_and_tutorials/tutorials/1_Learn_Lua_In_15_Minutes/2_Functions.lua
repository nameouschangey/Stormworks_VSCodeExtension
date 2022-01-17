-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


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
print("-----Functions------")
-- to save us writing the same code over and over we can use "functions"
-- a function is just a piece of code we've given a name, that we can "call" like we have been doing with print
--   it can take parameters (inputs) and can return an answer
print("remember, print is a function - we just didn't write it")

-- this is the syntax for a function called "add"
--      it takes two "parameters", number1 and number2
function add(number1, number2)
    local result = number1 + number2 -- "local" means this variable "result" ONLY exists in the function
    return result -- return the value of our result
end

-- and this is how we use it. Just like print.
add(5, 10)

-- because it returns a number as a result, we can use it anywhere we'd use a number
myVariable = add(5,10)
print("myVariable value: " .. myVariable)

-- or even just
print("add result: " .. add(25, 20))

-- can you see how this works?
myResult = add(add(10,15), add(10, add(5,15)))
print("myResult value: " .. myResult)

--[[
    as you can see, to get the parameter for the outer "add" function, we must first resolve the inner ones
    so we end up doing:
        add(add(10,15), add(10, add(5,15)))
        add(25, add(10, 20))
        add(25, 30)
        55

    and that final 55, now it's a simple value, can be assigned into the variable "myResult"
]]

-- you can put any instructions in functions
-- remember, just like this file - when you "call" a function; it starts running it from the top of the function down to the bottom of it
-- once finished, it returns back to where it was
-- you can have functions that call functions (that call functions) - it all works on the same idea "go do those instructions, then come back here"

function addFunky(a, b)
    local result = add(a,b) + add(a,b)
    result = result + add(5*a, 5*b)
    return result
end

-- remember it's just running the instructions one at a time
--  from the start of addFunky, down till it reaches the end
print("result of addFunky: " .. addFunky(10, 15))


