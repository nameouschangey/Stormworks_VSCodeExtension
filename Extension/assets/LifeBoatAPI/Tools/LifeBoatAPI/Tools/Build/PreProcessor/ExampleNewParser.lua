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

    return shortestIndex+1, text:sub(searchStart, shortestIndex)
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
    while i <= #text do
        if nextSectionIs(text, i, '"') then
            -- quote (")
            i, nextText = getTextIncluding(text, i+1, '[^\\]"')
            content[#content+1] = {type = "string", raw = '"' .. nextText}

        elseif nextSectionIs(text, i, "'") then
            -- quote (')
            i, nextText = getTextIncluding(text, i+1, "[^\\]'")
            content[#content+1] = {type = "string", raw = "'" .. nextText}

        elseif nextSectionIs(text, i, "%[%[") then
            -- quote ([[ ]])
            i, nextText = getTextIncluding(text, i, "%]%]")
            content[#content+1] = {type = "string", raw = nextText}          

        elseif nextSectionIs(text, i, "%-%-%-@lb") then
            -- preprocessor tag
            i, nextText = getTextIncluding(text, i, "\n")
            content[#content+1] = {type = "tag", raw = nextText}

        elseif nextSectionIs(text, i, "%-%-%[%[") then
            -- multi-line comment
            i, nextText = getTextIncluding(text, i, "%]%]")
            content[#content+1] = {type = "comment", raw = nextText}

        elseif nextSectionIs(text, i, "%-%-") then
            -- single-line comment
            i, nextText = getTextIncluding(text, i, "\n")
            content[#content+1] = {type = "comment", raw = nextText, children={}}
        else
            -- regular/lua text
            i, nextText = getTextUntil(text, i, "%-%-", '[^\\]"', "[^\\]'", "%[%[")
            content[#content+1] = {type = "lua", raw = nextText}
        end
    end

    return content
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
    return tree
end



text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\Sandbox\testst\MyMicrocontroller.lua]]))

local contentList = parse(text)
local contentTree = parseToTree(text, contentList)

a = 1 + 1