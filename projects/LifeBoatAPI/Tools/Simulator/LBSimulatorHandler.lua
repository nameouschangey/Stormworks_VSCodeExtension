
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

    hasMessage = function(this)
        return #(socket.select({this.client}, nil, 0)) > 0
    end;

    readMessage = function(this)

    end;

    handleMessages = function(this)
        while this:hasMessage() do
            local message = this:readMessage()

            -- process message
        end
    end;

    sendCommand = function (this, commandName, ...)
        local command = commandName .. "|" .. table.concat({...}, "|")

        -- using first 4 characters for length
        local lengthString = string.format("%04d", #command + 1)
        this.client:send(lengthString .. command .. "\n");
    end;
}

function empty() end;

function onDraw()
    simulator:sendCommand("RECT", 1, (frameCount/10) % 32, 10, 15, 15)
end



simulator = LBSimulatorHandler:new()
simulator:launch(LBFilepath:new([[C:\personal\STORMWORKS_VSCodeExtension\STORMWORKS_Simulator\STORMWORKS_Simulator\bin\Debug\STORMWORKS_Simulator.exe]]))

-- reliable 60 FPS main thread
local timeToRun = 10.0
local timeRunning = 0.0
local lastTime = socket.gettime()
local timeSinceFrame = 0.0
frameCount = 0
while timeRunning < timeToRun do
    local time = socket.gettime()
    timeRunning = timeRunning + (time - lastTime)
    timeSinceFrame = timeSinceFrame + (time - lastTime)
    lastTime = time

    if timeSinceFrame > 0.016 then
        timeSinceFrame = 0.0
        frameCount = frameCount + 1

        -- read server inputs
        
        -- run tick
        onSimulate = onSimulate or empty
        onTick = onTick or empty
        onDraw = onDraw or empty

        onSimulate()
        onTick()

        simulator:sendCommand("CLEAR")
        onDraw()
        
    else
        socket.sleep(0.001)
    end
end

simulator:close()