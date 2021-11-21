-- Nameous Changey

-- Based on work by Rene-Sackers ('Nelo):
--      Auto generated docs by StormworksLuaDocsGen (https://github.com/Rene-Sackers/StormworksLuaDocsGen)
--      Based on data in: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go
--      Notice issues/missing info? Please contribute here: https://docs.google.com/spreadsheets/d/1tCvYSzxnr5lWduKlePKg4FerpeKHbKTmwmAxlnjZ_Go, then create an issue on the GitHub repo

---@class LBSimulator_InputAPI
---@field _numbers number[] array of numbers inputs
---@field _bools boolean[] array of boolean inputs
input = {
    _numbers = {};
    _bools = {};

    --- @param index number The composite index to read from
    --- @return boolean value
    getBool = function(index)
        if(index > 32) then error("Index > 32 for input " .. tostring(index) .. " getting bool ") end
        if(index < 1) then error("Index < 1 for input " .. tostring(index) .. " getting bool ") end
        return input._bools[index]
    end;

    --- @param index number The composite index to read from
    --- @return number value
    getNumber = function(index)
        if(index > 32) then error("Index > 32 for input " .. tostring(index) .. " getting number ") end
        if(index < 1) then error("Index < 1 for input " .. tostring(index) .. " getting number ") end
        return input._numbers[index]
    end;
}

---@class LBSimulator_OutputAPI
---@field _numbers number[] array of numbers inputs
---@field _bools boolean[] array of boolean inputs
output = {
    _numbers = {};
    _bools = {};

    --- Set an on/off value on the composite output
    --- @param index number The composite index to write to
    --- @param value boolean The on/off value to write
    setBool = function(index, value)
        if(index > 32) then error("Index > 32 for output " .. tostring(index) .. " setting bool " .. tostring(value)) end
        if(index < 1) then error("Index < 1 for output " .. tostring(index) .. " setting bool " .. tostring(value)) end

        if(value ~= nil and value ~= output._bools[index]) then
            if onOutputBoolChangedListener then -- enables easy ability to stick breakpoints looking for the output changing, rather than tracking it down
                onOutputBoolChangedListener(index, output._bools[index], value)
            end

            output._bools[index] = value
        end
    end;

    --- Set a number value on the composite output
    --- @param index number The composite index to write to
    --- @param value number The number value to write
    setNumber = function(index, value)
        if(index > 32) then error("Index > 32 for output " .. tostring(index) .. " setting number " .. tostring(value)) end
        if(index < 1) then error("Index < 1 for output " .. tostring(index) .. " setting number " .. tostring(value)) end

        if(value ~= nil and value ~= output._numbers[index]) then
            if onOutputNumberChangedListener then  -- enables easy ability to stick breakpoints looking for the output changing, rather than tracking it down
                onOutputNumberChangedListener(index, output._numbers[index], value)
            end

            output._numbers[index] = value
        end
    end;
}

---@class LBSimulator_PropertiesAPI
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
    getNumber = function(label)
        return property._numbers[label]
    end;

    --- Get a bool value from a property
    --- @param label string The name of the property to read
    --- @return boolean value
    getBool = function(label)
        return property._bools[label]
    end;

    --- Get a text value from a property
    --- @param label string The name of the property to read
    --- @return string value
    getText = function(label)
        return property._texts[label]
    end;
}

--- Pre-processing, the game normally starts with all values at 0/false not nil
for i=1,32 do
    input._numbers[i] = 0
    input._bools[i] = false
    
    output._numbers[i] = 0
    output._bools[i] = false
end