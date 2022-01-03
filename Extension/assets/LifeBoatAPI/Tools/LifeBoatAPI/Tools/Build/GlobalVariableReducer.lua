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


---@class GlobalVariableReducer : BaseClass
---@field constants ParsingConstantsLoader
---@field renamer VariableRenamer shared instance of the renamer, to ensure variables are renamed safely
LifeBoatAPI.Tools.GlobalVariableReducer = {

    ---@param renamer VariableRenamer must be the same one as used before
    ---@param constants ParsingConstantsLoader
    ---@return GlobalVariableReducer
    new = function(cls, renamer, constants)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.renamer = renamer
        this.constants = constants
        return this
    end;

    ---@param this GlobalVariableReducer
    shortenGlobals = function(this, text)
        text = this:_shorten(text, "[^%w_]([%a_][%w_%.]-)[^%w_%.]", this.constants.fullNames)
        text = "\n" .. text -- ensure newly added variables work
        text = this:_shorten(text, "[^%w_]([%a_][%w_]-)[^%w_]", this.constants.baseNames)
        return text
    end;

    ---@param this GlobalVariableReducer
    _shorten = function(this, text, pattern, acceptableList)
        -- variables shortened are not keywords, and not global names (because those are a pita)
        local variables = LifeBoatAPI.Tools.StringUtils.find(text, pattern)

        -- filter down to ONLY the externalGlobals list
        variables = LifeBoatAPI.Tools.TableUtils.iwhere(variables, function(v) return v.captures[1]
                                                                and not v.captures[1]:find("STRING%d%d%d%d%d%d%dREPLACEMENT")
                                                                and acceptableList[v.captures[1]]
                                                                and not this.constants.restrictedKeywords[v.captures[1]] end)  -- only change globals where they're used at least twice, or it's a cost

        -- count times we've go this same variable in the list
        local count = {}
        for k,v in ipairs(variables) do
            if(not count[v.captures[1]]) then
                count[v.captures[1]] = 1
            else
                count[v.captures[1]] = count[v.captures[1]] + 1
            end
        end

        -- filter out variables not seen enough times
        variables = LifeBoatAPI.Tools.TableUtils.iwhere(variables, function(v) return count[v.captures[1]] >= 2 end)

        -- due to the pattern, we need to alter each variable, so it's start and end position exclude the non-variable character
        variables = LifeBoatAPI.Tools.TableUtils.iselect(variables, function(v) v.startIndex = v.startIndex + 1; v.endIndex = v.endIndex - 1; return v end)
        return this:_replaceVariables(text, variables)
    end;

    ---@param this GlobalVariableReducer
    ---@param variables StringMatch[]
    ---@param text string file data to parse
    ---@return string text with variables replaced with shorter versions
    _replaceVariables = function(this, text, variables)
        local variablesSeenBefore = {}
        local output = LifeBoatAPI.Tools.StringBuilder:new()

        local lastEnd = 1

        -- sub each variable with the shortened name
        for i,variable in ipairs(variables) do

            local name = variablesSeenBefore[variable.captures[1]] or this.renamer:getShortName()

            -- if this is the first instance, we also add the conversion to the top of the file
            if(not variablesSeenBefore[variable.captures[1]]) then
                output:addFront(name .. "=" .. variable.captures[1] .. "\n")
                variablesSeenBefore[variable.captures[1]] = name
            end

            output:add(text:sub(lastEnd, variable.startIndex-1), name)
            lastEnd = variable.endIndex + 1
        end

        -- add the final file chunk on
        output:add(text:sub(lastEnd, #text))

        -- add output after global definitions
        return output:getString()
    end;
};

LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.GlobalVariableReducer);