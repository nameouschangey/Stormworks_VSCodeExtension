-- Author: Nameous Changey
-- Please do not remove this notice
-- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--      By Nameous Changey (Please retain this notice at the top of the file as a courtesy; a lot of effort went into the creation of these tools.)

-- Note: This is entirely experimental
-- It affects _ENV, and there's a lot of chance of unpredictable results from data being shared between different environments
-- I will not be providing support for this Multi-MC Simulate, beyond providing this file

--- @diagnostic disable: undefined-global

_mcs = {}

function CopyTable(from, into, onlyExists)
    into = into or {}

    for k,v in pairs(from) do
        if(into[k] or not onlyExists) then
            into[k] = v
        end
    end
    return into
end

function CopyENV(name, env)
    local _env = CopyTable(env)

    env._globalTicks = 0
    
    ---@type LBSimulator_PropertiesAPI
    _env.property = CopyTable(_env.property)
    _env.property.name = name
    _env.property._numbers = CopyTable(_env.property._numbers)
    _env.property._bools = CopyTable(_env.property._bools)
    _env.property._texts = CopyTable(_env.property._texts)

    ---@type LBSimulator_InputAPI
    _env.input = CopyTable(_env.input)
    _env.input.name = name
    _env.input._numbers = CopyTable(_env.input._numbers)
    _env.input._bools = CopyTable(_env.input._bools)

    ---@type LBSimulator_OutputAPI
    _env.output = CopyTable(_env.output)
    _env.output.name = name
    _env.output._numbers = CopyTable(_env.output._numbers)
    _env.output._bools = CopyTable(_env.output._bools)

    ---@type LBSimulator
    _env.__simulator = CopyTable(_env.__simulator)
    _env.__simulator.name = name
    _env.__simulator.config = CopyTable(_env.__simulator.config)
    _env.__simulator.config.simulator = _env.__simulator
    _env.__simulator.config.name = name
    _env.__simulator.config.boolHandlers = CopyTable(_env.__simulator.config.boolHandlers)
    _env.__simulator.config.numberHandlers = CopyTable(_env.__simulator.config.numberHandlers)
    return _env
end



function LoadMC(name)
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
end


function multiTick()
    -- do not edit unless you know what you're doing
    for i, _env in ipairs(_mcs) do
        local originalENV = _ENV
        input = _env.input
        output = _env.output

        _ENV = _env

        __simulator.config:onSimulate()
        onSimulate = onLBSimulatorTick or Empty
        onSimulate(__simulator)

        if onTick then
            onTick()
        end

        _globalTicks = _globalTicks + 1

        _ENV = originalENV
    end
end

function multiDraw()
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
end


--- @diagnostic enable: undefined-global