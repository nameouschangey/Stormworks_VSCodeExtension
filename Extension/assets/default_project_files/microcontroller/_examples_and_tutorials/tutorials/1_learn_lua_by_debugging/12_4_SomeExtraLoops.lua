-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- F6 to run!

-- Three other loops you can use, as well as the `for index, value in ipairs(myTable) do ... end`
-- Loops just repeat the instructions within them a certain number of times


-- example table, just for using here
myTable = {"a", "b", "c", "d", "e", myKey = 123, myHeight=33, myName="DOG"}
-- use F6 and a breakpoint, to see the table values easily, and how it's arranged in the table

-- iterate the numerical key'd values
for index, value in ipairs(myTable) do
    print("index: " .. index .. ", value: " .. value)
end


-- iterate ALL the keys and values, in an unspecified order
-- note this one is pairs not ipairs  (i for integer)
for key, value in pairs(myTable) do
    print("key: " .. key .. ", value: " .. value)
end
-- notice how this output all the keys



-- numerical loop
-- counter starts at 10, increases till it reaches 18, and it's jumping 2 at a time
for counter=10, 18, 2 do
    debug.log("counter: " .. counter)
end

for counter=0, -5, -1 do
    debug.log("counter going negative: " .. counter)
end



-- while loop
-- keeps running till the condition is true
-- REMEMBER: LOOPS RUN ALL WITHIN ONE TICK - NOT one iteration per tick; THE ENTIRE THING
--           That's because the ENTIRE onTick function runs every tick
--           You DO NOT use these for animating things, moving things slowly etc.
condition = true
while condition do
    debug.log("This will run once and stop")
    condition = false
end
-- be aware, if your condition NEVER becomes false - the while loop will NEVER end
--  it's actually how the game stays open, there's a giant `while playerHasntClosedTheGame` loop (internally in c++)








------------------------------------
simulator:exit()