-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For customizing the inputs in the simulator, we can use code
--  Note that this is NOT an ingame feature, it's just for simulation

-- F6 to run!
-- To try: mess around with the simulator values and see what outputs
--         use the input values from `input.getNumber` to draw things, etc.



-- ignore this "---@section" for now, it just means all the code between here and the next "---@endsection" doesn't get build when
--   you hit F7. It's ONLY a VScode feature - Not LUA, Not Stormworks.
---@section _SIMULATOR_ONLY_

-- in this "root" of the file (outside any function), stick screen config, and properties
simulator:setScreen(1, "3x3") -- give us a 3x3 screen

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

-- we add this "end section" thing so when we press F7, this code is deleted. As it's NOT going to work in-game
-- this is NOT normal lua, so don't worry for now. This is ONLY in the VSCode Extension
---@endsection




-- actual game code now we're out of that config "section"

onTick = function()
    valueWeSetInConfigAbove = input.getNumber(10)
    otherValue = input.getNumber(11)
    
    if input.getBool(12) then
        output.setNumber(10, 555)
    else
        output.setNumber(10, 222)
    end
end