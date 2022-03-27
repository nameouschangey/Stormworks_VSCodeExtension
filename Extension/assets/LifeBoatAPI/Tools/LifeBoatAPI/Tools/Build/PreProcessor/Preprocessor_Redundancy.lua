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

-- example useage
-----@lb(redundancy,tagName,someIdentifier,instancesNeededor2,isExactMatch)
--    --function someIdentifier(x,y,z)
--    --   return x+y+z
--    --end
-----@lb(end,tagName)

---@class Preprocessor_Redundancy : BaseClass
---@field priority number
LifeBoatAPI.Tools.Preprocessor_Redundancy = {
    ---@class ProcessorTag_Redundancy : ProcessorTag
    ---@field redundancyIdentifier string

    ---@param this Preprocessor_Redundancy
    ---@param processor PreProcessor
    ---@param tag ProcessorTag
    ---@return ProcessorTag_Redundancy
    create = function(this, processor, tag)
        ---@param tag ProcessorTag_Redundancy
        tag.process = function(tag, text)
            local name = tag.args[1]
            local identifier = tag.args[2]
            local instancesNeeded = tonumber(tag.args[3]) or 2
            local isExactMatch = tag.args[4] == "partial" or tag.args[4] == "false"
            
            -- not a valid redundancy section without the identifier part
            if not identifier then
                return
            end

            if isExactMatch then
                identifier = "[^%a%d_]" .. LifeBoatAPI.Tools.StringUtils.escape(identifier) .. "[^%a%d_]"
            else
                identifier = LifeBoatAPI.Tools.StringUtils.escape(identifier)
            end

            -- find inner tags
            local closingTag = processor:getNextTagWhere(tag.index, function(nextTag) return nextTag.type == "end" and name == nextTag.args[1] end)
            
            if closingTag and #LifeBoatAPI.Tools.StringUtils.find(text, identifier) < instancesNeeded then
                -- remove tag and contents
                return LifeBoatAPI.Tools.StringUtils.replaceIndex(text, tag.startIndex, closingTag.endIndex, "")
            end
        end
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Preprocessor_Redundancy)



