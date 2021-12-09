"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.addBoilerplate = exports.addUserBoilerplate = exports.beginCreateNewProjectFolder = void 0;
const vscode = require("vscode");
const path = require("path");
const util_1 = require("util");
const utils = require("./utils");
const microControllerDefaultScript = `--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues
--- 	Please try to describe the issue clearly, and send a copy of the /_build/_debug_simulator_log.txt file, with any screenshots (thank you!)


--- With LifeBoatAPI; you can use the "require(...)" keyword to use code from other files!
---     This lets you share code between projects, and organise your work better.
---     The below, includes the content from _simulator_config.lua in the generated /_build/ folder
--- (If you want to include code from other projects, press CTRL+COMMA, and add to the LifeBoatAPI library paths)
require("_build._simulator_config")

--- default onTick function; called once per in-game tick (60 per second)
ticks = 0
function onTick()
    ticks = ticks + 1
    local myRandomValue = math.random()

    if(ticks%100 == 0) then
        -- Debugging Tip (F6 to run Simulator):
        --  By clicking just left of the line number (left column), you can set a little red dot; called a "breakpoint"
        --  When you run this in the LifeBoatAPI Simulator, the debugger will stop at each breakpoint and let you see the memory values
        -- You can also look at the "callstack" to see which functions were called to get where you are.
        --  Put a breakpoint to the left of this a = nil statement, and you'll be able to see what the value of "myRandomValue" is by hovering over it
        a = nil;
    end
end

--- default onDraw function; called once for each monitor connected each tick, order is not guaranteed
function onDraw()
	-- when you simulate, you should see a slightly pink circle growing over 10 seconds and repeating.
	screen.setColor(255, 125, 125)
	screen.drawCircleF(16, 16, (ticks%600)/60)
end


--- Ready to put this in the game?
--- Just hit F7 and then copy the (now tiny) file from the /out/ folder

`;
const microControllerDefaultSimulatorConfig = `
--- Note: code wrapped in ---@section <Identifier> <number> <Name> ... ---@endsection <Name>
---  Is only included in the final output if <Identifier> is seen <number> of times or more
---  This means the code below will not be included in the final, minimized version
---  And you can do the same to wrap library code; so that it's there if you use it, and deleted if you don't!
---  No more manual cutting/pasting code out!

---@section __SIMULATORONLY__ 1 _MAIN_SIMSECTION_INIT


-- When running the simulator, the global variable __simulator is created
-- Make sure to do any configuration before the the start of your main file
---@param simulator LBSimulator
---@param config LBSimulatorConfig
---@param helpers LBSimulatorInputHelpers
__simulator.config:configureScreen(1, "3x2", true, false)
__simulator.config:setProperty("ExampleProperty", 50)

-- handlers that automatically update the inputs each frame
-- useful for simple inputs (sweeps/wraps etc.)
__simulator.config:addBoolHandler(10,   function() return math.random() * 100 < 20 end)
__simulator.config:addNumberHandler(10, function() return math.random() * 100 end)

-- there's also a helpers library with a number of handling functions for you to try!
__simulator.config:addNumberHandler(10, LBSimulatorInputHelpers.contantNumber(5001))


--- runs every tick, prior to onTick and onDraw
--- Usually not needed, can allow you to do some custom manipulation
--- Or set breakpoints based on simulator state
---@param simulator LBSimulator
function onLBSimulatorTick(simulator)end

--- For easier debugging, called when an output value is changed
function onLBSimulatorOutputBoolChanged(index, oldValue, newValue)end
function onLBSimulatorOutputNumberChanged(index, oldValue, newValue)end

---@endsection _MAIN_SIMSECTION_INIT


`;
const addonDefaultScript = `

function onTick(game_ticks)
end

`;
const preBuildActionsDefault = `
-- This file is called just prior to the build process starting
-- Can add any pre-build actions; such as any code generation processes you wish, or other tool chains
-- Regular lua - you have access to the filesystem etc. via LBFilesystem
-- Recommend using LBFilepath for paths, to keep things easy

-- default is no actions
print("Build Started - No additional actions taken in _build/_pre_buildactions.lua")
`;
const postBuildActionsDefault = `
-- This file is called after the build process finished
-- Can be used to copy data into the game, trigger deployments, etc.
-- Regular lua - you have access to the filesystem etc. via LBFilesystem
-- Recommend using LBFilepath for paths, to keep things easy

-- default is no actions
print("Build Success - No additional actions in _build/_post_buildactions.lua file")
`;
function beginCreateNewProjectFolder(isMicrocontrollerProject) {
    const fileDialog = {
        canSelectFiles: false,
        canSelectFolders: true,
        canSelectMany: false,
        title: "Select or Create empty Project Folder",
        defaultUri: vscode.workspace.workspaceFolders === undefined ? vscode.Uri.file("C:/") : vscode.Uri.file(path.dirname(vscode.workspace.workspaceFolders[0].uri.fsPath))
    };
    return vscode.window.showOpenDialog(fileDialog)
        .then((folders) => {
        if (folders !== undefined) {
            var workspaceCount = vscode.workspace.workspaceFolders ? vscode.workspace.workspaceFolders.length : 0;
            var projectName = path.basename(folders[0].fsPath);
            return {
                isMicrocontroller: isMicrocontrollerProject,
                selectedFolder: { index: workspaceCount, uri: folders[0], name: projectName },
                settingsFilePath: vscode.Uri.prototype,
                launchFilepath: vscode.Uri.prototype
            };
        }
        else {
            return Promise.reject("No folder selected");
        }
    })
        .then((params) => {
        params.settingsFilePath = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/.vscode/settings.json");
        return vscode.workspace.fs.readFile(params.settingsFilePath).then((data) => {
            const stringData = new util_1.TextDecoder().decode(data);
            const jsonData = JSON.parse(stringData);
            return jsonData;
        }, (err) => {
            return {};
        }).then((settingsJson) => {
            settingsJson["lifeboatapi.stormworks.isMicrocontrollerProject"] = isMicrocontrollerProject;
            settingsJson["lifeboatapi.stormworks.isAddonProject"] = !isMicrocontrollerProject;
            return vscode.workspace.fs.writeFile(params.settingsFilePath, new util_1.TextEncoder().encode(JSON.stringify(settingsJson, null, 4)))
                .then(() => params);
        });
    })
        .then((params) => {
        params.launchFilepath = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/.vscode/launch.json");
        return vscode.workspace.fs.readFile(params.launchFilepath).then((data) => {
            const stringData = new util_1.TextDecoder().decode(data);
            const jsonData = JSON.parse(stringData);
            return jsonData;
        }, (err) => {
            return {
                version: "0.2.0",
                configurations: []
            };
        }).then((launchJson) => {
            launchJson["configurations"].push({
                name: "Run Lua",
                type: "lua",
                request: "launch",
                program: "${file}",
            });
            return vscode.workspace.fs.writeFile(params.launchFilepath, new util_1.TextEncoder().encode(JSON.stringify(launchJson, null, 4)))
                .then(() => params);
        });
    })
        .then((params) => {
        if (params.isMicrocontroller) {
            return setupMicrocontrollerFiles(params).then(() => params);
        }
        else {
            return setupAddonFiles(params).then(() => params);
        }
    })
        .then((params) => vscode.commands.executeCommand("workbench.view.explorer").then(() => params))
        .then((params) => {
        if (!vscode.workspace.workspaceFile) {
            let workspaceName = path.basename(params.selectedFolder.uri.fsPath);
            let workspaceFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/.vscode/" + workspaceName + ".code-workspace");
            return vscode.workspace.fs.writeFile(workspaceFile, new util_1.TextEncoder().encode(JSON.stringify({
                "folders": [
                    {
                        "path": ".."
                    }
                ]
            }, null, 4)))
                .then(() => vscode.commands.executeCommand("vscode.openFolder", workspaceFile));
        }
        return vscode.workspace.updateWorkspaceFolders(0, 0, params.selectedFolder);
    });
}
exports.beginCreateNewProjectFolder = beginCreateNewProjectFolder;
function addUserBoilerplate(text) {
    var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.user", utils.getCurrentWorkspaceFile());
    var authorName = "-- Author: " + (lifeboatConfig.get("authorName") ?? "<Authorname> (Please change this in user settings, Ctrl+Comma)");
    var githubLink = "-- GitHub: " + (lifeboatConfig.get("githubLink") ?? "<GithubLink>");
    var workshopLink = "-- Workshop: " + (lifeboatConfig.get("workshopLink") ?? "<WorkshopLink>");
    var extendedLines = lifeboatConfig.get("extendedBoilerplate");
    var extendedBoilerplate = "";
    if (extendedLines) {
        for (var line of extendedLines.split("\n")) {
            extendedBoilerplate += "\n--" + line;
        }
        return authorName + "\n" + githubLink + "\n" + workshopLink + "\n" + extendedBoilerplate + "\n" + text;
    }
    else {
        return authorName + "\n" + githubLink + "\n" + workshopLink + "\n" + text;
    }
}
exports.addUserBoilerplate = addUserBoilerplate;
function addBoilerplate(text) {
    var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.user", utils.getCurrentWorkspaceFile());
    var authorName = "-- Author: " + (lifeboatConfig.get("authorName") ?? "<Authorname> (Please change this in user settings, Ctrl+Comma)");
    var githubLink = "-- GitHub: " + (lifeboatConfig.get("githubLink") ?? "<GithubLink>");
    var workshopLink = "-- Workshop: " + (lifeboatConfig.get("workshopLink") ?? "<WorkshopLink>");
    var extendedLines = lifeboatConfig.get("extendedBoilerplate");
    var extendedBoilerplate = "";
    if (extendedLines) {
        for (var line of extendedLines.split("\n")) {
            extendedBoilerplate += "\n--" + line;
        }
    }
    var nameousBoilerplate = `-- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--      By Nameous Changey (Please retain this notice at the top of the file as a courtesy; a lot of effort went into the creation of these tools.)`;
    return authorName + "\n" + githubLink + "\n" + workshopLink + "\n" + extendedBoilerplate + "--\n" + nameousBoilerplate + "\n" + text;
}
exports.addBoilerplate = addBoilerplate;
function setupMicrocontrollerFiles(params) {
    const scriptFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/MyMicrocontroller.lua");
    return utils.doesFileExist(scriptFile, () => params, () => {
        return vscode.workspace.fs.writeFile(scriptFile, new util_1.TextEncoder().encode(addBoilerplate(microControllerDefaultScript)))
            .then(() => params);
    })
        .then(() => {
        const basicConfigFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_simulator_config.lua");
        return utils.doesFileExist(basicConfigFile, () => params, () => {
            return vscode.workspace.fs.writeFile(basicConfigFile, new util_1.TextEncoder().encode(addBoilerplate(microControllerDefaultSimulatorConfig)))
                .then(() => params);
        });
    }).then(() => {
        const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_post_buildactions.lua");
        return utils.doesFileExist(buildActionsFile, () => params, () => {
            return vscode.workspace.fs.writeFile(buildActionsFile, new util_1.TextEncoder().encode(addBoilerplate(postBuildActionsDefault)))
                .then(() => params);
        });
    }).then(() => {
        const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_pre_buildactions.lua");
        return utils.doesFileExist(buildActionsFile, () => params, () => {
            return vscode.workspace.fs.writeFile(buildActionsFile, new util_1.TextEncoder().encode(addBoilerplate(preBuildActionsDefault)))
                .then(() => params);
        });
    });
}
function setupAddonFiles(params) {
    const scriptFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/script.lua");
    return utils.doesFileExist(scriptFile, () => params, () => {
        return vscode.workspace.fs.writeFile(scriptFile, new util_1.TextEncoder().encode(addBoilerplate(addonDefaultScript)))
            .then(() => params);
    }).then(() => {
        const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_post_buildactions.lua");
        return utils.doesFileExist(buildActionsFile, () => params, () => {
            return vscode.workspace.fs.writeFile(buildActionsFile, new util_1.TextEncoder().encode(addBoilerplate(postBuildActionsDefault)))
                .then(() => params);
        });
    }).then(() => {
        const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_pre_buildactions.lua");
        return utils.doesFileExist(buildActionsFile, () => params, () => {
            return vscode.workspace.fs.writeFile(buildActionsFile, new util_1.TextEncoder().encode(addBoilerplate(preBuildActionsDefault)))
                .then(() => params);
        });
    });
}
//# sourceMappingURL=projectCreation.js.map