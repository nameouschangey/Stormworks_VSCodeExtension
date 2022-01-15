# Change Log
Issue tracker: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues 

### [0.0.11] - 10th January 2022
**minor**
- Fixed require issue, if there was no newline before the first require, it won't get picked up
- 

### [0.0.10] - 10th January 2022
**minor**
- Reverted previous nillification of debug/package libraries, which removed the debuggers ability to run properly
- LBStateMachine now uses 0 as default state name instead of "default" to save characters
- Apologies

### [0.0.9] - 9th January 2022
**major**
- Added colour-correction so the simulator colour-space matches the ingame one.
- Added LBColorSpace for correcting the in-game colours, back to how they should actually appear.
- Using non-stormworks compatible lua standard-libraries (e.g. "os" and "package") will now correctly result in errors similar to the game

**minor**
- Improved Minimizer; some leading spaces were being missed between certain operators
- Addon projects are now created with most minifications disabled
- Fixed issue where comment removal was disabled, that may cause issues in the output
- Minimizer now returns a more meaningful "reduced x characters" size; post redundancy removal
- Addon LUA intellisense was showing within MC projects

### [0.0.8] - 2nd January 2022
**major**
- **Add require("LifeBoatAPI") library for Microcontrollers:**
   - LBVec - vector maths library
   - LBTouchScreen - touch handling and basic button logic
   - LBAnimation - tick-based animation handling
   - LBStateMachine - simple state machine handling
   - LBTableUtils - table manipulation, including linq-like functions 
   - LBRollingAverage - simple way to handle rolling averages
   - LBMaths - simple maths conversions library, including compass conversion

- Minimizer settings now available, can turn off all minification if desired

**minor**
- Add optional pan/zoom position saving to the Simulator between sessions
- Fixed, simulator handling nil values differently to the game
- Fixed, goto keyword being minimized
- Wrapped up LifeBoatAPI into a single global, to reduce the debug spam
- Redirected stderr away from the output during build, to reduce log spam


### [0.0.7] - 19th December 2021
**major**
- Fixed screen.drawTextBox exception on certain strings (causing nothing to display)
- **Added Multi-MC simulation support; in the _build/_multi folder for advanced users**
- Fixed "using input and output in onDraw should be an error"
- Fixed "input.getBool(1) is E OR Q pressed, not just Q"

**minor**
- Minor cleanup of input, output and screen tables containing non-SW functions not starting with an underscore


### [0.0.6] - 12th December 2021
**major**
- Fixed number parsing issue affecting everybody outside of English-language countries! (sorry!)
- Fixed _debug_simulator_log.txt not generating if the folder has spaces in it's path

**minor**
- Resolved two warnings generated in the _build.lua and _simulator.lua files that were annoying to people who like clean code.
- Further improvements to logging simulator errors


### [0.0.5] - 11th December 2021
**major**
- Added error log file for the simulator, so we can solve more issues
- Now creates a .code-workspace file by default in the first project you make. Which simplifies life for new VSCode users.
- Added "Open Found Workspaces" for when users accidentally open a folder, instead of a workspace; again, to simplify life for new VSCode users.
- Improved pre and post build steps in lua.
- Fixed issue where running files that are in sub-folders wouldn't work, due to an incorrectly generated require path.
- Replaced internal renderer for more accurate results

**other**
- Removed onLBSimulatorInit method, to account for MCs where properties are read in global space, before the first tick
- Set cpath and path of the debugger when running, to reduce the chance of an occasional issue when using multiple workspaces
- Simulator now displays 32-bit floats, rather than 64-bit doubles
- Fixed simulator config "portrait mode" previously not working
- Fixed touch coordinates going outside normal range
- Fixed simulator zoom issue
- Fixed screen.drawText() positioning, rendering issue
- Fixed screen.drawClear() not respecting the colour
- Fixed simulator "skipFrames" causing a black screen
- Renamed default simulator config "_simulator_config" for consistency.


### [0.0.4] - 1st December 2021
- First official release
- Updated creditations to René Sackers - lua-docs generation
- Minor fixes

### [0.0.0] - 20th November 2021
Initial testing release
- LifeBoatAPI for Microcontrollers has some useful utilities
- LifeBoatAPI for Addons needs re-written from scratch, (not - included)
- Simulator written and working
- Debugging configurations setup and working
- Project creation written and working
