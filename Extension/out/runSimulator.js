"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.beginSimulator = void 0;
const vscode = require("vscode");
const path = require("path");
const util_1 = require("util");
const utils = require("./utils");
const projectCreation = require("./projectCreation");
function generateSimulatorLua(workspaceFolder, fileToSimulate) {
    // turn the relative path into a lua require
    var relativePath = fileToSimulate.fsPath.replace(workspaceFolder.fsPath, "");
    relativePath = relativePath.replace(path.extname(relativePath), "");
    relativePath = relativePath.replace("\\\\", "\\");
    relativePath = relativePath.replace("\\", ".");
    relativePath = relativePath.replace("/", ".");
    if (relativePath.substr(0, 1) === ".") // remove initial "." that might be left
     {
        relativePath = relativePath.substr(1);
    }
    // is that correct?
    // or do we need to do something else?
    var contents = `
require("LifeBoatAPI.Tools.Simulator.LBSimulator");
local __simulator = LBSimulator:new() 

require("${relativePath}");

__simulator:beginSimulation(false, arg[1])
__simulator:giveControlToMainLoop()
`;
    return projectCreation.addBoilerplate(contents);
}
function beginSimulator(context) {
    var workspace = utils.getCurrentWorkspaceFolder();
    var file = utils.getCurrentWorkspaceFile();
    if (workspace
        && file
        && !vscode.debug.activeDebugSession) // avoid running two debug sessions at once, easy to do as it's F6 to start
     {
        var simulatorLua = generateSimulatorLua(workspace.uri, file);
        var simulatedLuaFile = vscode.Uri.file(workspace.uri.fsPath + "/_build/_simulator.lua");
        return vscode.workspace.fs.writeFile(simulatedLuaFile, new util_1.TextEncoder().encode(simulatorLua))
            .then(() => {
            var config = {
                name: "Run Simulator",
                type: "lua",
                request: "launch",
                program: `${simulatedLuaFile?.fsPath}`,
                stopOnEntry: false,
                stopOnThreadEntry: false,
                arg: [
                    context.extensionPath + "/assets/simulator/STORMWORKS_Simulator.exe"
                ]
            };
            vscode.window.showInformationMessage(`Simulating file: ${utils.getCurrentWorkspaceFile()?.fsPath}`);
            return vscode.debug.startDebugging(workspace, config);
        });
    }
    if (vscode.debug.activeDebugSession) {
        return Promise.reject("Please end current debug session before starting another.");
    }
    else {
        return Promise.reject("Please ensure a valid file is selected for simulation");
    }
}
exports.beginSimulator = beginSimulator;
//# sourceMappingURL=runSimulator.js.map