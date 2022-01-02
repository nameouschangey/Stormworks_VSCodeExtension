-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

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
        local replacement = "COMMENT" .. string.format("%07d", this.count) .. "REPLACEMENT"
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

