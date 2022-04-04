LifeBoatAPI.Tools.LuaParser = {
    parse = function(text, tag)
        local this = LifeBoatAPI.Tools.LuaParser
        local LBStr = LifeBoatAPI.Tools.StringUtils
        local LBTree = LifeBoatAPI.Tools.LuaTree
        local content = {}

        local nextText = ""
        local i = 1

        while i <= #text do
            if LBStr.nextSectionIs(text, i, "\\") then
                i, nextText = i+1, text:sub(i,i+1)
                content[#content+1] = LBTree:new("lua", nextText)

            elseif LBStr.nextSectionIs(text, i, '"') then
                -- quote (")
                i, nextText = LBStr.getTextIncluding(text, i+1, '"')
                nextText = '"' .. nextText
                content[#content+1] = LBTree:new("string", nextText, {stringContent = nextText:sub(2,-2)})

            elseif LBStr.nextSectionIs(text, i, "'") then
                -- quote (')
                i, nextText = LBStr.getTextIncluding(text, i+1, "'")
                nextText = "'" .. nextText
                content[#content+1] = LBTree:new("string", nextText, {stringContent = nextText:sub(2,-2)})

            elseif LBStr.nextSectionIs(text, i, "%[%[") then
                -- quote ([[ ]])
                i, nextText = this:getTextIncluding(text, i, "%]%]")
                content[#content+1] = LBTree:new("string", nextText, {stringContent = nextText:sub(3,-3)})       

            elseif LBStr.nextSectionIs(text, i, "%-%-%-@lb") then
                -- preprocessor tag
                i, nextText = LBStr.getTextUntil(text, i, "\n")
                content[#content+1] = this._newTag(nextText)

            elseif LBStr.nextSectionIs(text, i, "%-%-%[%[") then
                -- multi-line comment
                i, nextText = LBStr.getTextIncluding(text, i, "%]%]")
                content[#content+1] = LBTree:new("comment", nextText)

            elseif LBStr.nextSectionIs(text, i, "%-%-") then
                -- single-line comment
                i, nextText = LBStr.getTextUntil(text, i, "\n")
                content[#content+1] = LBTree:new("comment", nextText)

            elseif LBStr.nextSectionIs(text, i, "%(") then
                i, content[#content+1] = this._parseBrackets(text, i, "(", ")", ",")

            elseif LBStr.nextSectionIs(text, i, "%[") then 
                i, content[#content+1] = this._parseBrackets(text, i, "[", "]", nil)

            elseif LBStr.nextSectionIs(text, i, "[%a_][%w_]*") then
                i, nextText = LBStr.getTextIncluding(text, i, "[%a_][%w_]*")
                
                content[#content+1] = LBTree:new("identifier", nextText) 

            elseif LBStr.nextSectionIs(text, i, "%s+") then
                -- whitespace
                i, nextText = LBStr.getTextIncluding(text, i, "%s*")
                content[#content+1] = LBTree:new("whitespace", nextText)

            elseif LBStr.nextSectionIs(text, i, "0x%x+") then 
                i, nextText = LBStr.getTextIncluding(text, i, "0x%x+")
                content[#content+1] = LBTree:new("hex", nextText)

            elseif LBStr.nextSectionIs(text, i, "%x+") then 
                i, nextText = LBStr.getTextIncluding(text, i, "%x+")
                content[#content+1] = LBTree:new("number", nextText)

            else
                -- regular/lua text
                i, nextText = LBStr.getTextUntil(text, i, "\\", "%s+", "[%a_][%w_]*", "%-%-", '"', "'", "%[%[")
                content[#content+1] = LBTree:new("lua", nextText)
            end
        end

        return this._toTree(content, tag or "program")
    end;

    _toTree = function(contentList, tag)
        -- can we also add "chain" to this
        -- can we also make function a type: identifier + brackets?
        -- how does merging work?

        local tree = LifeBoatAPI.Tools.LuaTree:new(tag, "")

        for i = 1, #contentList do
            local content = contentList[i]
            content = content or {}
    
            if content.type == "tag" then
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

    _parseBrackets = function(text, startIndex, openCharacter, closeCharacter, separator)
        local LBStr = LifeBoatAPI.Tools.StringUtils
        local LBTree = LifeBoatAPI.Tools.LuaTree
        local this = LifeBoatAPI.Tools.LuaParser

        local children = {}
        local brackets = 0
        local currentCapture = ""
        local endIndex = startIndex
        for i=startIndex, #text do
            endIndex = i
            local c = text:sub(i,i)
            if brackets == 1 and c == separator then
                children[#children+1] = this.parse(currentCapture, "param")
                children[#children+1] = LBTree:new("lua", separator)
                currentCapture = ""
            elseif c == closeCharacter then
                -- close )
                brackets = brackets - 1
                
                if brackets == 0 then
                    if #currentCapture > 0 then
                        children[#children+1] = this.parse(currentCapture, "param")
                    end
                    children[#children+1] = LBTree:new("lua", closeCharacter)
                    break;
                else
                    currentCapture = currentCapture .. c
                end
            elseif c == openCharacter then
                -- open (
                brackets = brackets + 1
                if brackets == 1 then
                    children[#children+1] = LBTree:new("lua", openCharacter)
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
        local tree = LifeBoatAPI.Tools.LuaTree:new("brackets", "", children)


        return endIndex+1, tree
    end;

    _newTag = function(tagtext)
        local LBStr = LifeBoatAPI.Tools.StringUtils
        local this = LifeBoatAPI.Tools.LuaParser
        local LBTree = LifeBoatAPI.Tools.LuaTree

        local contentIndex, startText = LBStr.getTextUntil(tagtext, 1, "%(")

        local endIndex, bracketParse = this._parseBrackets(tagtext, contentIndex, "(", ")", ",")
        bracketParse.type = "tag"
        bracketParse.raw = startText
        bracketParse.tag = bracketParse:child("param"):child("identifier").raw

        local trailingText = tagtext:sub(endIndex)
        if #trailingText > 0 then
            bracketParse[#bracketParse + 1] = LBTree:new("lua", trailingText)
        end

        return bracketParse
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
                    return this[i]
                end
            end
        end
        return nil
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
        local result = {}
        for i=1,#this do
            local content = this[i]
            result[#result+1] = content.raw
            if #content then
                result[#result+1] = content:toString()
                if content.type == "tag" and content.endTag then
                    result[#result+1] = content.endTag.raw
                end
            end
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










LifeBoatAPI.Tools.LuaTreeUtils = {
    ---@param tree LuaTree
    ---@param applyToType string
    ---@param replacementGenerator fun(tree:LuaTree, i:number, content:LuaTree) : LuaTree[]
    replaceWhere = function(tree, applyToType, replacementGenerator, avoidCopy)

        if not avoidCopy then
            tree = tree:deepCopy()
        end

        local replacements = {}
        tree:forEach(applyToType, function(tree, i, content)
                local replacement = replacementGenerator(tree, i, content)
                if replacement then
                    replacements[#replacements+1] = {i=i, r=replacement}
                end
            end)
        
        for i=1, #replacements do
            tree:replace(replacements[i].i, replacements[i].r)
        end

        tree:forEach(applyToType, function(tree, i, content)
                LifeBoatAPI.Tools.LuaTreeUtils.replaceWhere(content, applyToType, replacementGenerator, true)
            end)

        return tree
    end;

    ---@return LuaTree
    splitFunc = function(searchFunc)
        local LBTree = LifeBoatAPI.Tools.LuaTree
        return function(t, i, c)
                local contentReplacements = {}
                local foundTrees = searchFunc(t, i, c)
                local lastEnd = 1
                for varIndex=1, #foundTrees do
                    local newTree = foundTrees[varIndex]
    
                    -- handle the text between each variable
                    local startText = c.raw:sub(lastEnd, newTree.startIndex-1)
                    if #startText > 0 then
                        contentReplacements[#contentReplacements+1] = LBTree:new(c.type, startText)
                    end
    
                    local varText = c.raw:sub(newTree.startIndex, newTree.endIndex)
                    contentReplacements[#contentReplacements+1] = newTree
                    lastEnd = newTree.endIndex + 1
                end
    
                -- any remaining non-variable text on the end
                local endText = c.raw:sub(lastEnd, -1)
                if #endText > 0 then
                    contentReplacements[#contentReplacements+1] = LBTree:new(c.type, endText)
                end

                return contentReplacements
        end
    end;

    ---@param tree LuaTree
    ---@return LuaTree
    split = function(tree, applyToType, applyTo, searchFunc, avoidCopy)
        offset = offset or 0
        
        if not avoidCopy then
            tree = tree:deepCopy()
        end

        applyToType = applyToType or "lua"
        newType = newType or "split"

        local this = LifeBoatAPI.Tools.LuaTreeUtils
        local LBTree = LifeBoatAPI.Tools.LuaTree
        local replacements = {}
        for i=1,#tree do
            local content = tree[i]
            if content.type == applyToType then
                local contentReplacements = {}
                local variables = searchFunc(tree, i, content)
                local lastEnd = 1
                for varIndex=1, #variables do
                    local var = variables[varIndex]
    
                    -- handle the text between each variable
                    local startText = content.raw:sub(lastEnd, var.startIndex-1)
                    if #startText > 0 then
                        contentReplacements[#contentReplacements+1] = LBTree:new(applyToType, startText)
                    end
    
                    local varText = content.raw:sub(var.startIndex, var.endIndex)
                    contentReplacements[#contentReplacements+1] = LBTree:new(varText, {captures=var.captures})
                    lastEnd = var.endIndex + 1
                end
    
                -- any remaining non-variable text on the end
                local endText = content.raw:sub(lastEnd, -1)
                if #endText > 0 then
                    contentReplacements[#contentReplacements+1] = LBTree:new(applyToType, endText)
                end
    
                replacements[#replacements+1] = {i=i, replacements = contentReplacements}
            else
                this.split(content, applyToType, searchFunc)
            end
        end
    
        -- replace the content with the split versions
        for i=#replacements,1,-1 do
            tree:replace(replacements[i].i, replacements[i].replacements)
        end
    
        return tree
    end;

    ---@param tree LuaTree
    ---@return LuaTree
    collapseLuaNodes = function(tree, avoidCopy)
        if not avoidCopy then
            tree = tree:deepCopy()
        end

        local lastContent = {type="none"}
        for i=#tree,1,-1 do -- reverse for deletion
            local content = tree[i]
            if content.type == "lua" and lastContent.type == "lua" then
                content.raw = content.raw .. lastContent.raw
                table.remove(tree, i+1)
            else
                content:combineConsecutiveLuaNodes()
            end
            lastContent = content
        end
        return tree
    end;
}







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





simplePatternGenerator = function(newType, pattern, startOffset, endOffset)
    return function(t, i, c)
        local result = {}
        local v = LifeBoatAPI.Tools.StringUtils.find(c.raw, pattern, 1, startOffset, endOffset)
        for i=1, #v do
            result[#result+1] = LifeBoatAPI.Tools.LuaTree:new(newType, c.raw:sub(v[i].startIndex, v[i].endIndex), v[i])
        end
        return result
    end
end;


-- GlobalVariableReducer x
-- HexadecimalConverter x
-- NumberLiteralReducer x
-- StringCommentsParser?
-- StringReplace?


--[[ shortening identifiers safely
and not this.constants.baseNames[v.captures[1] ]
and not this.constants.fullNames[v.captures[1] ]
and not this.constants.restrictedKeywords[v.captures[1] ] end)

]]

--[[
    ---@param this GlobalVariableReducer
    shortenGlobals = function(this, text)
        text = this:_shorten(text, "[^%w_]([%a_][%w_%.]-)[^%w_%.]", this.constants.fullNames)
        text = "\n" .. text -- ensure newly added variables work
        text = this:_shorten(text, "[^%w_]([%a_][%w_]-)[^%w_]", this.constants.baseNames)
        return text
    end;

    ---@param this GlobalVariableReducer
    _shorten = function(this, text, pattern, acceptableList)
        -- variables shortened are not keywords, and not global names (because those are a pita)
        local variables = LifeBoatAPI.Tools.StringUtils.find(text, pattern)

        -- filter down to ONLY the externalGlobals list
        variables = LifeBoatAPI.Tools.TableUtils.iwhere(variables, function(v) return v.captures[1]
                                                                and not v.captures[1]:find("STRING%d%d%d%d%d%d%dREPLACEMENT")
                                                                and acceptableList[v.captures[1] ]
                                                                and not this.constants.restrictedKeywords[v.captures[1] ] end)
                                                                -- only change globals where they're used at least twice, or it's a cost
]]

--[[

    ---@param this HexadecimalConverter
    fixHexademicals = function(this, text)
        local stringUtils = LifeBoatAPI.Tools.StringUtils;

        -- variables shortened are not keywords, and not global names (because those are a pita)
        local hexValues = stringUtils.find(text, "[^%w_](0x%x+)")
        for i=1, #hexValues do
            local hexVal = hexValues[i]
            local hexAsNum = tonumber(hexVal.captures[1])
    
            text = stringUtils.subAll(text, "([^%w_])" .. stringUtils.escape(hexVal.captures[1]), "%1" .. tostring(hexAsNum))
        end
    
        return text
    end;
]]

text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\Sandbox\testst\MyMicrocontroller.lua]]))

local contentTree = LifeBoatAPI.Tools.LuaParser.parse(text)

local a = 1