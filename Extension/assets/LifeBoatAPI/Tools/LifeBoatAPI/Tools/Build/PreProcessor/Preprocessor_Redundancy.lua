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

---@class Preprocessor_RemoveIf : BaseClass
LifeBoatAPI.Tools.Preprocessor_RemoveIf = {
    ---@param this Preprocessor_RemoveIf
    ---@param processor PreProcessor
    ---@param tag ProcessorTag
    ---@return ProcessorTag
    create = function(this, processor, tag)

        tag.process = function(tag, text)
            tag.name            = tag.args[1]
            tag.identifier      = tag.args[2]
            tag.instancesNeeded = tonumber(tag.args[3]) or 2
            tag.isExactMatch    = tag.args[5] == "partial" or tag.args[5] == "false"

            local comparisonTypes = {
                ["<"] =     {comparer = function(found, wanted) return found < wanted end,  runInCleanup = false},
                ["~="] =    {comparer = function(found, wanted) return found ~= wanted end, runInCleanup = true},
                ["=="] =    {comparer = function(found, wanted) return found == wanted end, runInCleanup = true},
                ["="] =     {comparer = function(found, wanted) return found == wanted end, runInCleanup = true},
                ["<="] =    {comparer = function(found, wanted) return found <= wanted end, runInCleanup = false},
                [">="] =    {comparer = function(found, wanted) return found >= wanted end, runInCleanup = true},
                [">"] =     {comparer = function(found, wanted) return found > wanted end,  runInCleanup = true}
            };
            tag.comparison = comparisonTypes[tag.args[4]] or comparisonTypes["<"]

            -- not a valid redundancy section without the identifier part
            if not tag.identifier then
                return
            end

            if not tag.comparison.runInCleanup then
                tag:run(text)
            end
        end

        tag.cleanup = function(tag, text)
            if tag.comparison.runInCleanup then
                tag:run(text)
            end
        end

        tag.run = function(tag, text)
            if tag.isExactMatch then
                identifier = "[^%a%d_]" .. LifeBoatAPI.Tools.StringUtils.escape(identifier) .. "[^%a%d_]"
            else
                identifier = LifeBoatAPI.Tools.StringUtils.escape(identifier)
            end

            -- find inner tags
            local closingTag = processor:getNextTagWhere(tag.index, function(nextTag) return nextTag.type == "end" and tag.name == nextTag.args[1] end)
            
            if closingTag and tag.comparison.comparer(#LifeBoatAPI.Tools.StringUtils.find(text, identifier), tag.instancesNeeded)then
                -- remove tag and contents
                return LifeBoatAPI.Tools.StringUtils.replaceIndex(text, tag.startIndex, closingTag.endIndex, "")
            end
        end
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Preprocessor_RemoveIf)



