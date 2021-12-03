"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.beginSimulator = void 0;
const vscode = require("vscode");
const path = require("path");
const util_1 = require("util");
const utils = require("./utils");
function generateSimulatorLua(workspaceFolder, fileToSimulate) {
    // turn the relative path into a lua require
    var relativePath = fileToSimulate.fsPath.replace(workspaceFolder.fsPath, "");
    relativePath = relativePath.replace(path.extname(relativePath), "");
    relativePath = relativePath.replace("\\\\", "\\");
    relativePath = relativePath.replace("\\", ".");
    relativePath = relativePath.replace("/", ".");
    // is that correct?
    // or do we need to do something else?
    return `
    require("LifeBoatAPI.Tools.Simulator.LBSimulator");
    local __simulator = LBSimulator:new() 
    __simulator:beginSimulation()

    require("${relativePath}");

    __simulator:giveControlToMainLoop()
    `;
}
function beginSimulator() {
    var workspace = utils.getCurrentWorkspaceFolder();
    var file = utils.getCurrentWorkspaceFile();
    if (workspace
        && file
        && !vscode.debug.activeDebugSession) {
        var simulatorLua = generateSimulatorLua(workspace.uri, file);
        return vscode.workspace.fs.writeFile(vscode.Uri.file(workspace.uri.fsPath + "/out/_simulator.lua"), new util_1.TextEncoder().encode(simulatorLua))
            .then(() => {
            var config = {
                name: "Run Simulator",
                type: "lua",
                request: "launch",
                program: `${file?.fsPath}`,
                arg: [
                // stuff for the simulator to run?
                // can't remember what config is needed
                ]
            };
            vscode.window.showInformationMessage(`Simulating file: ${utils.getCurrentWorkspaceFile()?.fsPath}`);
            return vscode.debug.startDebugging(workspace, config);
        });
    }
    return Promise.reject();
}
exports.beginSimulator = beginSimulator;
//# sourceMappingURL=runSimulator.js.map