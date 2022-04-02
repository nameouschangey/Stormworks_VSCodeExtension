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
    new = function(cls, stringReplacer, commentReplacer)
    end;
    

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
            

            if closingTag and macroname and macroname ~= "" then
                local innerContent = text:sub(tag.endIndex+1, closingTag.startIndex-1)
                -- replace comments and strings back in


                local macroUses = LifeBoatAPI.Tools.StringUtils.find(text, macroname .. "%(([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*)%)")
                
                for i=1,#macroUses do
                    local macroUse = macroUses[i]
                    local parameterisedContent = " " .. innerContent .. " "

                    local env = {}
                    for i=1,7 do
                        if macroUse.captures[i] ~= "" then
                            local param = tag.args[i+2]
                            env[param] = macroUse.captures[i]
                        end
                    end

                    local success, contentFunction, err = pcall(load, parameterisedContent, "", "t", env)
                    if not contentFunction then
                        error("[" .. tostring(tag.macroname) .. "] code generation error. given compilerfunc tag doesnt produce valid lua: " .. err)
                    end

                    local generatedResult = contentFunction()
                    local generatedType = type(generatedResult)
                    local generatedCode = ""
                    if generatedType == "number" or generatedType == "boolean" or generatedType == "nil" then
                        generatedCode = tostring(generatedResult)
                    elseif generatedType == "table" then
                        generatedCode = LifeBoatAPI.Tools.TableUtils.tostring(generatedResult)
                    elseif generatedType == "function" then
                        error("[" .. tostring(tag.macroname) .. "] compilerfunc cannot return a function, you may have meant to return a string with the name of the function instead.")
                    end
                    
                    return LifeBoatAPI.Tools.StringUtils.replaceIndex(text, macroUse.startIndex, macroUse.endIndex, generatedCode) -- replace the actual macro part
                end
            end
        end

        tag.cleanup = function(tag, text)
            local name = tag.args[1]
            local closingTag = processor:getNextTagWhere(tag.index, function(t) return t.type == "end" and name == t.args[1] end)
            return LifeBoatAPI.Tools.StringUtils.replaceIndex(text, tag.startIndex, closingTag and closingTag.endIndex or tag.endIndex)
        end
    end;

    
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Preprocessor_CompilerFunc)
