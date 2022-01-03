-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

-- Note: This is entirely experimental
-- It affects _ENV, and there's a lot of chance of unpredictable results from data being shared between different environments
-- I will not be providing support for this Multi-MC Simulate, beyond providing this file

require("LifeBoatAPI.Tools.Simulator.Simulator")

---@diagnostic disable: undefined-global
---@diagnostic disable: lowercase-global


---@class MultiSimulator
---@field _mcs table[] -- list of _ENVs
---@field _displayableMC table -- _ENV from _mcs
---@field _originalInput Simulator_InputAPI
---@field _originalOutput Simulator_OutputAPI
---@field _originalSim Simulator
LifeBoatAPI.Tools.MultiSimulator = {

    ---@param this MultiSimulator
    new = function(this)
        this = LifeBoatAPI.Tools.BaseClass.new(this)

        this._mcs = {}
        this._originalSim = __simulator
        this._originalInput = input -- for displaying to screen
        this._originalOutput = output -- for displaying to screen
        this._displayableMC = nil

        return this
    end;


    --- Copies values in, but only those that already exist (effectively "update" table)
    copyTable = function(from, into, onlyExists)
        into = into or {}

        for k,v in pairs(from) do
            if(into[k] or not onlyExists) then
                into[k] = v
            end
        end
        return into
    end;

    --- Copies all necessary global state that must be preserved for each MC
    ---@param this MultiSimulator
    copyENV = function(this, name, env)
        local _env = this.copyTable(env)

        env._globalTicks = 0

        ---@type Simulator_PropertiesAPI
        _env.property           = this.copyTable(_env.property)
        _env.property.name      = name
        _env.property._numbers  = this.copyTable(_env.property._numbers)
        _env.property._bools    = this.copyTable(_env.property._bools)
        _env.property._texts    = this.copyTable(_env.property._texts)

        ---@type Simulator_InputAPI
        _env.input              = this.copyTable(_env.input)
        _env.input.name         = name
        _env.input._numbers     = this.copyTable(_env.input._numbers)
        _env.input._bools       = this.copyTable(_env.input._bools)

        ---@type Simulator_OutputAPI
        _env.output             = this.copyTable(_env.output)
        _env.output.name        = name
        _env.output._numbers    = this.copyTable(_env.output._numbers)
        _env.output._bools      = this.copyTable(_env.output._bools)

        ---@type Simulator
        _env.__simulator                        = this.copyTable(_env.__simulator)
        _env.__simulator.name                   = name
        _env.__simulator.config                 = this.copyTable(_env.__simulator.config)
        _env.__simulator.config.simulator       = _env.__simulator
        _env.__simulator.config.name            = name
        _env.__simulator.config.boolHandlers    = this.copyTable(_env.__simulator.config.boolHandlers)
        _env.__simulator.config.numberHandlers  = this.copyTable(_env.__simulator.config.numberHandlers)
        return _env
    end;

    ---@param this MultiSimulator
    loadMC = function(this, name)
        local originalEnv = _ENV
        _ENV = this:copyENV("MAIN", _ENV)

        require(name)

        local mcENV = this:copyENV(name, _ENV._G)
        table.insert(this._mcs, mcENV)

        _ENV = originalEnv
        _ENV.__simulator.config = LifeBoatAPI.Tools.SimulatorConfig:new(__simulator)

        onLBSimulatorTick = Empty
        onTick = Empty
        onDraw = Empty

        return mcENV
    end;


    ---@param this MultiSimulator
    generateOnTick = function(this)
        return function()
            -- do not edit unless you know what you're doing
            for i, _env in ipairs(this._mcs) do
                local originalENV = _ENV
                input       = _env.input
                output      = _env.output
                property    = _env.property

                _ENV = _env

                __simulator.config:onSimulate()
                onSimulate = onLBSimulatorTick or Empty
                onSimulate(__simulator)

                if onTick then
                    onTick()
                end

                _globalTicks = _globalTicks + 1

                _ENV = originalENV
                input       = originalENV.input
                output      = originalENV.output
                property    = originalENV.property
            end

            hasChanged = false
            if this._displayableMC then
                for i=1, 32 do

                    hasChanged = hasChanged or
                       (this._originalInput._bools[i]    ~= this._displayableMC.input._bools[i] or
                        this._originalInput._numbers[i]  ~= this._displayableMC.input._numbers[i] or
                        this._originalOutput._bools[i]   ~= this._displayableMC.output._bools[i] or
                        this._originalOutput._numbers[i] ~= this._displayableMC.output._numbers[i])

                    this._originalInput._bools[i]        = this._displayableMC.input._bools[i]
                    this._originalInput._numbers[i]      = this._displayableMC.input._numbers[i]

                    this._originalOutput._bools[i]       = this._displayableMC.output._bools[i]
                    this._originalOutput._numbers[i]     = this._displayableMC.output._numbers[i]

                end
            end

            if hasChanged then
                this._originalSim._isInputOutputChanged = true
            end
        end
    end;

    ---@param this MultiSimulator
    generateOnDraw = function(this)

        return function()
            -- do not edit unless you know what you're doing
            for i, _env in ipairs(this._mcs) do
                local originalENV = _ENV
                _ENV = _env

                if(onDraw) then
                    if onLBSimulatorShouldDraw == nil or onLBSimulatorShouldDraw(screen._simulator._currentScreen.screenNumber) then
                        onDraw()
                    end
                end

                _ENV = originalENV
            end
        end
    end;

    ---@param this MultiSimulator
    setDisplayMC = function(this, mc)
        this._displayableMC = mc
    end;
}

---@diagnostic enable: undefined-global
---@diagnostic enable: lowercase-global