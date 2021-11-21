
require("LifeBoatAPI.Tools.Utils.LBFilepath")
require("LifeBoatAPI.Tools.Utils.LBFilesystem")
require("LifeBoatAPI.Missions.Utils.LBString")
socket = require("socket")


---@class LBSimulatorHandler
LBSimulatorHandler = {
    ---@return LBSimulatorHandler
    new = function(this)
        this = LBCopy(this)
        return this
    end;

    ---@param simulatorExePath LBFilepath
    launch = function(this, simulatorExePath)
        this.simulatorPath = simulatorExePath
        this.simulatorOutPipePath = simulatorExePath:directory():add("/_SWSimulator.pipe")
        this.simulatorProcess = io.popen(simulatorExePath:win(), "w")

        -- create pipe
        local host = "127.0.0.1"
        local port = 14238

        this.client = assert(socket.tcp())
        this.client:connect(host, port)
    end;

    close = function (this)
        this:sendCommand("SHUTDOWN", "")
        this.client:close()
    end;

    sendCommand = function (this, commandName, ...)
        local command = commandName .. "|" .. table.concat({...}, "|")

        -- using first 4 characters for length, as it's easier than wrangling lua numbers into bytes into strings
        -- largest buffer we use right now is 2048 bytes, so no need for ability to send massive data anyway
        local lengthString = string.format("%04d", #command + 1)
        this.client:send(lengthString .. command .. "\n");
        --while true do
        --    local s, status, partial = this.client:receive()
        --    print(s or partial)
        --    if status == "closed" then break end
        --end
        
    end;

    readSetup = function(this)
        function _readSetup()
            local text = LBFileSystem_readAllText(this.simulatorOutPipePath)
            local splits = LBString_split(text, "|")
            
            return {
                width = tonumber(splits[2]),
                height = tonumber(splits[3]),
                milliseconds = tonumber(splits[4])
            }
        end

        return pcall(_readSetup())
    end;
}

simulator = LBSimulatorHandler:new()
simulator:launch(LBFilepath:new([[C:\personal\STORMWORKS_VSCodeExtension\STORMWORKS_Simulator\STORMWORKS_Simulator\bin\Debug\STORMWORKS_Simulator.exe]]))

simulator:sendCommand("RECT", 1, 10, 10, 15, 15)
--simulator:close()
simulator:sendCommand("RECT", 1, 10, 10, 15, 15)
simulator:close()