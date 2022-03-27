-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Utils.TableUtils")
require("LifeBoatAPI.Tools.Utils.StringBuilder")
require("LifeBoatAPI.Tools.Utils.StringUtils")
require("LifeBoatAPI.Tools.Build.PreProcessor.Preprocessor")

---@class Preprocessor_Redundancy : BaseClass
---@field priority number
LifeBoatAPI.Tools.Preprocessor_Remove = {

    ---@param this Preprocessor_Remove
    ---@param processor PreProcessor
    ---@param tag ProcessorTag
    ---@return Preprocessor_Remove
    create = function(this, processor, tag)
        ---@param tag ProcessorTag
        tag.process = function(tag, text)
        end;

        ---@param tag ProcessorTag
        tag.cleanup = function(tag, text)
            local name = tag.args[1]
            local closingTag = processor:getNextTagWhere(tag.index, function(nextTag) return nextTag.type == "end" and name == nextTag.args[1] end)

            return LifeBoatAPI.Tools.StringUtils.replaceIndex(text, tag.startIndex, closingTag and closingTag.endIndex or tag.endIndex)
        end;
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Preprocessor_Remove)



