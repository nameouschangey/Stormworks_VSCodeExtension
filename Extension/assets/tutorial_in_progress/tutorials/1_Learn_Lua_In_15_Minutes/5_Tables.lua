--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


-- Just hit F5 at any time, to run this file as a regular Lua file (without the Stormworks simulator).
--     You'll see debugger controls at the top of the window once it starts running.
--     Click StepInto to move 1 instruction at a time
--
--     You can use these to run 1 instruction at a time and see EXACTLY what lua is doing
--          * hovering over a variable tells you its current value
--          * clicking left of the line numbers will set a red circle ("breakpoint"). Pressing F5 will run all code up to that instruction.
--             you can use that to skip the parts you understand, and get straight to the "new" stuff each time

-- PS: If you noticed these green lines all start with "--", and don't seem to do anything. You've already intuitively figured out how comments work.


-------------------------------------------------------------------------------------------------------------
print("-----Tables------")

print("Tables are another 'type' of value, like text (strings), numbers and booleans")
print("It's an extremely simple feature, that lets you do a ton of things!")

-- tables are literally just collections of "keys" to "values"
-- keys can be ANY type of thing
-- values can be ANY type of thing
-- It's really that simple
-- (it's like a variable, that has it's own variables inside)

myTable = {
    ["text"] = "value",
    ["mykey2"] = "value2",
    [true] = 848484,
    [55] = true,
    [77] = false,
    ["abc"] = 123,
    ["myFunction"]  = function(...) end -- remember from before, how "functions" are also just a "thing" we can store in variables
}

-- syntax is just:
-- {
--     [key] = value
-- }

-- as a shorthand, if the key is a piece of text, you can also write it like this:
myTable = {
    text = "value",
    mykey2 = "value2",
    [true] = 848484,
    [55] = true,
    [77] = false,
    abc = 123,
    myFunction = function(...) end,
}
-- notice how we still need [] around the keys that aren't just text values ([true], [55], [77])


-- tables can be used to represent "things" more easily
-- Instead of:
dog1Height = 22
dog1Name = "Rex"
dog1X = 10
dog1Y = 11

-- Do:
dog1 = {
    height = 22,
    name = "Rex",
    x = 10,
    y = 11
}

print("you can use tableVariable.property to access its properties")
print(dog1.height)
print(dog1.name)
print(dog1.x)
print(dog1.y)


print("Imagine a table, in a table")
example = {
    myName = "example table",
    myRadarDistance = 111,
    mySubTable = {
        exampleKey = "Look, I'm in table, in a table"
    }
}

-- table.property.property and so on
print(example.mySubTable.exampleKey)

-- remember that you've probably already used tables
-- in Stormworks 'input' is a table, that you used like 'input.getNumber()'
--      where input is a table, getNumber is a property of that table, and the value it has is a function

-- defined something like this:
input = {
    getNumber = function(index)
        return SomeValueFromTheGame
    end,

    getBool = function(index)
        return SomeBooleanFromTheGame
    end,
}

-- same for screen, map, table, math, etc.


---------------------------------------------------------------------------------------------------------

print("You can access table properties using '.' like myTable.property1 etc.")
print("But as you can guess, that doesn't work if the key (property name) WASNT text")

-- In the same way as when we defined the table
--  we had to put [55], [77] etc, intead of just 55=..., 77=... because those names aren't text, they're...well..numbers
exampleTable = {
    [55] = "abc",
    [77] = "def",
    textPropertyName = "asdasdkasd"
}

-- we also use a different syntax to access their value
print("Use exampleTable[key] to access any property, especially those that are not text")
print(exampleTable[55])
print(exampleTable[77])

-- and yes, it works for text properties too - it's just *stylistic* preference we tend to use the "." instead
-- but it does work:
print(exampleTable["textPropertyName"])
print(exampleTable.textPropertyName)
-- these two are exactly the same thing
--  (but we prefer the second one, because we can use a tool that shrinks our code more easily)

---------------------------------------------------------------------------------------------------------

print("so why use tables?")
print("If you have a 'thing' that you'll want more than one of, a table is a great way to represent it")

function createDog(dogName, dogHeight, dogColor)
    return {
        name = dogName,
        height = dogHeight,
        color = dogColor
    }
end

dog1 = createDog("Rex", 100, "brown")
dog2 = createDog("Dave", 10, "golden")
dog3 = createDog("Zippo", 99, "dark brown")

---------------------------------------------------------------------------------------------------------