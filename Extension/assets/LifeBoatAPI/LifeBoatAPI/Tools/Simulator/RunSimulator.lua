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
    config:configureScreen(1, "2x1", true, true)

    config:setProperty("Sweep Limit/100", 50)
    config:setProperty("FOV X/100", 2)
    config:setProperty("Zoom1", 100)
    config:setProperty("Zoom2", 500)
    config:setProperty("Zoom3", 10000)
    config:setProperty("Direction", false)
    config:setProperty("On Pivot", false)

    config:addNumberHandler(1,  helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(2,  helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(3,  helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(4,  helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(5,  helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(6,  helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(7,  helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(8,  helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(9,  helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(10, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(11, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(12, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(13, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(14, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(15, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(16, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(17, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(18, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(19, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(20, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(21, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(22, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(23, helpers.wrappingNumber(0, 1, 0.01))
    config:addNumberHandler(24, helpers.wrappingNumber(0, 1, 0.01))

    config:addBoolHandler(1,  helpers.togglingBool(true, 10))
    config:addBoolHandler(2,  helpers.togglingBool(true, 10))
    config:addBoolHandler(3,  helpers.togglingBool(true, 10))
    config:addBoolHandler(4,  helpers.togglingBool(true, 10))
    config:addBoolHandler(5,  helpers.togglingBool(true, 10))
    config:addBoolHandler(6,  helpers.togglingBool(true, 10))
    config:addBoolHandler(7,  helpers.togglingBool(true, 10))
    config:addBoolHandler(8,  helpers.togglingBool(true, 10))
    config:addBoolHandler(9,  helpers.togglingBool(true, 10))
    config:addBoolHandler(10, helpers.togglingBool(true, 10))
    config:addBoolHandler(11, helpers.togglingBool(true, 10))
    config:addBoolHandler(12, helpers.togglingBool(true, 10))
    config:addBoolHandler(13, helpers.togglingBool(true, 10))
    config:addBoolHandler(14, helpers.togglingBool(true, 10))
    config:addBoolHandler(15, helpers.togglingBool(true, 10))
    config:addBoolHandler(16, helpers.togglingBool(true, 10))
    config:addBoolHandler(17, helpers.togglingBool(true, 10))
    config:addBoolHandler(18, helpers.togglingBool(true, 10))
    config:addBoolHandler(19, helpers.togglingBool(true, 10))
    config:addBoolHandler(20, helpers.togglingBool(true, 10))
    config:addBoolHandler(21, helpers.togglingBool(true, 10))
    config:addBoolHandler(22, helpers.togglingBool(true, 10))
    config:addBoolHandler(23, helpers.togglingBool(true, 10))
    config:addBoolHandler(24, helpers.togglingBool(true, 10))
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