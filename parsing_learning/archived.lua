
getTokensWhile = function(tokens, i, endTokenSet, inclusiveSet)
    local S = LBSymbolTypes
    i = i or 1
    
    local symbols = {}
    while i <= #tokens do
        local nextToken = tokens[i]
        if inclusiveSet and not inclusiveSet[nextToken.type] then
            return i, symbols, nextToken
        
        elseif endTokenSet and endTokenSet[nextToken.type] then
            return i, symbols, nextToken
        else
            symbols[#symbols+1] = LBSymbol:fromToken(nextToken.type)
            print("skipping " .. tokens[i].type .. ", " .. tokens[i].raw)
            i = i + 1
        end
    end

    return i, symbols, nil
end;


findSymbol = function(symbolList, iSymbolList, ...)
    local symbols = {...}

    while iSymbolList <= #symbolList do
        for iSymbol=1, #symbols do
            if symbols[iSymbol] == symbolList[iSymbolList] then
                return symbolList[iSymbolList], iSymbolList
            end
        end

        iSymbolList = iSymbolList + 1
    end

    return nil
end


parseParamList = function(tokens, i)
    local T = LBTokenTypes
    local S = LBSymbolTypes

    local brackets = LBSymbol:new(S.PARAMLIST)
    brackets[#brackets+1] = LBSymbol:new(S.OPENBRACKET, T.OPENBRACKET, "(")
    i=i+1

    while endToken.type ~= T.CLOSEBRACKET do
        local param = LBSymbol:new(S.PARAM)
        i, parsed, endToken = parse(tokens, i, set(T.CLOSEBRACKET, T.COMMA))
        insertIntoTable(brackets, parsed)
    end
    brackets[#brackets+1] = LBSymbol:new(S.CLOSEBRACKET, endToken.type, endToken.raw)
    i=i+1

    return i, brackets
end;



parseParen = function(tokens, i)
end;

parseRHS = function(tokens, i)
end;

parseFunctionBody = function(tokens, i)
end;

---@param tokens LBToken[]
---@return LBSymbol[]
parse2 = function(tokens, i, endTokenSet, inclusiveSet)
    local T = LBTokenTypes
    local S = LBSymbolTypes
    i = i or 1
    local parsed = nil;
    
    local symbols = {}
    while i <= #tokens do
        local nextToken = tokens[i]
        if inclusiveSet and not inclusiveSet[nextToken.type] then
            return i, symbols, nextToken
        
        elseif endTokenSet and endTokenSet[nextToken.type] then
            return i, symbols, nextToken

        elseif nextToken.type == T.IDENTIFIER then
            -- identifier chain
            -- handle accessors as part of the same chain?
            -- do we need a 3rd parse to get the function calls maybe?
            -- have we made a mess of all of this again? thinking we're being smart
            --#region
            -- really hate this right now
            -- effectively, got the entire language grammar to parse if we want to do it right
            -- I can see why whitespace gets removed from the tokens, although it's relatively important to keep it in there
            --   IDENTIFIER - WHITESPACE - ACCESSOR or IDENTIFIER -ACCESSOR harder than; IDENTIFIER - [ACCESSOR|IDENTIFIER] - IDENTIFIER is easier
            -- if we assume we tokenized correctly, what's the best way to consume the symbols
            -- should each token hold the whitespace for the next one? to simplify
            i, parsed = getTokensWhile(tokens, i, nil, set(T.IDENTIFIER, T.ACCESSOR, T.WHITESPACE))
            symbols[#symbols+1] = insertIntoTable(LBSymbol:new(S.IDENTIFIER_CHAIN), parsed)

        elseif nextToken.type == T.FUNCTION then
            -- function definition
            local functionDef = LBSymbol:new(S.FUNCTIONDEF)

            -- "function" + identifier -> brackets, part
            i, parsed, endToken = parse(tokens, i, set(T.OPENBRACKET))
            insertIntoTable(functionDef, parsed)
            functionDef.identifier = findSymbol(parsed, 1, S.IDENTIFIER_CHAIN)
            
            -- "brackets" (...,...,...)
            i, functionDef.paramList = parseParamList(tokens, i)
            insertIntoTable(functionDef, functionDef.paramList)

            -- actual function body up to, including end
            i, parsed, endToken = parse(tokens, i, set(T.END))
            parsed[#parsed+1] = LBSymbol:new(S.TOKEN, endToken.type, endToken.raw)
            insertIntoTable(functionDef, parsed)
            functionDef.body = parsed
            
            symbols[#symbols+1] = functionDef
            
        elseif false then

        elseif nextToken.type == T.IF then
            -- if statement


        elseif nextToken.type == T.WHILE then
            -- while loop
        elseif nextToken.type == T.FOR then
            -- for loop
        elseif nextToken.type == T.DO then
            -- code block
        elseif nextToken.type == T.REPEAT then
            -- repeat until
        else
            symbols[#symbols+1] = LBSymbol:new(S.TOKEN, nextToken.type, nextToken.raw)
            print("skipping " .. tokens[i].type .. ", " .. tokens[i].raw)
            i = i + 1
        end
    end

    return i, symbols, nil
end;







Parser = {
    new = function(this, tokens)
        this = LifeBoatAPI.Tools.BaseClass.new(this)
        this.i = 1
        this.tokens = tokens
        return this
    end;


    parseTable = function(tokens, i)
        -- nightmare

    end;

    -- this whole thing is stupid 
    -- all we wanted, was a way to parse the lbtags effectively
    -- find the macro calls
    -- and find the NAMED variable chains
    -- there's not much other analysis we want to do really
    -- maybe removing any separators next to }s?


    parseRoot = function(tokens, i)
        local symbols = {}
        local result = nil

        while i <= #tokens do
            -- group up any non-useful parsable stuff
            i, symbols[#symbols+1] = tryParseNonFunctional(tokens, i)

            if tokens[i].type == T.FUNCTION then
                -- named function definition
                parseNamedFunction()

            elseif is(tokens[i].type, T.IDENTIFIER) then
                -- could either be a function call, or an assignment
                -- this is a nightmare

            elseif is(tokens[i].type, T.OPENBRACKET) then
                -- function call
                parseFunctionCall();

            elseif tokens[i].type == T.OPENCURLY then
                -- table def
                parseTableDef();

            -- new scope blocks
            elseif tokens[i].type == T.IF then
                -- if statement

            elseif tokens[i].type == T.WHILE then
                -- while loop

            elseif tokens[i].type == T.FOR then
                -- for loop

            elseif tokens[i].type == T.DO then
                -- code block

            elseif tokens[i].type == T.REPEAT then
                -- repeat until

            else
                --unclassified (symbols that just become a "lua statement")
                symbols[#symbols+1] = LBSymbol:fromToken(tokens[i])
                print("skipping " .. tokens[i].type .. ", " .. tokens[i].raw)
                i = i + 1
            end
        end

        return i, symbols, nil
    end


}
