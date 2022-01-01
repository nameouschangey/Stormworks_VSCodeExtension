-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

---@diagnostic disable: undefined-doc-name

---@section LifeBoatAPI 1 LIFEBOATAPICLASS
LifeBoatAPI = {
    --- Copies data from (from) to (to)
    --- underwrites values copied (leaves original if it exists)
    --- Can be used to instantiate classes, or inherit from classes
    --- @generic T
    --- @param from T source to copy from
    --- @param to any destination to copy into
    --- @param overwrite boolean true if all keys should be overwritten
    --- @overload fun(from:T):T
    --- @return T true if the current instance, is a type that inherits from the given class
    ---@section lb_copy
    lb_copy = function(from,to,overwrite)
        to=to or {}
        for k,v in pairs(from) do
            to[k] = not overwrite and to[k] or v  --underwrites, so the original values are kept if they existed
        end
        return to
    end;
    ---@endsection

    --- An empty function for any stubs, but also reducing the code needed for 
    ---   "if onHoverFunction ~= nil then onHoverFunction end -> (onHoverFunction or LBEmptyFunction)()"
    ---@section lb_doNothing
    lb_doNothing = function()end;
    ---@endsection
}
---@endsection LIFEBOATAPICLASS
