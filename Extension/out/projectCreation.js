"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.beginCreateNewProjectFolder = void 0;
const vscode = require("vscode");
const path = require("path");
const util_1 = require("util");
const utils = require("./utils");
const microControllerDefaultScript = `-- developed with the Stormworks Lua (LifeboatAPI) plugin for VSCode

-- This section is stripped out by the LifeBoat API build process
-- It only existing within VSCode, for configuring the simulator
-- Configure the simulator, e.g. simulated inputs/outputs and screen size in the onSimulate function
---@section __SIMULATORONLY__ 1 _MAIN_SIMSECTION_INIT
---@param simulator LBSimulator
function onSimulate(simulator)
    
end
---@endsection _MAIN_SIMSECTION_INIT


function onTick()
end

function onDraw()
end
`;
const addonDefaultScript = `-- developed with the Stormworks Lua (LifeboatAPI) plugin for VSCode

function onTick()
end

function onDraw()
end
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
                settingsFilePath: vscode.Uri.prototype
            };
        }
        else {
            return Promise.reject("No folder selected");
        }
    }).then((params) => {
        params.settingsFilePath = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/.vscode/settings.json");
        return utils.doesFileExist(params.settingsFilePath, () => {
            return vscode.window
                .showErrorMessage("Project folder isn't empty. Are you sure?", ...["Overwrite existing", "Cancel"])
                .then((item) => {
                return (item === "Overwrite existing") ? params : Promise.reject();
            });
        }, () => {
            return params; // we don't want that settings file to already exist, otherwise a misclick could trample somebody's project.
        });
    })
        .then((params) => {
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
        const scriptFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/script.lua");
        return utils.doesFileExist(scriptFile, () => params, () => {
            const scriptText = params.isMicrocontroller ? microControllerDefaultScript : addonDefaultScript;
            return vscode.workspace.fs.writeFile(scriptFile, new util_1.TextEncoder().encode(scriptText))
                .then(() => params);
        });
    })
        .then((params) => {
        // must be last in the chain, as it can cause VSCode to restart
        vscode.workspace.updateWorkspaceFolders(0, 0, params.selectedFolder);
    });
}
exports.beginCreateNewProjectFolder = beginCreateNewProjectFolder;
//# sourceMappingURL=projectCreation.js.map