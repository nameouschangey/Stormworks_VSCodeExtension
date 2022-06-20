-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Build.ParsingConstantsLoader")

--------------------------------------------------------------------------------------------------------------------
---@class VariableRenamer : BaseClass
---@field constants ParsingConstantsLoader
LifeBoatAPI.Tools.VariableRenamer = {
    _replacementCharacters = "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"; -- no need for more than this with 4K chars
    
    ---@return VariableRenamer
    new = function(cls, constants)
        local self = LifeBoatAPI.Tools.BaseClass.new(cls)
        self.constants = constants
        self.variableNumber = 0
        return self
    end;

    --- Note, there is absolutely no reason to expect more than 2500 variables in a 4000 character file, hence 52*52 is fine
    ---@param self VariableRenamer
    getShortName = function(self)
        local name = ""
        repeat
            name = self:_generateName()
        until(not self.constants.restrictedKeywords[name] and not self.constants.baseNames[name] and not self.constants.fullNames[name])
        return name
    end;

    _generateName = function(self)
        local size = #self._replacementCharacters
        self.variableNumber = self.variableNumber + 1

        if(self.variableNumber <= size) then -- 53 most commonly variable names will become 1 letter each
            return self._replacementCharacters:sub(self.variableNumber, self.variableNumber) 
        elseif(self.variableNumber <= (size*size)) then
            local num1 = math.floor(self.variableNumber%size) + 1;
            local num2 = math.floor(self.variableNumber/size) + 1;
            return self._replacementCharacters:sub(num2,num2) .. self._replacementCharacters:sub(num1, num1)
        end
        return "L" .. tostring(self.variableNumber)
    end;
};
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.VariableRenamer);