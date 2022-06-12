import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";
import * as projectCreation from "./projectCreation";
import * as settingsManagement from "./settingsManagement";

function generateSimulatorLua(workspaceFolder:vscode.Uri, fileToSimulate : vscode.Uri)
{
    // turn the relative path into a lua require
    let relativePath = fileToSimulate.fsPath.replaceAll(workspaceFolder.fsPath, "");
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
    let contents = `
--- @diagnostic disable: undefined-global

-- replace newlines
for k,v in pairs(arg) do
    arg[k] = v:gsub("##LBNEWLINE##", "\\n")
end

require("LifeBoatAPI.Tools.Simulator.Simulator");
__simulator = LifeBoatAPI.Tools.Simulator:new() 
__simulator:_beginSimulation(false, arg[1], arg[2])

simulator = __simulator -- 0.0.11 easier to read by far but could be overwritten by somebody's global

-- compatibility with 0.0.7 projects
LBSimulatorInputHelpers = LifeBoatAPI.Tools.SimulatorInputHelpers

require("${relativePath}");

-- compatibility with 0.0.4 projects
if onLBSimulatorInit then
    onLBSimulatorInit(__simulator, __simulator.config, LBSimulatorInputHelpers)
end

__simulator:_giveControlToMainLoop()

--- @diagnostic enable: undefined-global
`;
    return projectCreation.addBoilerplate(contents);
}

export function beginSimulator(context:vscode.ExtensionContext)
{
    let workspace = utils.getCurrentWorkspaceFolder();
    let file = utils.getCurrentWorkspaceFile();

    if(!file || !workspace || !utils.isStormworksProject(workspace))
    {
        return;
    }

    if (!vscode.debug.activeDebugSession) // avoid running two debug sessions at once, easy to do as it's F6 to start
    {
        let simulatorLua = generateSimulatorLua(workspace.uri, file);
        let simulatedLuaFile = vscode.Uri.file(workspace.uri.fsPath + "/_build/_simulator.lua");

        // load the path and cpath, this means if the settings file is wrong - at least the simulator works
        // although the lua-debug probably won't. It shouldn't be needed, but it will make life a bit more stable.
        let path = settingsManagement.getDebugPaths(context, workspace);
        path.push(utils.sanitizeFolderPath(workspace.uri.fsPath) + "?.lua");

        return vscode.workspace.fs.writeFile(simulatedLuaFile, new TextEncoder().encode(simulatorLua))
        .then(
            () => {
                let config = {
                    name: "Run Simulator",
                    type: "lua",
                    request: "launch",
                    program: `${simulatedLuaFile?.fsPath}`,
                    stopOnEntry: false,
                    stopOnThreadEntry: false,
                    luaVersion : "5.3",
                    luaArch: "x86",
                    path: path.join(";"),
                    cpath: settingsManagement.getDebugCPaths(context),
                    arg: [
                        utils.sanitizeFolderPath(context.extensionPath) + "assets/simulator/STORMWORKS_Simulator.exe",
                        utils.sanitizeFolderPath(workspace?.uri.fsPath ?? "") + "_build/_debug_simulator_log.txt"
                    ]
                };
                
                // replace all newlines with ##LBNEWLINE## to be unpacked on the recieving end
                config.arg.forEach(function(val, index, arr) {
                    arr[index] = val.replaceAll("\r\n", "##LBNEWLINE##").replaceAll("\n", "##LBNEWLINE##");
                });

                // todo, set the debugger setting here, it doesn't look like it reads it from above?

                return vscode.debug.startDebugging(workspace, config);
            }
        );
    }
    else
    {
        return Promise.reject("Please end current debug session before starting another.");
    }
}