require("LifeBoatAPI.Tools.Utils.LBFilepath")
require("LifeBoatAPI.Tools.Utils.LBFilesystem")
require("LifeBoatAPI.Tools.Utils.LBString")

require("LifeBoatAPI.Tools.Simulator.LBSimulator_InputOutputAPI")
require("LifeBoatAPI.Tools.Simulator.LBSimulator_ScreenAPI")
require("LifeBoatAPI.Tools.Simulator.LBSimulatorConnection")
require("LifeBoatAPI.Tools.Simulator.LBSimulatorScreen")
require("LifeBoatAPI.Tools.Simulator.LBSimulatorConfig")
require("LifeBoatAPI.Tools.Simulator.LBSimulatorInputHelpers")

---@class LBSimulator : LBBaseClass
---@field config LBSimulatorConfig reference to the Simulator input/output config
---@field timePerFrame number in seconds
---@field renderOnFrames number effectively, frame-skip; how many frames to go between renders. 0 or 1 mean render every frame. 2 means render every 2nd frame
---@field sendOutputSkip number frame-skip for sending the input/output changes.
---@field isRendering boolean whether we are currently rendering or not, for blocking the screen operations
---@field _connection LBSimulatorConnection (internal) simulator connection handler
---@field _simulatorProcess file* (internal) currently running simulator process 
---@field _handlers table (internal) list of event handlers
---@field _screens LBSimulatorScreen[] (internal) list of currently active screens
---@field _currentScreen LBSimulatorScreen (internal) screen currently being rendered to or nil
---@field _isInputOutputChanged boolean (internal) true if the input/output was changed within this frame
LBSimulator = {
    ---@param this LBSimulator
    ---@return LBSimulator
    new = function (this)
        this = LBBaseClass.new(this)
        this._handlers = {}
        this.config = LBSimulatorConfig:new(this)
        this.timePerFrame = 1/60
        this._screens = {}
        this._currentScreen = nil
        this.renderOnFrames = 1
        this.sendOutputSkip = 1
        this.isRendering = false

        this:registerHandler("TOUCH",
            function(simulator, screenNumber, isDownL, isDownR, x, y)
                screenNumber = tonumber(screenNumber)
                x = tonumber(x)
                y = tonumber(y)
                isDownL = isDownL == "1"
                isDownR = isDownR == "1"

                this._screens[screenNumber] = this._screens[screenNumber] or LBSimulatorScreen:new(screenNumber)
                local thisScreen = this._screens[screenNumber]
                thisScreen.isTouchedL = isDownL
                thisScreen.isTouchedR = isDownR
                thisScreen.touchX = x
                thisScreen.touchY = y
            end)

        this:registerHandler("SCREENSIZE",
            function (simulator, screenNumber, width, height)
                screenNumber = tonumber(screenNumber)
                width = tonumber(width)
                height = tonumber(height)

                this._screens[screenNumber] = this._screens[screenNumber] or LBSimulatorScreen:new(screenNumber)
                local thisScreen = this._screens[screenNumber]
                thisScreen.width  = width
                thisScreen.height = height
            end)

        this:registerHandler("SCREENPOWER",
            function (simulator, screenNumber, poweredOn)
                screenNumber = tonumber(screenNumber)
                poweredOn = poweredOn == "1"
                this._screens[screenNumber] = this._screens[screenNumber] or LBSimulatorScreen:new(screenNumber)
                local thisScreen = this._screens[screenNumber]
                thisScreen.poweredOn = poweredOn
                if not thisScreen.poweredOn then
                    thisScreen.touchX = 0
                    thisScreen.touchY = 0
                    thisScreen.isTouchedL = false
                    thisScreen.isTouchedR = false
                end
            end)

        this:registerHandler("TICKRATE",
            function (simulator, ticksPerSecond, frameSkip)
                ticksPerSecond = tonumber(ticksPerSecond)
                frameSkip = tonumber(frameSkip)
                this.timePerFrame = 1 / ticksPerSecond
                this.renderOnFrames = math.max(1, frameSkip)
            end)

        return this
    end;

    ---@param this LBSimulator
    ---@param attachToExistingProcess boolean attach to an existing running Simulator, instead of kicking off a new instance
    beginSimulation = function(this, attachToExistingProcess, simulatorFile, simulatorLogFile)
        simulatorLogFile = simulatorLogFile or ""

        if not attachToExistingProcess then
            local simulatorExePath = LBFilepath:new(simulatorFile)
            this._simulatorProcess = io.popen(simulatorExePath:win() .. " -logfile \"" .. simulatorLogFile .. "\"", "w")
        end

        this._connection = LBSimulatorConnection:new()
            
        -- set the global screen and output to be simulated
        -- if you are brought here from an error; it's because you redefined screen or output. Please don't.
        screen.setSimulator(this)
        output.setSimulator(this)

        -- default screen
        this.config:configureScreen(1, "1x1", true)

        -- enable touchscreen by default
        local helpers = LBSimulatorInputHelpers
        this.config:addBoolHandler(1, helpers.touchScreenIsETouched(this,1))
        this.config:addBoolHandler(2, helpers.touchScreenIsQTouched(this,1))

        this.config:addNumberHandler(1, helpers.touchScreenWidth(this,1))
        this.config:addNumberHandler(2, helpers.touchScreenHeight(this,1))
        this.config:addNumberHandler(3, helpers.touchScreenXPosition(this,1))
        this.config:addNumberHandler(4, helpers.touchScreenYPosition(this,1))
    end;


    ---@param this LBSimulator
    giveControlToMainLoop = function(this)
        -- reliable 60 FPS main thread
        local timeRunning = 0.0
        local lastTime = _socket.gettime()
        local timeSinceFrame = 0.0
        local framesSinceRender = 1
        local framesSinceOut = 1

        while this._connection.isAlive do
            local time = _socket.gettime()
            timeRunning = timeRunning + (time - lastTime)
            timeSinceFrame = timeSinceFrame + (time - lastTime)
            lastTime = time

            if timeSinceFrame > this.timePerFrame then
                timeSinceFrame = 0.0
                
                -- messages incoming from the server
                this:readSimulatorMessages()

                -- run tick
                onSimulate = onLBSimulatorTick or Empty
                onTick = onTick or Empty
                onDraw = onDraw or Empty

                this.isRendering = false

                -- possibility that the server has closed connection at any of these points
                -- in which case, we want to stop processing asap
                if this._connection.isAlive then this.config:onSimulate() end
                if this._connection.isAlive then onSimulate(this) end

                if this._connection.isAlive then onTick() end

                -- we can frame-skip, which means rendering (=>less networking, significant cost reduction)
                --  can be useful when frame rate is suffering
                if framesSinceRender%this.renderOnFrames == 0 and this._connection.isAlive then
                    framesSinceRender = 1

                    local outputRate = math.max(this.sendOutputSkip, this.renderOnFrames) -- no point sending the data more often than rendering it
                    if framesSinceOut%outputRate == 0 then
                        if this._connection.isAlive then this:_sendInOuts() end
                        framesSinceOut = 1
                    else
                        framesSinceOut = framesSinceOut + 1
                    end

                    for screenNumber, screenData in pairs(this._screens) do 
                        if screenData.poweredOn then
                            this._currentScreen = screenData
                            this.isRendering = true
                            if this._connection.isAlive then onDraw() end
                        end
                    end

                    if this._connection.isAlive then this._connection:sendCommand("TICKEND", 1) end
                else
                    framesSinceRender = framesSinceRender + 1
                    if this._connection.isAlive then this._connection:sendCommand("TICKEND", 0) end
                end
            end
        end

        this._connection:close()
    end;

    ---@param this LBSimulator
    ---@param frameSkip number 
    ---@param tickRate number
    ---@param sendOutputSkip number
    setFrameRate = function (this, frameSkip, tickRate, sendOutputSkip)
        frameSkip = frameSkip or 1
        tickRate = tickRate or 60
        sendOutputSkip = sendOutputSkip or 1

        this.timePerFrame = 1 / tickRate
        this.renderOnFrames = frameSkip
    end;

    ---simulate the value an input should have
    ---@param this LBSimulator
    ---@param index number
    ---@param value boolean
    setInputBool = function(this, index, value)
        if(index > 32) then error("Index > 32 for input " .. tostring(index) .. " setting bool ") end
        if(index < 1) then error("Index < 1 for input " .. tostring(index) .. " setting bool ") end

        if value ~= nil and value ~= input.getBool(index) then
            this._isInputOutputChanged = true
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
            this._isInputOutputChanged = true
            input._numbers[index] = value
        end
    end;

    ---read and handle all messages sent by the simulator server since the last tick
    ---@param this LBSimulator
    readSimulatorMessages = function(this)
        while (this._connection.isAlive and this._connection:hasMessage()) do
            local message = this._connection:readMessage()
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
        if(this._isInputOutputChanged or this._isInputOutputChanged) then
            this._isInputOutputChanged = false

            local inputCommand  = (input._bools[1] and "1" or "0") .. "|" .. input._numbers[1]
            local outputCommand = (output._bools[1] and "1" or "0") .. "|" .. output._numbers[1]
            for i=2, 32 do
                inputCommand  = inputCommand  .. "|" .. (input._bools[i] and "1" or "0") .. "|" .. input._numbers[i]
                outputCommand = outputCommand .. "|" .. (output._bools[i] and "1" or "0") .. "|" .. output._numbers[i]
            end

            this._connection:sendCommand("INPUT", inputCommand)
            this._connection:sendCommand("OUTPUT", outputCommand)
        end
    end;
}



