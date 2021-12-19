-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

---@diagnostic disable: undefined-doc-name

------------------------------------------------------------------------------------------------------------------

--- Copies data from (from) to (to)
--- underwrites values copied (leaves original if it exists)
--- Can be used to instantiate classes, or inherit from classes
--- @generic T
--- @param from T source to copy from
--- @param to any destination to copy into
--- @param overwrite boolean true if all keys should be overwritten
--- @overload fun(from:T):T
--- @return T true if the current instance, is a type that inherits from the given class
---@section LBCopy
function LBCopy(from,to,overwrite)
    to=to or {}
    for k,v in pairs(from) do
        to[k] = (overwrite and v) or to[k] or v --underwrites, so the original values are kept if they existed
    end
    return to
end
---@endsection

--- An empty function for any stubs, but also reducing the code needed for 
---   "if onHoverFunction ~= nil then onHoverFunction end -> (onHoverFunction or LBEmptyFunction)()"
---@section LBEmptyFunction
function LBEmptyFunction(...)
end
---@endsection