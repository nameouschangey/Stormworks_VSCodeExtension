-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Missions.Utils.LBBase")
require("LifeBoatAPI.Missions.Utils.LBStringBuilder")
require("LifeBoatAPI.Tools.Minimizer.LBStringReplacer")

---@class LBStringCommentsParser : LBBaseClass
---@field stringReplacer LBStringReplacer replacer to use for this parse
LBStringCommentsParser = {

    ---@overload fun():LBStringCommentsParser
    ---@param cls LBStringCommentsParser
    ---@param replacer LBStringReplacer
    ---@return LBStringCommentsParser
    new = function(cls, replacer)
        local this = LBBaseClass.new(cls)
        this.stringReplacer = replacer or LBStringReplacer:new()
        return this
    end;

    ---Goes through the data of a code file, and removes all comments and replaces all strings with constants
    ---This allows for safe working on the file without destroying string data which may contain code-like phrases
    ---Strings can be re-added later using gsub, or another parse
    ---Comments are discarded as this is designed for use in a Minimizer
    ---@param this LBStringCommentsParser
    ---@param text string text to parse
    ---@param commentException fun(i:number, text:string):boolean exceptions function, that allows certain comments to remain - for other build tool purposes. (bodge)
    ---@return string text without the strings and comments
    removeStringsAndComments = function(this, text, commentException)
        local outputString = LBStringBuilder:new()
        local currentString = LBStringBuilder:new()

        local isInComment = false
        local isInQuote = false
        local quoteType = nil
        local cSlashCount = 0
        local cUnescapedSlash = false
        local isInCommentQuote = false -- not this will always be alongside isInComment = true

        for i = 1, #text, 1 do
            local cLast = text:sub(i-1, i-1)
            local c     = text:sub(i,i)
            local cNext = text:sub(i+1,i+1)

            cSlashCount = (cLast == "\\" and cSlashCount + 1) or 0
            cUnescapedSlash = cSlashCount%2 ~= 0

            if (not isInComment and not isInQuote) then
                if (cLast ~= '-' and c == '-' and cNext == '-' and not (commentException and commentException(i,text))) then
                    isInComment = true
                    if(text:sub(i,i+3) == "--[[") then
                        isInCommentQuote = true    
                    end
                elseif ((not cUnescapedSlash and (c == '"' or c=="'")) or (c=="[" and cNext == "[")) then
                    quoteType = c
                    isInQuote = true
                    currentString = LBStringBuilder:new(c)
                else
                    outputString:add(c)
                end
            elseif (not isInComment and isInQuote) then
                if((not cUnescapedSlash and c == quoteType and quoteType ~= "[") or (quoteType=="[" and cLast=="]" and c == "]")) then
                    currentString:add(c)
                    isInQuote = false
                    local replacement = this.stringReplacer:getStringReplacement(currentString:getString())
                    outputString:add(replacement)
                else
                    currentString:add(c)
                end
            elseif(isInComment and isInCommentQuote and c== "]" and cLast == "]") then
                isInComment = false
                isInCommentQuote = false
            elseif (isInComment and not isInCommentQuote and c == "\n") then
                isInComment = false
                outputString:add("\n")
            end
        end

        return outputString:getString()
    end;

    ---@param this LBStringCommentsParser
    ---@return string
    repopulateStrings = function(this, text)
        return this.stringReplacer:repopuplateStrings(text)
    end;
};

LBClass(LBStringCommentsParser);

