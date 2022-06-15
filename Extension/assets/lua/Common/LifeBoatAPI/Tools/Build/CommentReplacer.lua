-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Utils.TableUtils")
require("LifeBoatAPI.Tools.Utils.StringUtils")

---@class CommentReplacer : BaseClass
---@field replacements table[]
---@field count number
LifeBoatAPI.Tools.CommentReplacer = {

    ---@return CommentReplacer
    new = function(cls)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.count = 1
        this.replacements = {}
        return this
    end;

    ---@param this CommentReplacer
    ---@param stringValue string value to replace with a constant, including the surrounding quotes
    ---@return string replacement constant
    getCommentReplacement = function(this, stringValue)
        this.count = this.count + 1
        local replacement =  string.format("COMMENT%07dREPLACEMENT", this.count)
        this.replacements[#this.replacements + 1] = {original = stringValue, replacement = replacement}
        return replacement
    end;

    ---@param this CommentReplacer
    ---@param text string text that was previously stripped of strings
    ---@return string text with original strings repopulated
    repopuplateComments = function(this, text)
        for _,v in ipairs(this.replacements) do
            -- direct sub if there's only 1 of the string
            text  = text:gsub(v.replacement, LifeBoatAPI.Tools.StringUtils.escapeSub(v.original))
        end
        return text
    end;
};

LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.StringReplacer);

