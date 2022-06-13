require("Parsing.lex_tokenlist")
local T = LBTokenTypes


LBSymbolTypes = {
    GLOBAL_NAMEDFUNCTIONDEF     = "GLOBAL_NAMEDFUNCTIONDEF",
    LOCAL_NAMEDFUNCTIONDEF      = "LOCAL_NAMEDFUNCTIONDEF",

    GLOBAL_ASSIGNMENT           = "GLOBAL_ASSIGNMENT",
    LOCAL_ASSIGNMENT            = "LOCAL_ASSIGNMENT",

    FUNCTIONDEF         = "ANON_FUNCTIONDEF",
    FUNCTIONDEF_PARAMS  = "FUNCTIONDEF_PARAMS",

    TABLEDEF            = "TABLEDEF",

    WHILE_LOOP          = "WHILE_LOOP",
    FOR_LOOP            = "FOR_LOOP",
    DO_END              = "DO_END",
    REPEAT_UNTIL        = "REPEAT_UNTIL", 
    IF_STATEMENT        = "IF_STATEMENT",
    IF_CONDITION        = "IF_CONDITION",
    
    PARENTHESIS         = "PARENTHESIS",
    EXPCHAIN            = "EXPCHAIN",

    OPERATORCHAIN       = "OPERATORCHAIN",
    ORCHAIN             = "ORCHAIN",
    ANDCHAIN            = "ANDCHAIN",
    VALUECHAIN          = "VALUECHAIN",
    NUMCHAIN            = "NUMCHAIN",
    STRINGCHAIN         = "STRINGCONCAT",
    BOOLCHAIN           = "BOOLCHAIN",
    

    SQUARE_BRACKETS     = "SQUARE_BRACKETS",
    FUNCTIONCALL        = "FUNCTIONCALL",

    PARAM               = "PARAM",
    GOTOLABEL           = "GOTOLABEL",
    GOTOSTATEMENT       = "GOTOSTATEMENT",
    LBTAG               = "LBTAG",

    RETURNSTATEMENT     = "RETURNSTATEMENT"
    }
local S = LBSymbolTypes

---@class Parse
---@field parent Parse
---@field tokens LBToken[]
---@field symbol LBToken
---@field i number
---@field isReturnableScope boolean defined the type of scope, function or loop or none; for return and break keywords
---@field isLoopScope boolean
---@field errorObj any
---@field cache any
Parse = {
    ---@return Parse
    new = function(this, symboltype, tokens, i, parent)
        -- hardcoded class instantiation for performance, as it's called very often
        return {
            -- fields
            i = i or 1,
            tokens = tokens,
            symbol = LBToken:new(symboltype),
            parent = parent,
            isReturnableScope = parent and parent.isReturnableScope or false,
            isLoopScope = parent and parent.isLoopScope or false,
            cache = parent and parent.cache or {},

            -- functions
            branch = this.branch,
            commit = this.commit,
            error = this.error,
            match = this.match,
            consume = this.consume,
            tryConsume = this.tryConsume,
            tryConsumeAs = this.tryConsumeAs,
        }
    end;

    ---@return Parse
    branch = function(this, symboltype)
        return Parse:new(symboltype, this.tokens, this.i, this)
    end;

    ---@param this Parse
    commit = function(this)
        if this.parent then
            local parentSymbol = this.parent.symbol
            local thisSymbol = this.symbol
            if not thisSymbol.type or parentSymbol.type == thisSymbol.type then
                for i=1,#thisSymbol do
                    parentSymbol[#parentSymbol+1] = thisSymbol[i]
                end
            else
                this.parent.symbol[#this.parent.symbol+1] = this.symbol
            end
            this.parent.i = this.i
        end
        return true
    end;

    ---@param this Parse
    error = function(this, message)
        local lineInfo = this.tokens[this.i].lineInfo
        if (not this.errorObj) or (lineInfo.index > this.errorObj.index) then
            this.errorObj = {
                owner = this,
                message = message,
                i = this.i,
                index = lineInfo.index,
                line = lineInfo.line,
                column = lineInfo.column,
                toString = function(err)
                    return "line: " .. err.line .. ", column: " .. err.column .. "\n"
                        .. "at token " .. err.i .. ": " .. tostring(this.tokens[err.i].raw) .. "\n"
                        .. message .. "\n"
                end;
            }
        end

        if (not this.parent.errorObj) or (this.errorObj.index > this.parent.errorObj.index) then
            this.parent.errorObj = this.errorObj
        end
        return false
    end;

    ---@return boolean
    match = function(this, ...)
        return is(this.tokens[this.i].type, ...)
    end;

    ---@param this Parse
    tryConsume = function(this, ...)
        local rules = {...}
        for irules=1, #rules do
            local rule = rules[irules]

            if type(rule) == "function" then
                if not this.cache[rule] then
                    this.cache[rule] = {}
                end

                if this.cache[rule][this.i] ~= false then
                    local result = rule(this)
                    
                    if result then
                        this.cache[rule][this.i] = true
                        return true
                    else
                        this.cache[rule][this.i] = false
                    end
                end
            else
                if is(this.tokens[this.i].type, ...) then
                    this.symbol[#this.symbol+1] = this.tokens[this.i]
                    this.i = this.i + 1
                    return true
                else
                    return false
                end
            end
        end
        return false
    end;

    ---@param this Parse
    tryConsumeAs = function(this, symboltype, ...)
        local result = this:tryConsume(...)
        if result then
            this.symbol[#this.symbol].type = symboltype
        end
        return result
    end;
}

---@class Expressions
LBExpressions = {
    ---@param parse Parse
    Program = function(parse)
        local parse = parse:branch()

        parse:tryConsume(LBExpressions.genBody(T.EOF, T.RETURN))

        if parse:tryConsume(LBExpressions.ReturnStatement) then
            
        end
        if parse:tryConsume(T.EOF) then
            return parse:commit()
        end

        return parse:error("Did not reach EOF")
    end;

    ---@param parse Parse
    Statement = function(parse)
        parse = parse:branch(S.STATEMENT)
        if parse:tryConsume(T.SEMICOLON)
        or parse.isLoopScope and parse:tryConsume(T.BREAK)
        or parse:tryConsume(
            LBExpressions.LocalNamedFunctionDefinition,
            LBExpressions.GlobalNamedFunctionDefinition,
            LBExpressions.IfStatement,
            LBExpressions.ForLoopStatement,
            LBExpressions.ForInLoopStatement,
            LBExpressions.WhileLoopStatement,
            LBExpressions.RepeatUntilStatement,
            LBExpressions.DoEndStatement,
            LBExpressions.GotoLabelStatement,
            LBExpressions.GotoStatement,
            LBExpressions.ProcessorLBTagSection,
            LBExpressions.FunctionCallStatement,
            LBExpressions.GlobalAssignmentStatement,
            LBExpressions.LocalAssignmentStatement,
            parse.isReturnableScope and LBExpressions.ReturnStatement or nil
        ) then
            return parse:commit()
        end

        return parse:error("Invalid statement")
    end;

    ---@param parse Parse
    SquareBracketsIndex = function(parse)
        parse = parse:branch(S.SQUARE_BRACKETS)

        if parse:tryConsume(T.OPENSQUARE)
            and parse:tryConsume(LBExpressions.Expression)
            and parse:tryConsume(T.CLOSESQUARE) then

            return parse:commit()
        end

        return parse:error("Invalid square-bracket index")
    end;

    ---@param parse Parse
    ParenthesisExpression = function(parse)
        parse = parse:branch(S.PARENTHESIS)

        if parse:tryConsume(T.OPENBRACKET)
            and parse:tryConsume(LBExpressions.Expression)
            and parse:tryConsume(T.CLOSEBRACKET) then

            return parse:commit()
        end

        return parse:error("Invalid parenthesis expression")
    end;

    ---@param parse Parse
    TableDef = function(parse)
        parse = parse:branch(S.TABLEDEF)

        if parse:tryConsume(T.OPENCURLY) then
            
            if parse:tryConsume(LBExpressions.TableValueInitialization) then
                while parse:tryConsume(T.COMMA, T.SEMICOLON) do
                    if not parse:tryConsume(LBExpressions.TableValueInitialization) then
                        break; -- it's valid to end on a comma/semi-colon
                    end
                end
            end

            
            if parse:tryConsume(T.CLOSECURLY) then
                return parse:commit()
            end
        end

        return parse:error("Invalid table definition")
    end;

    ---@param parse Parse
    FunctionDefParenthesis = function(parse)
        parse = parse:branch(S.FUNCTIONDEF_PARAMS)
        if parse:tryConsume(T.OPENBRACKET) then

            if(parse:tryConsume(T.IDENTIFIER)) then
                
                while(parse:tryConsume(T.COMMA)) do
                    if parse:tryConsume(T.VARARGS) then
                        break -- should be final parameter, so close brackets next
                    end
                    if not parse:tryConsume(T.IDENTIFIER) then
                        return parse:error("Expected parameter after ','")
                    end
                end
            elseif parse:tryConsume(T.VARARGS) then
                -- nothing else to do, expect end
            end

            if parse:tryConsume(T.CLOSEBRACKET) then
                return parse:commit()
            end
        end

        return parse:error("Invalid function-definition parenthesis")
    end;

    ---@param parse Parse
    ExpressionList = function(parse)
        -- a,b,c,d,e comma separated items
        parse = parse:branch()
        if parse:tryConsume(LBExpressions.Expression) then
            while parse:tryConsume(T.COMMA) do
                if not parse:tryConsume(LBExpressions.Expression) then
                    return parse:error("Expression list must not leave trailing ','")
                end
            end
            return parse:commit()
        end

        return parse:error("Invalid expression-list")
    end;

    ---@param parse Parse
    ReturnStatement = function(parse)
        parse = parse:branch(S.RETURNSTATEMENT)
        if parse:tryConsume(T.RETURN) then

            -- optional expression-list
            parse:tryConsume(LBExpressions.ExpressionList)

            return parse:commit()
        end

        return parse:error("Invalid return statement")
    end;

    ---@param parse Parse
    AnonymousFunctionDef = function(parse)
        parse = parse:branch(S.FUNCTIONDEF)

        if parse:tryConsume(T.FUNCTION) 
        and parse:tryConsume(LBExpressions.FunctionDefParenthesis) then

            parse.isReturnableScope = true;
            parse.isLoopScope = false;
            parse:tryConsume(LBExpressions.genBody(T.END))

            if parse:tryConsume(T.END) then
                return parse:commit()
            end
        end

        return parse:error("Invalid anonymous function definition")
    end;

    ---@param parse Parse
    GlobalNamedFunctionDefinition = function(parse, ...)
        parse = parse:branch(S.GLOBAL_NAMEDFUNCTIONDEF)
        
        if parse:tryConsume(T.FUNCTION)
            and parse:tryConsume(T.IDENTIFIER) then

            -- for each ".", require a <name> after
            while parse:tryConsume(T.DOTACCESS) do
                if not parse:tryConsume(T.IDENTIFIER) then
                    return parse:error("Expected identifier after '.' ")
                end
            end

            -- if : exists, require <name> after
            if parse:tryConsume(T.COLONACCESS) then
                if not parse:tryConsume(T.IDENTIFIER) then
                    return parse:error("Expected final identifier after ':' ")
                end
            end

            if parse:tryConsume(LBExpressions.FunctionDefParenthesis) then
                parse.isReturnableScope = true;
                parse.isLoopScope = false;
                parse:tryConsume(LBExpressions.genBody(T.END))

                if parse:tryConsume(T.END) then
                    return parse:commit()
                end
            end
        end

        return parse:error("Invalid named-function definition")
    end;

    ---@param parse Parse
    LocalNamedFunctionDefinition = function(parse, ...)
        parse = parse:branch(S.LOCAL_NAMEDFUNCTIONDEF)
        
        -- optionally local
        if parse:tryConsume(T.LOCAL) and
           parse:tryConsume(T.FUNCTION)
            and parse:tryConsume(T.IDENTIFIER) then

            if parse:match(T.DOTACCESS, T.COLONACCESS) then
                return parse:error("Local function definition must only be simple identifier (no '.'/':') ")
            end

            if parse:tryConsume(LBExpressions.FunctionDefParenthesis) then
                parse.isReturnableScope = true;
                parse.isLoopScope = false;
                parse:tryConsume(LBExpressions.genBody(T.END))

                if parse:tryConsume(T.END) then
                    return parse:commit()
                end
            end
        end

        return parse:error("Invalid named-function definition")
    end;


    ---@param parse Parse
    OperatorChain = function(parse)
        parse = parse:branch()
        
        if parse:tryConsume(LBExpressions.OrChain, LBExpressions.AndChain, LBExpressions.ValueChain) then
            return parse:commit()
        end
        
        return parse:error("Invalid operator chain")
    end;
    

    OrChain = function(parse)
        parse = parse:branch(S.ORCHAIN)
        if parse:tryConsume(LBExpressions.AndChain, LBExpressions.ValueChain, LBExpressions.SingleExpression)
            and parse:tryConsume(T.OR)
            and parse:tryConsume(LBExpressions.AndChain, LBExpressions.ValueChain, LBExpressions.SingleExpression) then

            while parse:tryConsume(T.OR) do
                if not parse:tryConsume(LBExpressions.AndChain, LBExpressions.ValueChain, LBExpressions.SingleExpression) then
                    return parse:error("Expected expression following OR")
                end
            end
            return parse:commit()
        end
        
        return parse:error("Not Or Chain")
    end;

    AndChain = function(parse)
        parse = parse:branch(S.ANDCHAIN)
        if parse:tryConsume(LBExpressions.ValueChain, LBExpressions.SingleExpression)
            and parse:tryConsume(T.AND)
            and parse:tryConsume(LBExpressions.ValueChain, LBExpressions.SingleExpression) then

            while parse:tryConsume(T.AND) do
                if not parse:tryConsume(LBExpressions.ValueChain, LBExpressions.SingleExpression) then
                    return parse:error("Expected expression following AND")
                end
            end
            return parse:commit()
        end
        
        return parse:error("Not And Chain")
    end;

    ValueChain = function(parse)
        local isNumber, isBool, isString;

        parse = parse:branch(S.VALUECHAIN)
        if parse:tryConsume(LBExpressions.SingleExpression) then
        
            if parse:tryConsumeAs(T.MATHOP, T.MIXED_MATHOP, T.MATHOP) then
                isNumber = true
            elseif parse:tryConsume(T.STRING_CONCAT) then
                isString = true
            elseif parse:tryConsume(T.COMPARISON) then
                isBool = true
            else
                return parse:error("Invalid value chain")
            end

            if parse:tryConsume(LBExpressions.SingleExpression) then

                while true do
                    if parse:tryConsumeAs(T.MATHOP, T.MIXED_MATHOP, T.MATHOP) then
                        isNumber = true
                    elseif parse:tryConsume(T.STRING_CONCAT) then
                        isString = true
                    elseif parse:tryConsume(T.COMPARISON) then
                        isBool = true
                    else
                        break
                    end
           
                    if not parse:tryConsume(LBExpressions.SingleExpression) then
                        return parse:error("Invalid operator chain, missing final expression")
                    end
                end
                
                if isBool then
                    parse.symbol.type = S.BOOLCHAIN
                elseif isString then
                    parse.symbol.type = S.STRINGCHAIN
                elseif isNumber then
                    parse.symbol.type = S.NUMCHAIN
                else
                    error("internal: unexpected chain operators, please review parser code for errors")
                end

                return parse:commit()
            end
        end
        return parse:error("Invalid value chain")
    end;

    ---@param parse Parse
    FunctionCallStatement = function(parse)
        parse = parse:branch()

        -- save a lot of duplication by finding a valid ExpChain and then backtracking
        if parse:tryConsume(LBExpressions.ExpressionChainedOperator) then
            local lastChild = parse.symbol[#parse.symbol]
            if lastChild
            and lastChild[#lastChild]
            and is(lastChild[#lastChild].type, S.FUNCTIONCALL) then
                return parse:commit()
            end
        end

        return parse:error("Invalid function call statement")
    end;

    ---@param parse Parse
    ExpressionChainedOperator = function(parse)
        -- a = (1+2)()()[1].123 param,func,func,accesschain,accesschain
        -- singleExpressions can chain into infinite function calls, etc.
        parse = parse:branch(S.EXPCHAIN)
        if parse:tryConsume(T.IDENTIFIER) or parse:tryConsume(LBExpressions.ParenthesisExpression) then
            while true do
                if parse:tryConsume(T.DOTACCESS) then -- .<name>
                    if not parse:tryConsume(T.IDENTIFIER) then
                        return parse:error("Expected identifier after '.' ")
                    end
                elseif parse:tryConsume(T.COLONACCESS) then -- :<name>(func) 
                    if not (parse:tryConsume(T.IDENTIFIER)
                        and parse:tryConsume(LBExpressions.FunctionCallParenthesis)) then
                        return parse:error("Expected function call after ':'")
                    end
                elseif parse:tryConsume(LBExpressions.SquareBracketsIndex, LBExpressions.FunctionCallParenthesis) then -- [123] or (a,b,c)
                    -- all OK
                else
                    return parse:commit();
                end
            end
        end

        return parse:error("Invalid expression chain")
    end;

    ---@param parse Parse
    SingleExpression = function(parse)
        -- single expression, not lined by binary, e.g. a string, an identifier-chain, etc.
        parse = parse:branch()

        -- clear any unary operators from the front
        while parse:tryConsume(T.NOT)
              or parse:tryConsumeAs(T.UNARY_MATHOP, T.UNARY_MATHOP, T.MIXED_MATHOP) do
            local symbolJustAdded = parse.symbol[#parse.symbol]

            -- categorize this as a Math or Boolean expression (as these returns convert it)
            if is(symbolJustAdded.type, T.UNARY_MATHOP) then
                parse.symbol.type = S.NUMCHAIN
            else
                parse.symbol.type = S.BOOLCHAIN
            end
        end

        if parse:tryConsume(T.VARARGS, T.STRING, T.NUMBER, T.HEX, T.TRUE, T.FALSE, T.NIL)-- hard-coded value
        or parse:tryConsume(
            LBExpressions.ParenthesisExpression,
            LBExpressions.ExpressionChainedOperator, -- (exp.index.index.index[index][index](func)(func)(func))
            LBExpressions.TableDef,
            LBExpressions.AnonymousFunctionDef) then
            return parse:commit()
        end

        return parse:error("Invalid single-expression")
    end;

    ---@param parse Parse
    Expression = function(parse)
        -- identifier.access
        -- expression mathop|concat expression chain
        -- parenthesis -> expression
        parse = parse:branch()

        if parse:tryConsume(
            LBExpressions.OperatorChain, -- (exp op exp) (infinite chain-> single_exp op (exp op exp)) etc.
            LBExpressions.SingleExpression
        ) then
            return parse:commit()
        end

        return parse:error("Invalid expression")
    end;

    genBody = function(...)
        local args = {...}

        ---@param parse Parse
        return function(parse)
            parse = parse:branch()

            while not parse:match(table.unpack(args)) do
                if not parse:tryConsume(LBExpressions.Statement) then
                    return parse:error("Failed to terminate body")
                end
            end

            return parse:commit()
        end;
    end;

    ---@param parse Parse
    IfStatement = function(parse)
        parse = parse:branch(S.IF_STATEMENT)
        parse.isReturnableScope = true

        if parse:tryConsume(T.IF) 
            and parse:tryConsume(LBExpressions.Expression)
            and parse:tryConsume(T.THEN) then
            
            -- statements, if any - may be empty
            parse:tryConsume(LBExpressions.genBody(T.ELSEIF, T.ELSE, T.END))

            -- potential for elseifs (if they exist, must be well structured or return false "badly made thingmy")
            while parse:tryConsume(T.ELSEIF) do
                if not (parse:tryConsume(LBExpressions.Expression)
                    and parse:tryConsume(T.THEN)) then
                    return parse:error("Improperly specified elseif statement")
                else
                    -- parse statements in the "elseif" section
                    parse:tryConsume(LBExpressions.genBody(T.ELSEIF, T.ELSE, T.END))
                end
            end

            -- possible "else" section
            if parse:tryConsume(T.ELSE) then
                parse:tryConsume(LBExpressions.genBody(T.END))
            end

            if parse:tryConsume(T.END) then
                return parse:commit()
            end
        end

        return parse:error("Invalid if Statement")
    end;

    ---@param parse Parse
    GlobalAssignmentStatement = function(parse)
        parse = parse:branch(S.GLOBAL_ASSIGNMENT)

        if parse:tryConsume(LBExpressions.ExpressionChainedOperator) then 
            -- check last part of the EXPCHAIN was assignable
            local lastSymbol = parse.symbol[#parse.symbol]
            if not is(lastSymbol.type, T.IDENTIFIER, S.SQUARE_BRACKETS) then
                parse:error("Cannot assign to type: " .. lastSymbol.type)
            end

            -- now check repeatedly for the same, with comma separators
            --   return false if a comma is provided, but not a valid assignable value
            while parse:tryConsume(T.COMMA) do
                if not parse:tryConsume(LBExpressions.LValue) then
                    return parse:error("Expected lvalue after comma")
                end
            end

            if parse:tryConsume(T.ASSIGN) then -- equals sign "="
                -- expect a list of expressions to assign
                if parse:tryConsume(LBExpressions.ExpressionList) then
                    return parse:commit()
                else
                    parse:error("Expected expression following '=' assignment.")
                end
            end
        end
        return parse:error("Invalid Assignment/Local Declaration")
    end;

    ---@param parse Parse
    LocalAssignmentStatement = function(parse)
        parse = parse:branch(S.LOCAL_ASSIGNMENT)

        if parse:tryConsume(T.LOCAL)
            and parse:tryConsume(T.IDENTIFIER) then -- check last part of the EXPCHAIN was assignable
            
            -- now check repeatedly for the same, with comma separators
            --   return false if a comma is provided, but not a valid assignable value
            while parse:tryConsume(T.COMMA) do
                if not parse:tryConsume(T.IDENTIFIER) then
                    return parse:error("Expected lvalue after comma")
                end
            end

            if parse:tryConsume(T.ASSIGN) then -- equals sign "="
                -- expect a list of expressions to assign
                if parse:tryConsume(LBExpressions.ExpressionList) then
                    return parse:commit()
                else
                    parse:error("Expected expression following '=' assignment.")
                end
            else
                -- local statement can be without an assignment
                return parse:commit()
            end
        end
        
        return parse:error("Invalid Assignment/Local Declaration")
    end;

    ---@param parse Parse
    LValue = function(parse)
        parse = parse:branch() -- no typename; meaning it will simplify out

        -- messy but easier way to handle Lvalues: (saves a lot of duplication)
        -- easiest thing to do is, check if we can make a valid ExpChain and then make sure the end of it is actually modifiable
        if parse:tryConsume(LBExpressions.ExpressionChainedOperator) then
            local lastChild = parse.symbol[#parse.symbol]
            if lastChild
            and lastChild[#lastChild]
            and is(lastChild[#lastChild].type, S.SQUARE_BRACKETS, T.IDENTIFIER) then
                return parse:commit()
            end
        end

        return parse:error("Invalid lvalue")
    end;

    ---@param parse Parse
    FunctionCallParenthesis = function(parse)
        parse = parse:branch(S.FUNCTIONCALL) -- remember the parenthesis ARE the actual "function call"
        if  parse:tryConsume(T.OPENBRACKET) then

            -- can be empty parens
            parse:tryConsume(LBExpressions.ExpressionList)

            if parse:tryConsume(T.CLOSEBRACKET) then
                return parse:commit()
            end
        elseif parse:tryConsume(T.STRING) then
            -- alternate way to call functions, abyssmal addition to the language 
            return parse:commit()
        elseif parse:tryConsume(LBExpressions.TableDef) then
            -- equally mental way of calling functions, please refrain from this
            return parse:commit()
        end

        return parse:error("Invalid function call parenthesis")
    end;

    ---@param parse Parse
    TableAssignment = function(parse)
        parse = parse:branch(S.GLOBAL_ASSIGNMENT)
        if parse:tryConsume(LBExpressions.SquareBracketsIndex)
            or parse:tryConsume(T.IDENTIFIER) then

            if parse:tryConsume(T.ASSIGN) 
                and parse:tryConsume(LBExpressions.Expression) then

                return parse:commit()
            end
        end

        return parse:error("Invalid table assignment")
    end;

    ---@param parse Parse
    TableValueInitialization = function(parse)
        parse = parse:branch()
        if parse:tryConsume(
            LBExpressions.TableAssignment,
            LBExpressions.Expression
        ) then
            return parse:commit()
        end

        return parse:error("Invalid table value")
    end;

    ---@param parse Parse
    ForLoopStatement = function(parse)
        parse = parse:branch(S.FOR_LOOP)
        parse.isLoopScope = true
        parse.isReturnableScope = true
        
        if parse:tryConsume(T.FOR) then
            -- a,b,c,d,e=1..works
            if parse:tryConsume(T.IDENTIFIER)
                and parse:tryConsume(T.ASSIGN)
                and parse:tryConsume(LBExpressions.Expression) 
                and parse:tryConsume(T.COMMA)
                and parse:tryConsume(LBExpressions.Expression) then

                -- optional 3rd parameter (step)
                if parse:tryConsume(T.COMMA)
                    and not parse:tryConsume(LBExpressions.Expression) then
                    return parse:error("Trailing ',' in for-loop definition")
                end

                if parse:tryConsume(T.DO)
                and parse:tryConsume(LBExpressions.genBody(T.END))
                and parse:tryConsume(T.END) then
                    return parse:commit()
                end
            end
        end

        return parse:error("Invalid for-loop")
    end;


    ---@param parse Parse
    ForInLoopStatement = function(parse)
        parse = parse:branch(S.FOR_LOOP)
        parse.isLoopScope = true
        parse.isReturnableScope = true
        
        if parse:tryConsume(T.FOR) then
            -- a,b,c,d,e=1..works
            if parse:tryConsume(T.IDENTIFIER) then -- check last part of the EXPCHAIN was assignable

                -- now check repeatedly for the same, with comma separators
                --   return false if a comma is provided, but not a valid assignable value
                while parse:tryConsume(T.COMMA) do
                    if not parse:tryConsume(T.IDENTIFIER) then
                        return parse:error("Expected identifier after comma")
                    end
                end

                -- =exp, exp
                if parse:tryConsume(T.IN)
                and parse:tryConsume(LBExpressions.Expression) then

                    -- can now handle as many additional params as wanted
                    while parse:tryConsume(T.COMMA) do
                        if not parse:tryConsume(LBExpressions.Expression) then
                            return parse:error("Trailing ',' in for-loop definition")
                        end
                    end

                    if parse:tryConsume(T.DO)
                    and parse:tryConsume(LBExpressions.genBody(T.END))
                    and parse:tryConsume(T.END) then
                        return parse:commit()
                    end
                end
            end
        end

        return parse:error("Invalid for-loop")
    end;

    ---@param parse Parse
    WhileLoopStatement = function(parse)
        parse = parse:branch(S.WHILE_LOOP)
        parse.isLoopScope = true
        parse.isReturnableScope = true
        
        if parse:tryConsume(T.WHILE)
        and parse:tryConsume(LBExpressions.Expression)
        and parse:tryConsume(T.DO)
        and parse:tryConsume(LBExpressions.genBody(T.END))
        and parse:tryConsume(T.END) then
            return parse:commit()
        end

        return parse:error("Invalid while loop");
    end;


    ---@param parse Parse
    RepeatUntilStatement = function(parse)
        parse = parse:branch(S.REPEAT_UNTIL)
        parse.isLoopScope = true
        parse.isReturnableScope = true
        
        if parse:tryConsume(T.REPEAT)
        and parse:tryConsume(LBExpressions.genBody(T.UNTIL))
        and parse:tryConsume(T.UNTIL)
        and parse:tryConsume(LBExpressions.Expression) then
            return parse:commit()
        end

        return parse:error("Invalid repeat-until loop");
    end;

    ---@param parse Parse
    DoEndStatement = function(parse)
        parse = parse:branch(S.DO_END)
        parse.isReturnableScope = true

        if parse:tryConsume(T.DO)
        and parse:tryConsume(LBExpressions.genBody(T.END))
        and parse:tryConsume(T.END) then
            return parse:commit()
        end

        return parse:error("Invalid repeat-until loop");
    end;

    -- could arguably ban this
    ---@param parse Parse
    GotoStatement = function(parse)
        parse = parse:branch(S.GOTOSTATEMENT)
        if parse:tryConsume(T.GOTO)
        and parse:tryConsume(T.IDENTIFIER) then
            return parse:commit()
        end

        return parse:error("Invalid goto")
    end;

    ---@param parse Parse
    GotoLabelStatement = function(parse)
        parse = parse:branch(S.GOTOLABEL)
        if parse:tryConsume(T.GOTOMARKER)
            and parse:tryConsume(T.IDENTIFIER)
            and parse:tryConsume(T.GOTOMARKER) then
                return parse:commit()
        end
        return parse:error("Invalid goto ::label::")
    end;

    ---@param parse Parse
    ProcessorLBTagSection = function(parse)
        parse = parse:branch(S.LBTAG_SECTION)
        if parse:tryConsume(T.LBTAG_START) 
        and parse:tryConsume(LBExpressions.FunctionCallParenthesis)
        and parse:tryConsume(LBExpressions.genBody(T.LBTAG_END))
        and parse:tryConsume(T.LBTAG_END) then
            return parse:commit()
        end

        return parse:error("Invalid lb tag setup")
    end;
}

toString = function(tree)
    local result = {}
    for i=1,#tree do
        result[#result+1] = toString(tree[i])
        result[#result+1] = tree[i].raw
    end
    return table.concat(result)
end;

local s = require("socket")
parse = function(text)
    local startTime = s.gettime()
    local tokens = tokenize(text)

    print("tokenize time: " .. tostring(s.gettime() - startTime)) -- 2.3634777069092 (improved)

    startTime = s.gettime()
    local parser = Parse:new(nil, tokens, 1)
    local result = LBExpressions.Program(parser)
    print("parse time: " .. tostring(s.gettime() - startTime)) -- 0.5665168762207 (improved?)

    if not result then
        error(parser.errorObj:toString())
    end
    
    return parser.symbol
end;




