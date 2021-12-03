"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.beginBuild = void 0;
const vscode = require("vscode");
const util_1 = require("util");
const utils = require("./utils");
function generateSimulatorLua(workspaceFolder) {
    // is that correct?
    // or do we need to do something else?
    return `
    require("LifeBoatAPI.Tools.Simulator.LBSimulator");
    local __simulator = LBSimulator:new() 

    __simulator:beginSimulation(false, arg[1])
    __simulator:giveControlToMainLoop()
`;
}
function beginBuild(context) {
    var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", utils.getCurrentWorkspaceFile());
    var workspace = utils.getCurrentWorkspaceFolder();
    // we build an entire workspace at once, as the majority of the cost is starting up the combiner
    if (workspace) {
        var simulatorLua = generateSimulatorLua(workspace.uri);
        var simulatedLuaFile = vscode.Uri.file(workspace.uri.fsPath + "/out/_simulator.lua");
        return vscode.workspace.fs.writeFile(simulatedLuaFile, new util_1.TextEncoder().encode(simulatorLua))
            .then(() => {
            var config = {
                name: "Run Simulator",
                type: "lua",
                request: "launch",
                program: `${simulatedLuaFile?.fsPath}`,
                arg: [
                    lifeboatConfig.get("authorName"),
                    lifeboatConfig.get("githubLink"),
                    lifeboatConfig.get("workshopLink")
                ]
            };
            vscode.window.showInformationMessage(`Simulating file: ${utils.getCurrentWorkspaceFile()?.fsPath}`);
            return vscode.debug.startDebugging(workspace, config);
        });
    }
    return Promise.reject();
}
exports.beginBuild = beginBuild;
//# sourceMappingURL=runBuild.js.map