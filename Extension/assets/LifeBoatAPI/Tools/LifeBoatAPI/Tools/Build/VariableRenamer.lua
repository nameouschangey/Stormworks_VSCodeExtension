-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Build.ParsingConstantsLoader")

--------------------------------------------------------------------------------------------------------------------
---@class VariableRenamer : BaseClass
---@field constants ParsingConstantsLoader
LifeBoatAPI.Tools.VariableRenamer = {
    _replacementCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"; -- no need for more than this with 4K chars
    variableNumber = 1;
    
    ---@return VariableRenamer
    new = function(cls, constants)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.constants = constants
        return this
    end;
    
    --- Note, there is absolutely no reason to expect more than 2500 variables in a 4000 character file, hence 52*52 is fine
    ---@param this VariableRenamer
    getShortName = function(this)
        local name = ""
        repeat
            name = this:_generateName()
        until(not this.constants.restrictedKeywords[name] and not this.constants.baseNames[name])
        return name
    end;
    
    
    _generateName = function(this)
        this.variableNumber = this.variableNumber + 1
    
        if(this.variableNumber <= 52) then -- 52 most commonly variable names will become 1 letter each
            return this._replacementCharacters:sub(this.variableNumber, this.variableNumber) 
        elseif(this.variableNumber <= (52*52)) then
            local num1 = math.floor(this.variableNumber%52) + 1;
            local num2 = math.floor(this.variableNumber/52) + 1;
            return this._replacementCharacters:sub(num2,num2) .. this._replacementCharacters:sub(num1, num1)
        end
        return "L" .. tostring(this.variableNumber)
    end;
    
};
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.VariableRenamer);