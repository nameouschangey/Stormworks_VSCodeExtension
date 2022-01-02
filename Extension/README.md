# Stormworks Lua with LifeBoatAPI


An extension to provide proper build processes to the Stormworks community.

Key Features:
- Do you hate trying to figure out why a certain value is wrong in a calculation?
- Do you hate writing all your code in one big, disorganised file?
- Do you hate the 4000 character limit?
- Do you wish you could make well-structured code libraries, and use that code on multiple projects without copy/pasting?

LifeBoatAPI solves these by providing:
- An extremely powerful Minimizer, that can remove redudant code and shrink files massively
- A Combiner, that can trace the "require(...)" keyword so you can write code across multiple files
- A full Debugger that can show you the memory values of your Microcontroller
- A Simulator that support multiple screens simultaneously
- Full type hinting and error checking to avoid typos
- A solid library of code, the LifeBoatAPI, to simplify writing Stormworks code.

**Developed by Nameous Changey:** https://github.com/nameouschangey 

**Please report any issues here:** https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues

Using:
- integrated lua-docs from René Sackers: https://github.com/Rene-Sackers/StormworksLuaDocsGen
- lua-debug extension from: actboy169
- lua language server extension from: sumneko

# Latest Change
Try using the LifeBoatAPI library via `require("LifeBoatAPI")` for a full vector library, maths utilities and more.


# Quick Start Guide
## (0. Set your name so you can be credited!)
Boilerplate is generated with your details at the top of all files you create and build.

Goto Settings, and set your AuthorName, GithubLink and WorkshopLink:

- Press `CTRL+Comma`
- Use the searchbox to find "Stormworks User"
- Fill in those fields and a creditation notice will be automatically generated on files you create
- The optional "extended boilerplate" allows you to write a custom line, if you also wish

## 1. Create a New Stormworks Code Project
To create a New Project:

- From the "Get Started" screen click "New File", then select **`Stormworks: New Microcontroller Project`**
- Or, From the "File" menu, select "New File..." (not "New File")
- Or, Open the command-palette (`CTRL+SHIFT+P`) and type in "`Stormworks: New Microcontroller Project`"

## 2. Run, Simulate, Build
Once the project is open, you can:

### `F5` Run
Run the current file as plain lua, with debugging support. Useful for testing small code snippets, automated testing etc.

>You can set breakpoints (where the debugger stops, so you can inspect variables), by clicking in the left-hand Line Number column (adds a little red dot).*

### `F6` Simulate
In a **Microcontroller Project** you can press `F6` to simulate the current file in the LifeBoatAPI Simulator.

This is a full debug simulator, that works with breakpoints (as above), provides multi-screen and touch support.

>See the provided _build/SimulatorConfig.lua file in your project for configuring the inputs and screen size

### `F7` Build
To compile your project into the smallest, 4K character, form needed by the game - press F7.

This combines all your require(...) directives correctly, and then minimizes the output into the **`/out/release/`** folder.

>The basic use of the minimizer is more powerful than both lua-min and FlaffyPonyIDE's minimizers. However, it also adds redundancy removal functionality; which opens a new world of options. See below.

## 3. Got stuck? Ask for help!
This extension is in active development; I'm happy to try and help you get setup - and of course, when there are bugs, I'd always appreciate them being noted.

Please report any bugs you find here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues
And if you want some help, you can find me on the Stormworks discord as "Nameous" and ask there: https://discord.com/invite/stormworks

## (Reminder: Let the Minimizer do it for you!)

When writing code, it's tempting to try and shorten everything; or do clever tricks to "get the size down".

Remember, the **the minimizer will do the best job, when the code is clear and readable**. So keep variable names long and descriptive; write code that's easy to update and change - stop shooting yourself in the foot!

```lua
-- do this
function GetAngleBetweenTwoSurfaces(surfaceA, surfaceB, rotationAngle)
end

a = math.min(1,0)

-- instead of 
function surfRot(a,b,t)
end

m = math
a = m.min(1,0)
```

# Features

## Use the Lua "require(...)" Function
LifeBoatAPI also adds the "require(...)" lua function.

- In lua, using `require("FolderName.FileNameWithoutExtension")` includes code from other files
- You can organise your project significantly better this way, and re-use code files between multiple projects
- require's are fully resolved by the debugger, simulator and build process - so you don't need to worry.

And remember, the more people you encourage to start using VSCode, the less code you need to write yourself:

```lua
require("TrapdoorLib.Timers")
require("LifeBoatAPI.Maths.LBAngles")
require("BeginnersLibrary.Missiles.Guidance")

timer = trapdoor_timer_start(onTimerEnd)
function onTick()
    timer:onTick()
end

function onTimerEnd()
    timer:reset()

    local elevation = LBAngles_convertTurnsToRadians(input.getNumber(1))
    
    BeginnersSetMissileElevationFunction(elevation)
end
```

> Note: You should NOT require("") the global lua modules, as these are already automatically included into every file.
    e.g. require("screen"), require("map"), require("input"), require("output") are unecessary and will not work.
    You can simply use e.g. `screen.drawCircleF(...)` without any require, as it's part of Stormworks global modules.

## Create and Use Code Libraries
Use and create code libraries (it's easy!)

- Open VSCode settings `CTRL+Comma`, click on "Folder" settings - so these can be changed per project.
- Use the searchbox to find "Stormworks library"
- Add the absolute (full) paths to other libraries you wish to use.
- You can now require files from under this folder:

    - library path you added: *C:/myProjects/myGuidanceLibrary/*

    - file you want to use: *C:/myProjects/myGuidanceLibrary/APM/APM_Angles.lua*

    - lua require to write: *require("APM.APM_Angles")*


## Redundancy Removal
One of the most important features of the LifeBoatAPI toolset, is the Redundancy Removal process - as part of the Minimizer. (Build `F7`)

In most languages, when a function is not used - it is removed from the output. As such, you don't need to worry about only using one part of a library - you *"only pay for what you use"*.

**LifeBoatAPI now adds this functionality to Stormworks Lua**

Each block that is surrounded by `---@section MyIdentifier` and `---@endsection` is checked to see if the identifier appears in the code, and if not, is removed (recursively until all redundancies are removed).

This allows you to setup a library so that each function is a separate block, and is stripped from the output if it wasn't actually called at any point.

### Example:

```lua
---@section myOtherFunction
function myOtherFunction(abc)
    return abc + "def"
end;
---@endsection`

---@section myFunction
function myFunction(abc)
    myOtherFunction(abc)
end;
---@endsection`

var a = 10;
--end program
```

Because `myFunction` isn't used by any other code, it gets removed.

Then, that means the call to `myOtherFunction` is also gone - and so now there's no code using `myOtherFunction`, and it too will be removed.

As such, the only code that will remain is `var a = 10`, which is what we'd expect - as it's the only code actually "doing something".

### Extended Syntax

By default, the redundancy remover searches from the `---@section Identifier` to the next `---@endsection` it finds. And will remove the section if the Identifier appears 0 times.

This doesn't work well for nested blocks though - such as class definitions, as such you can also use the extended syntax (`identifier number blockname`)

*Note, we're using the included EmmyLua type hinting syntax below as well*

```lua
---@class myClass : BaseClass
---@field size number
---@field name string
---@section myClass 1 _MYCLASS_
myClass = {
    new = function(this, s, n)
        return LBCopy(this, {size = s, name = n})
    end

    ---@section myClass_destroyAllHumans
    myClass_destroyAllHumans = function() end
    ---@endsection

    ---@section myClass_killOrBeKilled
    myClass_killOrBeKilled = function() end
    ---@endsection
}
---@endsection _MYCLASS_
```

## Pre and Post Build Steps
To allow for more complex build chains, two additional lua files are generated with your project:
`/_build/_pre_buildactions.lua`
`/_build/_post_buildactions.lua`

These are entirely optional, but if they exist - they are run just before ("_pre_") and just after ("_post_") the build (`F7`) is run.
This allows you to integrate the build chain with other tools or processes more easily.

For example, if you are using Réne Sackers Lua-Extract tool; https://github.com/Rene-Sackers/StormworksLuaExtract
A potential build chain might be:
- In `_post_buildactions.lua`
- Copy the output from /out/release/ to the Lua-Extract /workspace/ directory (overwriting the relevant MC file)
- Lua-Extract will then take this data, and copy it into the game for you

This would allow you to update the files in-game, simply by pressing `F7`


Similarly, in `_pre_buildactions.lua`, if you have code generation you wish to run you can do so - for example:
- a find-and-replace Macro that lets you write code that acts like a function, without the function overhead
- running an external image to lua tool, so you can just stick the images in your `Project` folder, and automatically include them into your lua script every time you hit `F7`


\!\[feature X\]\(images/feature-x.png\)


## Multi-MC Simulation

Please see the /_build/_multi/ folder for this feature
It is an experimental feature, for advanced lua users; to support chaining multiple MCs together to multiple (potentially different) monitors.


## What is the "LifeBoatAPI"

The lifeboat API, is name such as the functionality being provided is more than just a few library functions - but a framework to simplify writing Stormworks mods, and Stormworks is a rescue game (a.k.a/ "Nameous is not very good at naming things")

It's currently in development and so much of it is hidden from the current version of the extension.

In future versions, you will be able to use LifeBoatAPI features via the `require(...)` command.

## Requirements

The LifeBoatAPI simulator was written for Windows, unfortunately as Nameous Changey has no access to a Mac - this is unlikely to change in the near future; unless there is significant demand for it to be ported.

All other requirements are installed automatically with this extension:
Lua by sumneko
Lua-Debug by actboy168