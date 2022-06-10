-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Press F6 To Run
-- Make edits, see what happens, learn by doing

-- Aims:
--  Have a better understanding of what you can do with functions



-- there's nothing special about onTick and onDraw
-- they are just two variables that the game looks for, and if they contain functions, the game uses them

-- but we can also use functions for a lot of other things, like simplifying our code

-- here we've made a variable called `addTwoNumbers`
--     and set it's value to be a function
addTwoNumbers = function(num1, num2)
    -- unlike onTick and onDraw, this function takes 2 parameters (we pick the names and how many)
    -- num1 and num2
    -- these let us pass in values; so we can write generic code in here and use it multiple times

    -- it also has a keyword "return", which means "exit the function and send this value back" to wherever it was called
    return num1 + num2
end

-- call our function with the parameters 1 and 2
--   the parameters num1 and num2 will use these values
--   the number we `return` from the function - is then what comes back here
result = addTwoNumbers(1, 2)
debug.log("result: " .. result)


addTwoNumbers(5,10) -- note how we don't *need* to catch the result in a variable. Sometimes functions "do things", like set global variables
                    -- or tell the game to do things
                    -- in which case, we might not want to return any result at all

                    
-- you can use the value returned from a function, the same way you would any other value or variable, etc.
c = 150 + addTwoNumbers(120, 120)
debug.log("c: " .. c)

d = addTwoNumbers(addTwoNumbers(100,100), addTwoNumbers(50,50)) -- remember, each value is resolved first - 100+100 function => 200, then the 50+50 function => 100, then the 200 + 100
debug.log("d: " .. d)                                           -- addTwoNumbers is the variable containing a function, addTwoNumbers() is CALLING that function to get a result



-- just as a reminder, if it makes things easier to see:
-- the parameter for debug.log is a piece of text ("a string")
-- you can hold CTRL+CLICK the function, to see how the code is written for it - if you really want
-- but this whole "parameters" thing is something you've intuitively done already
debug.log("THIS TEXT IS BEING PASSED INTO debug.log AS A PARAMETER")











--------------------------------------------
simulator:exit()