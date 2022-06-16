-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")

---@class TableUtils
LifeBoatAPI.Tools.TableUtils = {

    --- Returns whether this collection contains the given value or not
    ---@param tbl table
    ---@param value any value to check for
    ---@return boolean exists whether this value exists in the collection or not
    containsValue = function(tbl, value)
        for _,v in pairs(tbl) do
            if(v == value) then return true end
        end
        return false
    end;

    --- Returns whether this collection contains the given key or not
    --- (Other than being typographically nice - may as well just do tbl[key] mostly)
    ---@param tbl table
    ---@param key any key to check for
    ---@return boolean exists whether this value exists in the collection or not
    ---@section containsKey
    containsKey = function(tbl, key)
        return tbl[key] ~= nil
    end;
    ---@endsection

    --- Counts the number of elements in the table
    --- Differs from length, which counts numberical keys; ending at first nil
    ---@param tbl table table to act on
    ---@return number
    ---@section countKeys
    countKeys = function(tbl)
        local i = 0
        for _, v in pairs(tbl) do
            i = i + 1
        end
        return i
    end;
    ---@endsection

    --- safely removes the specified index from the table, ensuring that if it's a numerical key - we keep the values contiguous
    --- just using this.lb_data[key] = nil, for all keys, would mean we end up with arrays like {a,b,c,nil,nil,f,g,h} which ipairs and #length will only read up to c
    ---@param tbl table table to act on
    ---@param key any index to remove, or key to delete
    ---@section remove
    remove = function(tbl, key)
        if(type(key) == "number") then
            table.remove(tbl, key)
        else
            tbl[key] = nil
        end
    end;
    ---@endsection

    --- Inserts element value at position pos in list, shifting up the elements list[pos], list[pos+1], ···, list[#list].
    --- The default value for pos is #list+1, so that a call table.insert(t,x) inserts x at the end of list t.
    ---@param tbl table table to act on
    ---@param value any value to insert into the table
    ---@param index number index to insert into (shifts indices, instead of overwriting existing value)
    ---@section add
    add = function(tbl, value, index)
        if(index and type(index) == "number") then
            table.insert(tbl, index, value)
        elseif(index) then
            tbl[index] = value
        else
            table.insert(tbl, value)
        end
    end;
    ---@endsection

    --- simple addRange, used far too commonly not to include
    --- @param tbl table table to act on
    --- @param from table list of values to append to lhs table
    ---@section addRange
    addRange = function(tbl, from)
        LifeBoatAPI.Tools.Copy(from, tbl)
    end;
    ---@endsection

    --- simple addRange, used far too commonly not to include
    --- @param tbl table table to act on
    --- @param from table list of values to append to lhs table
    ---@section iaddRange
    iaddRange = function(tbl, from)
        for i=1, #from do
            tbl[#tbl+1] = from[i]
        end
    end;
    ---@endsection

    --- Flattens a key:value pair table into a list of values
    --- @generic K,V
    --- @param tbl table<K,V> table to act on
    --- @return V[] transformed table
    ---@section flattenValues
    flattenValues = function(tbl)
        local result = {}
        for k,v in pairs(tbl) do
            table.insert(result, v)
        end
        return result
    end;
    ---@endsection


    --- Flattens a key:value pair table into a list of keys
    --- @generic K,V
    --- @param tbl table<K,V> table to act on
    --- @return K[] transformed table
    ---@section flattenKeys
    flattenKeys = function(tbl)
        local result = {}
        for k,v in pairs(tbl) do
            table.insert(result, k)
        end
        return result
    end;
    ---@endsection


    --- Fills a holey array into an array starting at 1, contiguous upto #length
    --- Preserves non-numerical keys
    --- @generic T
    --- @param tbl T table to act on
    --- @return T transformed table
    ---@section ifillHoles
    ifillHoles = function(tbl)
        local result = {}
        for k,v in pairs(tbl) do
            if(type(k) == "number") then
                result[#result+1] = v
            else
                result[k] = v
            end
        end
        return result
    end;
    ---@endsection


    --- Slices the given list, returning the sub-list tbl[startIndex ... endIndex]
    --- Indices can be negative to count from the end of the table, e.g. -1 is the last element, and -2 is the second last element
    --- @generic T
    --- @param tbl T table to act on
    --- @param startIndex number
    --- @param endIndex number
    --- @return T slice
    ---@section islice
    islice = function(tbl, startIndex, endIndex)
        local result  = {}
        for i=(startIndex and startIndex < 0 and #tbl-startIndex+1) or startIndex or 1,
            (endIndex and endIndex < 0 and #tbl-endIndex+1) or endIndex or #tbl,
            1 do
            
            result[#result+1] = tbl[i]
        end
        return result
    end;
    ---@endsection


    --- Filters out values by the callable function
    --- @generic T
    --- @param tbl T table to act on
    --- @param callable fun(value:any, key:any):boolean
    --- @return T filtered table
    ---@section LBTable_where
    where = function(tbl, callable)
        local result = {}
        for k,v in pairs(tbl) do
            result[k] = callable(v,k) and v or nil
        end
        return result
    end;
    ---@endsection


    --- Filters out values by the callable function
    --- @generic T
    --- @param tbl T table to act on
    --- @param callable fun(value:any, key:number):boolean
    --- @return T filtered table
    ---@section iwhere
    iwhere = function(tbl, callable)
        local result = {}
        for k,v in ipairs(tbl) do
            table.insert(result, callable(v,k) and v or nil)
        end
        return result
    end;
    ---@endsection


    --- Transforms values from one format to another
    --- Note, returned value from callable is VALUE, KEY
    ---    This allows for shorter functions where the key is unchanged; and re-use with lb_iselect
    --- Select and Where functionality can be combined by returning nil as the value
    --- If the key is returned as nil, the original key is used
    --- @generic T
    --- @param tbl T table to act on
    --- @param callable fun(value:any, key:any):any,any func(value, key) => value',key' - an altered key and value to go into the result
    --- @return T transformed table
    ---@section select
    select = function(tbl, callable)
        local result = {}
        for k,v in pairs(tbl) do
            local dv, dk = callable(v,k)
            result[dk or k] = dv
        end
        return result
    end;
    ---@endsection


    --- Transforms values from one format to another
    --- Note, returned value from callable is VALUE
    --- Select and Where functionality can be combined by returning nil as the value
    --- @generic T
    --- @param tbl T table to act on
    --- @param callable fun(value:any, i:number):any func(value,index) => v' - an altered value to go into the result
    --- @return T transformed table
    ---@section iselect
    iselect = function(tbl, callable)
        local result = {}
        for k,v in ipairs(tbl) do
            table.insert(result, callable(v,k))
        end
        return result
    end;
    ---@endsection


    --- Groups values by a common key, selected by the callable, into a dictionary of lists
    --- @generic T,G
    --- @param tbl T table to act on
    --- @param callable fun(value:any, key:any):G func(k,v) => groupingValue - a value on which to group the results
    --- @return table<G,T> groups with lists of values, grouped by a commmon key
    ---@section groupBy
    groupBy = function(tbl, callable)
        local result = {}
        for k,v in pairs(tbl) do
            local groupableValue = callable(v,k)
            result[groupableValue] = result[groupableValue] or {}
            result[groupableValue][k] = v
        end
        return result
    end;
    ---@endsection


    --- Groups values by a common function, into a list of lists
    --- @generic T,G
    --- @param tbl T table to act on
    --- @param callable fun(v:any, k:number):any func(k,v) => groupingValue - a value on which to group the results
    --- @return table<G,T> table with lists of values, grouped by a commmon key
    ---@section igroupBy
    igroupBy = function(tbl, callable)
        local result = {}
        for k,v in ipairs(tbl) do
            local groupableValue = callable(v, k)
            result[groupableValue] = result[groupableValue] or {}
            table.insert(result[groupableValue], v)
        end
        return result
    end;
    ---@endsection


    --- Orders the table using the given comparison into a new table
    --- Assumes numerical keys, otherwise it does nothing useful
    --- Does not change existing table, returns a new table that is ordered
    --- @generic T
    --- @param tbl T table to act on
    --- @param comparison fun(a:any,b:any):boolean function returning strictly true, if a is before b
    --- @return T ordered table
    ---@section iorderBy
    iorderBy = function(tbl, comparison)
        local result = LifeBoatAPI.Tools.Copy(tbl, {}, true)
        table.sort(result, comparison)
        return result
    end;
    ---@endsection


    --- @generic T
    --- @param tbl T[] table to act on
    --- @param separator string separator to insert between each value
    --- @return string concatenated table values
    ---@section concat
    concat = function(tbl, separator)
        return table.concat(tbl, separator)
    end;
    ---@endsection


    ---Recursively runs through every value in a table
    ---Defends against circular references; so safe to use even with self-linking tables
    --- @overload fun(callable:function)
    --- @overload fun(callable:function, maxDepth:number)
    --- @param tbl table self instance
    --- @param callable fun(k:any,v:any,tbl:table,path:string[]) function to call per value found, callable(key, value, parentTable, pathToThisElement)
    --- @param maxDepth number max depth to recurse into, 0 or 1 are equal; neither go into any tables. -1 infinite recurse
    --- @param depth number
    --- @param path string[]
    --- @param seen table<any,boolean>
    ---@section recurse
    recurse = function(tbl, callable, maxDepth, depth, path, seen)
        path = path or {}
        depth = depth or 1
        seen = seen or {[tbl] = 1} -- track tables we've seen, avoid recursing into them
        for k,v in pairs(tbl) do
            -- track the current path
            local newPath = LifeBoatAPI.Tools.LBCopy(path)
            table.insert(newPath, k)

            -- function to be called on every value
            callable(k, v, tbl, newPath)

            -- recurse into any other tables
            if(type(v) == "table" and not seen[v]) then
                seen[v] = 1
                if(not maxDepth or depth < maxDepth) then
                    LifeBoatAPI.Tools.TableUtils.recurse(v, callable, maxDepth, depth+1, newPath, seen)
                end
            end
        end
    end;
    ---@endsection
}