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

---@diagnostic disable: lowercase-global

local _socket = require("socket")

---@class Simulator : BaseClass
---@field running boolean whether or not it's running
---@field sandboxEnv table
---@field buttons boolean[]
---@field buttonToggles boolean[]
---@field sliders number[]
---@field _timePerFrame number in seconds
---@field _renderOnFrames number effectively, frame-skip; how many frames to go between renders. 0 or 1 mean render every frame. 2 means render every 2nd frame
---@field _sendOutputSkip number frame-skip for sending the input/output changes.
---@field _isRendering boolean whether we are currently rendering or not, for blocking the screen operations
---@field _connection SimulatorConnection (internal) simulator connection handler
---@field _simulatorProcess file*|nil (internal) currently running simulator process 
---@field _handlers table (internal) list of event handlers
---@field _screens SimulatorScreen[] (internal) list of currently active screens
---@field _currentScreen SimulatorScreen|nil (internal) screen currently being rendered to or nil
---@field _isInputOutputChanged boolean (internal) true if the input/output was changed within this frame
---@field _overriddenInputBools boolean[]
---@field _overriddenInputNums boolean[]
LifeBoatAPI.Tools.Simulator = {

    ---@param self Simulator
    ---@return Simulator
    new = function (self, sandboxEnv)
        self = LifeBoatAPI.Tools.BaseClass.new(self)
        self._handlers = {}
        self._timePerFrame = 1/60
        self._screens = {}
        self._currentScreen = nil
        self._renderOnFrames = 1
        self._sendOutputSkip = 1
        self._isRendering = false
        self.running = false
        self.sandboxEnv = sandboxEnv
        self.buttons = {false,false,false,false,false,false,false,false,false,false}
        self.buttonToggles = {false,false,false,false,false,false,false,false,false,false}
        self.sliders = {0,0,0,0,0,0,0,0,0,0}
        self._overriddenInputNums = {}
        self._overriddenInputBools = {}

        self:_registerHandler("TOUCH",
            function(simulator, screenNumber, isTouched, isTouchedAlt, x, y, xAlt, yAlt)
                screenNumber = tonumber(screenNumber) or 1
                x = tonumber(x) or 0
                y = tonumber(y) or 0
                xAlt = tonumber(xAlt) or 0
                yAlt = tonumber(yAlt) or 0
                isTouched = isTouched == "1"
                isTouchedAlt = isTouchedAlt == "1"

                self._screens[screenNumber] = self._screens[screenNumber] or LifeBoatAPI.Tools.SimulatorScreen:new(screenNumber)
                local thisScreen = self._screens[screenNumber]
                thisScreen.isTouched = isTouched
                thisScreen.isTouchedAlt = isTouchedAlt
                thisScreen.touchX = x
                thisScreen.touchY = y
                thisScreen.touchAltX = xAlt
                thisScreen.touchAltY = yAlt
            end)

        self:_registerHandler("BUTTON_INPUTS",
            function(simulator, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10)
                simulator.sliders[1] = tonumber(s1)
                simulator.sliders[2] = tonumber(s2)
                simulator.sliders[3] = tonumber(s3)
                simulator.sliders[4] = tonumber(s4)
                simulator.sliders[5] = tonumber(s5)
                simulator.sliders[6] = tonumber(s6)
                simulator.sliders[7] = tonumber(s7)
                simulator.sliders[8] = tonumber(s8)
                simulator.sliders[9] = tonumber(s9)
                simulator.sliders[10] = tonumber(s10)

                simulator.buttons[1] =  b1 == "1"
                simulator.buttons[2] =  b2 == "1"
                simulator.buttons[3] =  b3 == "1"
                simulator.buttons[4] =  b4 == "1"
                simulator.buttons[5] =  b5 == "1"
                simulator.buttons[6] =  b6 == "1"
                simulator.buttons[7] =  b7 == "1"
                simulator.buttons[8] =  b8 == "1"
                simulator.buttons[9] =  b9 == "1"
                simulator.buttons[10] = b10 == "1"

                -- handle toggles
                for i=1,10 do
                    if simulator.buttons[i] then
                        simulator.buttonToggles[i] = not simulator.buttonToggles[i]
                    end
                end
            end)

        self:_registerHandler("SCREENSIZE",
            function (simulator, screenNumber, width, height)
                screenNumber = tonumber(screenNumber) or 1
                width = tonumber(width) or 0
                height = tonumber(height) or 0

                self._screens[screenNumber] = self._screens[screenNumber] or LifeBoatAPI.Tools.SimulatorScreen:new(screenNumber)
                local thisScreen = self._screens[screenNumber]
                thisScreen.width  = width
                thisScreen.height = height
            end)

        self:_registerHandler("SCREENPOWER",
            function (simulator, screenNumber, poweredOn)
                screenNumber = tonumber(screenNumber) or 1
                poweredOn = poweredOn == "1"
                self._screens[screenNumber] = self._screens[screenNumber] or LifeBoatAPI.Tools.SimulatorScreen:new(screenNumber)
                local thisScreen = self._screens[screenNumber]
                thisScreen.poweredOn = poweredOn
                if not thisScreen.poweredOn then
                    thisScreen.isTouched = false
                    thisScreen.isTouchedAlt = false
                    thisScreen.touchX = 0
                    thisScreen.touchY = 0
                    thisScreen.touchAltX = 0
                    thisScreen.touchAltY = 0
                end
            end)

        self:_registerHandler("TICKRATE",
            function (simulator, ticksPerSecond, frameSkip)
                ticksPerSecond = tonumber(ticksPerSecond)
                frameSkip = tonumber(frameSkip)
                self._timePerFrame = 1 / ticksPerSecond
                self._renderOnFrames = math.max(1, frameSkip)
            end)

        return self
    end;

    --- Get the touchscreen info for use in onLBSimulatorTick, to simulate touch inputs
    ---@param self Simulator
    ---@param screenNumber number touch info from which screen (default is 1)
    ---@return SimulatorScreen screen screen data for the requested screen, to be used in onLBSimulatorTick
    getTouchScreen = function (self, screenNumber)
        screenNumber = screenNumber or 1
        return self._screens[screenNumber] or LifeBoatAPI.Tools.SimulatorScreen:new(screenNumber)
    end;

    ---@param self Simulator
    ---@param buttonNumber number
    ---@return boolean
    getIsClicked = function (self, buttonNumber)
        return self.buttons[buttonNumber] or false
    end;

    ---@param self Simulator
    ---@param buttonNumber number
    ---@return boolean
    getIsToggled = function (self, buttonNumber)
        return self.buttonToggles[buttonNumber] or false
    end;

    ---@param self Simulator
    ---@param sliderNumber number
    ---@return number screen screen data for the requested screen, to be used in onLBSimulatorTick
    getSlider = function (self, sliderNumber)
        return self.sliders[sliderNumber] or 0
    end;

    ---@param self Simulator
    ---@param frameSkip number 
    ---@param tickRate number
    ---@param sendOutputSkip number
    setFrameRate = function (self, frameSkip, tickRate, sendOutputSkip)
        frameSkip = frameSkip or 1
        tickRate = tickRate or 60
        sendOutputSkip = sendOutputSkip or 1

        self._timePerFrame = 1 / tickRate
        self._renderOnFrames = frameSkip
    end;

    ---simulate the value an input should have
    ---@param self Simulator
    ---@param index number
    ---@param value boolean
    ---@param _internalUse Simulator|nil
    setInputBool = function(self, index, value, _internalUse)
        if(index > 32) then error("Index > 32 for input " .. tostring(index) .. " setting bool ") end
        if(index < 1) then error("Index < 1 for input " .. tostring(index) .. " setting bool ") end

        if _internalUse ~= self then
            self._overriddenInputBools[index] = true
        elseif self._overriddenInputBools[index] then
            return;
        end
        
        if value ~= nil and value ~= input.getBool(index) then
            self._isInputOutputChanged = true
            input._bools[index] = value
        end
    end;

    ---simulate the value an input should have
    ---@param self Simulator
    ---@param index number
    ---@param value number
    ---@param _internalUse Simulator|nil
    setInputNumber = function(self, index, value, _internalUse)
        if(index > 32) then error("Index > 32 for input " .. tostring(index) .. " setting number ") end
        if(index < 1) then error("Index < 1 for input " .. tostring(index) .. " setting number ") end

        if _internalUse ~= self then
            self._overriddenInputNums[index] = true
        elseif self._overriddenInputNums[index] then
            return;
        end
        
        if value ~= nil and value ~= input.getNumber(index) then
            self._isInputOutputChanged = true
            input._numbers[index] = value
        end
    end;

    ---@param self Simulator
    ---@param label string name of the property
    ---@param value string|boolean|number value to set as a property
    setProperty = function(self, label, value)
        if type(value) == "string" then
            property._texts[label] = value
        elseif type(value) == "boolean" then
            property._bools[label] = value
        elseif type(value) == "number" then
            property._numbers[label] = value
        else
            error("Stormworks properties must be Numbers, Strings or Booleans, when you tried to set property: " .. tostring(label))
        end
    end;

    ---@param self Simulator
    ---@param screenNumber number screen to configure, if this is not an existing screen - it becomes the next available integer
    ---@param screenSize string should be a valid SW screen size: 1x1, 2x1, 2x2, 3x2, 3x3, 5x3, 9x5
    ---@param poweredOn boolean true if the screen is turned on 
    ---@param portrait boolean (optional) true if this screen will be stood on its end in the game
    ---@overload fun(this : Simulator, screenNumber:number, screenSize:string)
    ---@return number screenNumber the actual screen number that was created
    setScreen = function(self, screenNumber, screenSize, poweredOn, portrait)
        portrait = portrait or false
        poweredOn = poweredOn ~= false
        
        local splits = LifeBoatAPI.Tools.StringUtils.split(screenSize, "x")

        local width = splits[1] * 32
        local height = splits[2] * 32

        if (not self._screens[screenNumber]
            or self._screens[screenNumber].width  ~= width
            or self._screens[screenNumber].height ~= height
            or self._screens[screenNumber].poweredOn ~= poweredOn
            or self._screens[screenNumber].portrait ~= portrait) then
                
            if not self._screens[screenNumber] then
                screenNumber = #self._screens + 1
                self._screens[screenNumber] = LifeBoatAPI.Tools.SimulatorScreen:new(screenNumber)
            end
            local thisScreen = self._screens[screenNumber]

            thisScreen.width = width
            thisScreen.height = height
            thisScreen.portrait = portrait
            thisScreen.poweredOn = poweredOn

            -- send the new screen data to the server
            self._connection:sendCommand("SCREENCONFIG",
                screenNumber,
                poweredOn and "1" or "0",
                screenSize,
                portrait and "1" or "0")
        end

        return screenNumber
    end;

    exit = function(self)
        self.running = false
    end,

    ---read and handle all messages sent by the simulator server since the last tick
    ---@param self Simulator
    _readSimulatorMessages = function(self)
        while (self._connection.isAlive and self._connection:hasMessage()) do
            local message = self._connection:readMessage()
            if message then
                local commandParts = LifeBoatAPI.Tools.StringUtils.split(message, "|")
                local commandName = table.remove(commandParts, 1) -- remove the commandName from the commandParts

                for handlerCommand, handler in pairs(self._handlers) do
                    if handlerCommand == commandName then
                        handler(self, table.unpack(commandParts))
                    end 
                end
            end
        end
    end;

    ---@param self Simulator
    ---@param attachToExistingProcess boolean attach to an existing running Simulator, instead of kicking off a new instance
    _beginSimulation = function(self, attachToExistingProcess, simulatorFile, simulatorLogFile)
        simulatorLogFile = simulatorLogFile or ""

        if not attachToExistingProcess then
            local simulatorExePath = LifeBoatAPI.Tools.Filepath:new(simulatorFile)
            local simLaunchCommand = '"' .. simulatorExePath:win() .. '" -logfile "' .. simulatorLogFile .. '"'
            self._simulatorProcess = io.popen('"' .. simLaunchCommand .. '"', "w") -- additional outer quotes needed, due to windows cmd
        end

        self._connection = LifeBoatAPI.Tools.SimulatorConnection:new()

        -- set the global screen and output to be simulated
        -- if you are brought here from an error; it's because you redefined screen or output. Please don't.
        screen._setSimulator(self)
        input._setSimulator(self)
        output._setSimulator(self)

        -- default screen
        self:setScreen(1, "3x3", true)

        self.running = true
    end;

    ---@param self Simulator
    _simulateDefaultInputs = function(self)
        local screen = self:getTouchScreen(1)
        self:setInputBool(1, screen.isTouched, self)
        self:setInputBool(2, screen.isTouchedAlt, self)

        self:setInputNumber(1, screen.width, self)
        self:setInputNumber(2, screen.height, self)
        self:setInputNumber(3, screen.touchX, self)
        self:setInputNumber(4, screen.touchY, self)
        self:setInputNumber(5, screen.touchAltX, self)
        self:setInputNumber(6, screen.touchAltY, self)
    end;

    ---@param self Simulator
    _giveControlToMainLoop = function(self)
        -- reliable 60 FPS main thread
        local timeRunning = 0.0
        local lastTime = _socket.gettime()
        local timeSinceFrame = 0.0
        local framesSinceRender = 1
        local framesSinceOut = 1
        local tickCount = 1

        while self._connection.isAlive and self.running do
            local time = _socket.gettime()
            timeRunning = timeRunning + (time - lastTime)
            timeSinceFrame = timeSinceFrame + (time - lastTime)
            lastTime = time

            if timeSinceFrame > self._timePerFrame then
                timeSinceFrame = 0.0
                
                -- reset button clicks
                for i=1,10 do
                    self.buttons[i] = false
                end

                -- messages incoming from the server
                self:_readSimulatorMessages()

                -- run tick
                onSimulate = self.sandboxEnv.onLBSimulatorTick or LifeBoatAPI.Tools.Empty
                onTick = self.sandboxEnv.onTick or LifeBoatAPI.Tools.Empty
                onDraw = self.sandboxEnv.onDraw or LifeBoatAPI.Tools.Empty

                self._isRendering = false

                -- possibility that the server has closed connection at any of these points
                -- in which case, we want to stop processing asap
                self:_simulateDefaultInputs()
                if self._connection.isAlive then onSimulate(self, tickCount) end
                if self._connection.isAlive then onTick() end

                tickCount = tickCount + 1

                -- we can frame-skip, which means rendering (=>less networking, significant cost reduction)
                --  can be useful when frame rate is suffering
                if framesSinceRender%self._renderOnFrames == 0 and self._connection.isAlive then
                    framesSinceRender = 1

                    local outputRate = math.max(self._sendOutputSkip, self._renderOnFrames) -- no point sending the data more often than rendering it
                    if framesSinceOut%outputRate == 0 then
                        if self._connection.isAlive then self:_sendInOuts() end
                        framesSinceOut = 1
                    else
                        framesSinceOut = framesSinceOut + 1
                    end

                    for _, screenData in pairs(self._screens) do 
                        if screenData.poweredOn then
                            self._currentScreen = screenData
                            self._isRendering = true
                            if self._connection.isAlive then onDraw() end
                        end
                    end

                    if self._connection.isAlive then self._connection:sendCommand("TICKEND", 1) end
                else
                    framesSinceRender = framesSinceRender + 1
                    if self._connection.isAlive then self._connection:sendCommand("TICKEND", 0) end
                end
            end
        end

        self._connection:close()
    end;

    ---register a handler to listen for simulator server messages
    ---only one listener may be registered per command
    ---@param self Simulator
    ---@param commandName string name of the command to listen for
    ---@param func fun(...) function taking arbitrary args that are filled in from the simulator params
    _registerHandler = function (self, commandName, func)
        self._handlers[commandName] = func
    end;

    ---helper, send the input and output data to the server
    ---@param self Simulator
    _sendInOuts = function (self)
        if(self._isInputOutputChanged or self._isInputOutputChanged) then
            self._isInputOutputChanged = false

            local inputCommand  = (input._bools[1] and "1" or "0") .. "|" .. input._numbers[1]
            local outputCommand = (output._bools[1] and "1" or "0") .. "|" .. output._numbers[1]
            for i=2, 32 do
                inputCommand  = inputCommand  .. "|" .. (input._bools[i] and "1" or "0") .. "|" .. input._numbers[i]
                outputCommand = outputCommand .. "|" .. (output._bools[i] and "1" or "0") .. "|" .. output._numbers[i]
            end

            self._connection:sendCommand("INPUT", inputCommand)
            self._connection:sendCommand("OUTPUT", outputCommand)
        end
    end;
}


---@diagnostic enable: lowercase-global
