
-- Example Simulator Config

---@section onLBSimulatorTick
-- Set properties and screen sizes here - will run once when the script is loaded
__simulator:setScreen(1, "3x3")
__simulator:setProperty("ExampleBoolProperty", true)
__simulator:setProperty("ExampleNumberProperty", 123)
__simulator:setProperty("ExampleTextProperty", "Text")

-- Runs every tick just before onTick; allows you to simulate the inputs changing
---@param simulator Simulator Use simulator:<function>() to set inputs etc.
---@param ticks number Number of ticks since simulator started
function onLBSimulatorTick(simulator, ticks)
    simulator:setInputNumber(20, ticks)                     -- example, set input 20 to the number of ticks
    simulator:setInputNumber(21, math.sin(ticks%60 / 60))   -- example, sin wave that oscillates every second
    simulator:setInputBool(20, ticks % 60 < 30)             -- example, bool that flips on/off every 30 ticks (0.5 seconds)
end;
---@endsection