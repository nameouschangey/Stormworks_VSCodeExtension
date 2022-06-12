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


---@class NumberLiteralReducer : BaseClass
---@field renamer VariableRenamer shared instance of the renamer, to ensure variables are renamed safely
LifeBoatAPI.Tools.NumberLiteralReducer = {

    ---@param renamer VariableRenamer must be the same one as used before
    ---@return NumberLiteralReducer
    new = function(cls, renamer)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.renamer = renamer
        return this
    end;

    ---@param this NumberLiteralReducer
    shortenNumbers = function(this, text)
        -- variables shortened are not keywords, and not global names (because those are a pita)
        text = this:_shortenType(text, LifeBoatAPI.Tools.StringUtils.find(text, "[^%w_](0x%x+)"))                 --hexadec
        text = this:_shortenType(text, LifeBoatAPI.Tools.StringUtils.find(text, "[^%w_](%d+%.?%d*[Ee]%-?%d*)"))   --exponents
        text = this:_shortenType(text, LifeBoatAPI.Tools.StringUtils.find(text, "[^%w_](%d+%.?%d*)"))             --all other numbers

        -- numbers in the form 0.123 can be shortened to .123
        text = LifeBoatAPI.Tools.StringUtils.subAll(text, "([^%w_])0+(%.%d+)", "%1%2")

        return text
    end;

    _shortenType = function(this, text, variables)
        -- filter down to numbers that are at least 3 characters long, or it's pointless
        variables = LifeBoatAPI.Tools.TableUtils.iwhere(variables, function(v) return v.captures[1] and #v.captures[1] >= 3 end)

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
        variables = LifeBoatAPI.Tools.TableUtils.iwhere(variables, function(v) return count[v.captures[1]] >= 3 end)

        -- due to the pattern, we need to alter each variable, so it's start position exclude the non-variable character
        variables = LifeBoatAPI.Tools.TableUtils.iselect(variables, function(v) v.startIndex = v.startIndex + 1; return v end)
        return this:_replaceVariables(text, variables)
    end;

    ---@param this NumberLiteralReducer
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
}

LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.NumberLiteralReducer);
