--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
--- Remember to set your Author name etc. in the settings: CTRL+COMMA

require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

--  Want to test everything works? Just hit F6 and the simulator will run
--  Remember, you can add a breakpoint by clicking to the left of the line-number, for full debugging!

---@section onLBSimulatorTick
--- Don't worry - this "section" only exists in the simulator. It's removed by the F7 build process.
--  It lets you customize the inputs for testing, so you can pretend you've got a touchscreen, or a compass etc. attached
do
    ---@type Simulator
    simulator = simulator

    -- Set properties and screen sizes here - will run once when the script is loaded
    simulator:setScreen(1, "3x3")
    simulator:setProperty("ExampleBoolProperty", true)
    simulator:setProperty("ExampleNumberProperty", 123)
    simulator:setProperty("ExampleTextProperty", "Text")

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        -- default touchscreen connection
        screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputBool(2, screenConnection.isTouchedAlt)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)
        simulator:setInputNumber(5, screenConnection.touchAltX)
        simulator:setInputNumber(6, screenConnection.touchAltY)
    end;
end
---@endsection



ticks = 0
function onTick()
    ticks = ticks + 1
end

function onDraw()
    screen.drawCircle(16,16,5)
end

--- Ready to put this in the game?
--- Just hit F7 and then copy the (now tiny) file from the /out/ folder
