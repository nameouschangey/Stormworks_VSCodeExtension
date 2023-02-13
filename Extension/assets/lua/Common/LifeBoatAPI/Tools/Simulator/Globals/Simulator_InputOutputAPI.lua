-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

-- Based on work by Rene-Sackers:
--      Auto generated docs by René Sackers, StormworksLuaDocsGen (https://github.com/Rene-Sackers/StormworksLuaDocsGen)
--      Based on data in: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go
--      Notice issues/missing info? Please contribute here: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go, then create an issue on the GitHub repo

---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-doc-param

---@class Simulator_InputAPI
---@field _numbers number[] array of numbers inputs
---@field _bools boolean[] array of boolean inputs
input = {
    _numbers = {};
    _bools = {};

    _setSimulator = function(simulator)
        input._simulator = simulator
    end;

    _ensureNotRendering = function()
        if input._simulator and input._simulator._isRendering then
            error("Cannot use input functions outside of onTick.")
        end
    end;

    --- @param index number The composite index to read from
    --- @return boolean value
    getBool = function(...)
        input._ensureNotRendering()

        local args = {...}
        if #args < 1 then return end

        local index = tonumber(args[1])

        if not index then return false end
        if(index > 32) then return false end
        if(index < 1) then  return false end

        return input._bools[index] or false
    end;

    --- @param index number The composite index to read from
    --- @return number value
    getNumber = function(...)
        input._ensureNotRendering()

        local args = {...}
        if #args < 1 then return end

        local index = tonumber(args[1])

        if not index then return 0.0 end
        if(index > 32) then return 0.0 end
        if(index < 1) then return 0.0 end

        return input._numbers[index] or 0.0
    end;
}

---@class Simulator_OutputAPI
---@field _numbers number[] array of numbers inputs
---@field _bools boolean[] array of boolean inputs
---@field _simulator Simulator current simulator, needed for reducing message count
output = {
    _numbers = {};
    _bools = {};

    _setSimulator = function(simulator)
        output._simulator = simulator
    end;

    _ensureNotRendering = function()
        if output._simulator and output._simulator._isRendering then
            error("Cannot use output functions outside of onTick.")
        end
    end;

    --- Set an on/off value on the composite output
    ---@param index number The composite index to write to
    ---@param value boolean The on/off value to write
    ---@overload fun(index:number, value:boolean)
    setBool = function(...)
        output._ensureNotRendering()
        local args = {...}
        if #args < 2 then return end

        local index = tonumber(args[1])
        local value = args[2] or false

        if not index then return end
        if(index > 32) then return end
        if(index < 1) then return end

        if(value ~= output._bools[index]) then
            ---@diagnostic disable: undefined-global
            if onLBSimulatorOutputBoolChanged then -- enables easy ability to stick breakpoints looking for the output changing, rather than tracking it down
                onLBSimulatorOutputBoolChanged(index, output._bools[index], value)
            end
            ---@diagnostic enable: undefined-global

            output._simulator._isInputOutputChanged = true;
            output._bools[index] = value
        end
    end;

    --- Set a number value on the composite output
    ---@param index number The composite index to write to
    ---@param value number The number value to write
    ---@overload fun(index:number, value:number)
    setNumber = function(...)
        output._ensureNotRendering()

        local args = {...}
        if #args < 2 then return end

        local index = tonumber(args[1])
        local value = tonumber(args[2]) or 0.0

        if not index then return end
        if(index > 32) then return end
        if(index < 1) then return end

        if(value ~= output._numbers[index]) then

            ---@diagnostic disable: undefined-global
            if onLBSimulatorOutputNumberChanged then  -- enables easy ability to stick breakpoints looking for the output changing, rather than tracking it down
                onLBSimulatorOutputNumberChanged(index, output._numbers[index], value)
            end
            ---@diagnostic enable: undefined-global

            output._simulator._isInputOutputChanged = true;
            output._numbers[index] = value
        end
    end;
}

---@class Simulator_PropertiesAPI
---@field _numbers table<string, number> number properties by name
---@field _bools  table<string, boolean> boolean properties by name
---@field _texts  table<string, string> string properties by name
property = {
    _numbers = {};
    _bools = {};
    _texts = {};

    --- Get a number value from a property
    --- @param label string The name of the property to read
    --- @return number value
    getNumber = function(...)
        local args = {...}
        if #args < 1 then return end

        local label = tostring(args[1])
        return property._numbers[tostring(label)] or 0.0
    end;

    --- Get a bool value from a property
    --- @param label string The name of the property to read
    --- @return boolean value
    getBool = function(...)
        local args = {...}
        if #args < 1 then return end

        local label = tostring(args[1])
        return property._bools[tostring(label)] or false
    end;

    --- Get a text value from a property
    --- @param label string The name of the property to read
    --- @return string value
    getText = function(...)
        local args = {...}
        if #args < 1 then return end

        local label = tostring(args[1])
        return property._texts[label] or ""
    end;
}

--- Pre-processing, the game normally starts with all values at 0/false not nil
for i=1,32 do
    input._numbers[i] = 0.0
    input._bools[i] = false

    output._numbers[i] = 0.0
    output._bools[i] = false
end

-- allow debug.log for printing, as this also works in-game
debug = debug or {}
debug.log = print


---@diagnostic enable: lowercase-global