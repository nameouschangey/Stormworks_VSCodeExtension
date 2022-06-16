# Change Log
Issue tracker: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues 

#### [0.0.23] - 16th June 2022
**minor**
- Re-enabled os.clock in the sandbox, due to request (note: this will still not work in SW)
- - Also note, print is enabled, but you should debug.log instead
- Re-enabled requring from /_build/ folder, without compromising performance

#### [0.0.22] - 15th June 2022
**major**
- Improved simulator sandboxing, more accurately reflects the functionality available to the game
- Performance improvements in the build process
- Simulator and Build process "require" functionality now match
**minor**
- Fixed issue with using '' quotes in require

#### [0.0.21] - 14th June 2022
**minor**
- Newlines in output should now be \n and not \r\n (only affects using minified data in directly via another process)

#### [0.0.20] - 14th June 2022
**minor**
- Fixed missing ---@endsection in default mc file

#### [0.0.19] - 13th June 2022
**minor**
- Removed all require("LifeBoatAPI") from default files for a simpler user experience
- Improved command warnings, and removed some from the command palette (recommend using right-click menu instead)

#### [0.0.18] - 12th June 2022
**major**
- EXTREMELY LARGE UPDATE
- Rewrote majority of internals to work better per-folder/per-workspace
- Fixed requires not working + simulator not working, for some users
- Added NEW git-libraries feature
- - "Add Library" and enter a git link, to add it to the project
- - require the files from this easily
- - "Share File" to create a quick gist to share with friends
- - Majorly extends the ability to share code with other developers, and easily make + re-use libraries between projects
- - Auto-updates when launching, so you can use the latest at all times

#### [0.0.17]
**major**
- Fix for people running VSCode terminal through cmd; newlines in command were preventing build working correctly
**minor**
- "Enable Pan" is now persistent between sessions
- ---@section change, if you miss the identifier, it will no longer crash - but instead will just remove that section

#### [0.0.16]
**major**
- Fix for spaces in windows username, preventing correct launch of Simulator

#### [0.0.14] + [0.0.15]
**major**
- Quick fix for "existing.push is not a function"
- Updated documentation by Toastery
**major**
- Fix for existing projects

#### [0.0.13] - 25th February 2022
**major**
- Added hexadecimal support, as game does not support 0xAAA -> 0xFFF, converts to decimal
- Fixed issue with spaces and other characters in filepaths, prevent Simulator working for some people
- Fixed first-time opening issue, where intellisense doesn't immediately load
- Updated addon api-docs, now correct to in-game
**minor**
- map functions no longer throw an error if used in onTick
- screen.setColor wraps at 255 as the game does, instead of clamping
- drawTextBox now respects \n newline characters as the game does

#### [0.0.12] - 25th January 2022
**minor**
- _buildactions.lua fixed for addons lua, which was breaking build process (caused by 0.0.11, sorry!)

### [0.0.11] - 24th January 2022
**major**
- **Added massive, interative tutorial for learning lua**
- **Major accuracy improvements, simulator now replicates many in-game bugs**
- Fixed issue with require, when it's the first line in the file
- Fixed simulator running on low-end GPUs/laptops
- Improvement to the minimizer, can now cut unnecessary 0's off decimals
- Added new _build_actions.lua system, far more flexible
- Cleaned up _simulator_config, newer style uses onLBSimulatorTick to simplify things
- Major work to TextBox wrapping code, now accurate to in-game

**minor**
- debug.log now prints to the DEBUG CONSOLE
- simulator window size now saves between sessions
- added styled button
- 1x3 monitor was missing
- can now disable the lua-built in libraries
- second set of touch data wasn't being utilized correctly
- button sizes fixed

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
