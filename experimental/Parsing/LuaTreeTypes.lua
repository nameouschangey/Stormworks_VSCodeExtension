require("Parsing.LuaTree")

---@class LuaParseTypes
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
    lbtag = "tag",
    identifierchain = "identifierchain",
    comparison = "comparison"
}

-- extended LuaTree Types
---@class LuaTree_IdentifierChain
---@field identifierBase string
---@field identifierFull string

---@class LuaTree_String : LuaTree
---@field stringContent string
LifeBoatAPI.Tools.LuaTree_String = {
    ---@return LuaTree_String
    new = function(this, raw, stringContent)
        return LifeBoatAPI.Tools.LuaTree.new(this, LifeBoatAPI.Tools.LuaParseTypes.string, raw, {stringContent = stringContent})
    end;
}


---@class LuaTree_LBTag
---@field brackets LuaTree_Brackets
---@field outputRaw boolean true if the tag-part itself should be output to string
---@field startText string
---@field endTag LuaTree_LBTag
LifeBoatAPI.Tools.LuaTree_LBTag = {
    ---@return LuaTree_LBTag
    new = function(this, text)
        local LBStr = LifeBoatAPI.Tools.StringUtils
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes

        this = LifeBoatAPI.Tools.LuaTree.new(this, LBTypes.lbtag)

        local contentIndex, startText = LBStr.getTextUntil(text, 1, "%(")
        this.startText = startText

        local endIndex, bracketParse = LifeBoatAPI.Tools.LuaTree_Brackets:new(text, contentIndex, "(", ")", ",")
        local trailingText = text:sub(endIndex)
        if #trailingText > 0 then
            bracketParse[#bracketParse + 1] = LifeBoatAPI.Tools.LuaTree:new(LBTypes.lua, trailingText)
        end

        this.brackets = bracketParse
        this.outputRaw = true

        return this
    end;

    toString = function(this)
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
}


---@class LuaTree_Brackets
LifeBoatAPI.Tools.LuaTree_Brackets = {
    new = function(this, text, startIndex, openCharacter, closeCharacter, separators)
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes
        local LBTree = LifeBoatAPI.Tools.LuaTree
        local LBParse = LifeBoatAPI.Tools.LuaParser

        separators = (type(separators) == LBTypes.table and separators) or {separators}
        local isSeparator = function(c)
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
                children[#children+1] = LBParse.parse(currentCapture, LBTypes.param)
                children[#children+1] = LBTree.new(this, LBTypes.lua, c)
                currentCapture = ""
            elseif c == closeCharacter then
                -- close )
                brackets = brackets - 1
                
                if brackets == 0 then
                    if #currentCapture > 0 then
                        children[#children+1] = LBParse.parse(currentCapture, LBTypes.param)
                    end
                    children[#children+1] = LBTree.new(this, LBTypes.lua, closeCharacter)
                    break;
                else
                    currentCapture = currentCapture .. c
                end
            elseif c == openCharacter then
                -- open (
                brackets = brackets + 1
                if brackets == 1 then
                    children[#children+1] = LBTree.new(this, LBTypes.lua, openCharacter)
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

        return endIndex+1, LBTree.new(this, LBTypes.brackets, nil, children)
    end;
}


---@class LuaTree_MacroCall : LuaTree
---@field identifier LuaTree_IdentifierChain
---@field brackets LuaTree_Brackets
LifeBoatAPI.Tools.LuaTree_MacroCall = {
    ---@return LuaTree_MacroCall
    new = function(this, raw)
        return LifeBoatAPI.Tools.LuaTree.new(this, LifeBoatAPI.Tools.LuaParseTypes.possibleMacroCall, raw)
    end;

    toString = function(this)
        local result = {
            this.identifier:toString()
        }
        for a=1,#this do
            result[#result+1] = this[a]:toString()
        end
        result[#result+1] = this.brackets:toString()
        return table.concat(result)
    end
}