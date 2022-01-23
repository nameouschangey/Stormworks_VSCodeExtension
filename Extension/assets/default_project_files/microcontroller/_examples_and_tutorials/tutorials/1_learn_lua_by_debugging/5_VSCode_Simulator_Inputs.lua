-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------




--[[
    Apologies ahead of this tutorial, it's a pain
    It's not hard - it's just that what you need to learn now, isn't anything new in lua, and it's not stormworks, it's JUST applicable to the VSCode extension

    That said, it's important for you simulating inputs, and testing interesting ideas out.
        Just bear with it, don't worry about understanding it all
        All you need is to know that you *can* do this, and recognise what it is, so that it's not confusing in future exercises.


    -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

    What you're going to learn here is:
            - In the VSCode Extension, how to simulate the in-game inputs
            - How to set the simulator screen resolution, from code
            - How to simulate in-game "properties" (i.e. those text boxes in your MC)
            - What ":" does in lua (maybe, don't stress over it if it doesn't make sense)
]]




-- For customizing the inputs in the simulator, we can use code
--  Note that this is NOT an ingame feature, it's just for simulation

-- F6 to run!
-- To try: mess around with the simulator values and see what outputs
--         use the input values from `input.getNumber` to draw things, etc.


---@section _SIMULATOR_ONLY_

-- in this "root" of the file (outside any function), stick screen config, and properties
simulator:setScreen(1, "3x3") -- give us a 3x3 screen
simulator:setScreen(2, "2x2")

simulator:setProperty("My In-Game Property Name", 123) -- accessible using property.getText, getNumber, getBool
simulator:setProperty("Bool Property", true)
simulator:setProperty("Text Property", "Hello World")
simulator:setProperty("Example", 1234556789)


-- and then for inputs that change every tick, add a variable containing the function onLBSimulatorTick
onLBSimulatorTick = function(simulator, ticks)
    simulator:setInputNumber(10, 123)
    simulator:setInputNumber(11, 22)

    -- wrap every 10 seconds (600 ticks), then check if we're above 300 ticks (5 seconds)
    if ticks % 600 > 300 then
        simulator:setInputBool(12, true)
    else
        simulator:setInputBool(12, false)
    end
end


-- note, you want to avoid doing too much in this onLBSimulatorTick function
--   don't share variables between here and onTick - because in-game, when you've removed this code - this part won't exist
--   this is ONLY for simulating the inputs, outside the game
--   a good way to avoid doing it by mistake, is to put an underscore infront of all your variables here - then they won't ever be confusing


--[[
    See all the lines where it sayd simulator:functionName()
    Using ":" instead of ".", like we do in `input.getNumber()`

    This is just a shorthand in lua, it's the same as writing  simulator.functionName(simulator)
    The functions in the `simulator` table, all expect the first parameter to be the `simulator` table itself. So we use `:` to make life easier

    AGAIN, YOU DO NOT NEED TO WORRY ABOUT THIS - IT IS EXPLAINED MORE LATER
    JUST ACCEPT "OH OK, IT'S A FUNCTION THAT'S BEING RUN"
]]
---@endsection





-- actual game code now we're out of that config "section"

onTick = function()
    valueWeSetInConfigAbove = input.getNumber(10)
    otherValue = input.getNumber(11)
    
    -- see how the output changes, each time the input number 12 changes
    if input.getBool(12) then
        output.setNumber(10, 555)
    else
        output.setNumber(10, 222)
    end
end