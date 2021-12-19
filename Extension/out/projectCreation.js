"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.addBoilerplate = exports.addUserBoilerplate = exports.beginCreateNewProjectFolder = void 0;
const vscode = require("vscode");
const path = require("path");
const util_1 = require("util");
const utils = require("./utils");
const fileContents = require("./fileContentsConstants");
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
            let workspaceCount = vscode.workspace.workspaceFolders ? vscode.workspace.workspaceFolders.length : 0;
            let projectName = path.basename(folders[0].fsPath);
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
    let lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.user", utils.getCurrentWorkspaceFile());
    let authorName = "-- Author: " + (lifeboatConfig.get("authorName") ?? "<Authorname> (Please change this in user settings, Ctrl+Comma)");
    let githubLink = "-- GitHub: " + (lifeboatConfig.get("githubLink") ?? "<GithubLink>");
    let workshopLink = "-- Workshop: " + (lifeboatConfig.get("workshopLink") ?? "<WorkshopLink>");
    let extendedLines = lifeboatConfig.get("extendedBoilerplate");
    let extendedBoilerplate = "";
    if (extendedLines) {
        for (let line of extendedLines.split("\n")) {
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
    let lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.user", utils.getCurrentWorkspaceFile());
    let authorName = "-- Author: " + (lifeboatConfig.get("authorName") ?? "<Authorname> (Please change this in user settings, Ctrl+Comma)");
    let githubLink = "-- GitHub: " + (lifeboatConfig.get("githubLink") ?? "<GithubLink>");
    let workshopLink = "-- Workshop: " + (lifeboatConfig.get("workshopLink") ?? "<WorkshopLink>");
    let extendedLines = lifeboatConfig.get("extendedBoilerplate");
    let extendedBoilerplate = "";
    if (extendedLines) {
        for (let line of extendedLines.split("\n")) {
            extendedBoilerplate += "\n--" + line;
        }
    }
    let nameousBoilerplate = `-- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--      By Nameous Changey (Please retain this notice at the top of the file as a courtesy; a lot of effort went into the creation of these tools.)`;
    return authorName + "\n" + githubLink + "\n" + workshopLink + "\n" + extendedBoilerplate + "--\n" + nameousBoilerplate + "\n" + text;
}
exports.addBoilerplate = addBoilerplate;
function setupMicrocontrollerFiles(params) {
    const scriptFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/MyMicrocontroller.lua");
    return utils.doesFileExist(scriptFile, () => params, () => {
        return vscode.workspace.fs.writeFile(scriptFile, new util_1.TextEncoder().encode(addBoilerplate(fileContents.microControllerDefaultScript)))
            .then(() => params);
    })
        .then(() => {
        const basicConfigFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_simulator_config.lua");
        return utils.doesFileExist(basicConfigFile, () => params, () => {
            return vscode.workspace.fs.writeFile(basicConfigFile, new util_1.TextEncoder().encode(addBoilerplate(fileContents.microControllerDefaultSimulatorConfig)))
                .then(() => params);
        });
    }).then(() => {
        const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_post_buildactions.lua");
        return utils.doesFileExist(buildActionsFile, () => params, () => {
            return vscode.workspace.fs.writeFile(buildActionsFile, new util_1.TextEncoder().encode(addBoilerplate(fileContents.postBuildActionsDefault)))
                .then(() => params);
        });
    }).then(() => {
        const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_pre_buildactions.lua");
        return utils.doesFileExist(buildActionsFile, () => params, () => {
            return vscode.workspace.fs.writeFile(buildActionsFile, new util_1.TextEncoder().encode(addBoilerplate(fileContents.preBuildActionsDefault)))
                .then(() => params);
        });
    }).then(() => {
        const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_multi/_simulate_multiple_example.lua");
        return utils.doesFileExist(buildActionsFile, () => params, () => {
            return vscode.workspace.fs.writeFile(buildActionsFile, new util_1.TextEncoder().encode(addBoilerplate(fileContents.simulateMultipleExample)))
                .then(() => params);
        });
    }).then(() => {
        const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_multi/LBMultiSimulatorExtension.lua");
        return utils.doesFileExist(buildActionsFile, () => params, () => {
            return vscode.workspace.fs.writeFile(buildActionsFile, new util_1.TextEncoder().encode(addBoilerplate(fileContents.lbMultiSimulatorExtension)))
                .then(() => params);
        });
    });
}
function setupAddonFiles(params) {
    const scriptFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/script.lua");
    return utils.doesFileExist(scriptFile, () => params, () => {
        return vscode.workspace.fs.writeFile(scriptFile, new util_1.TextEncoder().encode(addBoilerplate(fileContents.addonDefaultScript)))
            .then(() => params);
    }).then(() => {
        const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_post_buildactions.lua");
        return utils.doesFileExist(buildActionsFile, () => params, () => {
            return vscode.workspace.fs.writeFile(buildActionsFile, new util_1.TextEncoder().encode(addBoilerplate(fileContents.postBuildActionsDefault)))
                .then(() => params);
        });
    }).then(() => {
        const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_pre_buildactions.lua");
        return utils.doesFileExist(buildActionsFile, () => params, () => {
            return vscode.workspace.fs.writeFile(buildActionsFile, new util_1.TextEncoder().encode(addBoilerplate(fileContents.preBuildActionsDefault)))
                .then(() => params);
        });
    });
}
//# sourceMappingURL=projectCreation.js.map