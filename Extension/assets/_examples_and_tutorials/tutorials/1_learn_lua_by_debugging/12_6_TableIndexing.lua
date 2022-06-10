-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- F6 to run!

-- Another quick one, just to put it on your radar

-- reminder, tables are just like collections of variables
-- bunch of keys, and the associated value for those keys

myTable = {
    "a",  -- because we didn't give it a key, lua calculates the numerical index to give it. It's the same as [1] = "a"
    "b",  -- [2] = "b"
    "c",  -- [3] = "c"
    "d"   -- [4] = "d"
}

table.insert(myTable, "e") -- adds a new value, with the next available numerical index

-- we can "index" the table to access it's values
-- recommended to use this syntax when the key is a number
-- table[key] = value      -- write value
-- variable = table[key]   -- read value

myTable[55] = 1.123 -- set key 55 = value 1 in the table 'myTable'
abc = myTable[55]   -- read key "55" into the variable abc (value will be 1.123, we set just above)





myOtherTable = {
    name = "Paulie",  -- the same as writing ["name"] = "Paulie"
    height = 100,     -- key is "height", value is 100
    weight = 10,       -- ["weight"] = 10

    shoutFunc = function(value)
        debug.log("Ahhhhhhhh " .. value)
    end,
}

-- when the key is a string (text), we can use this shorthand to access the values
-- table.propertyName = value     -- write
-- variable = table.propertyName  -- read
-- this is the RECOMMENDED way to read keys with text names (it minifies MUCH shorter)

myOtherTable.width = myOtherTable.width + 20
val123 = myOtherTable.height

-- notice how we've already used this syntax for the `debug`, `input` and `output` tables
myOtherTable.shoutFunc(123) -- see above, we set myOtherTable = { shoutFunc = function() ... end }



-- and for completeness, of course - you can store ANYTHING in tables
-- including other tables

myExampleTable = {
    subTable = {
        a = 1,
        b = 2
    },
    value123 = 123
}

exampleVar = myExampleTable.subTable.a

myExampleTable.subTable.b = 55




















------------------------------------
simulator:exit()