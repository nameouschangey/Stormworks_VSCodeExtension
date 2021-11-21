-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

---@diagnostic disable: undefined-doc-name

------------------------------------------------------------------------------------------------------------------
--- Copies data from (from) to (to)
--- underwrites values copied (leaves original if it exists)
--- Can be used to instantiate classes, or inherit from classes
--- @generic T
--- @overload fun(from:T):T
--- @param from T source to copy from
--- @param to any destination to copy into
--- @param overwrite boolean true if all keys should be overwritten
--- @return T true if the current instance, is a type that inherits from the given class
function LBCopy(from,to,overwrite)
    to=to or {}
    for k,v in pairs(from) do
        to[k] = (overwrite and v) or to[k] or v --underwrites, so the original values are kept if they existed
    end
    return to
end

------------------------------------------------------------------------------------------------------------------
--- Global class base that all classes should inherit from
--- @class LBBaseClass
--- @field __c any
LBBaseClass = {
    ---@generic T
    ---@param cls T
    ---@return T
    new = function(cls)
        return LBClass(cls,{})
    end;

    --- Checks whether this instance, is of the given class type at runtime
    --- @generic ParentType
    --- @param this LBBaseClass
    --- @param class ParentType class to see if this is an instance of, or inherits from
    --- @return boolean true if the current instance, is a type that inherits from the given class
    is = function(this, class)
        return (this == class) or (this ~= nil and class ~= nil and type(this) == type(class)) or this.is(this.__c, class)
    end;

    --- shallow clone of this instance
    ---@generic T
    ---@param this T
    ---@return T
    clone = function(this)
        return LBCopy(this)
    end;
};

--- @generic T,P
--- @overload fun(child:T):T
--- @param parent T source to copy from
--- @param child T destination to copy into
--- @return T new instance or class created
function LBClass(parent, child)
    if(not child) then
        child = parent
        parent = LBBaseClass
    end
    child.__c = parent
    return LBCopy(parent, child)
end