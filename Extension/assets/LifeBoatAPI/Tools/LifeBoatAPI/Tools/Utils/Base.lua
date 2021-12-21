-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

---@diagnostic disable: undefined-doc-name

LifeBoatAPI = LifeBoatAPI or {}
LifeBoatAPI.Tools = LifeBoatAPI.Tools or {}

--- Empty function for simplifying  funcThatMightNotExist = theFunc or Empty
LifeBoatAPI.Tools.Empty = function() end;

--- Does a default check, but for booleans which can be a pain otherwise as false ruins it
---@param variable boolean value to check
---@param defaultIfNil boolean value to assign if the variable is nil; default is true
---@return boolean variable
LifeBoatAPI.Tools.DefaultBool = function (variable, defaultIfNil)
    if defaultIfNil == nil then
        defaultIfNil = true
    end
    
    if variable == nil then
        return defaultIfNil
    end
    return variable
end

--- Copies data from (from) to (to)
--- underwrites values copied (leaves original if it exists)
--- Can be used to instantiate classes, or inherit from classes
--- @generic T
--- @overload fun(from:T):T
--- @param from T source to copy from
--- @param to any destination to copy into
--- @param overwrite boolean true if all keys should be overwritten
--- @return T true if the current instance, is a type that inherits from the given class
LifeBoatAPI.Tools.Copy = function(from,to,overwrite)
    to=to or {}
    for k,v in pairs(from) do
        to[k] = (overwrite and v) or to[k] or v --underwrites, so the original values are kept if they existed
    end
    return to
end

--- Global class base that all classes should inherit from
--- @class BaseClass
--- @field __c any
LifeBoatAPI.Tools.BaseClass = {
    ---@generic T
    ---@param cls T
    ---@return T
    new = function(cls)
        return LifeBoatAPI.Tools.Class(cls,{})
    end;

    --- Checks whether this instance, is of the given class type at runtime
    --- @generic ParentType
    --- @param this BaseClass
    --- @param class ParentType class to see if this is an instance of, or inherits from
    --- @return boolean true if the current instance, is a type that inherits from the given class
    is = function(this, class)
        return (this == class)
                or (this ~= nil and class ~= nil and type(this) == type(class))
                or this.is(this.__c, class)
    end;

    --- shallow clone of this instance
    ---@generic T
    ---@param this T
    ---@return T
    clone = function(this)
        return LifeBoatAPI.Tools.Copy(this)
    end;
};

--- @generic T,P
--- @overload fun(child:T):T
--- @param parent T source to copy from
--- @param child T destination to copy into
--- @return T new instance or class created
LifeBoatAPI.Tools.Class = function(parent, child)
    if(not child) then
        child = parent
        parent = LifeBoatAPI.Tools.BaseClass
    end
    child.__c = parent
    return LifeBoatAPI.Tools.Copy(parent, child)
end