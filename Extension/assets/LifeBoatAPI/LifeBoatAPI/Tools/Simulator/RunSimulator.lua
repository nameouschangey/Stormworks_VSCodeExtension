package.path = package.path .. ";C:/personal/STORMWORKS_VSCodeExtension/Extension/assets/LifeBoatAPI/?.lua"
package.path = package.path .. ";C:/personal/STORMWORKS_VSCodeExtension/Extension/assets/luasocket/?.lua"

package.cpath = package.cpath .. ";C:/personal/STORMWORKS_VSCodeExtension/Extension/assets/luasocket/dll/socket/core.dll"
package.cpath = package.cpath .. ";C:/personal/STORMWORKS_VSCodeExtension/Extension/assets/luasocket/dll/mime/core.dll"

require("LifeBoatAPI.Tools.Utils.LBFilepath")
require("LifeBoatAPI.Tools.Utils.LBFilesystem")
require("LifeBoatAPI.Missions.Utils.LBString")

require("LifeBoatAPI.Tools.Simulator.LBSimulator_InputOutputAPI")
require("LifeBoatAPI.Tools.Simulator.LBSimulator_ScreenAPI")
require("LifeBoatAPI.Tools.Simulator.LBSimulator")
require("LifeBoatAPI.Tools.Simulator.LBSimulatorConfig")
require("LifeBoatAPI.Tools.Simulator.LBSimulatorInputHelpers")
require("LifeBoatAPI.Tools.Simulator.LBSimulatorConnection")


---@section __IF__IS__SIMULATING__
---@param simulator LBSimulator
---@param config LBSimulatorConfig
---@param helpers LBSimulatorInputHelpers
function onSimulatorInit(simulator, config, helpers)
    config:configureScreen(1, "2x2", true, true)
    config:setProperty("Sweep Limit/100", 50)
    config:setProperty("FOV X/100", 2)
    config:setProperty("Zoom1", 100)
    config:setProperty("Zoom2", 500)
    config:setProperty("Zoom3", 10000)
    config:setProperty("Direction", false)
    config:setProperty("On Pivot", false)

    for i=5, 32 do
        config:addNumberHandler(i,  helpers.wrappingNumber(0, 1, 0.01))
        config:addBoolHandler(i,  function() return math.random() * 100 < 20 end)
    end
end

function onSimulatorTick(simulator)end

function onSimulatorOutputBoolChanged(index, oldValue, newValue)
end

function onSimulatorOutputNumberChanged(index, oldValue, newValue)
end
---@endsection


-- file to simulate
local simulator = LBSimulator:new()
simulator:beginSimulation(true)

require("LifeBoatAPI.Tools.Simulator.ToSim")

simulator:giveControlToMainLoop()