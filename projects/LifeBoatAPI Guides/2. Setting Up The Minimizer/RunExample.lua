-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Tools.Combiner.LBCombiner")
require("LifeBoatAPI.Tools.Minimizer.LBMinimizer")
require("LifeBoatAPI.Tools.Minimizer.LBParsingConstantsLoader")

--------------------------------------------------------------------------------------------
-- 1) Setup the constants for the file you're minimizing
-- The below shows the setup for vehicles.
--------------------------------------------------------------------------------------------

print("Loading Constants") 
local constants = LBParsingConstantsLoader:new()
constants:addRestrictedKeywords(constants._vehicle_restricted_callbacks)  -- select from _vehicle_restricted and _mission_restricted

-- "Load" external libraries that you're allowed to use in Stormworks
-- Likely these are the only ones forever, but if it changes - update this list
constants:loadLibrary("table")
constants:loadLibrary("math")
constants:loadLibrary("string", true)

-- Load the relevant 'Nelo doc file; downloaded from: https://github.com/Rene-Sackers/StormworksLuaDocsGen
-- You will either want the missions or vehicles doc file. Specify the path to it below.
constants:loadNeloDocFile(LBFilepath:new([[C:\personal\STORMWORKS\projects\LifeBoatAPI Guides\2. Setting Up The Minimizer\docs\docs_vehicles.lua]]))




------------------------
-- 2. Perform the combination process; specifying the directories to find source code in
------------------------

-- Change the below arguments to match your own directories and files
-- arg 1: Root folder under which all your .lua code can be found. (the root folder for your workspace in VSCode)
-- arg 2: The filepath to use as an entry-point, e.g. the file that contains onTick and onDraw
-- arg 3: The filepath to output your combined file to

print("Combining Files") 
local combiner = LBCombiner:new()

combiner:addRootFolder(LBFilepath:new([[C:\personal\STORMWORKS\projects\]]))

combiner:combine(LBFilepath:new([[C:\personal\STORMWORKS\projects\LifeBoatAPI Guides\2. Setting Up The Minimizer\ExampleInput.lua]]),
                 LBFilepath:new([[C:\personal\STORMWORKS\projects\LifeBoatAPI Guides\2. Setting Up The Minimizer\Example_Combined.lua]]))




------------------------
-- 3. Perform the minification process; specifying the file to minimize, and where to save the minimized file
------------------------

-- Change the below arguments to match your own directories and files
-- arg 1: input file to minimize - likely the output file from the combiner above; for the simplest workflow
-- arg 2: output filepath to save the minimized data.

print("Minimizing Output") 
local minimizer = LBMinimizer:new(constants)
minimizer:minimizeFile(LBFilepath:new([[C:\personal\STORMWORKS\projects\LifeBoatAPI Guides\2. Setting Up The Minimizer\Example_Combined.lua]]),
                       LBFilepath:new([[C:\personal\STORMWORKS\projects\LifeBoatAPI Guides\2. Setting Up The Minimizer\Example_Minified.lua]]))
print("Complete") 