-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Missions.Utils.LBBase")
require("LifeBoatAPI.Missions.Utils.LBTable")
require("LifeBoatAPI.Missions.Utils.LBString")
require("LifeBoatAPI.Missions.Utils.LBStringBuilder")
require("LifeBoatAPI.Tools.Minimizer.LBVariableRenamer")
require("LifeBoatAPI.Tools.Minimizer.LBParsingConstantsLoader")

---@class LBNumberLiteralReducer : LBBaseClass
---@field renamer LBVariableRenamer shared instance of the renamer, to ensure variables are renamed safely
LBNumberLiteralReducer = {

    ---@param renamer LBVariableRenamer must be the same one as used before
    ---@return LBNumberLiteralReducer
    new = function(cls, renamer)
        local this = LBBaseClass.new(cls)
        this.renamer = renamer
        return this
    end;

    ---@param this LBNumberLiteralReducer
    shortenNumbers = function(this, text)
        -- variables shortened are not keywords, and not global names (because those are a pita)
        text = this:_shortenType(text, LBString_find(text, "[^%w_](0x%x+)"))                 --hexadec
        text = this:_shortenType(text, LBString_find(text, "[^%w_](%d+%.?%d*[Ee]%-?%d*)"))   --exponents
        text = this:_shortenType(text, LBString_find(text, "[^%w_](%d+%.?%d*)"))             --all other numbers

        return text
    end;


    _shortenType = function(this, text, variables)
        -- filter down to numbers that are at least 3 characters long, or it's pointless
        variables = LBTable_iwhere(variables, function(v) return v.captures[1] and #v.captures[1] >= 3 end)

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
        variables = LBTable_iwhere(variables, function(v) return count[v.captures[1]] >= 3 end)

        -- due to the pattern, we need to alter each variable, so it's start position exclude the non-variable character
        variables = LBTable_iselect(variables, function(v) v.startIndex = v.startIndex + 1; return v end)
        return this:_replaceVariables(text, variables)
    end;

    ---@param this LBNumberLiteralReducer
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
LBClass(LBNumberLiteralReducer);
