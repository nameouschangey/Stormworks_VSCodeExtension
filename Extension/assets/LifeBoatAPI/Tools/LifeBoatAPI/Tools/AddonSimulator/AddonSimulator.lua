-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Filepath")
require("LifeBoatAPI.Tools.Utils.FileSystemUtils")
require("LifeBoatAPI.Tools.Utils.StringUtils")
require("LifeBoatAPI.Tools.Simulator.Globals.Simulator_InputOutputAPI")
require("LifeBoatAPI.Tools.Simulator.Globals.Simulator_ScreenAPI")
require("LifeBoatAPI.Tools.Simulator.SimulatorConnection")
require("LifeBoatAPI.Tools.Simulator.SimulatorScreen")
require("LifeBoatAPI.Tools.Simulator.SimulatorConfig")
require("LifeBoatAPI.Tools.Simulator.SimulatorInputHelpers")

---@diagnostic disable: lowercase-global

local _socket = require("socket")

---@class AddonSimulator : BaseClass
---@field _timePerFrame number in seconds
---@field running boolean whether or not it's running
LifeBoatAPI.Tools.AddonSimulator = {

    ---@param this AddonSimulator
    ---@return AddonSimulator
    new = function (this)
        this = LifeBoatAPI.Tools.BaseClass.new(this)
        this._timePerFrame = 1/60
        this.running = false
        return this
    end;

    exit = function(this)
        this.running = false
    end,

    ---@param this Simulator
    ---@param attachToExistingProcess boolean attach to an existing running Simulator, instead of kicking off a new instance
    _beginSimulation = function(this, attachToExistingProcess, simulatorFile, simulatorLogFile)
        simulatorLogFile = simulatorLogFile or ""

        if not attachToExistingProcess then
            local simulatorExePath = LifeBoatAPI.Tools.Filepath:new(simulatorFile)
            this._simulatorProcess = io.popen("\"" .. simulatorExePath:win() .. " -logfile \"" .. simulatorLogFile .. "\"\"", "w")
        end

        this._connection = LifeBoatAPI.Tools.SimulatorConnection:new()

        -- set the global screen and output to be simulated
        -- if you are brought here from an error; it's because you redefined screen or output. Please don't.
        screen._setSimulator(this)
        input._setSimulator(this)
        output._setSimulator(this)

        -- default screen
        this.config:configureScreen(1, "1x1", true)

        -- enable touchscreen by default
        local helpers = LifeBoatAPI.Tools.SimulatorInputHelpers
        this.config:addBoolHandler(1, helpers.touchScreenIsTouched(this,1))

        this.config:addNumberHandler(1, helpers.touchScreenWidth(this,1))
        this.config:addNumberHandler(2, helpers.touchScreenHeight(this,1))
        this.config:addNumberHandler(3, helpers.touchScreenXPosition(this,1))
        this.config:addNumberHandler(4, helpers.touchScreenYPosition(this,1))

        this.running = true
    end;


    ---@param this Simulator
    _giveControlToMainLoop = function(this)
        -- reliable 60 FPS main thread
        local timeRunning = 0.0
        local lastTime = _socket.gettime()
        local timeSinceFrame = 0.0
        local framesSinceRender = 1
        local framesSinceOut = 1
        local tickCount = 1

        while this._connection.isAlive and this.running do
            local time = _socket.gettime()
            timeRunning = timeRunning + (time - lastTime)
            timeSinceFrame = timeSinceFrame + (time - lastTime)
            lastTime = time

            if timeSinceFrame > this._timePerFrame then
                timeSinceFrame = 0.0

                -- messages incoming from the server
                this:_readSimulatorMessages()

                -- run tick
                onSimulate = onLBSimulatorTick or LifeBoatAPI.Tools.Empty
                onTick = onTick or LifeBoatAPI.Tools.Empty
                onDraw = onDraw or LifeBoatAPI.Tools.Empty

                this._isRendering = false

                -- possibility that the server has closed connection at any of these points
                -- in which case, we want to stop processing asap
                if this._connection.isAlive then this.config:onSimulate() end
                if this._connection.isAlive then onSimulate(this, tickCount) end
                if this._connection.isAlive then onTick() end

                tickCount = tickCount + 1

                -- we can frame-skip, which means rendering (=>less networking, significant cost reduction)
                --  can be useful when frame rate is suffering
                if framesSinceRender%this._renderOnFrames == 0 and this._connection.isAlive then
                    framesSinceRender = 1

                    local outputRate = math.max(this._sendOutputSkip, this._renderOnFrames) -- no point sending the data more often than rendering it
                    if framesSinceOut%outputRate == 0 then
                        if this._connection.isAlive then this:_sendInOuts() end
                        framesSinceOut = 1
                    else
                        framesSinceOut = framesSinceOut + 1
                    end

                    for _, screenData in pairs(this._screens) do 
                        if screenData.poweredOn then
                            this._currentScreen = screenData
                            this._isRendering = true
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

    ---register a handler to listen for simulator server messages
    ---only one listener may be registered per command
    ---@param this Simulator
    ---@param commandName string name of the command to listen for
    ---@param func fun(...) function taking arbitrary args that are filled in from the simulator params
    _registerHandler = function (this, commandName, func)
        this._handlers[commandName] = func
    end;

    ---helper, send the input and output data to the server
    ---@param this Simulator
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


---@diagnostic enable: lowercase-global
