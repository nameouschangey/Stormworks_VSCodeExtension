-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Simulator.SimulatorScreen")


---@class SimulatorConfig : BaseClass
---@field boolHandlers table<string, fun():boolean> handlers
---@field numberHandlers table<string, fun():number> handlers
---@field simulator Simulator
LifeBoatAPI.Tools.SimulatorConfig = {
    ---@param simulator Simulator
    new = function (this, simulator)
        this = LifeBoatAPI.Tools.BaseClass.new(this)
        this.boolHandlers = {}
        this.numberHandlers = {}
        this.simulator = simulator
        return this
    end;

    ---@param this SimulatorConfig
    ---@param screenNumber number screen to configure, if this is not an existing screen - it becomes the next available integer
    ---@param screenSize string should be a valid SW screen size: 1x1, 2x1, 2x2, 3x2, 3x3, 5x3, 9x5
    ---@param poweredOn boolean true if the screen is turned on 
    ---@param portrait boolean (optional) true if this screen will be stood on its end in the game
    ---@overload fun(this : SimulatorConfig, screenNumber:number, screenSize:string)
    ---@return number screenNumber the actual screen number that was created
    configureScreen = function(this, screenNumber, screenSize, poweredOn, portrait)
        this.simulator:setScreen(screenNumber, screenSize, poweredOn, portrait)
    end;

    ---@param this SimulatorConfig
    ---@param label string name of the property
    ---@param value string|boolean|number value to set as a property
    setProperty = function(this, label, value)
        this.simulator:setProperty(label, value)
        this.simulator:getTouchScreen(1)
    end;

    ---@param this SimulatorConfig
    ---@param index number index between 1->32 for which input to handle
    ---@param handler fun():number function that returns a number to set to this index each frame
    addNumberHandler = function(this, index, handler)
        if type(index) ~= "number" or index < 1 or index > 32 then
            error("addNumberHandler can only be set for valid game indexes 1->32")
        end

        if(type(handler) == "number") then
            local value = handler
            handler = function() return value end
        end

        if(type(handler) ~= "function") then
            error("config handler must be a function, but got " .. type(handler))
        end

        this.numberHandlers[index] = handler
    end;

    ---@param this SimulatorConfig
    ---@param index number index between 1->32 for which input to handle
    ---@param handler fun():boolean function that returns a boolean to set to this index each frame
    addBoolHandler = function(this, index, handler)
        if type(index) ~= "number" or index < 1 or index > 32 then
            error("addBoolHandler can only be set for valid game indexes 1->32")
        end

        if(type(handler) == "boolean") then
            handler = function() return handler end
        end

        if(type(handler) ~= "function") then
            error("config handler must be a function, but got " .. type(handler))
        end

        this.boolHandlers[index] = handler
    end;

    ---@param this SimulatorConfig
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