---@class LBSymbol
---@field type string
---@field raw string
LBSymbol = {
    new = function(this, type, raw)
        this = LifeBoatAPI.Tools.BaseClass.new(this)
        this.type = type
        this.raw = raw
        return this
    end;

    fromToken = function(this, token)
        return LBSymbol:new(token.type, token.raw)
    end;
}

--- takes either a list of params, of a table in arg1
set = function(...)
    local args = {...}
    args = type(args[1]) == "table" and args[1] or args 

    local result = {}
    for i=1,#args do
        result[args[i]] = true
    end
    return result
end;



LBTokenTypes = {
    STRING          = "STRING",
    LBTAG           = "LBTAG",
    COMMENT         = "COMMENT",
    OPENBRACKET     = "OPENBRACKET",
    CLOSEBRACKET    = "CLOSEBRACKET",
    OPENSQUARE      = "OPENSQUARE",
    CLOSESQUARE     = "CLOSESQUARE",
    OPENCURLY       = "OPENCURLY",
    CLOSECURLY      = "CLOSECURLY",
    COMMA           = "COMMA",
    SEMICOLON       = "SEMICOLON",
    COMPARISON      = "COMPARISON",
    CONCAT          = "CONCAT",
    ASSIGNMENT      = "ASSIGNMENT",
    ACCESSOR        = "ACCESSOR",
    MATHOP          = "MATHOP",
    IDENTIFIER      = "IDENTIFIER",
    TYPECONSTANT    = "TYPECONSTANT",
    NUMBER          = "NUMBER",
    HEX             = "HEX",
    WHITESPACE      = "WHITESPACE",
    VARARGS         = "VARARGS",
    AND             = "AND",
    BREAK           = "BREAK",
    DO              = "DO",
    ELSE            = "ELSE",
    ELSEIF          = "ELSEIF",
    END             = "END",
    FOR             = "FOR",
    FUNCTION        = "FUNCTION",
    GOTO            = "GOTO",
    IF              = "IF",
    IN              = "IN",
    LOCAL           = "LOCAL",
    NOT             = "NOT",
    OR              = "OR",
    REPEAT          = "REPEAT",
    RETURN          = "RETURN",
    THEN            = "THEN",
    UNTIL           = "UNTIL",
    WHILE           = "WHILE",
    FALSE           = "FALSE",
    TRUE            = "TRUE",
    NIL             = "NIL",
    SOF = "SOF",
    EOF = "EOF"}

LBSymbolTypes = {
    TOKEN               = true,
    STRING              = true,
    FUNCTIONDEF         = true,
    FUNCTIONCALL        = true,
    TABLEDEF            = true,
    IDENTIFIER_CHAIN    = true,
    LBTAG               = true,
    WHILE_LOOP          = true,
    FOR_LOOP            = true,
    DO_END              = true,
    REPEAT_UNTIL        = true,
    SQUARE_BRACKETS     = true,
    PARAMLIST           = true,
    PARAM               = true
    }

local T = LBTokenTypes
local S = LBSymbolTypes

tokenizekeyword = function(keyword)
    if keyword == keyword:lower() then  -- ensure keyword is lowercase
        return LBTokenTypes[keyword:upper()]
    end
    return nil
end;

---@param text string
---@return LBToken[]
tokenize = function(text)
    local LBStr = LifeBoatAPI.Tools.StringUtils
    local tokens = {}
    local nextToken = ""

    --lex
    local iText = 1 
    while iText <= #text do
        if LBStr.nextSectionIs(text, iText, '"') then
            -- quote (")
            iText, nextToken = LBStr.getTextIncluding(text, iText, '[^\\]"')
            tokens[#tokens+1] = LBSymbol:new(T.STRING, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "'") then
            -- quote (')
            iText, nextToken = LBStr.getTextIncluding(text, iText, "[^\\]'")
            tokens[#tokens+1] = LBSymbol:new(T.STRING, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%[%[") then
            -- quote ([[ ]])
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%]%]")
            tokens[#tokens+1] = LBSymbol:new(T.STRING, nextToken)  

        elseif LBStr.nextSectionIs(text, iText, "%-%-%-@lb") then
            -- preprocessor tag
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%-%-%-@lb")
            tokens[#tokens+1] = LBSymbol:new(T.LBTAG, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%-%-%[%[") then
            -- multi-line comment
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%]%]")
            tokens[#tokens+1] = LBSymbol:new(T.COMMENT, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%-%-") then
            -- single-line comment
            iText, nextToken = LBStr.getTextUntil(text, iText, "\n")
            tokens[#tokens+1] = LBSymbol:new(T.COMMENT, nextToken)

        elseif LBStr.nextSectionIs(text, iText, ";") then
            -- single-line comment
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.SEMICOLON, nextToken)

        elseif LBStr.nextSectionIs(text, iText, ",") then
            -- single-line comment
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.COMMA, nextToken)


        elseif LBStr.nextSectionIs(text, iText, "%(") then
            -- regular brackets
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.OPENBRACKET, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%[") then
            -- regular brackets
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.OPENSQUARE, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%{") then
            -- regular brackets
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.OPENCURLY, nextToken)


        elseif LBStr.nextSectionIs(text, iText, "%)") then
            -- regular brackets
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.CLOSEBRACKET, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%]") then
            -- regular brackets
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.CLOSESQUARE, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%}") then
            -- regular brackets
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.CLOSECURLY, nextToken)


        elseif LBStr.nextSectionIs(text, iText, "//") then
            -- floor (one math op not two)
            iText, nextToken = iText+1, text:sub(iText, iText+1)
            tokens[#tokens+1] = LBSymbol:new(T.MATHOP, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[%*/%+%-%%]") then
            -- all other math ops
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.MATHOP, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%.%.%.") then
            -- varargs
            iText, nextToken = iText+3, text:sub(iText, iText+2)
            tokens[#tokens+1] = LBSymbol:new(T.VARARGS, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%.%.") then
            -- concat
            iText, nextToken = iText+2, text:sub(iText, iText+1)
            tokens[#tokens+1] = LBSymbol:new(T.CONCAT, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[><=~]=") then
            -- comparison
            iText, nextToken = iText+2, text:sub(iText, iText+1)
            tokens[#tokens+1] = LBSymbol:new(T.COMPARISON, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[><]") then
            -- comparison
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.COMPARISON, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "=") then
            -- assignment
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.ASSIGNMENT, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[%a_][%w_]*") then
            -- keywords & identifier
            iText, nextToken = LBStr.getTextIncluding(text, iText, "[%a_][%w_]*")
            local keyword = tokenizekeyword(nextToken)
            if keyword then
                tokens[#tokens+1] = LBSymbol:new(keyword, nextToken)
            else
                tokens[#tokens+1] = LBSymbol:new(T.IDENTIFIER, nextToken)
            end

        elseif LBStr.nextSectionIs(text, iText, "%s+") then
            -- whitespace
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%s*")
            tokens[#tokens+1] = LBSymbol:new(T.WHITESPACE, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "0x%x+") then
            -- hex 
            iText, nextToken = LBStr.getTextIncluding(text, iText, "0x%x+")
            tokens[#tokens+1] = LBSymbol:new(T.HEX, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "%x*%.?%x+") then 
            -- number
            iText, nextToken = LBStr.getTextIncluding(text, iText, "%x*%.?%x+")
            tokens[#tokens+1] = LBSymbol:new(T.NUMBER, nextToken)

        elseif LBStr.nextSectionIs(text, iText, "[%.:]") then
            -- chain access
            iText, nextToken = iText+1, text:sub(iText, iText)
            tokens[#tokens+1] = LBSymbol:new(T.ACCESSOR, nextToken)

        else
            error("unexpected text " .. nextToken .. " at " .. iText)
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
    return associateRightWhitespaceAndComments(tokens)
end;

associateRightWhitespaceAndComments = function(tokens)
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
    if #leadingWhitespace > 0 then
        local token = LBSymbol:new(T.EOF)
        result[#result+1] = token
        for ileadingWhitespace=1, #leadingWhitespace do
            token[#token+1] = leadingWhitespace[ileadingWhitespace]
        end
    end
    return result
end;

insertIntoTable = function(tbl, list)
    for i=1,#list do
        tbl[#tbl+1] = list[i]
    end

    return tbl
end;




is = function(obj, ...)
    local args = {...}
    for i=1,#args do
        if obj == args[i] then
            return args[i]
        end
    end
    return nil
end;



-- what things can we do from "regular scope"

---@class Parse
---@field parent Parse
---@field tokens LBSymbol[]
---@field symbol LBSymbol
---@field i number
---@field isFunctionScope boolean only affects one thing "is return a valid keyword"
Parse = {
    ---@return Parse
    new = function(this, type, tokens, i, parent)
        this = LifeBoatAPI.Tools.BaseClass.new(this)
        this.i = i or 1
        this.tokens = tokens
        this.symbol = LBSymbol:new(type)
        this.parent = parent
        this.isFunctionScope = parent and parent.isFunctionScope or false
        return this
    end;

    ---@return Parse
    branch = function(this, type)
        return Parse:new(type, this.tokens, this.i, this)
    end;

    ---@param this Parse
    commit = function(this)
        if this.parent then
            this.parent.symbol[#this.parent.symbol+1] = this.symbol
            this.parent.i = this.i
        end
        return true
    end;

    ---@return boolean
    match = function(this, ...)
        return is(this.tokens[this.i].type, ...)
    end;

    ---@return boolean
    consume = function(this, ...)
        local consumedAny = this:tryConsume(...)
        while(this:tryConsume(...)) do end
        return consumedAny
    end;

    ---@return boolean
    tryConsume = function(this, ...)
        if is(this.tokens[this.i].type, ...) then
            this.symbol[#this.symbol+1] = this.tokens[this.i]
            return true
        else
            return false
        end
    end;

    ---@param this Parse
    tryConsumeRules = function(this, ...)
        local rules = {...}
        for irule=1, #rules do
            if rules[irule](this) then
                return true
            end
        end
        return false
    end;

    ---@param this Parse
    consumeRules = function(this, ...)
        if not this:tryConsumeRules(...) then
            error("Parse error, no suitable rule")
        end
        return true
    end;
}



---@param parse Parse
Statement = function(parse)
    parse = parse:branch(S.STATEMENT)
    if parse:tryConsumeRules(
        NamedFunctionDefinition,
        Assignment,
        LocalWithoutAssignment,
        FunctionCall,
        IfStatement,
        ProcessorLBTagSection
    ) then
        return parse:commit()
    end
    -- Assignment
    -- local without Assignment
    -- Whitespace/Comments
    -- Function Call
    -- Function Def
    -- If/Loops/Do/Etc.
    -- Goto (bleh)
end;

ExpressionList = function(parse)
    -- a,b,c,d,e comma separated items
end;






FunctionCall = function(parse)
    parse = parse:branch(S.FUNCTIONCALL)
end;

SquareBracketsIndex = function(parse)
    parse = parse:branch(S.SQUARE_BRACKETS)

    if parse:tryConsume(T.OPENSQUARE)
        and parse:tryConsumeRules(Expression)
        and parse:tryConsume(T.CLOSESQUARE) then

        return parse:commit()
    end
end

ParenthesisExpression = function(parse)
    parse = parse:branch(S.PARENTHESIS)

    if parse:tryConsume(T.OPENBRACKET)
        and parse:tryConsumeRules(Expression)
        and parse:tryConsume(T.CLOSEBRACKET) then

        return parse:commit()
    end
end;

---@param parse Parse
AccessChain = function(parse)
    return (parse:tryConsume(T.ACCESSOR) and parse:tryConsume(T.IDENTIFIER))
             or parse:tryConsume(SquareBracketsIndex)
end;

---@param parse Parse
BinaryExpression = function(parse)
    return parse:tryConsumeRules(SingleExpression)
        and parse:tryConsume(T.AND, T.OR, T.CONCAT, T.MATHOP)
        and parse:tryConsume(Expression)
end;

---@param parse Parse
ExpressionChainedOperator = function(parse)
    -- a = (1+2)()()[1].123 param,func,func,accesschain,accesschain
    -- singleExpressions can chain into infinite function calls, etc.

    if parse:tryConsume(T.IDENTIFIER) or parse:tryConsumeRules(ParenthesisExpression) then
        while parse:tryConsumeRules(AccessChain,
                                    FunctionCall) do end
            return true;
    end
end

TableDef = function()
    parse = parse:branch(S.TABLEDEF)

    if parse:tryConsume(T.OPENCURLY)
        and parse:tryConsumeRules(Expression)
        and parse:tryConsume(T.CLOSECURLY) then

        return parse:commit()
    end
end;

AnonymousFunctionDef = function(parse)
    parse = parse:branch(S.EXPRESSION)

    -- clear any unary operators from the front
    while parse:tryConsume(T.UNARY_OP) do end

    if parse:tryConsumeRules(
        ExpressionChainedOperator, -- (exp.index.index.index[index][index](func)(func)(func))
        TableDef,
        AnonymousFunctionDef) 
        or parse:tryConsume(T.STRING, T.NUMBER, T.HEX, T.TRUE, T.FALSE, T.NIL)  -- hard-coded value
        then
        return parse:commit()
    end
end;

SingleExpression = function(parse)
    -- single expression, not lined by binary, e.g. a string, an identifier-chain, etc.
    parse = parse:branch(S.EXPRESSION)

    -- clear any unary operators from the front
    while parse:tryConsume(T.UNARY_OP) do end

    if parse:tryConsumeRules(
        ExpressionChainedOperator, -- (exp.index.index.index[index][index](func)(func)(func))
        TableDef,
        AnonymousFunctionDef) 
        or parse:tryConsume(T.STRING, T.NUMBER, T.HEX, T.TRUE, T.FALSE, T.NIL)  -- hard-coded value
        then
        return parse:commit()
    end
end;

---@param parse Parse
Expression = function(parse)
    -- identifier.access
    -- expression mathop|concat expression chain
    -- parenthesis -> expression
    parse = parse:branch(S.EXPRESSION)

    if parse:tryConsumeRules(
        BinaryExpression, -- (exp op exp) (infinite chain-> single_exp op (exp op exp)) etc.
        SingleExpression
    ) then
        return true
    end
end;



---@param parse Parse
IfStatement = function(parse)
    parse = parse:branch(S.IFSTATEMENT)
    if parse:tryConsume(T.IF)
        and parse:tryConsumeRules(Expression)
        and parse:tryConsume(T.THEN) then
        
        -- statements, if any - may be empty
        while parse:tryConsumeRules(Statement) do end

        -- potential for elseifs (if they exist, must be well structured or return false "badly made thingmy")
        while parse:tryConsume(T.ELSEIF) do
            if not (parse:tryConsumeRules(Expression)
                and parse:tryConsume(T.THEN)) then
                return false
            else
                -- parse statements in the "elseif" section
                while parse:tryConsumeRules(Statement) do end
            end
        end

        -- possible "else" section
        if parse:tryConsume(T.ELSE) then
            -- if "else" exists, expression + then must be well formed
            if not (parse:tryConsumeRules(Expression)
                and parse:tryConsume(T.THEN)) then
                return false
            else
                -- parse statements in the "elseif" section
                while parse:tryConsumeRules(Statement) do end
            end
        end

        if parse:tryConsume(T.END) then
            return parse:commit()
        end
    end
end;


---@param parse Parse
Assignment = function(parse)
    parse = parse:branch(S.ASSIGNMENT)
    parse:tryConsume(T.LOCAL)
    parse:tryConsume()
end;

NamedFunctionDefinition = function(parse)
end;

LocalWithoutAssignment = function(parse)
end;

TableValueInitialization = function(parse)
end;

FunctionCall = function(parse)
end;

ProcessorLBTagSection = function(parse)
end;

ParseProgram = function(tokens)
    local parse = Parse:new(S.PROGRAM, tokens, 1)

    while parse:consumeRules(Statement) do end

    return parse
end;



---@return string
toString = function(tokens)
    local result = {}
    for i=1,#tokens do
        result[#result+1] = tokens[i].raw
    end
    return table.concat(result)
end;



testParse = function(parseFunc, text)
    local tokens = tokenize(text)
    local parser = Parse:new("TEST", tokens, 1)
    local result = parseFunc(parser)
    return result, parser.symbol
end;

testParse(SquareBracketsIndex,[[ [123] ]])
-- text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]))
-- 
-- local tokensList = tokenize(text)
-- 
-- local parsed = ParseProgram(tokensList)
-- 
-- LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
--     LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\gen1.lua]]),
--     toString(tokensList))
-- 
-- 
-- 
-- 
-- __simulator:exit()
