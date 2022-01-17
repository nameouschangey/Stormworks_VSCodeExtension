-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


-- Just hit F5 at any time, to run this file as a regular Lua file (without the Stormworks simulator).
--     You'll see debugger controls at the top of the window once it starts running.
--     Click StepInto to move 1 instruction at a time
--
--     You can use these to run 1 instruction at a time and see EXACTLY what lua is doing
--          * hovering over a variable tells you its current value
--          * clicking left of the line numbers will set a red circle ("breakpoint"). Pressing F5 will run all code up to that instruction.
--             you can use that to skip the parts you understand, and get straight to the "new" stuff each time

-- PS: If you noticed these green lines all start with "--", and don't seem to do anything. You've already intuitively figured out how comments work.


-------------------------------------------------------------------------------------------------------------
print("-----If------")


print("You've learned that code runs from top to bottom")
print("But what if you only want some things, to run at some times?")

-- if statements let you run one set of code or another, based on a condition

a = 5
if a < 10 then  -- if <boolean> then <actions> else <otheractions> end
    print("a was less than 10")
else
    print("THIS WON'T RUN BECAUSE A is 5") -- this instruction will never be run, unless you change the value of a
end



-- note that anything can be used as your boolean
-- any variable value that isn't "nil" or "false" will be treated as true

number = 123
nilValue = nil

if nilValue then
    print("This wont run")
end

if number then
    print("This will")
end

if 0 then
    print("Even this will, because 0 ISNT FALSE OR NIL")
end



--- and here we have a boolean value stored in a variable before we use it in the if statements
myValue = 10 > 5 and 11 > 2 and not (false or 2 > 11) -- and, or, not are just like the logic blocks you have in the game
if myValue then
    print("my value is true")
end

if 5 < 10 and not 5 < 1 then
    print("should be clearer now?")
end



print("but we're also neglecting the elseif here")
print("extremely easy, you can chain multiple conditions to make your life easier")

if 5 > 10 then
    print("condition that isn't true")
elseif 5 > 6 then
    print("only gets evaluated if the first condition isn't true")
elseif 5 < 100 then
    print("again, only runs because the ones before werent true")
else
    print("none of the above conditions were true if this runs")
end



-- and that's really ALL there is to "if, else"
-- you can obviously; use this in functions - (because you can use ANY instructions in functions)

function returnBiggest(num1, num2)
    if num1 > num2 then
        return num1
    else
        return num2
    end
end

print("return biggest: " .. returnBiggest(10, 15))
