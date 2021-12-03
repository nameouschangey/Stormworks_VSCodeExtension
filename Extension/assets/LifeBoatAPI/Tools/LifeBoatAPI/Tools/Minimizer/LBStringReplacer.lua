-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Missions.Utils.LBBase")
require("LifeBoatAPI.Missions.Utils.LBTable")
require("LifeBoatAPI.Missions.Utils.LBString")

---@class LBStringReplacer : LBBaseClass
---@field renamer LBVariableRenamer
---@field stringsReplaced table<string,table>
LBStringReplacer = {

    ---@return LBStringReplacer
    new = function(cls, renamer)
        local this = LBBaseClass.new(cls)
        this.stringsReplaced = {}
        this.count = 1
        this.renamer = renamer
        return this
    end;

    ---@param this LBStringReplacer
    ---@param stringValue string value to replace with a constant, including the surrounding quotes
    ---@return string replacement constant
    getStringReplacement = function(this, stringValue)
        if(not this.stringsReplaced[stringValue]) then
            this.count = this.count + 1
            local replacement = "STRING" .. string.format("%07d", this.count) .. "REPLACEMENT"
            this.stringsReplaced[stringValue] = {value = replacement, count = 1}
            return replacement
        else
            this.stringsReplaced[stringValue].count = this.stringsReplaced[stringValue].count + 1
            return this.stringsReplaced[stringValue].value
        end
    end;

    ---@param this LBStringReplacer
    ---@param text string text that was previously stripped of strings
    ---@return string text with original strings repopulated
    repopuplateStrings = function(this, text)
        for k,v in pairs(this.stringsReplaced) do
            if v.count > 1 then
                -- if there's multiples of this string constant, we're almost always better to create a new variable for it
                local newName = this.renamer:getShortName()
                text = newName .. "=" .. k .. "\n" .. text:gsub(v.value, LBString_escapeSub(newName))
            else
                -- direct sub if there's only 1 of the string
                text  = text:gsub(v.value, LBString_escapeSub(k))
            end
            
        end
        return text
    end;
};

LBClass(LBStringReplacer);

