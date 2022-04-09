LifeBoatAPI.Tools.LuaParseTypes = {
    lua = "lua",
    string = "string",
    comment = "comment",
    brackets = "brackets",
    index = "index",
    table = "table",
    accessor = "accessor",
    varargs = "varargs",
    concat = "concat",
    assignment = "assignment",
    whitespace = "whitespace",
    identifier = "identifier",
    hex = "hex",
    number = "number",
    possibleMacroCall = "functioncall",
    keyword = "keyword",
    typeconstant = "typeconstant",
    param = "param",
    tag = "tag",
    identifierchain = "identifierchain"
}


LifeBoatAPI.Tools.LuaParser = {
    parse = function(text, tag)
        local this = LifeBoatAPI.Tools.LuaParser
        local LBStr = LifeBoatAPI.Tools.StringUtils
        local LBTree = LifeBoatAPI.Tools.LuaTree
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes
        local content = {}

        local nextText = ""
        local i = 1

        while i <= #text do
            if LBStr.nextSectionIs(text, i, "\\") then
                i, nextText = i+1, text:sub(i,i+1)
                content[#content+1] = LBTree:new(LBTypes.lua, nextText)

            elseif LBStr.nextSectionIs(text, i, '"') then
                -- quote (")
                i, nextText = LBStr.getTextIncluding(text, i+1, '"')
                nextText = '"' .. nextText
                content[#content+1] = LBTree:new(LBTypes.string, nextText, {stringContent = nextText:sub(2,-2)})

            elseif LBStr.nextSectionIs(text, i, "'") then
                -- quote (')
                i, nextText = LBStr.getTextIncluding(text, i+1, "'")
                nextText = "'" .. nextText
                content[#content+1] = LBTree:new(LBTypes.string, nextText, {stringContent = nextText:sub(2,-2)})

            elseif LBStr.nextSectionIs(text, i, "%[%[") then
                -- quote ([[ ]])
                i, nextText = this:getTextIncluding(text, i, "%]%]")
                content[#content+1] = LBTree:new(LBTypes.string, nextText, {stringContent = nextText:sub(3,-3)})       

            elseif LBStr.nextSectionIs(text, i, "%-%-%-@lb") then
                -- preprocessor tag
                i, nextText = LBStr.getTextUntil(text, i, "\n")
                content[#content+1] = this._newTag(nextText)

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
                i, content[#content+1] = this._parseBrackets(LBTypes.brackets, text, i, "(", ")", ",")

            elseif LBStr.nextSectionIs(text, i, "%[") then 
                -- indexing brackets
                i, content[#content+1] = this._parseBrackets(LBTypes.index, text, i, "[", "]", nil)

            elseif LBStr.nextSectionIs(text, i, "%{") then 
                -- table
                i, content[#content+1] = this._parseBrackets(LBTypes.table, text, i, "{", "}", {",",";"})

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

        local tree = content
        this.collapseLuaNodes(tree)
        this.groupIdentifiers(tree)
        tree = this._buildTagTree(content, tag or "program")
        this._groupPotentialMacroCalls(tree)

        return tree
    end;

    _buildTagTree = function(contentList, tag)
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes
        local tree = LifeBoatAPI.Tools.LuaTree:new(tag)

        for i = 1, #contentList do
            local content = contentList[i] or {}
    
            if content.type == LBTypes.tag then
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

    _parseBrackets = function(tag, text, startIndex, openCharacter, closeCharacter, separators)
        local LBStr = LifeBoatAPI.Tools.StringUtils
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes
        local LBTree = LifeBoatAPI.Tools.LuaTree
        local this = LifeBoatAPI.Tools.LuaParser

        separators = (type(separators) == LBTypes.table and separators) or {separators}
        isSeparator = function(c)
            for i=1,#separators do
                if c == separators[i] then
                    return true
                end
            end
            return false
        end;

        local children = {}
        local brackets = 0
        local currentCapture = ""
        local endIndex = startIndex
        for i=startIndex, #text do
            endIndex = i
            local c = text:sub(i,i)
            if brackets == 1 and isSeparator(c) then
                children[#children+1] = this.parse(currentCapture, LBTypes.param)
                children[#children+1] = LBTree:new(LBTypes.lua, c)
                currentCapture = ""
            elseif c == closeCharacter then
                -- close )
                brackets = brackets - 1
                
                if brackets == 0 then
                    if #currentCapture > 0 then
                        children[#children+1] = this.parse(currentCapture, LBTypes.param)
                    end
                    children[#children+1] = LBTree:new(LBTypes.lua, closeCharacter)
                    break;
                else
                    currentCapture = currentCapture .. c
                end
            elseif c == openCharacter then
                -- open (
                brackets = brackets + 1
                if brackets == 1 then
                    children[#children+1] = LBTree:new(LBTypes.lua, openCharacter)
                else
                    currentCapture = currentCapture .. c
                end
            else
                currentCapture = currentCapture .. c
            end
        end
    
        if brackets > 0 then
            error("Format error, missing closing brackets at:" .. tostring(startIndex))
        end
    
        -- quick-access list, not modifyable
        local tree = LifeBoatAPI.Tools.LuaTree:new(tag or LBTypes.brackets, nil, children)


        return endIndex+1, tree
    end;



    _newTag = function(tagtext)
        local LBStr = LifeBoatAPI.Tools.StringUtils
        local this = LifeBoatAPI.Tools.LuaParser
        local LBTree = LifeBoatAPI.Tools.LuaTree
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes

        local tag = LBTree:new(LBTypes.tag)

        local contentIndex, startText = LBStr.getTextUntil(tagtext, 1, "%(")
        tag.startText = startText

        local endIndex, bracketParse = this._parseBrackets(LBTypes.tag, tagtext, contentIndex, "(", ")", ",")
        local trailingText = tagtext:sub(endIndex)
        if #trailingText > 0 then
            bracketParse[#bracketParse + 1] = LBTree:new(LBTypes.lua, trailingText)
        end

        tag.brackets = bracketParse
        tag.outputRaw = true
        tag.toString = function(this)
            local result = {}

            if this.outputRaw then
                result[#result+1] = this.startText
                result[#result+1] = this.brackets:toString()    
            end

            for i=1,#this do
                result[#result+1] = this[i]:toString()
            end

            if this.outputRaw and this.endTag then
                result[#result+1] = this.endTag:toString()   
            end

            return table.concat(result)
        end

        return tag
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
    groupIdentifiers = function(tree)
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
                LifeBoatAPI.Tools.LuaParser.groupIdentifiers(node);
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
                local newNode = LifeBoatAPI.Tools.LuaTree:new(LBTypes.possibleMacroCall)
                newNode.identifier = node

                newNode.toString = function(this)
                    local result = {
                        this.identifier:toString()
                    }
                    for a=1,#this do
                        result[#result+1] = this[a]:toString()
                    end
                    result[#result+1] = this.brackets:toString()
                    return table.concat(result)
                end

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

    ---@param tree LuaTree
    ---@return LuaTree
    collapseLuaNodes = function(tree)
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes

        local lastContent = {type="none"}
        for i=#tree,1,-1 do -- reverse for deletion
            local content = tree[i]
            if content.type == LBTypes.lua and lastContent.type == LBTypes.lua then
                content.raw = content.raw .. lastContent.raw
                table.remove(tree, i+1)
            else
                LifeBoatAPI.Tools.LuaParser.collapseLuaNodes(content)
            end
            lastContent = content
        end
        return tree
    end;
}


---@class LuaTree
---@field type string
---@field raw string
LifeBoatAPI.Tools.LuaTree = {
    ---@return LuaTree
    new = function(this, type, raw, other)
        this = LifeBoatAPI.Tools.BaseClass.new(this)
        this.type = type
        this.raw = raw
        this.filter = this.deepCopy;
        for k,v in pairs(other or {}) do
            this[k] = v
        end
        return this
    end;
    
    children = function (this, typeName)
        local children = {}
        for i=1,#this do
            if this[i].type == typeName then
                children[#children+1] = this[i]
            end
        end
        return children
    end;

    child = function (this, typeName, index)
        index = index or 1
        local found = 0
        for i=1,#this do
            if this[i].type == typeName then
                found = found + 1
                if found == index then
                    return this[i], i
                end
            end
        end
        return nil, nil
    end; 


    ---@param this LuaTree
    ---@param applyToType string
    ---@param func fun(tree:LuaTree, i:number, content:LuaTree)
    forEach = function(this, applyToType, func)
        for i=1,#this do
            local content = this[i]
            if not applyToType or content.type == applyToType then
                func(this, i, content)
            end
            content:forEach(applyToType, func)
        end
        return this
    end;

    ---@param this LuaTree
    ---@param node LuaTree
    ---@return LuaTree
    shallowCopy = function(this, node)
        local copy = {}
        for k,v in pairs(node) do
            copy[k] = v
        end
        return copy
    end;
    
    ---@param this LuaTree
    ---@param shouldCopyPredicate fun(tree:LuaTree, i:number, content:LuaTree) : boolean
    ---@return LuaTree
    deepCopy = function(this, shouldCopyPredicate)
        local result = this:shallowCopy(this)
        result = {}
    
        for i=1,#this do
            local content = this[i]
            if not shouldCopyPredicate or shouldCopyPredicate(this, i, content) then
                result[#result+1] = content:deepCopy(content, shouldCopyPredicate)
            end
        end
        return result
    end;

    ---@param this LuaTree
    ---@return string
    toString = function(this)
        local result = {this.raw}
        for i=1,#this do
            result[#result+1] = this[i]:toString()
        end
        return table.concat(result)
    end;

    ---@return LuaTree[]
    flatten = function(this, condition)
        local flattened = {}
        for i=1,#this do
            local node = this[i]
            if not condition or condition(this,i,node) then
                flattened[#flattened+1] = node
            end

            local nodeChildren = node:flatten(condition)
            for nodeIndex=1,#nodeChildren do
                flattened[#flattened+1] = nodeChildren[nodeIndex]
            end
        end
        return flattened
    end;

    ---@param this LuaTree
    ---@param index number
    ---@param contentList LuaTree[]
    insert = function(this, index, contentList)
        for i=#contentList, 1, -1 do
            table.insert(this, index, contentList[i])
        end
        return this
    end;
    
    ---@param this LuaTree
    ---@param index number
    ---@param contentList LuaTree[]
    replace = function(this, index, contentList)
        table.remove(this, index)
        this:insert(index, contentList)
    end;
}



-- probably want to extend this for each type of thing, e.g. tag/function call
-- we need function-calls to be separate, so we can find them for macro use

-- otherwise we don't really care too much I don't think?
-- the rest are all pretty well just raw text, so nothing special there
-- it's just grouping function calls we want
-- and tags
-- tags behave a little differently, because we may want to simply remove the tag part, but leave the rest
-- and want that to be done easily


---@param this LuaTree_MinifyStringDuplicates
---@param variableNamer VariableRenamer
---@param tree LuaTree
---@return LuaTree
removeStringDuplicates = function(this, variableNamer, tree, avoidCopy)
    if not avoidCopy then
        tree = tree:deepCopy()
    end

    local stringsFound = {}
    tree:forEach("string",
        function(t,c)
            stringsFound[c.stringContent] = (stringsFound[c.stringContent] or 0) + 1
        end)
    
    for k,v in pairs(stringsFound) do
        stringsFound[k] = v > 1 and variableNamer:getShortName() or nil
    end

    tree:forEach("string",
        function(t,c)
            if stringsFound[c.stringContent] then
                c.type = "lua"
                c.raw = stringsFound[c.stringContent] -- replace with variable
            end
        end)

    -- generate a new block of code and insert it
    for k,v in pairs(stringsFound) do
        tree:insert(1, LifeBoatAPI.Tools.LuaParser.parse(v .. '="'..k..'"\n'))
    end

    return tree
end;


---@param tree LuaTree
---@param variableRenamer VariableRenamer
minifyIdentifiers = function(this, variableRenamer, tree, avoidCopy)
    if not avoidCopy then
        tree = tree:deepCopy()
    end

    LifeBoatAPI.Tools.LuaTreeUtils.split(tree, "[^%w_]([%a_][%w_]*)", "lua", "identifier", true)

    local identifiersSeen = {}
    tree:forEach("identifier",
        function(t,i,c)
            identifiersSeen[c.raw] = identifiersSeen[c.raw] or variableRenamer:getShortName()
            c.type = "lua"
            c.raw = identifiersSeen[c.raw]
        end)

    return tree
end;


---@param tree LuaTree
---@param variableRenamer VariableRenamer
covertHexToNumber = function(this, variableRenamer, tree, avoidCopy)
    if not avoidCopy then
        tree = tree:deepCopy()
    end

    LifeBoatAPI.Tools.LuaTreeUtils.split(tree, "[^%w_](0x%x+)", "lua", "hex", true)
    
    tree:forEach("hex",
        function(t,i,c)
                c.type = "number"
                c.raw = tonumber(c.raw)
        end)

    return tree
end;




text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\Sandbox\testst\MyMicrocontroller.lua]]))

local contentTree = LifeBoatAPI.Tools.LuaParser.parse(text)
LifeBoatAPI.Tools.FileSystemUtils.writeAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\Sandbox\testst\generated1.lua]]), contentTree:toString())

local a = 1

__simulator:exit()