-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------



-- Remember you can set Breakpoints! Click to the left of the line number to add a little red circle!


tickCounter = 0 -- we'll use this in onTick

-- NB: Just for functions, this is an alternative way of writing:
--     `onTick = function() ... end`
--     (which is actually how I'd recommend it - it's clearer that all you're doing is assigning a function, into the variable called "onTick")
function onTick()
    tickCounter = tickCounter + 1 -- add 1 each tick, so we can count how many ticks

    -- the variable `input` is provided by the game. It holds a `table` (box that can hold many variables), with two functions in it
    --    these functions let you read the numbers and booleans from the composite input

    -- by default, in VScode, the composite input will contain the touchscreen coordinates
    monitorWidth  = input.getNumber(1)
    monitorHeight = input.getNumber(2)
    monitorTouchX = input.getNumber(3) -- x coordinate that's being clicked on the monitor
    monitorTouchY = input.getNumber(4) -- y coordinate that's being clicked on the monitor

    monitorIsBeingClicked = input.getBool(1)
    

    -----------------------
    -- the variable `output` is provided by the game, it holds a `table`, with functions in it
    --      these functions let you write data to the composite output
    output.setNumber(1, monitorWidth)
    output.setNumber(2, 1020202)
    output.setBool(1, true)

    output.setNumber(10, tickCounter)
    output.setNumber(11, tickCounter % 600) -- will cycle every 10 seconds (60 ticks/second)
end




-- remember, `function onDraw() ... end`
-- and       `onDraw = function() ... end` ARE THE EXACT SAME THING
-- there's two ways, because a lot of programmers are used to `function funcName() ... end` - but they should just get with the times ;)
onDraw = function()
    -- nothing to see here, we're don't care about onDraw in this tutorial (the game will still look for it, and call it if it finds it)

    -- ...ok here's a little circle just to keep you happy (and yes, `screen` is anotehr `table` containing a bunch of drawing functions)
    screen.drawCircle(16,16,10)
end