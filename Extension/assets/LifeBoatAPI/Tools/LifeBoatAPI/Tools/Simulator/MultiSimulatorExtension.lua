-- Author: Nameous Changey
-- Please do not remove this notice
-- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--      By Nameous Changey (Please retain this notice at the top of the file as a courtesy; a lot of effort went into the creation of these tools.)

-- Note: This is entirely experimental
-- It affects _ENV, and there's a lot of chance of unpredictable results from data being shared between different environments
-- I will not be providing support for this Multi-MC Simulate, beyond providing this file

---@diagnostic disable: undefined-global
---@diagnostic disable: lowercase-global

LifeBoatAPI = LifeBoatAPI or {}
LifeBoatAPI.Tools = LifeBoatAPI.Tools or {}

LifeBoatAPI.Tools.MultiSim = {
    copyTable = function(from, into, onlyExists)
        into = into or {}

        for k,v in pairs(from) do
            if(into[k] or not onlyExists) then
                into[k] = v
            end
        end
        return into
    end;

    copyENV = function(name, env)
        local _env = CopyTable(env)

        env._globalTicks = 0
        
        ---@type Simulator_PropertiesAPI
        _env.property = CopyTable(_env.property)
        _env.property.name = name
        _env.property._numbers = CopyTable(_env.property._numbers)
        _env.property._bools = CopyTable(_env.property._bools)
        _env.property._texts = CopyTable(_env.property._texts)

        ---@type Simulator_InputAPI
        _env.input = CopyTable(_env.input)
        _env.input.name = name
        _env.input._numbers = CopyTable(_env.input._numbers)
        _env.input._bools = CopyTable(_env.input._bools)

        ---@type Simulator_OutputAPI
        _env.output = CopyTable(_env.output)
        _env.output.name = name
        _env.output._numbers = CopyTable(_env.output._numbers)
        _env.output._bools = CopyTable(_env.output._bools)

        ---@type Simulator
        _env.__simulator = CopyTable(_env.__simulator)
        _env.__simulator.name = name
        _env.__simulator.config = CopyTable(_env.__simulator.config)
        _env.__simulator.config.simulator = _env.__simulator
        _env.__simulator.config.name = name
        _env.__simulator.config.boolHandlers = CopyTable(_env.__simulator.config.boolHandlers)
        _env.__simulator.config.numberHandlers = CopyTable(_env.__simulator.config.numberHandlers)
        return _env
    end;

    LoadMC = function(name)
        local originalEnv = _ENV
        _ENV = CopyENV("MAIN", _ENV)

        require(name)

        local mcENV = CopyENV(name, _ENV._G)
        table.insert(_mcs, mcENV)

        _ENV = originalEnv
        _ENV.__simulator.config = LBSimulatorConfig:new(__simulator)

        onLBSimulatorTick = Empty
        onTick = Empty
        onDraw = Empty

        return mcENV
    end;


    onTick = function()
        -- do not edit unless you know what you're doing
        for i, _env in ipairs(_mcs) do
            local originalENV = _ENV
            input = _env.input
            output = _env.output
            property = _env.property

            _ENV = _env

            __simulator.config:onSimulate()
            onSimulate = onLBSimulatorTick or Empty
            onSimulate(__simulator)

            if onTick then
                onTick()
            end

            _globalTicks = _globalTicks + 1

            _ENV = originalENV
            input = originalENV.input
            output = originalENV.output
            property = originalENV.property
        end

        hasChanged = false
        if _displayableMC then
            for i=1, 32 do

                hasChanged = hasChanged or
                    (_originalInput._bools[i] ~= _displayableMC.input._bools[i] or
                    _originalInput._numbers[i] ~= _displayableMC.input._numbers[i] or
                    _originalOutput._bools[i] ~= _displayableMC.output._bools[i] or
                    _originalOutput._numbers[i] ~= _displayableMC.output._numbers[i])

                _originalInput._bools[i] = _displayableMC.input._bools[i]
                _originalInput._numbers[i] = _displayableMC.input._numbers[i]

                _originalOutput._bools[i] = _displayableMC.output._bools[i]
                _originalOutput._numbers[i] = _displayableMC.output._numbers[i]

            end
        end

        if hasChanged then
            _originalSim._isInputOutputChanged = true
        end
    end;

    onDraw = function()
        -- do not edit unless you know what you're doing
        for i, _env in ipairs(_mcs) do
            local originalENV = _ENV
            _ENV = _env


            if(onDraw) then
                if onLBSimulatorShouldDraw == nil or onLBSimulatorShouldDraw(screen._simulator._currentScreen.screenNumber) then
                    onDraw()
                end
            end

            _ENV = originalENV
        end
    end;

    displayMCInOut = function(mc)
        _displayableMC = mc
    end;
}

LifeBoatAPI.Tools.MultiSim._mcs = {}
LifeBoatAPI.Tools.MultiSim._originalSim = __simulator
LifeBoatAPI.Tools.MultiSim._originalInput = input -- for displaying to screen
LifeBoatAPI.Tools.MultiSim._originalOutput = output -- for displaying to screen
LifeBoatAPI.Tools.MultiSim._displayableMC = nil


---@diagnostic enable: undefined-global
---@diagnostic enable: lowercase-global