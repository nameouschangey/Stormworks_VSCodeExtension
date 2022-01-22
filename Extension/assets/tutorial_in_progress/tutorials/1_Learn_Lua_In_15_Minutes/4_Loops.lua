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
print("-----Loops------")


print("Sometimes you write the same code")
print("Over and")
print("Over and")
print("Over and")
print("Over")

-- you can use loops to repeat instructions multiple times
-- like in a recipe, they say "beat 3 eggs", not "beat an egg then beat an egg then beat an egg"

-----------------------------------------------------------
-- the syntax is simple:
-- while boolean do
--     instructions to run over and over again
-- end
-- will keep running the instructions until it the boolean is false

i = 0
while i < 3 do
    i = i + 1 -- remember variables, this increases i by 1
    print("this loop has run " .. i .. " times")
end

print("that's all there is to it, a loop just repeats instructions over and over again")

-- Just note, in Stormworks a loop has NOTHING to do with ticks.
--  in-game, your loop will run IN FULL till it ends, before the control is returned to the game
--  remember, computers are simple; instructions run from the top - down to the bottom. Like a recipe book.

print("that while (boolean) do (instructions) end syntax is called a 'while loop' - really imaginative isn't it.")
print("and remember, ANY boolean will work, but if it never becomes false - your code will never end.")

-- ever wonder how games don't close after you open them, if code runs from top-to-bottom and then finishes?
-- (extremely simplified - but you can guarantee there's a while loop involved)

gameIsRunning = false -- just to avoid you getting stuck in a never-ending loop, obviously this would be `true` for it to run

while gameIsRunning do
    -- in case it's not clear, all these variables will be `nil` as they've not been defined
    --    they're just for the example
    if currentTime - lastFrameTime > 1/60 then
        simulatePhysicsFrame()
        renderToScreen()

        if playerIsPressingQuit then
            gameIsRunning = false -- will cause the loop to end
        end

        lastFrameTime = currentTime
    end
end

---------------------------------------------------------------

-- another kind of loop you can use is a `for` loop

-- as in "do these actions *for* 5 repetitions" 
-- versus, "keep doing these actions *while* the boolean is true"

firstValue = 1 -- note, in lua, we tend to count from 1 not 0; if you're used to other languages that may seem odd to you
maximumValue = 5
amountToIncreaseEachTimeOr1AsDefault = 1
for counter=firstValue, maximumValue, amountToIncreaseEachTimeOr1AsDefault do
    print("For loops are good when you have a PRE-DETERMINED times you want to repeat. " .. counter);
end

print("a for loop uses a counter (just a variable), and it increases that counter until it reaches the maximum you set")
print("you can omit the 3rd parameter (`amountToIncrease..`) if you want to increase 1 at a time")

-- "i" is a really common name for the counter
-- note how we only put in 2 values, because we increase 1 at a time
for i = 1, 5 do
    -- instructions to repeat go in here, between the "do" and "end"
    -- again, any instructions are fine 
    print("Looping, i has the value: " .. i)
end

for i = 1, 100, 50 do
    print("But this time we're skipping 50 at a time. This is i: " .. i)
end

-- and this one counts backwards
for i=100, 95, -1 do
    print("backwards counting: " .. i) -- remember ".." joins a two pieces of text, or a number onto a piece of text
end

-- you might already be realising in stormworks, it's not uncommon to want to draw multiple things
-- for example, drawing 5 buttons...I wonder what you could use for that


-- as a side note, you may be wondering if this will work:
for i = 1, 3 do
    for j = 1, 3 do
        print("i: " .. i .. ", j: " .. j .. ", i*j: " .. i*j)
    end
    -- ANY instructions can go in here.
end


-----------------------------------------------------------------------------------------------------------------------

print("Finally on loops, you sometimes want some extra control.")
print("A keywords you can use to control how loops work is `break`")
print("It's really straight forward, and works the same in all loops (for and while)")

while true do
    print("you might be thinking this is insane")
    print("won't this loop run forever, and the program will stall?")

    shouldWeEscape = true
    if shouldWeEscape then
        break -- like a prison break, we escape the current loop we're in. No matter what the condition is
    end
end

print("straight after the break statement, this is what will be run - the rest of the loop is skipped")

while true do
    for i=1, 9999999 do
        print("if you see this multiple times, we didn't break out. See you in iteration 9999999")
        break -- escape the loop
    end

    print("notice we escape the for loop; but we were in two loops. So now let's escape the while loop too")
    break
end

print("freedom!")

-- you might use this, for example, to find a value in a list of things
--  you'd loop through the list checking each thing. Once you find one that matches in an if statement, you can break.
--  no point running the code for the rest of the loop right?

for targetNumber=1,8 do
    -- run some code to check the radar inputs
    -- some code to calculate a distance to the target
    distanceToTarget = 10

    if distanceToTarget < 100 then
        print("found a target that's close enough, we don't need to check the rest")
        -- run some code to detonate, or avoid it, whatever the desired action is
        break
    end
end

print("and that's 'break'")

------------------------------------------------------------------------------------------