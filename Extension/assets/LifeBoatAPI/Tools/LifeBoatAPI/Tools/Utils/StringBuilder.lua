-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Utils.TableUtils")

---@class StringBuilder : BaseClass
---@field stringData string[] string being built
LifeBoatAPI.Tools.StringBuilder = {
    ---@overload fun() : StringBuilder default constructor, no initial string value
    ---@param cls StringBuilder
    ---@param text string initial value for the string
    new = function(cls, text)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.stringData = {};
        if(text) then
            this:add(text)
        end
        return this;
    end;

    --- Adds the given string to the front of the string being build
    ---@param this StringBuilder
    ---@vararg any values to add to the string
    addFront = function(this, value)
        LifeBoatAPI.Tools.TableUtils.add(this.stringData, tostring(value), 1)
    end;

    ---Adds the given string to the current string being built
    ---@param this StringBuilder
    ---@vararg any values to add to the string
    add = function(this, ...)
        for i, v in ipairs({...}) do
            LifeBoatAPI.Tools.TableUtils.add(this.stringData, tostring(v))
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
        return LifeBoatAPI.Tools.TableUtils.concat(this.stringData, separator)
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.StringBuilder)
