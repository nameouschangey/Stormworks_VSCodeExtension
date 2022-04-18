require("Parsing.lex")

local T = LBTokenTypes


LBSymbolTypes = {
    FUNCTIONDEF         = "FUNCTIONDEF",
    FUNCTIONCALL        = "FUNCTIONCALL",
    TABLEDEF            = "TABLEDEF",
    WHILE_LOOP          = "WHILE_LOOP",
    FOR_LOOP            = "FOR_LOOP",
    DO_END              = "DO_END",
    REPEAT_UNTIL        = "REPEAT_UNTIL",
    SQUARE_BRACKETS     = "SQUARE_BRACKETS",
    
    IF_STATEMENT        = "IF_STATEMENT",
    IF_CONDITION        = "IF_CONDITION",

    BODY                = "BODY",

    ASSIGNMENT          = "ASSIGNMENT",
    PROGRAM             = "PROGRAM",
    PARENTHESIS         = "PARENTHESIS",
    EXPCHAIN            = "EXPCHAIN",
    OPERATORCHAIN       = "OPERATORCHAIN",
    DECLARE_LOCAL       = "DECLARE_LOCAL",
    FUNCTIONDEF_PARAMS  = "FUNCTIONDEF_PARAMS",
    PARAM               = "PARAM",

    GOTOLABEL           = "GOTOLABEL",
    GOTOSTATEMENT       = "GOTOSTATEMENT",

    LBTAG_SECTION       = "LBTAG_SECTION"
    }
local S = LBSymbolTypes


---@class Parse
---@field parent Parse
---@field tokens LBSymbol[]
---@field symbol LBSymbol
---@field i number
---@field isReturnableScope boolean defined the type of scope, function or loop or none; for return and break keywords
---@field isLoopScope boolean
---@field errorObj any
---@field cache any
Parse = {
    ---@return Parse
    new = function(this, type, tokens, i, parent)
        -- hardcoded class instantiation for performance, as it's called very often
        return {
            new = this.new,
            branch = this.branch,
            commit = this.commit,
            error = this.error,
            match = this.match,
            consume = this.consume,
            tryConsume = this.tryConsume,
            tryConsumeRules = this.tryConsumeRules,
            tryConsumeRulesAs = this.tryConsumeRulesAs,

            i = i or 1,
            tokens = tokens,
            symbol = LBSymbol:new(type),
            parent = parent,
            isReturnableScope = parent and parent.isReturnableScope or false,
            isLoopScope = parent and parent.isLoopScope or false,
            cache = parent and parent.cache or {}
        }
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
            this.i = this.i + 1
            return true
        else
            return false
        end
    end;

    ---@param this Parse
    tryConsumeRules = function(this, ...)
        local rules = {...}
        for irules=1, #rules do
            local rule = rules[irules]

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
        end
        return false
    end;

    ---@param this Parse
    tryConsumeRulesAs = function(this, name, ...)
        local branch = this:branch(name)
        local result = branch:tryConsumeRules(...)
        if result then
            branch:commit()
        else
            branch:error("Failed to parse as " .. tostring(name))
        end
        return result
    end;
}

local exp
---@class Expressions
exp = {
    ---@param parse Parse
    Program = function(parse)
        local parse = parse:branch()

        parse:tryConsumeRules(exp.genBody(T.EOF, T.RETURN))

        if parse:tryConsumeRules(exp.ReturnStatement) then
            
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
        or parse:tryConsumeRules(
            exp.NamedFunctionDefinition,
            exp.IfStatement,
            exp.ForLoopStatement,
            exp.ForInLoopStatement,
            exp.WhileLoopStatement,
            exp.RepeatUntilStatement,
            exp.DoEndStatement,
            exp.GotoLabelStatement,
            exp.GotoStatement,
            exp.ProcessorLBTagSection,
            exp.FunctionCallStatement,
            exp.AssignmentOrLocalDeclaration,
            parse.isReturnableScope and exp.ReturnStatement or nil
        ) then
            return parse:commit()
        end

        return parse:error("Invalid statement")
    end;


    SquareBracketsIndex = function(parse)
        parse = parse:branch(S.SQUARE_BRACKETS)

        if parse:tryConsume(T.OPENSQUARE)
            and parse:tryConsumeRules(exp.Expression)
            and parse:tryConsume(T.CLOSESQUARE) then

            return parse:commit()
        end

        return parse:error("Invalid square-bracket index")
    end;

    ParenthesisExpression = function(parse)
        parse = parse:branch(S.PARENTHESIS)

        if parse:tryConsume(T.OPENBRACKET)
            and parse:tryConsumeRules(exp.Expression)
            and parse:tryConsume(T.CLOSEBRACKET) then

            return parse:commit()
        end

        return parse:error("Invalid parenthesis expression")
    end;

    TableDef = function(parse)
        parse = parse:branch(S.TABLEDEF)

        if parse:tryConsume(T.OPENCURLY) then
            
            if parse:tryConsumeRules(exp.TableValueInitialization) then
                while parse:tryConsume(T.COMMA, T.SEMICOLON) do
                    if not parse:tryConsumeRules(exp.TableValueInitialization) then
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

    ExpressionList = function(parse)
        -- a,b,c,d,e comma separated items
        parse = parse:branch()
        if parse:tryConsumeRules(exp.Expression) then
            while parse:tryConsume(T.COMMA) do
                if not parse:tryConsumeRules(exp.Expression) then
                    return parse:error("Expression list must not leave trailing ','")
                end
            end
            return parse:commit()
        end

        return parse:error("Invalid expression-list")
    end;

    ---@param parse Parse
    ReturnStatement = function(parse)
        parse = parse:branch()
        if parse:tryConsume(T.RETURN) then

            -- optional expression-list
            parse:tryConsumeRules(exp.ExpressionList)

            return parse:commit()
        end

        return parse:error("Invalid return statement")
    end;

    ---@param parse Parse
    AnonymousFunctionDef = function(parse)
        parse = parse:branch(S.FUNCTIONDEF)

        if parse:tryConsume(T.FUNCTION) 
        and parse:tryConsumeRules(exp.FunctionDefParenthesis) then

            parse.isReturnableScope = true;
            parse.isLoopScope = false;
            parse:tryConsumeRules(exp.genBody(T.END))

            if parse:tryConsume(T.END) then
                return parse:commit()
            end
        end

        return parse:error("Invalid anonymous function definition")
    end;

    ---@param parse Parse
    NamedFunctionDefinition = function(parse, ...)
        parse = parse:branch(S.FUNCTIONDEF)
        
        -- optionally local
        parse:tryConsume(T.LOCAL)

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

            if parse:tryConsumeRules(exp.FunctionDefParenthesis) then

                parse.isReturnableScope = true;
                parse.isLoopScope = false;
                parse:tryConsumeRules(exp.genBody(T.END))

                if parse:tryConsume(T.END) then
                    return parse:commit()
                end
            end
        end

        return parse:error("Invalid named-function definition")
    end;

    ---@param parse Parse
    BinaryExpression = function(parse)
        parse = parse:branch(S.OPERATORCHAIN)
        if parse:tryConsumeRules(exp.SingleExpression)
            and parse:tryConsume(T.AND, T.OR, T.MIXED_OP, T.BINARY_OP, T.COMPARISON)
            and parse:tryConsumeRules(exp.Expression) then

            return parse:commit()
        end

        return parse:error("Invalid binary expression")
    end;


    LValue = function(parse)
        parse = parse:branch() -- no typename; meaning it will simplify out

        -- messy but easier way to handle Lvalues: (saves a lot of duplication)
        -- easiest thing to do is, check if we can make a valid ExpChain and then make sure the end of it is actually modifiable
        if parse:tryConsumeRules(exp.ExpressionChainedOperator) then
            local lastChild = parse.symbol[#parse.symbol]
            if lastChild
            and lastChild[#lastChild]
            and is(lastChild[#lastChild].type, S.SQUARE_BRACKETS, T.IDENTIFIER) then
                parse.symbol.type = S.LVALUE
                return parse:commit()
            end
        end

        return parse:error("Invalid lvalue")
    end;



    ---@param parse Parse
    FunctionCallStatement = function(parse)
        parse = parse:branch()

        -- save a lot of duplication by finding a valid ExpChain and then backtracking
        if parse:tryConsumeRules(exp.ExpressionChainedOperator) then
            local lastChild = parse.symbol[#parse.symbol]
            if lastChild
            and lastChild[#lastChild]
            and is(lastChild[#lastChild].type, S.FUNCTIONCALL) then
                parse.symbol.type = S.FUNCTIONCALL
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
        if parse:tryConsume(T.IDENTIFIER) or parse:tryConsumeRules(exp.ParenthesisExpression) then
            while true do
                if parse:tryConsume(T.DOTACCESS) then -- .<name>
                    if not parse:tryConsume(T.IDENTIFIER) then
                        return parse:error("Expected identifier after '.' ")
                    end
                elseif parse:tryConsume(T.COLONACCESS) then -- :<name>(func) 
                    if not (parse:tryConsume(T.IDENTIFIER)
                        and parse:tryConsumeRules(exp.FunctionCallParenthesis)) then
                        return parse:error("Expected function call after ':'")
                    end
                elseif parse:tryConsumeRules(exp.SquareBracketsIndex, exp.FunctionCallParenthesis) then -- [123] or (a,b,c)
                    -- all OK
                else
                    return parse:commit();
                end
            end
        end

        return parse:error("Invalid expression chain")
    end;

    SingleExpression = function(parse)
        -- single expression, not lined by binary, e.g. a string, an identifier-chain, etc.
        parse = parse:branch()

        -- clear any unary operators from the front
        while parse:tryConsume(T.NOT, T.UNARY_OP, T.MIXED_OP) do end

        if parse:tryConsume(T.VARARGS, T.STRING, T.NUMBER, T.HEX, T.TRUE, T.FALSE, T.NIL)-- hard-coded value
        or parse:tryConsumeRules(
            exp.ParenthesisExpression,
            exp.ExpressionChainedOperator, -- (exp.index.index.index[index][index](func)(func)(func))
            exp.TableDef,
            exp.AnonymousFunctionDef) then
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

        if parse:tryConsumeRules(
            exp.BinaryExpression, -- (exp op exp) (infinite chain-> single_exp op (exp op exp)) etc.
            exp.SingleExpression
        ) then
            return parse:commit()
        end

        return parse:error("Invalid expression")
    end;

    genBody = function(...)
        local args = {...}

        ---@param parse Parse
        return function(parse)
            parse = parse:branch(S.BODY)

            while not parse:match(table.unpack(args)) do
                if not parse:tryConsumeRules(exp.Statement) then
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
            and parse:tryConsumeRulesAs(S.IF_CONDITION, exp.Expression)
            and parse:tryConsume(T.THEN) then
            
            -- statements, if any - may be empty
            parse:tryConsumeRules(exp.genBody(T.ELSEIF, T.ELSE, T.END))

            -- potential for elseifs (if they exist, must be well structured or return false "badly made thingmy")
            while parse:tryConsume(T.ELSEIF) do
                if not (parse:tryConsumeRulesAs(S.IF_CONDITION, exp.Expression)
                    and parse:tryConsume(T.THEN)) then
                    return parse:error("Improperly specified elseif statement")
                else
                    -- parse statements in the "elseif" section
                    parse:tryConsumeRules(exp.genBody(T.ELSEIF, T.ELSE, T.END))
                end
            end

            -- possible "else" section
            if parse:tryConsume(T.ELSE) then
                parse:tryConsumeRules(exp.genBody(T.END))
            end

            if parse:tryConsume(T.END) then
                return parse:commit()
            end
        end

        return parse:error("Invalid if Statement")
    end;

    ---@param parse Parse
    AssignmentOrLocalDeclaration = function(parse)
        parse = parse:branch(S.ASSIGNMENT)
        local isLocal = parse:tryConsume(T.LOCAL)
        
        if parse:tryConsumeRules(exp.LValue) then -- check last part of the EXPCHAIN was assignable
            
            -- now check repeatedly for the same, with comma separators
            --   return false if a comma is provided, but not a valid assignable value
            while parse:tryConsume(T.COMMA) do
                if not parse:tryConsumeRules(exp.LValue) then
                    return parse:error("Expected lvalue after comma")
                end
            end

            if parse:tryConsume(T.ASSIGN) then -- equals sign "="
                -- expect a list of expressions to assign
                if parse:tryConsumeRules(exp.ExpressionList) then
                    return parse:commit()
                end
            elseif isLocal then
                -- if declared local, can be a simple "local statement" with no value - as rare as that is
                parse.symbol.type = S.DECLARE_LOCAL
                return parse:commit()
            end
        end

        return parse:error("Invalid Assignment/Local Declaration")
    end;



    ---@param parse Parse
    FunctionCallParenthesis = function(parse)
        parse = parse:branch(S.FUNCTIONCALL)
        if  parse:tryConsume(T.OPENBRACKET) then

            -- can be empty parens
            parse:tryConsumeRules(exp.ExpressionList)

            if parse:tryConsume(T.CLOSEBRACKET) then
                return parse:commit()
            end
        elseif parse:tryConsume(T.STRING) then
            -- alternate way to call functions, abyssmal addition to the language 
            return parse:commit()
        elseif parse:tryConsumeRules(exp.TableDef) then
            -- equally mental way of calling functions, please refrain from this
            return parse:commit()
        end

        return parse:error("Invalid function call parenthesis")
    end;

    TableAssignment = function(parse)
        parse = parse:branch(S.ASSIGNMENT)
        if parse:tryConsumeRules(exp.SquareBracketsIndex)
            or parse:tryConsume(T.IDENTIFIER) then

            if parse:tryConsume(T.ASSIGN) 
                and parse:tryConsumeRules(exp.Expression) then

                return parse:commit()
            end
        end

        return parse:error("Invalid table assignment")
    end;

    TableValueInitialization = function(parse)
        parse = parse:branch()
        if parse:tryConsumeRules(
            exp.TableAssignment,
            exp.Expression
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
                and parse:tryConsumeRules(exp.Expression) 
                and parse:tryConsume(T.COMMA)
                and parse:tryConsumeRules(exp.Expression) then

                -- optional 3rd parameter (step)
                if parse:tryConsume(T.COMMA)
                    and not parse:tryConsumeRules(exp.Expression) then
                    return parse:error("Trailing ',' in for-loop definition")
                end

                if parse:tryConsume(T.DO)
                and parse:tryConsumeRules(exp.genBody(T.END))
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
                and parse:tryConsumeRules(exp.Expression) then

                    -- can now handle as many additional params as wanted
                    while parse:tryConsume(T.COMMA) do
                        if not parse:tryConsumeRules(exp.Expression) then
                            return parse:error("Trailing ',' in for-loop definition")
                        end
                    end

                    if parse:tryConsume(T.DO)
                    and parse:tryConsumeRules(exp.genBody(T.END))
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
        and parse:tryConsumeRules(exp.Expression)
        and parse:tryConsume(T.DO)
        and parse:tryConsumeRules(exp.genBody(T.END))
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
        and parse:tryConsumeRules(exp.genBody(T.UNTIL))
        and parse:tryConsume(T.UNTIL)
        and parse:tryConsumeRules(exp.Expression) then
            return parse:commit()
        end

        return parse:error("Invalid repeat-until loop");
    end;

    DoEndStatement = function(parse)
        parse = parse:branch(S.DO_END)
        parse.isReturnableScope = true

        if parse:tryConsume(T.DO)
        and parse:tryConsumeRules(exp.genBody(T.END))
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

    ProcessorLBTagSection = function(parse)
        parse = parse:branch(S.LBTAG_SECTION)
        if parse:tryConsume(T.LBTAG_START) 
        and parse:tryConsumeRules(exp.FunctionCallParenthesis)
        and parse:tryConsumeRules(exp.genBody(T.LBTAG_END))
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

--- links up nodes with better metadata
--- prepares the AST to actually be used; so it's less confusing
--- things like lbtags
---@param tree LBSymbol
restructure = function(tree)
    simplify(tree)

    return tree
end;

---restructures the tree to be simpler
---@param tree LBSymbol
simplify = function(tree)
    local i = 1   
    while i <= #tree do
        local child = tree[i]

        if not child.type or (tree.type == child.type) then
            
            if child[1] then
                tree[i] = child[1]
            end
            for ichild=2, #child do
                table.insert(tree, i+ichild-1, child[ichild])
            end
        else
            simplify(tree[i])
            i = i + 1
        end 
    end

    return tree
end;

local s = require("socket")

parse = function(text)
    local startTime = s.gettime()
    local tokens = tokenize(text)

    print("tokenize time: " .. tostring(s.gettime() - startTime)) -- 2.3634777069092 (improved)

    startTime = s.gettime()
    local parser = Parse:new(nil, tokens, 1)
    local result = exp.Program(parser)
    print("parse time: " .. tostring(s.gettime() - startTime)) -- 0.5665168762207 (improved?)

    if not result then
        error(parser.errorObj:toString())
    end
    
    return simplify(parser.symbol)
end;



local text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]))

local parsed = parse(text)

LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\gen1.lua]]),
    toString(parsed))

__simulator:exit()

