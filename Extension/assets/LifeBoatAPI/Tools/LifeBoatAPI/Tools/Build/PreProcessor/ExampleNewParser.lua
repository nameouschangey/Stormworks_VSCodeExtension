nextSectionIs = function(text, i, pattern)
    local startIndex, endIndex, captures = text:find(pattern, i)
    return startIndex == i
end;


getTextIncluding = function(text, searchStart, ...)
    local patterns = {...}

    local shortestIndex = #text
    for i=1,#patterns do
        local pattern = patterns[i]
        local startIndex, endIndex, captures = text:find(pattern, searchStart)
        if endIndex and endIndex < shortestIndex then
            shortestIndex = endIndex
        end
    end

    return shortestIndex+1, text:sub(searchStart, shortestIndex)
end;

getTextUntil = function(text, searchStart, ...)
    local patterns = {...}

    local shortestIndex = #text+1
    for i=1,#patterns do
        local pattern = patterns[i]
        if type(pattern) == "table" then
            local startIndex, endIndex, captures = text:find(pattern.p, searchStart)
            if startIndex and (startIndex + pattern.o) < shortestIndex then
                shortestIndex = (startIndex + pattern.o)
            end
        else
            local startIndex, endIndex, captures = text:find(pattern, searchStart)
            if startIndex and (startIndex) < shortestIndex then
                shortestIndex = (startIndex)
            end
        end
    end

    return shortestIndex, text:sub(searchStart, shortestIndex-1)
end;

parse = function(text)
    local content = {}

    local nextText = ""
    local i = 1
    while i <= #text do
        if nextSectionIs(text, i-1, '[^\\]"') then
            -- quote (")
            i, nextText = getTextIncluding(text, i, '[^\\]"')
            content[#content+1] = {type = "string", raw = nextText, stringContent = nextText:sub(2,-2)}

        elseif nextSectionIs(text, i-1, "[^\\]'") then
            -- quote (')
            i, nextText = getTextIncluding(text, i, "[^\\]'")
            content[#content+1] = {type = "string", raw = nextText, stringContent = nextText:sub(2,-2)}

        elseif nextSectionIs(text, i, "%[%[") then
            -- quote ([[ ]])
            i, nextText = getTextIncluding(text, i, "%]%]")
            content[#content+1] = {type = "string", raw = nextText, stringContent = nextText:sub(3,-3)}          

        elseif nextSectionIs(text, i, "%-%-%-@lb") then
            -- preprocessor tag
            i, nextText = getTextUntil(text, i, "\n")
            content[#content+1] = newTag(nextText)

        elseif nextSectionIs(text, i, "%-%-%[%[") then
            -- multi-line comment
            i, nextText = getTextIncluding(text, i, "%]%]")
            content[#content+1] = {type = "comment", raw = nextText}

        elseif nextSectionIs(text, i, "%-%-") then
            -- single-line comment
            i, nextText = getTextUntil(text, i, "\n")
            content[#content+1] = {type = "comment", raw = nextText}
        else
            -- regular/lua text
            local textAt = text:sub(i,i+5)
            i, nextText = getTextUntil(text, i, "%-%-", {p='[^\\]"',o=1}, {p="[^\\]'",o=1}, "%[%[")
            content[#content+1] = {type = "lua", raw = nextText}
        end
    end

    return content
end

newTag = function(tagtext)
    local contentIndex, startText = getTextUntil(tagtext, 1, "%(")
    local _, content = getTextUntil(tagtext, contentIndex+1, "%)[^%)]-$")

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

    return {
        type = "tag",
        tag = captures[1] or "none",
        raw = tagtext,
        captures = captures,
    }
end

parseToTree = function(text, contentList)
    local tree = {
        type="program",
        raw = text }
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
end

getTagTrees = function(tree)
    local tagTrees = {}
    for i=1,#tree do
        local content = tree[i]
        if content.type == "tag" then
            tagTrees[#tagTrees+1] = content
        end
    end
    return tagTrees
end;

forEach = function(tree, applyToType, func)
    for i=1,#tree do
        local content = tree[i]
        if not applyToType or content.type == applyToType then
            func(tree, content)
        end
        forEach(content, applyToType, func)
    end
    return tree
end;

shallowCopyTreeNode = function(node)
    local copy = {}
    for k,v in pairs(node) do
        copy[k] = v
    end
    return copy
end;

deepCopyTree = function(tree, func)
    local result = shallowCopyTreeNode(tree)
    result = {}

    for i=1,#tree do
        local content = tree[i]
        if not func or func(tree, content) then
            result[#result+1] = deepCopyTree(content, func)
        end
    end
    return result
end;

treeToString = function(tree)
    local result = {}
    for i=1,#tree do
        local content = tree[i]
        result[#result+1] = content.raw
        if #content then
            result[#result+1] = treeToString(content)
            if content.type == "tag" and content.endTag then
                result[#result+1] = content.endTag.raw
            end
        end
    end
    return table.concat(result)
end;


splitLuaIdentifiers = function(tree)
    local replacements = {}
    for i=#tree,1,-1 do -- reverse for deletion
        local content = tree[i]
        if content.type == "lua" then
            local contentReplacements = {}
            local variables = LifeBoatAPI.Tools.StringUtils.find(content.raw, "([%a_][%w_]*)")
            local lastEnd = 1
            for varIndex=1, #variables do
                local var = variables[varIndex]

                contentReplacements[#contentReplacements+1] = {type="lua", raw=content.raw:sub(lastEnd, var.startIndex+1)}              
                newNode = {type="indentifer", raw=var.captures[1]}
                table.insert(tree, i+1, newNode)
            end
        else
            splitLuaIdentifiers(content)
        end
    end
    return tree
end;

combineConsecutiveLuaNodes = function(tree)
    local lastContent = {type="none"}
    for i=#tree,1,-1 do -- reverse for deletion
        local content = tree[i]
        if content.type == "lua" and lastContent.type == "lua" then
            content.raw = content.raw .. lastContent.raw
            table.remove(tree, i+1)
        else
            combineConsecutiveLuaNodes(content)
        end
        lastContent = content
    end
    return tree
end;



VariableNamer = {
    count = 1,
    next = function(this)
        this.count = this.count + 1
        return "LB" .. this.count
    end;
}

insert = function(tree, index, contentList)
    for i=#contentList, 1, -1 do
        table.insert(tree, index, contentList[i])
    end
    return tree
end;

replace = function(tree, index, contentList)
    table.remove(tree, index)
    insert(table, index, contentList)
end;

removeStringDuplicates = function(variableNamer, tree)
    local stringsFound = {}
    forEach(tree, "string",
    function(t,c)
        stringsFound[c.stringContent] = (stringsFound[c.stringContent] or 0) + 1
    end)
    
    for k,v in pairs(stringsFound) do
        if v > 1 then
            stringsFound[k] = variableNamer:next()
        else
            stringsFound[k] = nil
        end
    end

    forEach(tree, "string",
    function(t,c)
        if stringsFound[c.stringContent] then
            c.type = "lua"
            c.raw = stringsFound[c.stringContent] -- replace with variable
        end
    end)

    -- generate a new block of code and insert it
    for k,v in pairs(stringsFound) do
        insert(tree, 1, parse(v .. '="'..k..'"\n'))
    end

    return tree
end;


text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\Sandbox\testst\MyMicrocontroller.lua]]))

local contentList = parse(text)

local contentTree = parseToTree(text, contentList)
local tagTrees = getTagTrees(contentTree)

local textAgain = treeToString(contentTree)


local noComments = deepCopyTree(contentTree, function(tree,content) return content.type ~= "comment" end)

local combined = combineConsecutiveLuaNodes(deepCopyTree(noComments))


--print(treeToString(noComments))
local areSame = tostring(text == textAgain)

print(treeToString(removeStringDuplicates(VariableNamer, contentTree)))
a = 1 + 1


