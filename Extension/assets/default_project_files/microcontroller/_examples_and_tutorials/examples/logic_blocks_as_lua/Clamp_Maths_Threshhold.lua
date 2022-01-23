-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- lots of maths functions are available in the `math` table, built into lua


-- math.min returns the lowest of two numbers. (math.max does the opposite)
minimum = 50
value = 100
a = math.min(minimum, value)
debug.log("a: " .. tostring(a))


-- turns to radians
turns = 1
radians = turns * (2 * math.pi) 
trigonometry = math.sin(radians)

-- turns to degrees
turns = 1
degrees = turns * (360)


-- basic arithmetic works as expected:
a = (1 + 1) * 10 -- 20
b = (100 /50) -- 2
c = (9 % 7) -- 2 (modulo, is the remainder of 9/7)
d = 5 - 2 -- 3
e = 5^2 -- 25, (5 to the power 2, exponent)


-- theshhold
function threshold(value, min, max)
    return value < max and value > min
end


-- clamp
function clamp(value, min, max)
    return math.min(math.max(min, value), max)
end

-- sign, returns -1 or 1
function sign(value)
    return value / math.abs(value)
end

