-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- You've seen how to set breakpoints, and in that same tutorial - how variables work
-- To put your learning into practice, try the following quick exercises:

-- Write your code and hit F6 to run
-- If you make mistakes, that's normal, just try again till it works.
-- (Screw it all up? just make a new project - no sweat.)



-- 0. Example. (Sometimes it's hard to get started without an example to copy. No matter how well you understand it)
--  "Define a variable called myDogsHeadSize and give it the value 55"
myDogsHeadSize = 55
debug.log("Value of myDogsHeadSize (expecting 55): " .. tostring(myDogsHeadSize)) -- output



-- 1. Overwrite the value of radiusOfMyHorse with the value 55
radiusOfMyHorse = 10
radiusOfMyHorse = 15
-- your code here:

debug.log("Value of radiusOfMyHorse (expecting 101): " .. tostring(radiusOfMyHorse)) -- output



-- 2. Subtract applesThatAreRed from applesInTotal, and write the result into a variable called applesThatAreGreen
applesThatAreRed = 100
applesInTotal = 1000
-- your code here:

debug.log("Value of applesThatAreGreen (expecting 900): " .. tostring(applesThatAreGreen)) -- output



-- 3. Put a motivational message to yourself, in quotes, into a variable called myMotivationalMessage
--
-- your code here:

debug.log("Your message to yourself: " .. tostring(myMotivationalMessage)) -- output



-- 4. (HARDER) figure out a way to swap the values of `myFirstValue` and `mySecondValue`
--    you're not allowed to just hard-code the numbers in e.g. `mySecondValue = 500`, it'd work, but that'd be cheating.
tempValue = nil -- nil means "nothing"/"empty"/"not holdin' squat".
myFirstValue = 55
mySecondValue = 100
-- your code here:


debug.log("Swapped values. myFirstValue (expecting 100): " .. tostring(myFirstValue) .. ", mySecondValue (expecting 55): " .. tostring(mySecondValue))
