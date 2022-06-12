-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Utils.TableUtils")

--- struct representing a variable found in the code
---@class StringMatch : BaseClass
---@field startIndex number position it was found in the text
---@field endIndex number end position this variable was found at
---@field captures table variable text that was found
LifeBoatAPI.Tools.StringMatch = {
    ---@return StringMatch
    new = function(cls, ...)
        local this, args = LifeBoatAPI.Tools.BaseClass.new(cls),{...}
        this.startIndex = args[1]
        this.endIndex = args[2]
        this.captures = LifeBoatAPI.Tools.TableUtils.islice(args,3)
        return this
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.StringMatch)--- struct representing a variable found in the code


---@class StringUtils
LifeBoatAPI.Tools.StringUtils = {
    --- runs gsub repeatedly until all instances, and instances created by the substitutions, are replaced
    ---  running gsub once, on some strings, may cause a pattern to be formed that itself can be replaced
    ---  for example, replacing 2 spaces with 1 space; needs run multiple times if there were, e.g. 3 spaces in a row.
    ---@param data string string to gsub
    ---@param pattern string pattern to match
    ---@param replacement string replacement to sub into the string
    ---@return string replaced string with all instances of pattern replaced
    subAll = function(data, pattern, replacement)
        local replacedLength = 0
        local replaced = data
        repeat
            replacedLength = #replaced
            replaced = replaced:gsub(pattern, replacement)
        until(#replaced == replacedLength)

        return replaced
    end;

    ---Escapes the given string so it can be used as a pattern, without changing meaning
    ---@param str string string to escape for gsub use
    ---@return string escaped
    escape = function(str)
        return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
    end;

    ---Escapes the given string so it can be used as a sub REPLACEMENT
    ---@param str string string to escape for gsub use
    ---@return string escaped
    escapeSub = function(str)
        return function() return str end
    end;

    ---Counts the occurences of the pattern in the given string
    ---@param str string string to count occurences of the pattern in
    ---@param pattern string pattern to count matches of
    ---@return number matches
    count = function(str, pattern)
        local _, count = str:gsub(pattern, "")
        return count
    end;

    ---Splits a string into substrings based on a given pattern
    ---Separator is removed from the returned items
    ---@param str string string to count occurences of the pattern in
    ---@param separatorPattern string pattern to count matches of
    ---@return string[] matches
    split = function(str, separatorPattern)
        separatorPattern = separatorPattern or "%s"
        local result = {}
        for value in str:gmatch("([^"..separatorPattern.."]+)") do
            LifeBoatAPI.Tools.TableUtils.add(result, value)
        end
        return result
    end;

    ---Improved matching, vs. gmatch, as we get the indices things were found at
    ---Particularly useful for "cheap and dirty" parsing of text files
    ---@overload fun(data: string, pattern:string): StringMatch[]
    ---@param text string text to parse for variables
    ---@param pattern string pattern to search for
    ---@param startIndex number index to start from, default is 1
    ---@return StringMatch[] list of matches with their captures
    find = function(text, pattern, startIndex)
        local found = {}
        local index = startIndex or 1 -- reminder; str:sub(1,1) gets the first character of the string
        local searching = true
        while index < #text and searching do
            local match = LifeBoatAPI.Tools.StringMatch:new(text:find(pattern, index))
            if(match.startIndex) then
                index = match.endIndex
                LifeBoatAPI.Tools.TableUtils.add(found, match)
            else
                searching = false
            end
        end

        return found
    end;
}