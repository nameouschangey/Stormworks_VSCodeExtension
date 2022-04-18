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
            result[#result + 1] = value
        end
        return result
    end;

    find = function(text, pattern, startIndex, startOffset, endOffset)
        startOffset = 0
        endOffset = 0
        local found = {}
        local index = startIndex or 1 -- reminder; str:sub(1,1) gets the first character of the string
        local searching = true
        while index <= #text and searching do
            local match = LifeBoatAPI.Tools.StringMatch:new(text:find(pattern, index))
            if(match.startIndex) then
                match.startIndex = match.startIndex + startOffset
                index = match.endIndex + 1 + endOffset
                found[#found+1] = match
            else
                searching = false
            end
        end

        return found
    end;

    ---The index specified (e.g. startIndex) is the FIRST character to be replaced, vice versa for endIndex
    ---That is: text[startIndex] and text[endIndex] are both going to be replaced
    ---"hello world", start=1, end=3 -> "xxxlo world"
    ---@return string
    replaceIndex = function(text, startIndex, endIndex, replacement)
        local textBefore = text:sub(1,startIndex-1)
        local textAfter = text:sub(endIndex+1)
        return textBefore .. (replacement or "") .. textAfter
    end;

    ---@return string
    getNextOccurenceOf = function(text, startIndex, step, ...)
        local characters = {...}
        local endIndex = step > 0 and #text or 1

        for i=startIndex, endIndex, step do
            local c = text[i]
            for charIndex=1,#characters do
                if characters[charIndex] == c then
                    return i
                end
            end
        end

        -- not found 
        return nil
    end;

    --- Whether the two sections match
    ---@return boolean
    nextSectionIs = function(text, i, pattern)
        local startIndex, endIndex, captures = text:find(pattern, i)
        return startIndex == i
    end;
    
    --- Whether the two sections match
    ---@return boolean
    nextSectionEquals = function(text, i, str)
        for istr=1, #str do
            local char = str:sub(istr,istr)
            if char ~= text:sub(i+istr-1,i+istr-1) then
                return false
            end
        end
        return true
    end;

    ---@return number, string
    getTextIncluding = function(text, searchStart, ...)
        local patterns = {...}
    
        local shortestIndex = #text
        for i=1,#patterns do
            local pattern = patterns[i]
            local startIndex, endIndex, captures = text:find(pattern, searchStart)
            if endIndex and endIndex < shortestIndex then
                shortestIndex = endIndex
            end
        end
    
        return shortestIndex+1, text:sub(searchStart, shortestIndex)
    end;
    
    ---@return number, string
    getTextUntil = function(text, searchStart, ...)
        local patterns = {...}
    
        local shortestIndex = #text+1
        for i=1,#patterns do
            local pattern = patterns[i]
            if type(pattern) == "table" then
                local startIndex, endIndex, captures = text:find(pattern.p, searchStart)
                if startIndex and (startIndex + pattern.o) < shortestIndex then
                    shortestIndex = (startIndex + pattern.o)
                end
            else
                local startIndex, endIndex, captures = text:find(pattern, searchStart)
                if startIndex and (startIndex) < shortestIndex then
                    shortestIndex = (startIndex)
                end
            end
        end
    
        return shortestIndex, text:sub(searchStart, shortestIndex-1)
    end;
}