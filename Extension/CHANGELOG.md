# Change Log

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
