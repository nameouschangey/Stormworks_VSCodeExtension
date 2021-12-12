"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.beginSimulator = void 0;
const vscode = require("vscode");
const path = require("path");
const util_1 = require("util");
const utils = require("./utils");
const projectCreation = require("./projectCreation");
const settingsManagement = require("./settingsManagement");
function generateSimulatorLua(workspaceFolder, fileToSimulate) {
    // turn the relative path into a lua require
    let relativePath = fileToSimulate.fsPath.replaceAll(workspaceFolder.fsPath, "");
    relativePath = relativePath.replaceAll(path.extname(relativePath), "");
    relativePath = relativePath.replaceAll("\\", "/");
    relativePath = relativePath.replaceAll("//", "/");
    relativePath = relativePath.replaceAll("/", ".");
    if (relativePath.substr(0, 1) === ".") // remove initial "." that might be left
     {
        relativePath = relativePath.substr(1);
    }
    // is that correct?
    // or do we need to do something else?
    let contents = `
--- @diagnostic disable: undefined-global

require("LifeBoatAPI.Tools.Simulator.LBSimulator");
__simulator = LBSimulator:new() 
__simulator:beginSimulation(false, arg[1], arg[2])

require("${relativePath}");

-- compatibility with 0.0.4 projects
if onLBSimulatorInit then
    onLBSimulatorInit(__simulator, __simulator.config, LBSimulatorInputHelpers)
end

__simulator:giveControlToMainLoop()

--- @diagnostic enable: undefined-global
`;
    return projectCreation.addBoilerplate(contents);
}
function beginSimulator(context) {
    let workspace = utils.getCurrentWorkspaceFolder();
    let file = utils.getCurrentWorkspaceFile();
    if (workspace
        && file
        && utils.isMicrocontrollerProject()
        && !vscode.debug.activeDebugSession) // avoid running two debug sessions at once, easy to do as it's F6 to start
     {
        let simulatorLua = generateSimulatorLua(workspace.uri, file);
        let simulatedLuaFile = vscode.Uri.file(workspace.uri.fsPath + "/_build/_simulator.lua");
        let ws = workspace;
        // load the path and cpath, this means if the settings file is wrong - at least the simulator works
        // although the lua-debug probably won't. It shouldn't be needed, but it will make life a bit more stable.
        let path = settingsManagement.getDebugPaths(context);
        path.push(utils.sanitisePath(workspace.uri.fsPath) + "?.lua");
        return vscode.workspace.fs.writeFile(simulatedLuaFile, new util_1.TextEncoder().encode(simulatorLua))
            .then(() => {
            let config = {
                name: "Run Simulator",
                type: "lua",
                request: "launch",
                program: `${simulatedLuaFile?.fsPath}`,
                stopOnEntry: false,
                stopOnThreadEntry: false,
                cpath: settingsManagement.getDebugCPaths(context).join(";"),
                path: path.join(";"),
                arg: [
                    utils.sanitisePath(context.extensionPath) + "/assets/simulator/STORMWORKS_Simulator.exe",
                    utils.sanitisePath(ws.uri.fsPath) + "/_build/_debug_simulator_log.txt"
                ]
            };
            return vscode.debug.startDebugging(workspace, config);
        });
    }
    if (!utils.isMicrocontrollerProject()) { // no error, might not be a stormworks project
    }
    else if (vscode.debug.activeDebugSession) {
        return Promise.reject("Please end current debug session before starting another.");
    }
    else {
        return Promise.reject("Please ensure a valid file is selected for simulation");
    }
}
exports.beginSimulator = beginSimulator;
//# sourceMappingURL=runSimulator.js.map