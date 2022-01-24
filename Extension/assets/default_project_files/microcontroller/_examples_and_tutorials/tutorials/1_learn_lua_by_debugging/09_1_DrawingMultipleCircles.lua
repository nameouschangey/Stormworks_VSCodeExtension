-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- F6 to run!
-- To try, make multiple circles using the createCircle function and table.insert()

createCircle = function(circleX, circleY, circleRadius, circleMovementSpeed)
    return {
        x = circleX,
        y = circleY,
        radius = circleRadius,
        speed = circleMovementSpeed
    }
end

-- table.insert adds a new value into a table, and figures out the next numerical key to give it
-- e.g. a table like this:
--      myTable = { [1] = "a", [2] = "b", [3] = "c"}
--      table.insert(myTable, "NEW VALUE")
--      the next available key is [4], and that's where the "NEW VALUE" will be put
-- You can think of it as like it's adding something to the end of a list

myCircles = {} -- new table for holding the circles

circle1 = createCircle(10,10,5, 1) -- call the function we made above, putting values into the brackets for the parameters
table.insert(myCircles, circle1)

circle2 = createCircle(5,5,2,1)
table.insert(myCircles, circle2)

circle3 = createCircle(0,5,2,2)
table.insert(myCircles, circle3)
-- If you're using the debugger, you can hover over "myCircles" to see that it contains 3 tables
-- and you can hover over eat of the circle... tables to see what's in them


onTick = function()
    -- because we have a table of circles, like a list. we can do the same code for each of them using a loop

    -- index is the "key" for each value, in this case 1,2,3
    -- circle is a variable that will be changed to each value in thet table, one after another
    for index, circle in ipairs(myCircles) do

        -- this runs once per circle in myCircles, so we don't need to write it 3 times
        circle.x = circle.x + circle.speed
        circle.y = circle.y + circle.speed

        if circle.x > 32 then
            circle.x = 0
        end

        if circle.y > 32 then
            circle.y = 0
        end
    end

end


onDraw = function()

    for index, circle in ipairs(myCircles) do
        screen.setColor(255,100,100)
        screen.drawCircle(circle.x, circle.y, circle.radius) -- draw a circle at x=16, y=16, with a radius that grows to 30 every 10 seconds

    end

end

-- But why do this? isn't it easier with just "x" and "y" in the other example?
-- Next file shows the power of using a table - how you can write it once, and have it work for lots of things!

-- You can try making a second table for a second circle, then add the movement code in onTick, and drawing code in onDraw to show it!