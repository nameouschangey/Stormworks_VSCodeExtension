-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Exercise
-- 1. Quick exercise, play about with the simulator properties here
--    Try making input 13, a number set to the value 55
--    Try making input 20, a number that goes up 5 every tick
--    Try adding more or less screens, of different sizes
--    Try reading the inputs and outputs, in the onTick function



---@section _SIMULATOR_ONLY_

-- in this "root" of the file (outside any function), stick screen config, and properties
simulator:setScreen(1, "3x3") -- give us a 3x3 screen
simulator:setScreen(2, "2x2")
simulator:setProperty("My Example Property Name", 123) -- accessible using property.getText, getNumber, getBool


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
