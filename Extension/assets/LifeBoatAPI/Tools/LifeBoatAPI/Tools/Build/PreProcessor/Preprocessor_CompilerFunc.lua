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

---Provides support for Compiletime functions
---Used for generating code at compile-time; similar to macros but not quite the same
---Note that additional tags probably shouldn't be used within macros
---@class Preprocessor_CompilerFunc : BaseClass
---@field priority number
LifeBoatAPI.Tools.Preprocessor_CompilerFunc = {
    ---@class ProcessorTag_CompilerFunc : ProcessorTag
    ---@field macroname string

    ---@param this Preprocessor_CompilerFunc
    ---@param tag ProcessorTag
    ---@param processor PreProcessor
    ---@return ProcessorTag_CompilerFunc
    create = function(this, processor, tag)
        ---@param tag ProcessorTag_CompilerFunc
        tag.process = function(tag, text)
            local name = tag.args[1]
            local macroname = tag.args[2] or ""
            local closingTag = processor:getNextTagWhere(tag.index, function(t) return t.type == "end" and name == t.args[1] end)
            

            if closingTag and macroname ~= "" then
                local innerContent = text:sub(tag.endIndex+1, closingTag.startIndex-1)
                local macroUses = LifeBoatAPI.Tools.StringUtils.find(text, macroname .. "%(([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*)%)")
                
                for i=1,#macroUses do
                    local macroUse = macroUses[i]
                    local parameterisedContent = " " .. innerContent .. " "
                    for i=1,7 do
                        if macroUse.captures[i] ~= nil then
                            -- given our block of content, replace all the parameters used in it (e.g. x, y, z) with the values given in the ACTUAL use
                            local param = tag.args[i+2]
                            parameterisedContent:gsub(LifeBoatAPI.Tools.StringUtils.escape("[^%a%d_]" .. param.. "[^%a%d_]"),
                                                      LifeBoatAPI.Tools.StringUtils.escapeSub(macroUse.captures[i]))
                            local env = {}
                            local contentFunction, err = load(parameterisedContent, "", "t", env)
                            if not contentFunction then
                                error("code generation error. given compilerfunc tag [" .. tag.macroname .. "] doesnt produce valid lua: " .. err)
                            end

                            local generatedCode = tostring(contentFunction())

                            -- simply replace the use of the content with the content (e.g. a(1,2,3) => the actual macro content)
                            LifeBoatAPI.Tools.StringUtils.replaceIndex(text, macroUse.startIndex, macroUse.endIndex, generatedCode) -- replace the actual macro part
                        end
                    end
                end

                if #macroUses > 0 then
                    return text
                end
            end
        end;

    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Preprocessor_CompilerFunc)
