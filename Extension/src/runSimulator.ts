import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";
import * as projectCreation from "./projectCreation";

function generateSimulatorLua(workspaceFolder:vscode.Uri, fileToSimulate : vscode.Uri)
{
    // turn the relative path into a lua require
    var relativePath = fileToSimulate.fsPath.replaceAll(workspaceFolder.fsPath, "");
    relativePath = relativePath.replaceAll(path.extname(relativePath), "");
    relativePath = relativePath.replaceAll("\\", "/");
    relativePath = relativePath.replaceAll("//", "/");
    relativePath = relativePath.replaceAll("/", ".");

    if(relativePath.substr(0,1) === ".") // remove initial "." that might be left
    {
        relativePath = relativePath.substr(1);
    }

    // is that correct?
    // or do we need to do something else?
    var contents = `
require("LifeBoatAPI.Tools.Simulator.LBSimulator");
__simulator = LBSimulator:new() 
__simulator:beginSimulation(false, arg[1], arg[2])

require("${relativePath}");

__simulator:giveControlToMainLoop()
`;
    return projectCreation.addBoilerplate(contents);
}

export function beginSimulator(context:vscode.ExtensionContext)
{
    var workspace = utils.getCurrentWorkspaceFolder();
    var file = utils.getCurrentWorkspaceFile();

    if (workspace
        && file
        && utils.isMicrocontrollerProject()
        && !vscode.debug.activeDebugSession) // avoid running two debug sessions at once, easy to do as it's F6 to start
    {
        var simulatorLua = generateSimulatorLua(workspace.uri, file);
        var simulatedLuaFile = vscode.Uri.file(workspace.uri.fsPath + "/_build/_simulator.lua");

        var ws : vscode.WorkspaceFolder = workspace;

        return vscode.workspace.fs.writeFile(simulatedLuaFile, new TextEncoder().encode(simulatorLua))
        .then(
            () => {
                var config = {
                    name: "Run Simulator",
                    type: "lua",
                    request: "launch",
                    program: `${simulatedLuaFile?.fsPath}`,
                    stopOnEntry: false,
                    stopOnThreadEntry: false,
                    cpath:"",
                    path:"",
                    arg: [
                        context.extensionPath + "/assets/simulator/STORMWORKS_Simulator.exe",
                        ws.uri.fsPath + "/_build/_debug_simulator_log.txt"
                    ]
                };
                
                return vscode.debug.startDebugging(workspace, config);
            }
        );
    }

    if(!utils.isMicrocontrollerProject())
    {// no error, might not be a stormworks project
    }
    else if(vscode.debug.activeDebugSession)
    {
        return Promise.reject("Please end current debug session before starting another.");
    }
    else
    {
        return Promise.reject("Please ensure a valid file is selected for simulation");
    }
}