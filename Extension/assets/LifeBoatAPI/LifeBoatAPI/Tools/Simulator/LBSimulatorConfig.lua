require("LifeBoatAPI.Tools.Simulator.LBSimulatorScreen")

---@class LBSimulatorConfig : LBBaseClass
---@field boolHandlers table<string, fun():boolean> handlers
---@field numberHandlers table<string, fun():number> handlers
---@field simulator LBSimulator
LBSimulatorConfig = {
    ---@param simulator LBSimulator
    new = function (this, simulator)
        this = LBBaseClass.new(this)
        this.boolHandlers = {}
        this.numberHandlers = {}
        this.simulator = simulator
        return this
    end;

    ---@param this LBSimulatorConfig
    ---@param width number
    ---@param height number
    ---@param portrait boolean (optional) true if this screen will be stood on its end in the game
    ---@overload fun(this : LBSimulatorConfig, screenNumber:number, width:number, height:number)
    configureScreen = function(this, screenNumber, width, height, portrait)
        portrait = portrait or false
        this.simulator.screens[screenNumber] = this.simulator.screens[screenNumber] or LBSimulatorScreen:new()
        local thisScreen = this.simulator.screens[screenNumber]
        thisScreen.width = width
        thisScreen.height = height

        -- send the new screen data to the server
        this.simulator.connection:sendCommand("SCREENCONFIG", screenNumber, width, height, portrait and "1" or "0")
    end;

    ---@param this LBSimulatorConfig
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

    ---@param this LBSimulatorConfig
    ---@param index number index between 1->32 for which input to handle
    ---@param handler fun():number function that returns a number to set to this index each frame
    addNumberHandler = function(this, index, handler)
        if type(index) ~= "number" or index < 1 or index > 32 then
            error("addNumberHandler can only be set for valid game indexes 1->32")
        end

        this.numberHandlers[index] = handler
    end;

    ---@param this LBSimulatorConfig
    ---@param index number index between 1->32 for which input to handle
    ---@param handler fun():boolean function that returns a boolean to set to this index each frame
    addBoolHandler = function(this, index, handler)
        if type(index) ~= "number" or index < 1 or index > 32 then
            error("addBoolHandler can only be set for valid game indexes 1->32")
        end

        this.boolHandlers[index] = handler
    end;

    ---@param this LBSimulatorConfig
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