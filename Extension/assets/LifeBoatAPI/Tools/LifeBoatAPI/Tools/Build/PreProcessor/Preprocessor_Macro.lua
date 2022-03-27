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



---Provides support for Macros
---Note that additional tags probably shouldn't be used within macros
---@class Preprocessor_Macro : BaseClass
---@field priority number
LifeBoatAPI.Tools.Preprocessor_Macro = {
    ---@class ProcessorTag_Macro : ProcessorTag
    ---@field macroname string

    ---@param this Preprocessor_Macro
    ---@param tag ProcessorTag
    ---@param processor PreProcessor
    ---@return ProcessorTag_Macro
    create = function(this, processor, tag)
        ---@param tag ProcessorTag_Macro
        tag.process = function(tag, text)
            local name = tag.args[1]
            local macroname = tag.args[2] or ""
            local closingTag = processor:getNextTagWhere(tag.index, function(t) return t.type == "end" and name == t.args[1] end)
            

            if closingTag and macroname ~= "" then
                local innerContent = text:sub(tag.endIndex+1, closingTag.startIndex-1)
                local macroUses = LifeBoatAPI.Tools.StringUtils.find(text, macroname .. "%(([^,)]*),?([^,)]*),?([^,)]*),?([^,)]*),?([^,)]*),?([^,)]*),?([^,)]*)%)")
                
                for i=1,#macroUses do
                    local macroUse = macroUses[i]
                    local parameterisedContent = " " .. innerContent .. " "
                    for i=1,7 do
                        if macroUse.captures[i] ~= "" then
                            -- given our block of content, replace all the parameters used in it (e.g. x, y, z) with the values given in the ACTUAL use
                            local param = tag.args[i+2]
                            parameterisedContent = parameterisedContent:gsub("([^%a%d_])" .. LifeBoatAPI.Tools.StringUtils.escape(param) .. "([^%a%d_])",
                                                                             "%1" .. LifeBoatAPI.Tools.StringUtils.escape(macroUse.captures[i]) .. "%2")
                        end
                    end
                    return LifeBoatAPI.Tools.StringUtils.replaceIndex(text, macroUse.startIndex, macroUse.endIndex, parameterisedContent) -- replace the actual macro part
                end
            end
        end
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Preprocessor_Macro)
