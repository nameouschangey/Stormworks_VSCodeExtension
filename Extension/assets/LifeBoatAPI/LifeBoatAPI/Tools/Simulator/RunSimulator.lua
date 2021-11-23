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

simulator = LBSimulator:new()

---@section __IF__IS__SIMULATING__
    ---@param simulator LBSimulator
    ---@param config LBSimulatorConfig
    ---@param helpers LBSimulatorInputHelpers
    function onSimulatorInit(simulator, config, helpers)
        config:configureScreen(1, "9x5", true, true)
        config:configureScreen(2, "9x5", true, true)
        config:configureScreen(3, "9x5", true, true)

        config:setProperty("navconstant", 5)
        config:addNumberHandler(15,10)
        config:addNumberHandler(1, helpers.wrappingNumber(0, 1, 0.01))
        config:addNumberHandler(2, helpers.wrappingNumber(0, 1, 0.01))
        config:addNumberHandler(3, helpers.wrappingNumber(0, 1, 0.01))
        config:addNumberHandler(4, helpers.wrappingNumber(0, 1, 0.01))
        config:addNumberHandler(5, helpers.wrappingNumber(0, 1, 0.01))
        config:addNumberHandler(6, helpers.wrappingNumber(0, 1, 0.01))
    end

    function onSimulatorTick(simulator)end

    function onSimulatorOutputBoolChanged(index, oldValue, newValue)
    end

    function onSimulatorOutputNumberChanged(index, oldValue, newValue)
    end
---@endsection

-- file to simulate
require("LifeBoatAPI.Tools.Simulator.ToSim")

simulator:run()