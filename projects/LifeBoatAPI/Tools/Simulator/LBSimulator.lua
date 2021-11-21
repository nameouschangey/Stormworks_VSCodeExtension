
require("LifeBoatAPI.Tools.Utils.LBFilepath")
require("LifeBoatAPI.Tools.Utils.LBFilesystem")
require("LifeBoatAPI.Missions.Utils.LBString")

require("LifeBoatAPI.Tools.Simulator.LBSimulator_InputOutputAPI")
require("LifeBoatAPI.Tools.Simulator.LBSimulator_ScreenAPI")

_socket = require("socket")

---@class LBSimulatorConnection : LBBaseClass
---@field isAlive boolean whether the connection is current live
---@field client table socket connection
LBSimulatorConnection = {
    ---@return LBSimulatorConnection
    new = function(this)
        this = LBBaseClass.new(this)

        local host = "127.0.0.1"
        local port = 14238

        this.client = assert(_socket.tcp())
        this.client:connect(host, port)

        this.isAlive = true

        return this
    end;

    ---@param this LBSimulatorConnection
    close = function (this)
        this:sendCommand("SHUTDOWN", "")
        this.client:close()
    end;

    ---@param this LBSimulatorConnection
    ---@param commandName string name of the command
    ---@vararg ... additional string params to send to the simulator
    sendCommand = function (this, commandName, ...)
        local command = commandName .. "|" .. table.concat({...}, "|")

        -- using first 4 characters for length
        local lengthString = string.format("%04d", #command + 1)
        local bytesSend, err = this.client:send(lengthString .. command .. "\n");

        if err == "closed" then
            this.isAlive = false
        elseif err then
            error(err)
        end
    end;

    ---@return boolean messageExists whether a message is ready to be read or not
    hasMessage = function(this)
        return #(_socket.select({this.client}, nil, 0)) > 0
    end;

    ---@return string message reads the next message waiting from the simulator
    readMessage = function(this)
        local size, err = this.client:receive(4)

        if err == "closed" then
            this.isAlive = false
            return nil
        elseif err then
            error(err)
        end

        size = tonumber(size)
        local bytesRead = 0
        local data = ""
        while bytesRead < size do
            local buffer, err = this.client:receive(size - bytesRead)
            bytesRead = bytesRead + #buffer
            data = data .. buffer

            if err == "closed" then
                this.isAlive = false
                return nil
            elseif err then
                error(err)
            end
        end
        return data
    end;    
}

function empty() end;


---@class LBSimulatorInputs : LBBaseClass
---@field boolHandlers table<string, fun():boolean> handlers
---@field numberHandlers table<string, fun():number> handlers
---@field touchData table
---@field simulator LBSimulator
LBSimulatorInputs = {
    ---@param simulator LBSimulator
    new = function (this, simulator)
        this = LBBaseClass.new(this)
        this.boolHandlers = {}
        this.numberHandlers = {}
        this.touchData = {
            x = 0,
            y = 0,
            isDown = false,
            isRDown = false
        }
        this.simulator = simulator

        simulator:registerHandler("TOUCH",
        function(sim, isDown, isRDown, x, y)
            this.touchData.isDown = (isDown == "1")
            this.touchData.isRDown = (isRDown == "1")
            this.touchData.x = tonumber(x)
            this.touchData.y = tonumber(y)
        end)

        -- default handlers
        --    screen sizes
        this:addNumberHandler(1, function() return screen.getWidth() end);
        this:addNumberHandler(2, function() return screen.getHeight() end);

        --    touchscreen isDown and position
        this:addBoolHandler(1,   function() return this.touchData.isDown end);
        this:addBoolHandler(2,   function() return this.touchData.isRDown end);
        this:addNumberHandler(3, function() return this.touchData.x end);
        this:addNumberHandler(4, function() return this.touchData.y end);
        return this
    end;

    ---@param this LBSimulatorInputs
    ---@param label string name of the property
    ---@param value string|boolean|number value to set as a property
    setProperty = function(this, label, value)
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

    ---@param this LBSimulatorInputs
    ---@param index number index between 1->32 for which input to handle
    ---@param handler fun():number function that returns a number to set to this index each frame
    addNumberHandler = function(this, index, handler)
        if type(index) ~= "number" or index < 1 or index > 32 then
            error("addNumberHandler can only be set for valid game indexes 1->32")
        end

        this.numberHandlers[index] = handler
    end;

    ---@param this LBSimulatorInputs
    ---@param index number index between 1->32 for which input to handle
    ---@param handler fun():boolean function that returns a boolean to set to this index each frame
    addBoolHandler = function(this, index, handler)
        if type(index) ~= "number" or index < 1 or index > 32 then
            error("addBoolHandler can only be set for valid game indexes 1->32")
        end

        this.boolHandlers[index] = handler
    end;

    ---@param this LBSimulatorInputs
    onSimulate = function (this)
        -- handle the touchscreen + screen sizes
        -- assume the user wants these connected, and they may be overwritten
        for k,v in pairs(this.boolHandlers) do
            this.simulator:setInputBool(k,v())
        end

        for k,v in pairs(this.numberHandlers) do
            this.simulator:setInputNumber(k,v())
        end
    end;
}

---@class LBSimulator : LBBaseClass
---@field connection LBSimulatorConnection simulator connection handler
---@field simulatorProcess file* currently running simulator process 
---@field _handlers table
---@field config LBSimulatorInputs
LBSimulator = {
    ---@param this LBSimulator
    ---@return LBSimulator
    new = function (this)
        this = LBBaseClass.new(this)
        this._handlers = {}
        this.config = LBSimulatorInputs:new(this)
        this.timePerFrame = 1/60
        return this
    end;

    run = function(this)
        local simulatorExePath = LBFilepath:new([[C:\personal\STORMWORKS_VSCodeExtension\STORMWORKS_Simulator\STORMWORKS_Simulator\bin\Debug\STORMWORKS_Simulator.exe]])
        this.simulatorProcess = io.popen(simulatorExePath:win(), "w")
        this.connection = LBSimulatorConnection:new()

        onSimulatorInit = onSimulatorInit or empty
        onSimulatorInit()

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
                onSimulate = onSimulate or empty
                onTick = onTick or empty
                onDraw = onDraw or empty

                -- possibility that the server has closed connection at any of these points
                -- in which case, we want to stop processing asap
                if this.connection.isAlive then this.config:onSimulate() end

                if this.connection.isAlive then onSimulate(this) end
                if this.connection.isAlive then onTick() end

                if this.connection.isAlive then this:_sendInOuts() end

                if this.connection.isAlive then this.connection:sendCommand("CLEAR") end
                if this.connection.isAlive then onDraw() end
                
            else
                _socket.sleep(0.001)
            end
        end

        this.connection:close()
    end;

    setInputBool = function(this, index, value)
        if(index > 32) then error("Index > 32 for input " .. tostring(index) .. " setting bool ") end
        if(index < 1) then error("Index < 1 for input " .. tostring(index) .. " setting bool ") end

        if value ~= nil and value ~= input.getBool(index) then
            this.inputsChanged = true
            input._bools[index] = value
        end
    end;

    setInputNumber = function(this, index, value)
        if(index > 32) then error("Index > 32 for input " .. tostring(index) .. " setting number ") end
        if(index < 1) then error("Index < 1 for input " .. tostring(index) .. " setting number ") end

        if value ~= nil and value ~= input.getNumber(index) then
            this.inputsChanged = true
            input._numbers[index] = value
        end
    end;

    ---@param this LBSimulator
    _sendInOuts = function (this)
        if(this.inputsChanged) then
            this.inputsChanged = false

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

    registerHandler = function (this, commandName, func)
        this._handlers[commandName] = func
    end;
}

LBSimulatedInputHelpers = {
    
    ---Sets this input to a specific value constantly
    ---@param value boolean
    ---@return fun():boolean
    constantBool = function(value)
        return function() return value and true or false end
    end;

    ---Sets the input to a constant number value
    ---@param value boolean
    ---@return fun():number
    constantNumber = function(value)
        return function() return value end
    end;
    
    ---Sets the input to a bool that toggles on and off every so many ticks
    ---@param togglePeriod number number of ticks between each toggle
    ---@return fun():boolean
    togglingBool = function(initialValue, togglePeriod)
        local ticks = 0
        local value = initialValue
        togglePeriod = math.floor(togglePeriod)
        return function()
            ticks = ticks + 1
            if ticks % togglePeriod == 0 then
                value = not value
            end
            return value
        end
    end;

    ---Sets the input to a number that wraps around a fixed range
    ---@param min number min value to wrap at
    ---@param max number max value to wrap at
    ---@param increment number amount to increase/decrease each tick
    ---@param initial number initial value (optional)
    ---@return fun():number
    wrappingNumber = function(min, max, increment, initial)
        initial = initial or min
        if min > max then
            min,max = max,min
        end
        local value = initial
        return function ()
            value = value + increment
            if value > max then
                value = min
            end
            if value < min then
                value = max
            end
            return value
        end
    end;

    ---Increments the current value by an unpredictable amount each tick
    ---Noise that accumulates
    ---@param noiseAmount number noise will be produced in the range [0, noiseAmount]
    ---@param initial number initial value
    ---@param noiseOffset number constant value to offset by (e.g. to allow something that "constantly rises at a random rate")
    ---@return fun():number
    noiseyIncrement = function(noiseAmount, initial, noiseOffset)
        initial = initial or 0
        noiseOffset = noiseOffset or 0
        local value = initial
        return function ()
            value = value + ((math.random()-0.5) * noiseAmount) + noiseOffset
            return value
        end
    end;

    ---Gives a value that oscillates around the given point, noise does not accumulate
    ---@param noiseAmount number noise will be produced in the range [0, noiseAmount]
    ---@param initial number initial value
    ---@return fun():number
    noiseyOscillation = function(noiseAmount, initial)
        initial = initial or 0
        local value = initial
        return function ()
            return value + ((math.random()-0.5) * noiseAmount)
        end
    end;

    ---Gives a value that oscillates steadily between two values
    ---@param min number min value to wrap at
    ---@param max number max value to wrap at
    ---@param increment number amount to increase/decrease each tick
    ---@param initial number initial value (optional)
    ---@return fun():number
    oscillatingNumber = function(min, max, increment, initial)
        initial = initial or 0
        if min > max then
            min,max = max,min
        end
        local value = initial
        local direction = increment >= 0 and 1 or -1
        increment = increment >= 0 and increment or (-1 * increment)
        return function ()
            value = value + (increment * direction)
            if value > max then
                local difference = value - max
                value = max
                direction = direction * -1
                value = value + (difference * direction) -- re-add the amount we overshot the edge, to keep it accurate
            end
            if value < min then
                local difference = min - value
                value = min
                direction = direction * -1
                value = value + (difference * direction) -- re-add the amount we overshot the edge, to keep it accurate
            end
            return value
        end
    end;
}


simulator = LBSimulator:new()
simulator:run()
screen.SetSimulator(simulator)


---@section __IF__IS__SIMULATING__
    ---@param simulator LBSimulator
    function onSimulatorInit(simulator)
        simulator.config:addBoolHandler(9, LBSimulatedInputHelpers.constantBool(true))
        simulator.config:addNumberHandler(10, LBSimulatedInputHelpers.oscillatingNumber(-10,10,-0.2,5))
        simulator.config:addNumberHandler(11, LBSimulatedInputHelpers.wrappingNumber(-10,10,0.2,4))
        simulator.config:addNumberHandler(12, LBSimulatedInputHelpers.noiseyOscillation(1,0))
        simulator.config:addNumberHandler(13, LBSimulatedInputHelpers.noiseyIncrement(1, 0, 0))
    end
    function onSimulatorTick(simulator)end
    function onSimulatorOutputBoolChanged(index, oldValue, newValue) end
    function onSimulatorOutputNumberChanged(index, oldValue, newValue) end
---@endsection

function onDraw()
    output.setBool(4,true)
    output.setNumber(11, frameCount)
    screen.drawRectF((frameCount/10) % 32, 10, 15, 15)
end


