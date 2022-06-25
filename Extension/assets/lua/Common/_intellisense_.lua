-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--- DO NOT EVER REQUIRE THIS FILE
--- IT IS TO RE-ADD THE DELETED BUILTINS, TO GET INTELLISENSE TO WORK CORRECTLY FOR STORMWORKS CODE
--- THIS FILE JUST NEEDS TO EXIST WITHIN THE SEARCH PATH

--- Include the contents from another file, into the global environment of this file
--- e.g. require("_build._simulator_config") will include the contents of the file "ProjectFolder/_build/_simulator_config.lua" into this file
---@param filename string filename to include, with "." instead of "/" between folders
require = function(filename) end

--- Allows a program to traverse all fields of a table.
--- Its first argument is a table and its second argument is an index in this table.
--- A call to next returns the next index of the table and its associated value.
--- When called with nil as its second argument, next returns an initial index and its associated value.
--- When called with the last index, or with nil in an empty table, next returns nil. If the second argument is absent, then it is interpreted as nil.
--- In particular, you can use next(t) to check whether a table is empty.
---@param tbl table
---@param index number
---@overload fun(table: table):number,any
next = function (tbl, index) end

--- Provides an iterator over all the key:value pairs in the table (unordered)
--- Use within a for loop: for key,value in pairs(myTable) do ... end
---@generic K
---@generic V
---@param tbl table< K, V >
---@return K key, V value
pairs = function (tbl) end

--- Provides an iterator over all the ordered, numerical index pairs in the table
--- Starts at index 1 and ends at the first nil index
--- Use within a for loop: for index,value in ipairs(myTable) do ... end
---@generic K
---@generic V
---@param tbl table< K, V >
---@return number index, V value
ipairs = function(tbl) end

--- Returns the type of its only argument, as a string.
--- The possible results of this function are:
--- "nil" (a string, not the value nil), "number", "string", "boolean", "table", "function", "thread", and "userdata".
---@param value any
---@return string typename
type = function (value) end


--- Receives a value of any type and converts it to a string in a human-readable format.
--- @param value any
--- @return string converted
tostring = function(value) end


--- When called with no base, tonumber tries to convert its argument to a number.
--- If the argument is already a number or a string convertible to a number, then tonumber returns this number; otherwise, it returns fail.
---@param value string|number
---@return number converted
tonumber = function (value) end


---@return number
math.cos = function(x) end -- fix for missing return type in Lua's built-in docs