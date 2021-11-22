require("LifeBoatAPI.Tools.Utils.LBFilepath")
require("LifeBoatAPI.Tools.Utils.LBFilesystem")
require("LifeBoatAPI.Missions.Utils.LBString")

require("LifeBoatAPI.Tools.Simulator.LBSimulator_InputOutputAPI")
require("LifeBoatAPI.Tools.Simulator.LBSimulator_ScreenAPI")


function Empty() end;


---@class LBSimulator : LBBaseClass
---@field connection LBSimulatorConnection simulator connection handler
---@field simulatorProcess file* currently running simulator process 
---@field _handlers table
---@field config LBSimulatorConfig
---@field screens LBSimulatorScreen[]
---@field currentScreen LBSimulatorScreen
---@field isInputOutputChanged boolean 
LBSimulator = {
    ---@param this LBSimulator
    ---@return LBSimulator
    new = function (this)
        this = LBBaseClass.new(this)
        this._handlers = {}
        this.config = LBSimulatorConfig:new(this)
        this.timePerFrame = 1/60
        this.screens = {}
        this.currentScreen = nil

        this:registerHandler("TOUCH",
            function(simulator, screenNumber, isDownL, isDownR, x, y)
                this.screens[screenNumber] = this.screens[screenNumber] or LBSimulatorScreen:new()
                local thisScreen = this.screens[screenNumber]
                thisScreen.isTouchedL = (isDownL == "1")
                thisScreen.isTouchedR = (isDownR == "1")
                thisScreen.touchX = x
                thisScreen.touchY = y
            end)

        this:registerHandler("SCREENSIZE",
            function (simulator, screenNumber, width, height)
                this.screens[screenNumber] = this.screens[screenNumber] or LBSimulatorScreen:new()
                local thisScreen = this.screens[screenNumber]
                thisScreen.width  = width
                thisScreen.height = height
            end)

        this:registerHandler("REMOVESCREEN",
            function (simulator, screenNumber)
                this.screens[screenNumber] = nil
            end)

        return this
    end;

    run = function(this)
        local simulatorExePath = LBFilepath:new([[C:\personal\STORMWORKS_VSCodeExtension\Extension\assets\simulator\STORMWORKS_Simulator.exe]])
        this.simulatorProcess = io.popen(simulatorExePath:win(), "w")
        this.connection = LBSimulatorConnection:new()

        -- default screen
        this.config:configureScreen(1, 32, 32, false)

        onSimulatorInit = onSimulatorInit or Empty
        onSimulatorInit(this, this.config, LBSimulatorInputHelpers)

        -- reliable 60 FPS main thread
        local timeRunning = 0.0
        local lastTime = _socket.gettime()
        local timeSinceFrame = 0.0
        frameCount = 0
        while this.connection.isAlive do
            local time = _socket.gettime()
            timeRunning = timeRunning + (time - lastTime)
            timeSinceFrame = timeSinceFrame + (time - lastTime)
            lastTime = time

            if timeSinceFrame > this.timePerFrame then
                timeSinceFrame = 0.0
                frameCount = frameCount + 1

                -- messages incoming from the server
                this:readSimulatorMessages()

                -- run tick
                onSimulate = onSimulate or Empty
                onTick = onTick or Empty
                onDraw = onDraw or Empty

                -- possibility that the server has closed connection at any of these points
                -- in which case, we want to stop processing asap
                if this.connection.isAlive then this.config:onSimulate() end

                if this.connection.isAlive then onSimulate(this) end
                if this.connection.isAlive then onTick() end

                if this.connection.isAlive then this:_sendInOuts() end

                for screenNumber, screenData in pairs(this.screens) do 
                    this.currentScreen = screenData
                    if this.connection.isAlive then this.connection:sendCommand("CLEAR", screenNumber) end
                    if this.connection.isAlive then onDraw() end
                end
            else
                _socket.sleep(0.001)
            end
        end

        this.connection:close()
    end;

    ---simulate the value an input should have
    ---@param this LBSimulator
    ---@param index number
    ---@param value boolean
    setInputBool = function(this, index, value)
        if(index > 32) then error("Index > 32 for input " .. tostring(index) .. " setting bool ") end
        if(index < 1) then error("Index < 1 for input " .. tostring(index) .. " setting bool ") end

        if value ~= nil and value ~= input.getBool(index) then
            this.isInputOutputChanged = true
            input._bools[index] = value
        end
    end;

    ---simulate the value an input should have
    ---@param this LBSimulator
    ---@param index number
    ---@param value number
    setInputNumber = function(this, index, value)
        if(index > 32) then error("Index > 32 for input " .. tostring(index) .. " setting number ") end
        if(index < 1) then error("Index < 1 for input " .. tostring(index) .. " setting number ") end

        if value ~= nil and value ~= input.getNumber(index) then
            this.isInputOutputChanged = true
            input._numbers[index] = value
        end
    end;

    ---read and handle all messages sent by the simulator server since the last tick
    ---@param this LBSimulator
    readSimulatorMessages = function(this)
        while (this.connection.isAlive and this.connection:hasMessage()) do
            local message = this.connection:readMessage()
            if message then
                local commandParts = LBString_split(message, "|")
                local commandName = table.remove(commandParts, 1) -- remove the commandName from the commandParts
                
                for handlerCommand, handler in pairs(this._handlers) do
                    if handlerCommand == commandName then
                        handler(this, table.unpack(commandParts))
                    end 
                end
            end
        end
    end;

    ---register a handler to listen for simulator server messages
    ---only one listener may be registered per command
    ---@param this LBSimulator
    ---@param commandName string name of the command to listen for
    ---@param func fun(...) function taking arbitrary args that are filled in from the simulator params
    registerHandler = function (this, commandName, func)
        this._handlers[commandName] = func
    end;

        ---helper, send the input and output data to the server
    ---@param this LBSimulator
    _sendInOuts = function (this)
        if(this.isInputOutputChanged or this.isInputOutputChanged) then
            this.isInputOutputChanged = false

            local inputCommand  = (input._bools[1] and "1" or "0") .. "|" .. input._numbers[1]
            local outputCommand = (output._bools[1] and "1" or "0") .. "|" .. output._numbers[1]
            for i=2, 32 do
                inputCommand  = inputCommand  .. "|" .. (input._bools[i] and "1" or "0") .. "|" .. input._numbers[i]
                outputCommand = outputCommand .. "|" .. (output._bools[i] and "1" or "0") .. "|" .. output._numbers[i]
            end

            this.connection:sendCommand("INPUT", inputCommand)
            this.connection:sendCommand("OUTPUT", outputCommand)
        end
    end;
}



