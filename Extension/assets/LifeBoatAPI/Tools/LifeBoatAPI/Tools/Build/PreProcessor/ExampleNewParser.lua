LifeBoatAPI.Tools.LuaParser = {
    parse = function(text)
        local this = LifeBoatAPI.Tools.LuaParser
        local LBStr = LifeBoatAPI.Tools.StringUtils
        local LBTree = LifeBoatAPI.Tools.LuaTree
        local content = {}

        local nextText = ""
        local i = 1
        while i <= #text do
            if LBStr.nextSectionIs(text, i-1, '[^\\]"') then
                -- quote (")
                i, nextText = LBStr.getTextIncluding(text, i, '[^\\]"')
                content[#content+1] = LBTree:new("string", nextText, {stringContent = nextText:sub(2,-2)})

            elseif LBStr.nextSectionIs(text, i-1, "[^\\]'") then
                -- quote (')
                i, nextText = LBStr.getTextIncluding(text, i, "[^\\]'")
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
            else
                -- regular/lua text
                i, nextText = LBStr.getTextUntil(text, i, "%-%-", {p='[^\\]"',o=1}, {p="[^\\]'",o=1}, "%[%[")
                content[#content+1] = LBTree:new("lua", nextText)
            end
        end

        return this._toTree(text, content)
    end;

    _toTree = function(text, contentList)
        local tree = LifeBoatAPI.Tools.LuaTree:new("program", text)

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

    _newTag = function(tagtext)
        local LBStr = LifeBoatAPI.Tools.StringUtils

        local contentIndex, startText = LBStr.getTextUntil(tagtext, 1, "%(")
        local _, content = LBStr.getTextUntil(tagtext, contentIndex+1, "%)[^%)]-$")
    
        local captures = {}
        local brackets = 0
        local currentCapture = ""
        for i=1, #content do
            local c = content:sub(i,i)
            if brackets == 0 and c == "," then
                captures[#captures+1] = currentCapture
                currentCapture = ""
            elseif c == ")" then
                brackets = brackets - 1
                currentCapture = currentCapture .. c
                if brackets == -1 then
                    error("Format error, too many closing brackets in tag: " .. tagtext)
                end
            elseif c == "(" then
                brackets = brackets + 1
                currentCapture = currentCapture .. c
            else
                currentCapture = currentCapture .. c
            end
        end
    
        captures[#captures+1] = currentCapture
    
        if brackets > 0 then
            error("Format error, missing closing bracket in tag: " .. tagtext)
        end
    
        return LifeBoatAPI.Tools.LuaTree:new("tag", tagtext, {
            tag = captures[1] or "none",
            captures = captures,
        })
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
        for k,v in pairs(other) do
            this[k] = v
        end
        return this
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


---@class LuaTree_MinifyStringDuplicates
LifeBoatAPI.Tools.LuaTree_MinifyStringDuplicates = {

    ---@return LuaTree_MinifyStringDuplicates
    new = function(this)
        return LifeBoatAPI.Tools.BaseClass.new(this)
    end;

    ---@param this LuaTree_MinifyStringDuplicates
    ---@param variableNamer VariableRenamer
    ---@param tree LuaTree
    ---@return LuaTree
    run = function(this, variableNamer, tree, avoidCopy)
        if not avoidCopy then
            tree = tree:deepCopy()
        end

        local stringsFound = {}
        tree:forEach("string",
            function(t,c)
                stringsFound[c.stringContent] = (stringsFound[c.stringContent] or 0) + 1
            end)
        
        for k,v in pairs(stringsFound) do
            if v > 1 then
                stringsFound[k] = variableNamer:getShortName()
            else
                stringsFound[k] = nil
            end
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
}

LifeBoatAPI.Tools.LuaTreeUtils = {

    ---@param tree LuaTree
    ---@return LuaTree
    split = function(tree, pattern, applyToType, newType, avoidCopy)
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
                local variables = LifeBoatAPI.Tools.StringUtils.find(content.raw, pattern)
                local lastEnd = 1
                for varIndex=1, #variables do
                    local var = variables[varIndex]
    
                    -- handle the text between each variable
                    local startText = content.raw:sub(lastEnd, var.startIndex-1)
                    if #startText > 0 then
                        contentReplacements[#contentReplacements+1] = LBTree:new(applyToType, startText)
                    end
    
                    contentReplacements[#contentReplacements+1] = LBTree:new(newType,var.captures[1], {captures=var.captures})
    
                    lastEnd = var.endIndex + 1
                end
    
                -- any remaining non-variable text on the end
                local endText = content.raw:sub(lastEnd, -1)
                if #endText > 0 then
                    contentReplacements[#contentReplacements+1] = LBTree:new(applyToType, endText)
                end
    
                replacements[#replacements+1] = {i=i, replacements = contentReplacements}
            else
                this:split(content)
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

---@class LuaTree_MinifyIdentifiers
LifeBoatAPI.Tools.LuaTree_MinifyIdentifiers = {
    ---@return LuaTree_MinifyIdentifiers
    new = function(this)
        return LifeBoatAPI.Tools.BaseClass.new(this)
    end;

    ---@param tree LuaTree
    ---@param variableRenamer VariableRenamer
    run = function(this, variableRenamer, tree, avoidCopy)
        if not avoidCopy then
            tree = tree:deepCopy()
        end

        LifeBoatAPI.Tools.LuaTreeUtils.split(tree, "([%a_][%w_]*)", "lua", "identifier", true)

        local identifiersSeen = {}
        tree:forEach("identifier",
            function(t,i,c)
                if c.raw then
                    identifiersSeen[c.raw] = identifiersSeen[c.raw] or variableRenamer:getShortName()
                    c.type = "lua"
                    c.raw = identifiersSeen[c.raw]
                end
            end)
        LifeBoatAPI.Tools.LuaTreeUtils.collapseLuaNodes(tree, true)

        return tree
    end;
}

---@class LuaTree_MinifyIdentifiers
LifeBoatAPI.Tools.LuaTree_MinifyIdentifiers = {
    ---@return LuaTree_MinifyIdentifiers
    new = function(this)
        return LifeBoatAPI.Tools.BaseClass.new(this)
    end;

    ---@param tree LuaTree
    ---@param variableRenamer VariableRenamer
    run = function(this, variableRenamer, tree, avoidCopy)
        if not avoidCopy then
            tree = tree:deepCopy()
        end

        LifeBoatAPI.Tools.LuaTreeUtils.split(tree, "([%a_][%w_]*)", "lua", "identifier", true)

        local identifiersSeen = {}
        tree:forEach("identifier",
            function(t,i,c)
                if c.raw then
                    identifiersSeen[c.raw] = identifiersSeen[c.raw] or variableRenamer:getShortName()
                    c.type = "lua"
                    c.raw = identifiersSeen[c.raw]
                end
            end)
        LifeBoatAPI.Tools.LuaTreeUtils.collapseLuaNodes(tree, true)

        return tree
    end;
}













text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\Sandbox\testst\MyMicrocontroller.lua]]))

local contentList = parse(text)

local contentTree = parseToTree(text, contentList)
local tagTrees = filterTree(contentTree, function(tree,content) return content.type == "tag" end)

local textAgain = treeToString(contentTree)


local noComments = filterTree(contentTree, function(tree,content) return content.type ~= "comment" end)

local combined = combineConsecutiveLuaNodes(deepCopyTree(noComments))

local splitIdentifiers = splitLuaIdentifiers(contentTree)
local identifiers = filterTree(splitIdentifiers, function(tree, content) return content.type == "identifier" end)

--print(treeToString(noComments))
local areSame = tostring(text == textAgain)

print(treeToString(removeStringDuplicates(VariableNamer, contentTree)))
a = 1 + 1


