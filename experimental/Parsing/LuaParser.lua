require("Parsing.LuaTree")
require("Parsing.LuaTreeTypes")



---@class LuaParser
LifeBoatAPI.Tools.LuaParser = {
    parse = function(text, tag)
        
        local this = LifeBoatAPI.Tools.LuaParser
        local LBStr = LifeBoatAPI.Tools.StringUtils
        local LBTree = LifeBoatAPI.Tools.LuaTree
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes
        local content = {}

        local nextText = ""
        local i = 1

        --lex
        while i <= #text do
            if LBStr.nextSectionIs(text, i, "\\") then
                i, nextText = i+1, text:sub(i,i+1)
                content[#content+1] = LBTree:new(LBTypes.lua, nextText)

            elseif LBStr.nextSectionIs(text, i, '"') then
                -- quote (")
                i, nextText = LBStr.getTextIncluding(text, i+1, '"')
                nextText = '"' .. nextText
                content[#content+1] = LifeBoatAPI.Tools.LuaTree_String:new(nextText, nextText:sub(2,-2))

            elseif LBStr.nextSectionIs(text, i, "'") then
                -- quote (')
                i, nextText = LBStr.getTextIncluding(text, i+1, "'")
                nextText = "'" .. nextText
                content[#content+1] = LifeBoatAPI.Tools.LuaTree_String:new(nextText, nextText:sub(2,-2))

            elseif LBStr.nextSectionIs(text, i, "%[%[") then
                -- quote ([[ ]])
                i, nextText = LBStr.getTextIncluding(text, i, "%]%]")
                content[#content+1] = LifeBoatAPI.Tools.LuaTree_String:new(nextText, nextText:sub(2,-2))   

            elseif LBStr.nextSectionIs(text, i, "%-%-%-@lb") then
                -- preprocessor tag
                i, nextText = LBStr.getTextUntil(text, i, "\n")
                content[#content+1] = LifeBoatAPI.Tools.LuaTree_LBTag:new(nextText)

            elseif LBStr.nextSectionIs(text, i, "%-%-%[%[") then
                -- multi-line comment
                i, nextText = LBStr.getTextIncluding(text, i, "%]%]")
                content[#content+1] = LBTree:new(LBTypes.comment, nextText)

            elseif LBStr.nextSectionIs(text, i, "%-%-") then
                -- single-line comment
                i, nextText = LBStr.getTextUntil(text, i, "\n")
                content[#content+1] = LBTree:new(LBTypes.comment, nextText)

            elseif LBStr.nextSectionIs(text, i, "%(") then
                -- regular brackets
                i, content[#content+1] = LifeBoatAPI.Tools.LuaTree_Brackets:new(text, i, "(", ")", ",")

            elseif LBStr.nextSectionIs(text, i, "%[") then 
                -- indexing brackets
                i, content[#content+1] = LifeBoatAPI.Tools.LuaTree_Brackets:new(text, i, "[", "]", nil)
                content[#content].type = LBTypes.index

            elseif LBStr.nextSectionIs(text, i, "%{") then 
                -- table
                i, content[#content+1] = LifeBoatAPI.Tools.LuaTree_Brackets:new(text, i, "{", "}", {",",";"})
                content[#content].type = LBTypes.table

            elseif LBStr.nextSectionIs(text, i, "%.%.%.") then
                -- varargs
                i, nextText = LBStr.getTextIncluding(text, i, "%.%.%.")
                content[#content+1] = LBTree:new(LBTypes.varargs, nextText) 

            elseif LBStr.nextSectionIs(text, i, "%.%.") then
                -- concat
                i, nextText = LBStr.getTextIncluding(text, i, "%.%.")
                content[#content+1] = LBTree:new(LBTypes.concat, nextText) 

            elseif LBStr.nextSectionIs(text, i, "[><=~]=") then
                -- comparison
                i, nextText = LBStr.getTextIncluding(text, i, "[><=~]=")
                content[#content+1] = LBTree:new(LBTypes.comparison, nextText) 

            elseif LBStr.nextSectionIs(text, i, "=") then
                -- assignment
                i, nextText = LBStr.getTextIncluding(text, i, "=")
                content[#content+1] = LBTree:new(LBTypes.assignment, nextText) 

            elseif LBStr.nextSectionIs(text, i, "[%.:]") then
                -- chain access
                i, nextText = LBStr.getTextIncluding(text, i, "[%.:]")
                content[#content+1] = LBTree:new(LBTypes.accessor, nextText) 

            elseif LBStr.nextSectionIs(text, i, "[%a_][%w_]*") then
                -- keywords & identifier
                i, nextText = LBStr.getTextIncluding(text, i, "[%a_][%w_]*")
                if this._isKeyword(nextText) then
                    content[#content+1] = LBTree:new(LBTypes.keyword, nextText) 
                elseif this._isTypeConstant(nextText) then
                    content[#content+1] = LBTree:new(LBTypes.typeconstant, nextText) 
                else
                    content[#content+1] = LBTree:new(LBTypes.identifier, nextText) 
                end

            elseif LBStr.nextSectionIs(text, i, "%s+") then
                -- whitespace
                i, nextText = LBStr.getTextIncluding(text, i, "%s*")
                content[#content+1] = LBTree:new(LBTypes.whitespace, nextText)

            elseif LBStr.nextSectionIs(text, i, "0x%x+") then
                -- hex 
                i, nextText = LBStr.getTextIncluding(text, i, "0x%x+")
                content[#content+1] = LBTree:new(LBTypes.hex, nextText)

            elseif LBStr.nextSectionIs(text, i, "%x*%.?%x+") then 
                -- number
                i, nextText = LBStr.getTextIncluding(text, i, "%x*%.?%x+")
                content[#content+1] = LBTree:new(LBTypes.number, nextText)

            else
                -- regular/lua text
                i, nextText = LBStr.getTextUntil(text, i, 
                "=", "[><=~]=",
                "[%(%{%[]",
                "[%.:]",
                "%x*%.?%x+", "0x%x+",
                "\\",
                "%s+",
                "[%a_][%w_]*",
                "%-%-",
                '"', "'",
                "%[%[")
                content[#content+1] = LBTree:new(LBTypes.lua, nextText)
            end
        end

        -- parse
        local tree = content
        this._groupIdentifiers(tree)
        tree = this._buildTagTree(tree, tag or "program")
        this._groupPotentialMacroCalls(tree)

        return tree
    end;

    _buildTagTree = function(contentList, tag)
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes
        local tree = LifeBoatAPI.Tools.LuaTree:new(tag)

        for i = 1, #contentList do
            local content = contentList[i] or {}
    
            if content.type == LBTypes.lbtag then
                local firstIdentifier = content.brackets:child(LBTypes.param):child(LBTypes.identifierchain)
                local firstKeyword = content.brackets:child(LBTypes.param):child(LBTypes.keyword)
                content.tag = (firstIdentifier and firstIdentifier.identifierFull) or (firstKeyword and firstKeyword.raw)

                if not content.tag then
                    error("Parse rule error - tag missing first param")
                end

                if content.tag == "end" then
                    tree.endTag = content
    
                    if not tree.parent then
                        error("Too many ---@lb(end) tags")
                    end
                    tree = tree.parent
                else
                    tree[#tree+1] = content
                    content.parent = tree
                    tree = content
                end
            else
                tree[#tree+1] = content
            end
        end
    
        if tree.parent then
            error("Missing ---@lb(end) tag")
        end
    
        return tree
    end;

    
    
    _keywords = {
        ["and"]     = 1 ,["break"] = 1 ,["do"]       = 1 ,["else"]  = 1 ,["elseif"] = 1
        ,["end"]    = 1 ,["for"]   = 1 ,["function"] = 1 ,["goto"]  = 1 ,["if"]     = 1
        ,["in"]     = 1 ,["local"] = 1 ,["not"]      = 1 ,["or"]    = 1 ,["repeat"] = 1
        ,["return"] = 1 ,["then"]  = 1 ,["until"]    = 1 ,["while"] = 1
    };

    _isKeyword = function(text)
        return LifeBoatAPI.Tools.LuaParser._keywords[text]
    end;

    _typeconstants = {
        ["nil"] = 1, ["true"] = 1, ["false"] = 1
    };

    _isTypeConstant = function(text)
        return LifeBoatAPI.Tools.LuaParser._typeconstants[text]
    end;

    ---@param tree LuaTree
    _groupIdentifiers = function(tree)
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes

        local i = 0
        while i < #tree do
            i = i + 1
            local node = tree[i]
            
            -- go through all nodes that are identifiers,
            -- chain all subsequent identifiers together (all identifiers become identifier-chain -> child identifiers + accessors)
            if node.type == LBTypes.identifier then
                local newNode = LifeBoatAPI.Tools.LuaTree:new(LBTypes.identifierchain)
                newNode.identifierFull = node.raw
                newNode.identifierBase = node.raw
                newNode[#newNode+1] = node

                local lastChainIndex = i
                local queuedNodes = {} -- nodes that could be in the chain, if a closer (e.g. identifier/accessor/etc.) is found. Normally whitespace
                local j = i
                while j < #tree do
                    j=j+1
                    local chained = tree[j]
                    if chained.type == LBTypes.identifier or chained.type == LBTypes.accessor then
                        -- identifiers and separators combine to the shortened name, e.g. a.b.c.d
                        for queuedIndex=1,#queuedNodes do
                            newNode[#newNode+1] = queuedNodes[queuedIndex]
                        end
                        queuedNodes = {}
                        newNode.identifierFull = newNode.identifierFull .. chained.raw
                        newNode[#newNode+1] = chained
                        lastChainIndex = j

                    elseif chained.type == LBTypes.whitespace then
                        -- whitespace ignored but kept
                        queuedNodes[#queuedNodes+1] = chained

                    else
                        -- end of "stuff that can go into an identifier chain"
                        break;
                    end
                end

                -- replace the parts of the tree we're grouping
                -- i+1 should now be the next node we've not checked
                tree[i] = newNode
                for removalIndex=lastChainIndex,i+1,-1 do
                    table.remove(tree, removalIndex)
                end
            elseif node.type ~= LBTypes.identifierchain then
                LifeBoatAPI.Tools.LuaParser._groupIdentifiers(node);
            end
        end
        return tree
    end;

    ---@param tree LuaTree
    _groupPotentialMacroCalls = function(tree)
        -- we only really want this, for handling macro expansion
        -- so we only care about plain identifier.chain(a,b,c) and not e.g. ident.chain.abc[123](a,b,c)(d,e,f) as is of course possible
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes

        local lastKeywordWasFunction = false
        local i = 0
        while i < #tree do
            i = i + 1
            local node = tree[i]
            
            -- check that we're not picking up a function definition instead (function abc.def(a,b,c) ... end)
            if node.type == LBTypes.keyword and node.raw == "function" then
                lastKeywordWasFunction = true
            elseif node.type ~= LBTypes.whitespace
                    and node.type ~= LBTypes.identifierchain
                    and node.type ~= LBTypes.identifier then
                lastKeywordWasFunction = false
            end

            -- go through all nodes that are identifiers,
            -- chain all subsequent identifiers together (all identifiers become identifier-chain -> child identifiers + accessors)
            if node.type == LBTypes.identifierchain and not lastKeywordWasFunction then
                local newNode = LifeBoatAPI.Tools.LuaTree_MacroCall:new()
                newNode.identifier = node

                local lastChainIndex = nil

                if tree[i+1] and tree[i+1].type == LBTypes.brackets then
                    newNode.brackets = tree[i+1]
                    lastChainIndex=i+1
                elseif tree[i+2] and tree[i+1].type == LBTypes.whitespace and tree[i+2].type == LBTypes.brackets then
                    newNode[#newNode+1] = tree[i+1]
                    newNode.brackets = tree[i+2]
                    lastChainIndex=i+2
                end

                -- replace the parts of the tree we're grouping
                -- i+1 should now be the next node we've not checked
                if lastChainIndex then
                    tree[i] = newNode
                    for removalIndex=lastChainIndex,i+1,-1 do
                        table.remove(tree, removalIndex)
                    end
                end
            elseif node.type ~= LBTypes.possibleMacroCall then
                LifeBoatAPI.Tools.LuaParser._groupPotentialMacroCalls(node);
            end
        end
        return tree
    end;
}
