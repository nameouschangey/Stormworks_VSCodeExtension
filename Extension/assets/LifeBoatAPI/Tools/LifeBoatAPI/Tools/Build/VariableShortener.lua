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


---@class VariableShortener : BaseClass
---@field renamer VariableRenamer
---@field constants ParsingConstantsLoader
LifeBoatAPI.Tools.VariableShortener = {

    ---@param cls VariableShortener
    ---@param renamer VariableRenamer
    ---@param constants ParsingConstantsLoader
    ---@return VariableShortener
    new = function(cls, renamer, constants)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.constants = constants
        this.renamer = renamer
        return this
    end;

    ---@param this VariableShortener
    shortenVariables = function(this, text)
        -- variables shortened are not keywords, and not global names (because those are a pita)
        local variables = LifeBoatAPI.Tools.StringUtils.find(text, "[^%w_]([%a_][%w_]-)[^%w_]")

        -- filter out variables that we're not allowed to shorten
        variables = LifeBoatAPI.Tools.TableUtils.iwhere(variables, function(v) return v.captures[1]
                                                                and not v.captures[1]:find("STRING%d%d%d%d%d%d%dREPLACEMENT")
                                                                and not this.constants.baseNames[v.captures[1]]
                                                                and not this.constants.fullNames[v.captures[1]]
                                                                and not this.constants.restrictedKeywords[v.captures[1]] end)
        -- due to the pattern, we need to alter each variable, so it's start and end position exclude the non-variable character
        variables = LifeBoatAPI.Tools.TableUtils.iselect(variables, function(v) v.startIndex = v.startIndex + 1; v.endIndex = v.endIndex - 1; return v end)

        return this:_replaceVariables(text, variables)
    end;

    ---@param this VariableShortener
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
            variablesSeenBefore[variable.captures[1]] = name

            output:add(text:sub(lastEnd, variable.startIndex-1), name)
            lastEnd = variable.endIndex + 1
        end

        -- add the final file chunk on
        output:add(text:sub(lastEnd, #text))

        -- add output after global definitions
        return output:getString()
    end;
};
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.VariableShortener);
