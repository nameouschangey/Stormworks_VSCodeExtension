
---@class LBToken
LBToken = {
    new = function(this, type, raw)
        this = LifeBoatAPI.Tools.BaseClass.new(this)
        this.type = type
        this.raw = raw
        return this
    end;
}

LBTokenTypes = {
    STRING = "string",
    KEYWORD = "keyword",
    LBTAG = "lbtag",
    COMMENT = "comment",
    OPENBRACKET = "openbracket",
    CLOSEBRACKET = "closebracket",
    COMMA = "comma",
    SEMICOLON = "semicolon",
    COMPARISON = "comparison",
    CONCAT = "concat",
    ASSIGNMENT = "assignment",
    ACCESSOR = "accessor",
    MATHOP = "mathop",
    IDENTIFIER = "identifier",
    TYPECONSTANT = "typeconstant",
    NUMBER = "number",
    HEX = "hex",
    WHITESPACE = "whitespace",
}

_keywords = {
    ["and"]     = 1 ,["break"] = 1 ,["do"]       = 1 ,["else"]  = 1 ,["elseif"] = 1
    ,["end"]    = 1 ,["for"]   = 1 ,["function"] = 1 ,["goto"]  = 1 ,["if"]     = 1
    ,["in"]     = 1 ,["local"] = 1 ,["not"]      = 1 ,["or"]    = 1 ,["repeat"] = 1
    ,["return"] = 1 ,["then"]  = 1 ,["until"]    = 1 ,["while"] = 1
};
_isKeyword = function(text)
    return _keywords[text]
end;

_typeconstants = {
    ["nil"] = 1, ["true"] = 1, ["false"] = 1
};
_isTypeConstant = function(text)
    return _typeconstants[text]
end;


---@param text string
---@return LBToken[]
function tokenize(text)
    local this = LifeBoatAPI.Tools.LuaParser
    local LBStr = LifeBoatAPI.Tools.StringUtils

    local tokens = {}
    local nextToken = ""

    --lex
    local iText = 1 
    while iText <= #text do
        if LBStr.nextSectionIs(text, iText, '"') then
            -- quote (")
            iText, nextToken = LBStr.getTextIncluding(text, iText, '[^\\]"')
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.STRING, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "'") then
            -- quote (')
            iText, nextToken = LBStr.getTextIncluding(text, iText, "[^\\]'")
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.STRING, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%[%[") then
            -- quote ([[ ]])
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%]%]")
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.STRING, nextToken)  

        elseif LBStr.nextSectionIs(text, iText, "%-%-%-@lb") then
            -- preprocessor tag
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%-%-%-@lb")
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.LBTAG, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%-%-%[%[") then
            -- multi-line comment
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%]%]")
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.COMMENT, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%-%-") then
            -- single-line comment
            iText, nextToken = LBStr.getTextUntil(text, iText, "\n")
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.COMMENT, nextToken)

        elseif LBStr.nextSectionIs(text, iText, ";") then
            -- single-line comment
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.SEMICOLON, nextToken)

        elseif LBStr.nextSectionIs(text, iText, ",") then
            -- single-line comment
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.COMMA, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[%(%[%{]") then
            -- regular brackets
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.OPENBRACKET, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[%)%]%}]") then
            -- regular brackets
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.CLOSEBRACKET, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "//") then
            -- floor (one math op not two)
            iText, nextToken = iText+1, text:sub(iText, iText+1)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.MATHOP, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[%*/%+%-%%]") then
            -- all other math ops
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.MATHOP, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%.%.%.") then
            -- varargs
            iText, nextToken = iText+3, text:sub(iText, iText+2)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.VARARGS, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%.%.") then
            -- concat
            iText, nextToken = iText+2, text:sub(iText, iText+1)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.CONCAT, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[><=~]=") then
            -- comparison
            iText, nextToken = iText+2, text:sub(iText, iText+1)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.COMPARISON, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[><]") then
            -- comparison
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.COMPARISON, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "=") then
            -- assignment
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.ASSIGNMENT, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[%a_][%w_]*") then
            -- keywords & identifier
            iText, nextToken = LBStr.getTextIncluding(text, iText, "[%a_][%w_]*")
            if _isKeyword(nextToken) then
                tokens[#tokens+1] = LBToken:new(LBTokenTypes.KEYWORD, nextToken)
            elseif _isTypeConstant(nextToken) then
                tokens[#tokens+1] = LBToken:new(LBTokenTypes.TYPECONSTANT, nextToken)
            else
                tokens[#tokens+1] = LBToken:new(LBTokenTypes.IDENTIFIER, nextToken)
            end

        elseif LBStr.nextSectionIs(text, iText, "%s+") then
            -- whitespace
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%s*")
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.WHITESPACE, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "0x%x+") then
            -- hex 
            iText, nextToken = LBStr.getTextIncluding(text, iText, "0x%x+")
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.HEX, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%x*%.?%x+") then 
            -- number
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%x*%.?%x+")
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.NUMBER, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[%.:]") then
            -- chain access
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBToken:new(LBTokenTypes.ACCESSOR, nextToken)

        else
            -- regular/lua text
            iText, nextToken = LBStr.getTextUntil(text, iText, 
            "=", "[><=~]=",
            "[%*/%+%-%%]",
            "[%(%{%[]",
            "[%.:]",
            "%x*%.?%x+", "0x%x+",
            "%s+",
            "[%a_][%w_]*",
            "%-%-",
            '"', "'",
            "%[%[")
            error("unexpected text " .. nextToken .. " at " .. iText)
            --tokens[#tokens+1] = LBTree:new(LBTypes.lua, nextToken)
        end
    end

    return tokens
end;


---@return string
toString = function(tokens)
    local result = {}
    for i=1,#tokens do
        result[#result+1] = tokens[i].raw
    end
    return table.concat(result)
end;


text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]))

local tokensList = tokenize(text)
LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\gen1.lua]]),
    toString(tokensList)
)




__simulator:exit()