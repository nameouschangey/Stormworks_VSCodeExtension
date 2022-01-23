-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- F6 to run
-- This file shows how boolean operations are implemented in lua
-- Note, anything can act as a boolean - everything is "true" except "false" and "nil"


--- Quick Note ----
--- anything can be used like a boolean
myText = "ABC"

if true then
    debug.log("Example")    
end

if myText then
    debug.log("See how myText acts like 'true' because it isn't nil or false. Even though it's text, not *actually* a boolean")
end

-----

-- NOT
a = true
b = not a -- b will be false
debug.log("b: " .. tostring(b))


-- AND
a = true
b = false
c = a and b -- c will be false, unless both a and b are true
debug.log("c: " .. tostring(c))


-- OR
a = true
b = false
c = a or b -- c will be true, as long as either a or b are true
debug.log("c: " .. tostring(c))


-- XOR
a = true
b = false
c = (a ~= b) and (a or b) -- XOR is true when a or b is true, but not when a and b are both true (i.e. have the same value). ~= is "not equal"
debug.log("c: " .. tostring(c))


------------------------------------------------------------------------------------------------------------------------
-- These are the basic boolean logic building blocks that you will use a ton.
-- Note, that in lua, the result of "and" isn't just true - but is the second argument (b)
--    This lets us do some cool tricks:

a = true
if a then
    b = "A IS TRUE"
else
    b = "A IS NOT TRUE"
end

-- can be turned into:
b = a and "A IS TRUE" or "A IS NOT TRUE"
debug.log("b: " .. tostring(b))

-- want a number if a boolean is true?
boolean = 55 > 123 -- example
result = boolean and 1 or 0 -- 1 if true, 0 if false or nil


-- another quick trick, toggling a boolean
a = true
a = not a -- now if a was true, it's false. If it was false, it's true.

