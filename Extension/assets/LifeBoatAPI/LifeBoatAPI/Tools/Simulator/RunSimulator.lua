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
screen.setSimulator(simulator)
output.setSimulator(simulator)

---@section __IF__IS__SIMULATING__
    ---@param simulator LBSimulator
    ---@param config LBSimulatorConfig
    function onSimulatorInit(simulator, config, helpers)
        config:configureScreen(1, 32, 32,true)

        simulator.config:addBoolHandler(9,    helpers.constantBool(true))
        simulator.config:addNumberHandler(10, helpers.oscillatingNumber(-10,10,-0.2,5))
        simulator.config:addNumberHandler(11, helpers.wrappingNumber(-10,10,0.2,4))
        simulator.config:addNumberHandler(12, helpers.noiseyOscillation(1,0))
        simulator.config:addNumberHandler(13, helpers.noiseyIncrement(1, 0, 0))
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