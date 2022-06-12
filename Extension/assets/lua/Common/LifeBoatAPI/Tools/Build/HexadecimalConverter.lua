-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Utils.TableUtils")
require("LifeBoatAPI.Tools.Utils.StringUtils")
require("LifeBoatAPI.Tools.Utils.StringBuilder")
require("LifeBoatAPI.Tools.Build.VariableRenamer")
require("LifeBoatAPI.Tools.Build.ParsingConstantsLoader")


--- Finds and converts all Hexadecimals into decimals
--- Stormworks doesn't natively support Hex numbers (0x123 is fine, 0xfff is incorrect caught as an error), this enables them
---@class HexadecimalConverter : BaseClass
LifeBoatAPI.Tools.HexadecimalConverter = {

    ---@return HexadecimalConverter
    new = function(cls)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        return this
    end;

    ---@param this HexadecimalConverter
    fixHexademicals = function(this, text)
        local stringUtils = LifeBoatAPI.Tools.StringUtils;

        -- variables shortened are not keywords, and not global names (because those are a pita)
        local hexValues = stringUtils.find(text, "[^%w_](0x%x+)")
        for i=1, #hexValues do
            local hexVal = hexValues[i]
            local hexAsNum = tonumber(hexVal.captures[1])
    
            text = stringUtils.subAll(text, "([^%w_])" .. stringUtils.escape(hexVal.captures[1]), "%1" .. tostring(hexAsNum))
        end
    
        return text
    end;
}

LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.HexadecimalConverter);
