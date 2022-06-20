-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.StringUtils")
require("LifeBoatAPI.Tools.Utils.Filepath")
require("LifeBoatAPI.Tools.Utils.FileSystemUtils")
require("LifeBoatAPI.Tools.Build.RedundancyRemover")
require("LifeBoatAPI.Tools.Build.StringCommentsParser")
require("LifeBoatAPI.Tools.Build.VariableShortener")
require("LifeBoatAPI.Tools.Build.GlobalVariableReducer")
require("LifeBoatAPI.Tools.Build.ParsingConstantsLoader")
require("LifeBoatAPI.Tools.Build.NumberLiteralReducer")
require("LifeBoatAPI.Tools.Build.HexadecimalConverter")

---@class MinimizerParams
---@field reduceAllWhitespace   boolean if true, shortens all whitespace duplicates where possible
---@field reduceNewlines        boolean if true, reduces duplicate newlines but not other whitespace
---@field removeRedundancies    boolean if true, removes redundant code sections using the ---@section syntax
---@field shortenVariables      boolean if true, shortens variables down to 1 or 2 character names
---@field shortenGlobals        boolean if true, shortens the sw-global functions, such as screen.drawRect, to e.g. s=screen.drawRect
---@field shortenNumbers        boolean if true, shortens numbers, including removing duplicate number literals and removing leading 0s
---@field forceNCBoilerplate    boolean (recommend false) forces the NC boilerplate to be output, even if it makes the file exceed 4000 characters
---@field forceBoilerplate      boolean (recommend false) forces the user boilerplate to be output, even if it makes the file exceed 4000 characters
---@field removeComments        boolean if true, strips all comments from the output
---@field shortenStringDuplicates boolean if true, reduce duplicate string literals
---@field skipCombinedFileOutput  boolean if true, doesn't output the combined file - to speed up the build process

---@class Minimizer : BaseClass
---@field constants ParsingConstantsLoader list of external, global keywords
---@field params MinimizerParams table of params for turning on/off functionality
LifeBoatAPI.Tools.Minimizer = {
    ---@param cls Minimizer
    ---@param constants ParsingConstantsLoader
    ---@param params MinimizerParams
    ---@return Minimizer
    new = function(cls, constants, params)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.constants = constants

        this.params = params or {}
        this.params.removeComments              = LifeBoatAPI.Tools.DefaultBool(this.params.removeComments,         true)
        this.params.reduceAllWhitespace         = LifeBoatAPI.Tools.DefaultBool(this.params.reduceAllWhitespace,    true)
        this.params.reduceNewlines              = LifeBoatAPI.Tools.DefaultBool(this.params.reduceNewlines,         true)
        this.params.removeRedundancies          = LifeBoatAPI.Tools.DefaultBool(this.params.removeRedundancies,     true)
        this.params.shortenVariables            = LifeBoatAPI.Tools.DefaultBool(this.params.shortenVariables,       true)
        this.params.shortenGlobals              = LifeBoatAPI.Tools.DefaultBool(this.params.shortenGlobals,         true)
        this.params.shortenNumbers              = LifeBoatAPI.Tools.DefaultBool(this.params.shortenNumbers,         true)
        this.params.shortenStringDuplicates     = LifeBoatAPI.Tools.DefaultBool(this.params.shortenStringDuplicates,true)
        this.params.forceNCBoilerplate          = LifeBoatAPI.Tools.DefaultBool(this.params.forceNCBoilerplate,     false)
        this.params.forceBoilerplate            = LifeBoatAPI.Tools.DefaultBool(this.params.forceBoilerplate,       false)   
        this.params.skipCombinedFileOutput      = LifeBoatAPI.Tools.DefaultBool(this.params.skipCombinedFileOutput, false)   

        return this
    end;

    ---Minimizes the content of the given file and saves it to disk
    ---@param outPath Filepath path to save to or nil to save over the original file
    ---@param this Minimizer
    ---@param inPath Filepath
    ---@return string minimized for use in any other purpose
    minimizeFile = function(this, inPath, outPath, boilerplate)
        local text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(inPath)
        local minimized, newsize = this:minimize(text, boilerplate)
        LifeBoatAPI.Tools.FileSystemUtils.writeAllText(outPath, minimized)

        return minimized, newsize
    end;

    ---@param text string text to be minimized
    ---@param this Minimizer
    ---@return string minimized
    minimize = function(this, text, boilerplate)
        boilerplate = boilerplate or ""

        -- insert space at the start prevents issues where the very first character in the file, is part of a variable name
        text = " " .. text .. "\n\n"

        

        -- remove all redundant strings and comments, avoid these confusing the parse
        local parser = LifeBoatAPI.Tools.StringCommentsParser:new(not this.params.removeComments, LifeBoatAPI.Tools.StringReplacer:new(variableRenamer))
        text = parser:removeStringsAndComments(text,
                                                function(i,text)
                                                    return text:sub(i, i+10) == "---@section" or
                                                           text:sub(i, i+13) == "---@endsection"
                                                end)

        -- remove all redudant code sections (will become exponentially slower as the codebase gets bigger)
        if(this.params.removeRedundancies) then
            local remover = LifeBoatAPI.Tools.RedundancyRemover:new()
            text = remover:removeRedundantCode(text)
        end

        -- re-parse to remove all code-section comments now we're done with them
        text = parser:removeStringsAndComments(text)


        -- rename variables so everything is consistent (if creating new globals happens, it's important they have unique names)
        local variableRenamer = LifeBoatAPI.Tools.VariableRenamer:new(this.constants)
        if(this.params.shortenVariables) then
            local shortener = LifeBoatAPI.Tools.VariableShortener:new(variableRenamer, this.constants)
            text = shortener:shortenVariables(text)
        end

        -- final step still todo, replace all external globals if they're used more than once
        if(this.params.shortenGlobals) then
            local globalShortener = LifeBoatAPI.Tools.GlobalVariableReducer:new(variableRenamer, this.constants)
            text = globalShortener:shortenGlobals(text)
        end

        -- fix hexadecimals
        local hexadecimalFixer = LifeBoatAPI.Tools.HexadecimalConverter:new()
        text = hexadecimalFixer:fixHexademicals(text)

        -- reduce numbers
        if(this.params.shortenNumbers) then
            local numberShortener = LifeBoatAPI.Tools.NumberLiteralReducer:new(variableRenamer)
            text = numberShortener:shortenNumbers(text)
        end


        -- rename variables as short as we can get (second pass)
        -- New renamer, so everything gets a new name again - now we can do it regarding frequency of use
        if(this.params.shortenVariables) then
            local shortener = LifeBoatAPI.Tools.VariableShortener:new(LifeBoatAPI.Tools.VariableRenamer:new(this.constants), this.constants)
            text = shortener:shortenVariables(text)
        end


        -- remove all unnecessary whitespace, etc. (a real minifier will do a better job, but this gets close enough for us)
        if(this.params.reduceNewlines) then
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "\n%s*\n%s*\n", "\n\n") -- remove empty lines
        end

        if(this.params.reduceAllWhitespace) then
            text = this:_reduceWhitespace(text)
        end

        -- repopulate the original string data now it's safe
        text = parser:repopulateStrings(text, this.params.shortenStringDuplicates)

        local sizeWithoutBoilerplate = #text

        local nameousBoilerplateSize = 233 + #tostring(sizeWithoutBoilerplate) + #tostring(#text)
        local predictedBoilerplateSize = ((this.params.forceNCBoilerplate or (#text + #boilerplate + nameousBoilerplateSize < 4000)) and nameousBoilerplateSize + #boilerplate) 
                                       or ((this.params.forceBoilerplate or (#text + #boilerplate < 4000)) and #boilerplate)
                                       or 0

        -- add boilerplate if the file is small enough
        -- please do not remove this, the user's boilerplate has precedence over the nameous changey one
        -- but if your resulting file has space - it is polite to include this; a significant effort went into making the minimizer
        local nameousBoilerplate =
[[-- Developed & Minimized using LifeBoatAPI - Stormworks Lua plugin for VSCode
-- https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--      By Nameous Changey]]
.. "\n-- Minimized Size: " .. tostring(sizeWithoutBoilerplate) .. " (" .. tostring(sizeWithoutBoilerplate + predictedBoilerplateSize) ..  " with comment) chars"

        local addedSpacing = not this.params.removeComments and "\n\n" or ""
        -- add boilerplate if the file is small enough (4000 chars instead of 4096, gives some slight wiggle room)
        if(this.params.forceNCBoilerplate or (#text + #boilerplate + #nameousBoilerplate < 4000)) then
            text = boilerplate .. "--\n" .. nameousBoilerplate .. "\n" .. addedSpacing .. text
        elseif(this.params.forceBoilerplate or #text + #boilerplate < 4000) then
            text = boilerplate .. "\n" .. addedSpacing .. text
        end

        return text, sizeWithoutBoilerplate
    end;

    ---@param this Minimizer
    ---@param text string text to minimize
    ---@return string text
    _reduceWhitespace = function(this, text)
         -- remove duplicate spacing
        text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s%s", "\n")
        
        -- remove whitespace around certain operators
        local characters = {
            "=", ",", ">", "<",
            "+", "-", "*", "/", "%",
            "{", "}", "(", ")", "[", "]",
            "^", "|", "~", "#",
            ".."
        }
        for _, character in ipairs(characters) do
            text = this:_reduceWhitespaceCharacter(text, character)
        end

        -- ,} ;} -> }
        text = LifeBoatAPI.Tools.StringUtils.subAll(text, "[,;]}", "}")
        return text
    end;

    ---@param this Minimizer
    ---@param text string text to minimize
    ---@param character string character/operator to remove space around
    ---@return string text
    _reduceWhitespaceCharacter = function (this, text, character)
        return LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*"..LifeBoatAPI.Tools.StringUtils.escape(character) .."%s*", LifeBoatAPI.Tools.StringUtils.escapeSub(character))
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Minimizer)