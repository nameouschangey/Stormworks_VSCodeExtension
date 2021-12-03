import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";

function generateSimulatorLua(workspaceFolder:vscode.Uri)
{
    // is that correct?
    // or do we need to do something else?
    return `
    require("LifeBoatAPI.Tools.Simulator.LBSimulator");
    local __simulator = LBSimulator:new() 

    __simulator:beginSimulation(false, arg[1])
    __simulator:giveControlToMainLoop()
`;
}

export function beginBuild(context:vscode.ExtensionContext)
{
    var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", utils.getCurrentWorkspaceFile());

    var workspace = utils.getCurrentWorkspaceFolder();

    // we build an entire workspace at once, as the majority of the cost is starting up the combiner
    if (workspace)
    {
        var simulatorLua = generateSimulatorLua(workspace.uri);
        var simulatedLuaFile = vscode.Uri.file(workspace.uri.fsPath + "/out/_simulator.lua");
        return vscode.workspace.fs.writeFile(simulatedLuaFile, new TextEncoder().encode(simulatorLua))
        .then(
            () => {
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
            }
        );
    }

    return Promise.reject();
}