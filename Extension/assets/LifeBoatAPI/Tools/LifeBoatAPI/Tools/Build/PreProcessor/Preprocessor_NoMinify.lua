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
---@lb(redundancy,tagName,someIdentifier,instancesNeededor2,isExactMatch)
    --function someIdentifier(x,y,z)
    --   return x+y+z
    --end
---@lb(end,tagName)

---@class Preprocessor_NoMinify : BaseClass
---@field replacements table<string,string>
LifeBoatAPI.Tools.Preprocessor_NoMinify = {
    ---@class ProcessorTag_NoMinify : ProcessorTag
    ---@field redundancyIdentifier string
    ---@field nextReplacementID number

    ---@param this Preprocessor_NoMinify
    ---@param text string
    ---@return string
    repopulateStrings = function(this, text)
        for replacementID, replacement in pairs(this.replacements) do
            return LifeBoatAPI.Tools.StringUtils.subAll(text,LifeBoatAPI.Tools.StringUtils.escape(replacementID), LifeBoatAPI.Tools.StringUtils.escapeSub(replacement))
        end
    end;

    ---@param this Preprocessor_NoMinify
    ---@param processor PreProcessor
    ---@param tag ProcessorTag
    ---@return ProcessorTag_NoMinify
    create = function(this, processor, tag)

        ---@param text string
        ---@param tag ProcessorTag_NoMinify
        tag.process = function(tag, text)
            local name = tag.args[1]

            ----- find inner tags
            local closingTag = processor:getNextTagWhere(tag.index, function(nextTag) return nextTag.type == "end" and name == nextTag.args[1] end)

            if closingTag then
                this.nextReplacementID = (this.nextReplacementID or 0) + 1
                local replacementID = "__lb__nominify__replacement__" .. this.nextReplacementID

                -- add this to list of things to be repopulated at the end
                this.replacements[replacementID] = text:sub(tag.endIndex+1, closingTag.startIndex-1)
                
                -- remove tag and contents
                return LifeBoatAPI.Tools.StringUtils.replaceIndex(text, tag.startIndex, closingTag.endIndex, replacementID)
            end
        end;
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Preprocessor_NoMinify)



