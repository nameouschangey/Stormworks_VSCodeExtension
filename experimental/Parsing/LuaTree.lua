LifeBoatAPI = LifeBoatAPI or {}
LifeBoatAPI.Tools = LifeBoatAPI.Tools or {}

---@class LuaTree
---@field type string
---@field raw string
---@field parent any (optional)
LifeBoatAPI.Tools.LuaTree = {

    ---@param this LuaTree
    ---@return LuaTree
    new = function(this, type, raw, other)
        this = LifeBoatAPI.Tools.BaseClass.new(this)
        this.type = type
        this.raw = raw
        for k,v in pairs(other or {}) do
            this[k] = v
        end
        return this
    end;
    
    ---@param this LuaTree
    children = function (this, typeName)
        local children = {}
        for i=1,#this do
            if this[i].type == typeName then
                children[#children+1] = this[i]
            end
        end
        return children
    end;

    ---@param this LuaTree
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
        local result = LifeBoatAPI.Tools.LuaTree:shallowCopy(this)
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
