require("Parsing.utils")

---@class LBToken
---@field type string
---@field raw string
---@field lineInfo LBLineInfo
LBToken = {
    new = function(this, type, raw, lineinfo)
        return {
            type = type,
            raw = raw,
            lineInfo = lineinfo or {line=-1,column=-1,index=-1}
        }
    end;
}

LBTokenTypes = {
    COMMENT         = "COMMENT",
    WHITESPACE      = "WHITESPACE",

    STRING          = "STRING",
    FALSE           = "FALSE",
    TRUE            = "TRUE",
    NIL             = "NIL",
    NUMBER          = "NUMBER",
    HEX             = "HEX",
    
    OPENBRACKET     = "OPENBRACKET",
    CLOSEBRACKET    = "CLOSEBRACKET",

    OPENSQUARE      = "OPENSQUARE",
    CLOSESQUARE     = "CLOSESQUARE",

    OPENCURLY       = "OPENCURLY",
    CLOSECURLY      = "CLOSECURLY",

    COMMA           = "COMMA",
    SEMICOLON       = "SEMICOLON",

    BINARY_OP       = "BINARY_OP",
    MIXED_OP        = "MIXED_OP",
    UNARY_OP        = "UNARY_OP",

    LOCAL           = "LOCAL",
    IDENTIFIER      = "IDENTIFIER",

    ASSIGN          = "ASSIGN",
    DOTACCESS       = "DOTACCESS",
    COLONACCESS     = "COLONACCESS",

    VARARGS         = "VARARGS",

    DO              = "DO",
    REPEAT          = "REPEAT",
    UNTIL           = "UNTIL",
    WHILE           = "WHILE",

    FOR             = "FOR",
    IN              = "IN",

    IF              = "IF",
    THEN            = "THEN",
    ELSEIF          = "ELSEIF",
    ELSE            = "ELSE",

    FUNCTION        = "FUNCTION",

    END             = "END",
    
    AND             = "AND",
    NOT             = "NOT",
    OR              = "OR",

    BREAK           = "BREAK",
    RETURN          = "RETURN",

    GOTO            = "GOTO",
    GOTOMARKER      = "GOTO_LABEL",

    EOF             = "EOF",
    LBTAG_START     = "LBTAG_START",
}

local T = LBTokenTypes


local LBKeywords = {
    ["false"]           = LBTokenTypes.FALSE,
    ["true"]            = LBTokenTypes.TRUE,
    ["nil"]             = LBTokenTypes.NIL,

    ["local"]           = LBTokenTypes.LOCAL,

    ["and"]             = LBTokenTypes.AND,
    ["not"]             = LBTokenTypes.NOT,
    ["or"]              = LBTokenTypes.OR,

    ["function"]        = LBTokenTypes.FUNCTION,
    ["goto"]            = LBTokenTypes.GOTO,

    ["if"]              = LBTokenTypes.IF,
    ["then"]            = LBTokenTypes.THEN,
    ["elseif"]          = LBTokenTypes.ELSEIF,
    ["else"]            = LBTokenTypes.ELSE,

    ["repeat"]          = LBTokenTypes.REPEAT,
    ["until"]           = LBTokenTypes.UNTIL,
    ["while"]           = LBTokenTypes.WHILE,
    ["for"]             = LBTokenTypes.FOR,
    ["in"]              = LBTokenTypes.IN,
    ["do"]              = LBTokenTypes.DO,
    ["end"]             = LBTokenTypes.END,

    ["break"]           = LBTokenTypes.BREAK,
    ["return"]          = LBTokenTypes.RETURN,
}

local tokenizekeyword = function(keyword)
    return LBKeywords[keyword]
end;

local getString = function(lineInfo, text, iText, ending)
    local start = iText
    iText = iText + 1
    while iText <= #text do
        local char = text:sub(iText,iText)
        if char == "\\" then
            iText = iText + 2
        elseif char == ending then
            return iText+1, text:sub(start, iText)
        else
            iText = iText + 1
        end
    end

    error(lineInfo:toString() .. "\nIncomplete string, starting at: " .. iText .. ": \n " .. text:sub(start) )
end;

local associateRightWhitespaceAndComments = function(tokens)
    local result = {}
    local leadingWhitespace = {}
    for itokens=1, #tokens do
        if is(tokens[itokens].type, T.WHITESPACE, T.COMMENT) then
            leadingWhitespace[#leadingWhitespace+1] = tokens[itokens]
        else
            local token = tokens[itokens]
            result[#result+1] = token
            for ileadingWhitespace=1, #leadingWhitespace do
                token[#token+1] = leadingWhitespace[ileadingWhitespace]
            end
            leadingWhitespace = {}
        end
    end

    -- add any trailing whitespace to the EOF marker
    local eofToken = tokens[#tokens]
    if #leadingWhitespace > 0 then
        for ileadingWhitespace=1, #leadingWhitespace do
            eofToken[#eofToken+1] = leadingWhitespace[ileadingWhitespace]
        end
    end
    return result
end;

---@param text string
---@return LBToken[]
tokenize = function(text)
    local LBStr = LifeBoatAPI.Tools.StringUtils
    local nextSectionEquals = LBStr.nextSectionEquals
    local nextSectionIs = LBStr.nextSectionIs

    --performance lookups
    local lookup_digit = set("1","2","3","4","5","6","7","8","9","0",".")
    local lookup_alpha = set("_", "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                                  "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
    local lookup_math  = set("*","/","+","%","^","&","|")
    local lookup_ws    = set(" ", "\n", "\r", "\t")

    local tokens = {}
    local nextToken = ""

    local lineNumber = 1
    local lastLineStartIndex = 1
    local iText = 1

    local getLineInfo = function()
        ---@class LBLineInfo
        ---@field line number
        ---@field index number
        ---@field column number
        local lineInfo = {
            line = lineNumber,
            index = iText,
            column = 1 + iText - lastLineStartIndex,
            toString = function(this)
                return string.format("line: %d, column: %d, index: %d", this.line, this.column, this.index)
            end
        };
        return lineInfo
    end;

    while iText <= #text do
        local lineInfo = getLineInfo()
        local startIndex = iText
        local nextChar = text:sub(iText,iText)
        local next2Char = text:sub(iText,iText+1)
        
        if nextChar == '"' then
            -- quote (")
            iText, nextToken = getString(lineInfo, text, iText, '"')
            tokens[#tokens+1] = LBToken:new(T.STRING, nextToken)

        elseif nextChar == "'" then
            -- quote (')
            iText, nextToken = getString(lineInfo, text, iText, "'")
            tokens[#tokens+1] = LBToken:new(T.STRING, nextToken)

        elseif (next2Char == "[[" or next2Char == "[=") and nextSectionIs(text, iText, "%[=-%[") then
            -- quote ([[ ]])
            -- annoying syntax thing they added [====[ comment ]====] with same number of equals on either side
            local numEquals = 0
            local closingPattern = {"%]"}
            while text:sub(iText+3+numEquals,iText+3+numEquals) == '=' do
                numEquals = numEquals + 1
                closingPattern[#closingPattern+1] = "="
            end
            closingPattern[#closingPattern+1] = "%]"
            iText, nextToken = LBStr.getTextIncluding(text, iText, table.concat(closingPattern))
            tokens[#tokens+1] = LBToken:new(T.STRING, nextToken)  

        elseif nextSectionEquals(text, iText, "---@lb") then
            -- preprocessor tag
            iText, nextToken = iText+6, text:sub(iText, iText+5)
            tokens[#tokens+1] = LBToken:new(T.LBTAG_START, nextToken)

        elseif nextSectionEquals(text, iText, "--[") and nextSectionIs(text, iText, "%-%-%[=-%[") then
            -- multi-line comment
            -- annoying syntax thing they added [====[ comment ]====] with same number of equals on either side
            local numEquals = 0
            local closingPattern = {"%]"}
            while text:sub(iText+3+numEquals,iText+3+numEquals) == '=' do
                numEquals = numEquals + 1
                closingPattern[#closingPattern+1] = "="
            end
            closingPattern[#closingPattern+1] = "%]"

            iText, nextToken = LBStr.getTextIncluding(text, iText, table.concat(closingPattern))
            tokens[#tokens+1] = LBToken:new(T.COMMENT, nextToken)

        elseif next2Char == "--" then
            -- single-line comment
            iText, nextToken = LBStr.getTextUntil(text, iText, "\n")
            tokens[#tokens+1] = LBToken:new(T.COMMENT, nextToken)

        elseif nextChar == ";" then
            -- single-line comment
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.SEMICOLON, nextToken)

        elseif nextChar == "," then
            -- single-line comment
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.COMMA, nextToken)


        elseif nextChar == "(" then
            -- regular brackets
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.OPENBRACKET, nextToken)

        elseif nextChar == "[" then
            -- regular brackets
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.OPENSQUARE, nextToken)

        elseif nextChar == "{" then
            -- regular brackets
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.OPENCURLY, nextToken)


        elseif nextChar == ")" then
            -- regular brackets
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.CLOSEBRACKET, nextToken)

        elseif nextChar == "]" then
            -- regular brackets
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.CLOSESQUARE, nextToken)

        elseif nextChar == "}" then
            -- regular brackets
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBToken:new(T.CLOSECURLY, nextToken)

        elseif next2Char == ">>" or next2Char == "<<" then
            -- comparison
            iText, nextToken = iText+2, next2Char
            tokens[#tokens+1] = LBToken:new(T.BINARY_OP, nextToken)

        elseif next2Char == ">=" or next2Char == "<=" or next2Char == "~=" or next2Char == "==" then
            -- comparison
            iText, nextToken = iText+2, next2Char
            tokens[#tokens+1] = LBToken:new(T.BINARY_OP, nextToken)

        elseif nextChar == ">" or nextChar == "<" then
            -- comparison
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.BINARY_OP, nextToken)

        elseif next2Char == "//" then
            -- floor (one math op not two)
            iText, nextToken = iText+2, next2Char
            tokens[#tokens+1] = LBToken:new(T.BINARY_OP, nextToken)

        elseif nextChar == "#" then
            -- all other math ops
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.UNARY_OP, nextToken)
        
        elseif nextChar == "~" or nextChar == "-" then
            -- all other math ops
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.MIXED_OP, nextToken)

        elseif lookup_math[nextChar] then
            -- all other math ops
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.BINARY_OP, nextToken)


        elseif nextSectionEquals(text, iText, "...") then
            -- varargs
            iText, nextToken = iText+3, text:sub(iText, iText+2)
            tokens[#tokens+1] = LBToken:new(T.VARARGS, nextToken)

        elseif next2Char == ".." then
            -- concat
            iText, nextToken = iText+2, next2Char
            tokens[#tokens+1] = LBToken:new(T.BINARY_OP, nextToken)

        elseif nextChar == "=" then
            -- assignment
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.ASSIGN, nextToken)

        elseif lookup_alpha[nextChar] then
            -- keywords & identifier
            iText, nextToken = LBStr.getTextIncluding(text, iText, "[%a_][%w_]*")
            local keyword = tokenizekeyword(nextToken)
            if keyword then
                tokens[#tokens+1] = LBToken:new(keyword, nextToken)
            else
                tokens[#tokens+1] = LBToken:new(T.IDENTIFIER, nextToken)
            end

        elseif lookup_ws[nextChar] then --nextSectionIs(text, iText, "%s") then
            -- whitespace
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%s*")
            tokens[#tokens+1] = LBToken:new(T.WHITESPACE, nextToken)

        elseif next2Char == "0x" and nextSectionIs(text, iText, "0x%x+") then
            -- hex 
            iText, nextToken = LBStr.getTextIncluding(text, iText, "0x%x+")
            tokens[#tokens+1] = LBToken:new(T.HEX, nextToken)

        elseif lookup_digit[nextChar] and nextSectionIs(text, iText, "%d*%.?%d+") then 
            -- number
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%d*%.?%d+")
            tokens[#tokens+1] = LBToken:new(T.NUMBER, nextToken)

        elseif nextChar == "." then
            -- chain access
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.DOTACCESS, nextToken)

        elseif next2Char == "::" then
            -- chain access
            iText, nextToken = iText+1, next2Char
            tokens[#tokens+1] = LBToken:new(T.GOTOMARKER, nextToken)

        elseif nextChar == ":" then
            -- chain access
            iText, nextToken = iText+1, nextChar
            tokens[#tokens+1] = LBToken:new(T.COLONACCESS, nextToken)

        else
            error(lineInfo:toString() .. "\nCan't process symbol \"" .. text:sub(iText, iText+10) .. "...\"\n\n\"" .. text:sub(math.max(0, iText-20), iText+20) .. "...\"")
        end
        tokens[#tokens].lineInfo = lineInfo

        -- update line info
        local newLines = LBStr.find(nextToken, "\n")
        if #newLines > 0 then
            lineNumber = lineNumber + #newLines
            lastLineStartIndex = startIndex + newLines[#newLines].endIndex
        end
    end

    -- insert StartOfFile and EndOfFile tokens for whitespace association
    --  need to find first non-whitespace/non-comment node
    local i = 1
    while i <= #tokens do
        if not is(tokens[i].type, T.WHITESPACE, T.COMMENT) then
            break;
        end
        i=i+1
    end
    -- add the EOF marker
    tokens[#tokens+1] = LBToken:new(T.EOF, nil, getLineInfo())

    return associateRightWhitespaceAndComments(tokens)
end;