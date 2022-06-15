-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Utils.TableUtils")

---@class StringBuilder : BaseClass
---@field stringData string[] string being built
LifeBoatAPI.Tools.StringBuilder = {
    ---@overload fun() : StringBuilder default constructor, no initial string value
    ---@param cls StringBuilder
    ---@param text string initial value for the string
    new = function(cls, text)
        local self = {
            stringData = {},
            addFront = cls.addFront,
            add = cls.add,
            addLine = cls.addLine,
            getString = cls.getString
        }
        if(text) then
            self:add(text)
        end
        return self;
    end;

    --- Adds the given string to the front of the string being build
    ---@param this StringBuilder
    ---@vararg any values to add to the string
    addFront = function(this, value)
        table.insert(this.stringData, 1, value)
    end;

    ---Adds the given string to the current string being built
    ---@param this StringBuilder
    ---@vararg any values to add to the string
    add = function(this, ...)
        local args = {...}
        for i=1, #args do
            this.stringData[#this.stringData+1] = args[i]
        end
    end;

    ---Adds the given string and ends with a new line added
    ---@param this StringBuilder
    ---@vararg any values to add. A newline will be generated to the end
    addLine = function(this, ...)
        this:add(..., "\n")
    end;

    ---Gets the completed string
    ---@overload fun():string
    ---@param this StringBuilder
    ---@param separator string optional separator, if provided is inserted between each entry 
    ---@return string completed string that has been built
    getString = function(this, separator)
        return table.concat(this.stringData, separator)
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.StringBuilder)
