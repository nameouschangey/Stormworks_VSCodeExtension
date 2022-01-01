-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Tools.Utils.StringUtils")
require("LifeBoatAPI.Tools.Utils.Filepath")
require("LifeBoatAPI.Tools.Utils.FileSystemUtils")
require("LifeBoatAPI.Tools.Build.RedundancyRemover")
require("LifeBoatAPI.Tools.Build.StringCommentsParser")
require("LifeBoatAPI.Tools.Build.VariableShortener")
require("LifeBoatAPI.Tools.Build.GlobalVariableReducer")
require("LifeBoatAPI.Tools.Build.ParsingConstantsLoader")
require("LifeBoatAPI.Tools.Build.NumberLiteralReducer")

---@class MinimizerParams
---@field reduceAllWhitespace   boolean
---@field reduceNewlines        boolean
---@field removeRedundancies    boolean
---@field shortenVariables      boolean
---@field shortenGlobals        boolean
---@field shortenNumbers        boolean
---@field forceNCBoilerplate    boolean
---@field forceBoilerplate      boolean


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
        this.params.reduceAllWhitespace         = LifeBoatAPI.Tools.DefaultBool(this.params.reduceAllWhitespace) 
        this.params.reduceNewlines              = LifeBoatAPI.Tools.DefaultBool(this.params.reduceNewlines)
        this.params.removeRedundancies          = LifeBoatAPI.Tools.DefaultBool(this.params.removeRedundancies)
        this.params.shortenVariables            = LifeBoatAPI.Tools.DefaultBool(this.params.shortenVariables)
        this.params.shortenGlobals              = LifeBoatAPI.Tools.DefaultBool(this.params.shortenGlobals)
        this.params.shortenNumbers              = LifeBoatAPI.Tools.DefaultBool(this.params.shortenNumbers)
        this.params.forceNCBoilerplate          = LifeBoatAPI.Tools.DefaultBool(this.params.forceNCBoilerplate, false)
        this.params.forceBoilerplate            = LifeBoatAPI.Tools.DefaultBool(this.params.forceBoilerplate, false)   

        return this
    end;

    ---Minimizes the content of the given file and saves it to disk
    ---@param outPath Filepath path to save to or nil to save over the original file
    ---@param this Minimizer
    ---@param filepath Filepath
    ---@return string minimized for use in any other purpose
    minimizeFile = function(this, filepath, outPath, boilerplate)
        outPath = outPath or filepath
        local text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(filepath)
        local minimized, originalLength, newLength = this:minimize(text, boilerplate)
        LifeBoatAPI.Tools.FileSystemUtils.writeAllText(outPath, minimized)

        return minimized, originalLength, newLength
    end;

    ---@param text string text to be minimized
    ---@param this Minimizer
    ---@return string minimized
    minimize = function(this, text, boilerplate)
        boilerplate = boilerplate or ""
        local originalLength = #text
        -- insert space at the start prevents issues where the very first character in the file, is part of a variable name
        text = " " .. text .. "\n\n"

        
        local variableRenamer = LifeBoatAPI.Tools.VariableRenamer:new(this.constants)

        -- remove all redundant strings and comments, avoid these confusing the parse
        local parser = LifeBoatAPI.Tools.StringCommentsParser:new(LifeBoatAPI.Tools.StringReplacer:new(variableRenamer))
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

        -- rename variables as short as we can get
        if(this.params.shortenVariables) then
            local shortener = LifeBoatAPI.Tools.VariableShortener:new(variableRenamer, this.constants)
            text = shortener:shortenVariables(text)
        end

        -- final step still todo, replace all external globals if they're used more than once
        if(this.params.shortenGlobals) then
            local globalShortener = LifeBoatAPI.Tools.GlobalVariableReducer:new(variableRenamer, this.constants)
            text = globalShortener:shortenGlobals(text)
        end

        -- reduce numbers
        if(this.params.shortenNumbers) then
            local numberShortener = LifeBoatAPI.Tools.NumberLiteralReducer:new(variableRenamer)
            text = numberShortener:shortenNumbers(text)
        end

        -- remove all unnecessary whitespace, etc. (a real minifier will do a better job, but this gets close enough for us)
        if(this.params.reduceNewlines) then
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "\n\n", "\n") -- remove duplicate newlines
        end

        if(this.params.reduceAllWhitespace) then
            text = this:_reduceWhitespace(text)
        end

        -- repopulate the original string data now it's safe
        text = parser:repopulateStrings(text)

        -- add boilerplate if the file is small enough
        -- please do not remove this, the user's boilerplate has precedence over the nameous changey one
        -- but if your resulting file has space - it is polite to include this; a significant effort went into making the minimizer
        local newLength = #text
        local nameousBoilerplate =
[[-- Developed & Minimized using LifeBoatAPI - Stormworks Lua plugin for VSCode
-- https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--      By Nameous Changey]]
.. "\n-- Originally: " .. tostring(originalLength) .. " chars, Reduced to: " .. tostring(newLength) .. " chars"

        -- add boilerplate if the file is small enough (4000 chars instead of 4096, gives some slight wiggle room)
        if(this.params.forceNCBoilerplate or (#text + #boilerplate + #nameousBoilerplate < 4000)) then
            text = boilerplate .. "--\n" .. nameousBoilerplate .. "\n" .. text
        elseif(this.params.forceBoilerplate or #text + #boilerplate < 4000) then
            text = boilerplate .. "\n" .. text
        end

        return text, originalLength, newLength
    end;

    ---@param this Minimizer
    ---@param text string text to minimize
    ---@return string text
    _reduceWhitespace = function(this, text)
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s%s", "\n") -- remove duplicate spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*,%s*", ",")  -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*=%s*", "=")  -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*>%s*", ">")  -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*<%s*", "<")  -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*+%s*", "+")  -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*-%s*", "-")  -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*%*%s*", "*") -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*%/%s*", "/") -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*%{%s*", "{") -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*%}%s*", "}") -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*%(%s*", "(") -- remove unnecessary spacing
            text = LifeBoatAPI.Tools.StringUtils.subAll(text, "%s*%)%s*", ")") -- remove unnecessary spacing
            return text
    end
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Minimizer)