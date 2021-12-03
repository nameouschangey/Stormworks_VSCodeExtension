-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Missions.Utils.LBBase")
require("LifeBoatAPI.Missions.Utils.LBTable")
require("LifeBoatAPI.Missions.Utils.LBString")
require("LifeBoatAPI.Missions.Utils.LBStringBuilder")
require("LifeBoatAPI.Tools.Minimizer.LBVariableRenamer")
require("LifeBoatAPI.Tools.Minimizer.LBParsingConstantsLoader")

--------------------------------------------------------------------------------------------------------------------
---@class LBVariableShortener : LBBaseClass
---@field renamer LBVariableRenamer
---@field constants LBParsingConstantsLoader
LBVariableShortener = {

    ---@param cls LBVariableShortener
    ---@param renamer LBVariableRenamer
    ---@param constants LBParsingConstantsLoader
    ---@return LBVariableShortener
    new = function(cls, renamer, constants)
        local this = LBBaseClass.new(cls)
        this.constants = constants
        this.renamer = renamer
        return this
    end;

    ---@param this LBVariableShortener
    shortenVariables = function(this, text)
        -- variables shortened are not keywords, and not global names (because those are a pita)
        local variables = LBString_find(text, "[^%w_]([%a_][%w_]-)[^%w_]")

        -- filter out variables that we're not allowed to shorten
        variables = LBTable_iwhere(variables, function(v) return v.captures[1]
                                                                and not v.captures[1]:find("STRING%d%d%d%d%d%d%dREPLACEMENT")
                                                                and not this.constants.baseNames[v.captures[1]]
                                                                and not this.constants.fullNames[v.captures[1]]
                                                                and not this.constants.restrictedKeywords[v.captures[1]] end)
        -- due to the pattern, we need to alter each variable, so it's start and end position exclude the non-variable character
        variables = LBTable_iselect(variables, function(v) v.startIndex = v.startIndex + 1; v.endIndex = v.endIndex - 1; return v end)

        return this:_replaceVariables(text, variables)
    end;

    ---@param this LBVariableShortener
    ---@param variables LBStringMatch[]
    ---@param text string file data to parse
    ---@return string text with variables replaced with shorter versions
    _replaceVariables = function(this, text, variables)
        local variablesSeenBefore = {}
        local output = LBStringBuilder:new()

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
LBClass(LBVariableShortener);
