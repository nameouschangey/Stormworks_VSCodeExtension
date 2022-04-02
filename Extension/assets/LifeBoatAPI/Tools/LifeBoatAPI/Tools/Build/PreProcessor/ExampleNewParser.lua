nextSectionIs = function(text, i, pattern)
    local startIndex, endIndex, captures = text:find(pattern, i)
    return startIndex == i
end;

getTextUntil = function(text, searchStart, ...)
    local patterns = {...}

    local shortestIndex = #text
    for i=1,#patterns do
        local pattern = patterns[i]
        local startIndex, endIndex, captures = text:find(pattern, searchStart)
        if startIndex and startIndex < shortestIndex then
            shortestIndex = startIndex
        end
    end

    return shortestIndex-1, text:sub(searchStart, shortestIndex-1)
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

---Goes through the data of a code file, and removes all comments and replaces all strings with constants
---This allows for safe working on the file without destroying string data which may contain code-like phrases
---Strings can be re-added later using gsub, or another parse
---Comments are discarded as this is designed for use in a Minimizer
---@param text string text to parse
---@return string text without the strings and comments
parse = function(text)
    local content = {}

    local nextText = ""
    local i = 1
    while i+1 <= #text do
        if nextSectionIs(text, i, '[^\\]"') then
            -- quote (")
            i, nextText = getTextIncluding(text, i+1, '[^\\]"')
            content[#content+1] = {type = "string", raw = nextText}

        elseif nextSectionIs(text, i, "[^\\]'") then
            -- quote (')
            i, nextText = getTextIncluding(text, i+1, "[^\\]'")
            content[#content+1] = {type = "string", raw = nextText}

        elseif nextSectionIs(text, i, "%[%[") then
            -- quote ([[ ]])
            i, nextText = getTextIncluding(text, i, "%]%]")
            content[#content+1] = {type = "string", raw = nextText}          

        elseif nextSectionIs(text, i, "%-%-%-@lb") then
            -- preprocessor tag
            i, nextText = getTextIncluding(text, i, "\n")
            content[#content+1] = newTag(nextText)

        elseif nextSectionIs(text, i, "%-%-%[%[") then
            -- multi-line comment
            i, nextText = getTextIncluding(text, i, "%]%]")
            content[#content+1] = {type = "comment", raw = nextText}

        elseif nextSectionIs(text, i, "%-%-") then
            -- single-line comment
            i, nextText = getTextIncluding(text, i, "\n")
            content[#content+1] = {type = "comment", raw = nextText}
        else
            -- regular/lua text
            local textAt = text:sub(i,i+5)
            i, nextText = getTextUntil(text, i, "%-%-", '[^\\]"', "[^\\]'", "%[%[")
            i = i + 1
            content[#content+1] = {type = "lua", raw = nextText}
        end
    end

    return content
end

newTag = function(tagtext)
    local contentIndex, startText = getTextUntil(tagtext, 1, "%(")
    local _, content = getTextUntil(tagtext, contentIndex+2, "%)[^%)]-\n")

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
        raw = text,
        content={}
        }
    for i = 1, #contentList do
        local content = contentList[i]
        content.content = content.content or {}

        if content.type == "tag" then
            if content.tag == "end" then
                tree.endTag = content

                if not tree.parent then
                    error("Too many ---@lb(end) tags")
                end
                tree = tree.parent
            else
                tree.content[#tree.content+1] = content
                content.parent = tree
                tree = content
            end
        else
            tree.content[#tree.content+1] = content
        end
    end

    if tree.parent then
        error("Missing ---@lb(end) tag")
    end

    return tree
end

getTagTrees = function(tree)
    local tagTrees = {}
    for i=1,#tree.content do
        local content = tree.content[i]
        if content.type == "tag" then
            tagTrees[#tagTrees+1] = content
        end
    end
    return tagTrees
end;

text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\Sandbox\testst\MyMicrocontroller.lua]]))

local contentList = parse(text)
local contentTree = parseToTree(text, contentList)
local tagTrees = getTagTrees(contentTree)
a = 1 + 1