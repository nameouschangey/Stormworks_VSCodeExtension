-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


--[[
    This one's a bit of a pain of a concept
    It's not hard, but it's just a little janky until it makes sense

    If you find this too annoying, you CAN ignore it for now

    90% of stormworks players, don't knowingly use this feature (the `local` keyword for variables in functions)

    BUT, if you 'get it' it will make life simpler - you'll be able to stop worrying about overwriting variables between different functions
]]



addTwoNumbers = function(num1, num2)
    -- num1 and num2, only exist within this function - because they're parameters
    -- the name for this is "local" variables; which are different to "global" variables
    -- locals, only exist in the function they're in 
    -- globals, exist everywhere

    local answer = 0 -- won't exist outside this function because we explicitly said `local` before the name

    answer = num1 + num2 -- (don't need to `local` again, because the "answer" variable we're setting the value of, was already said to be local in this function)
    

    exampleGlobalVariable = exampleGlobalVariable + 1 -- just to prove a point, every time this function runs - the GLOBAL variable `exampleGlobalVariable` is increased by 1

    return answer -- this function gives a result, back to wherever it was called from
end


exampleGlobalVariable = 123 -- all variables NOT marked as `local` are globals. That includes our `addTwoNumbers` variable, which contains a function.
                            -- this means if you see `exampleGlobalVariable` anywhere else in this script - it's the SAME variable.

answer = 55 -- whereas this is NOT the same variable as the one in "addTwoNumbers", because the one in the function is LOCAL
            -- but this is GLOBAL
            -- in a function, if a LOCAL variable with the same name exists as a global one, the local variable is used.


result = addTwoNumbers(10, 55) -- pass in the two values that will become num1 and num2 in the function
                               -- the result from the line `return answer` will be returned here

debug.log("Result has the value: " .. tostring(result)) -- the value returned into result, should be 65! (55 + 10)

debug.log("exampleGlobalVariable now has the value: " .. tostring(exampleGlobalVariable)) -- showing that the global variable was changed

--[[
    Recap notes:
        1. This is a very janky/programmery couple of concepts to add in, don't let it throw you, if it confuses you - don't stress
        2. All variables are considered "Global" by default, only function parameters (e.g. a,b & c in `function(a, b, c)`) and variables marked `local` are local
        3. Local variables only exist until the end of the function they're in
        4. You use them to avoid accidentally overwriting a variable's value that's also used in another function
        5. You REALLY don't need to worry too much - knowing this all should make life simpler, if it feels confusing; ignore it for now
]]


















-------------------------------------------
simulator:exit()