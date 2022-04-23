require("Parsing.parse")
local T = LBTokenTypes
local S = LBSymbolTypes

-- macro stuff?


removeComments = function(tree)
    -- remove all comment elements
    treeForEach(tree,
        function(current)
            for i=#current,1,-1 do
                if current[i].type == T.COMMENT then
                    table.remove(current, i)
                end
            end
        end)

    combineConsecutiveWhitespace(tree)
    
    return tree
end;

shortenVariables = function(tree)
end;

shortenExternalGlobals = function(tree)
end;

convertHexadecimals = function(tree)
end;

reduceNumberDuplicates = function(tree)
end;

reduceStringDuplicates = function(tree)
end;


combineConsecutiveWhitespace = function(tree)
    -- remove all comment elements
    treeForEach(tree,
        function(current)
            for i=#current,2,-1 do
                if current[i].type == T.WHITESPACE and current[i-1].type == T.WHITESPACE then
                    current[i-1].raw = current[i-1].raw .. current[i].raw
                    table.remove(current, i)
                end
            end
        end)

    return tree
end;

shrinkWhitespaceBlocks = function(tree)
    local LBStr = LifeBoatAPI.Tools.StringUtils
    -- any whitespace surrounding certain operators can be stripped "for free"
    treeForEach(tree,
        function(current)
            if current.type == T.WHITESPACE then
                if LBStr.count(current.raw, "\n") > 0 then
                    current.raw = "\n"
                else
                    current.raw = " "
                end
            end
        end)

    return tree
end;

removeUnecessaryWhitespaceBlocks = function(tree)
    local stripWhitespace;
    stripWhitespace = function(t)
        for i=#t, 1, -1 do
            if t[i].type == T.WHITESPACE then
                table.remove(t, i)
            end
        end
    end;
    
    -- any whitespace surrounding certain operators can be stripped "for free"
    local lastNonWitespace = nil
    treeForEach(tree,
        function(current)
            if  (not lastNonWitespace) 
                or is(current.type, T.BINARY_OP, T.COLONACCESS, T.DOTACCESS, T.MIXED_OP, T.UNARY_OP, T.COMPARISON, T.OPENCURLY,  T.OPENBRACKET,  T.OPENSQUARE,  T.ASSIGN, T.STRING, T.COMMA, T.SEMICOLON, T.VARARGS)
                or is(lastNonWitespace.type,    T.BINARY_OP, T.COLONACCESS, T.DOTACCESS, T.MIXED_OP, T.UNARY_OP, T.COMPARISON, T.CLOSECURLY, T.CLOSEBRACKET, T.CLOSESQUARE, T.ASSIGN, T.STRING, T.COMMA, T.SEMICOLON, T.VARARGS)
                then
                stripWhitespace(current)
            end

            lastNonWitespace = (current.raw and current.type ~= T.WHITESPACE and current) or lastNonWitespace
        end)

    return tree
end;

treeForEach = function (tree, func)
    local foreachInTree;
    foreachInTree = function(subtree)
        for i=1,#subtree do
            foreachInTree(subtree[i])
            func(subtree[i])
        end
    end;
    foreachInTree(tree)
end