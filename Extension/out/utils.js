"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.doesFileExist = exports.isStormworksProject = exports.isMicrocontrollerProject = exports.getCurrentWorkspaceFolder = exports.getCurrentWorkspaceFile = void 0;
const vscode = require("vscode");
function getCurrentWorkspaceFile() {
    return vscode.window.activeTextEditor?.document.uri;
}
exports.getCurrentWorkspaceFile = getCurrentWorkspaceFile;
function getCurrentWorkspaceFolder() {
    const currentFile = getCurrentWorkspaceFile();
    if (currentFile) {
        return vscode.workspace.getWorkspaceFolder(currentFile);
    }
    return undefined;
}
exports.getCurrentWorkspaceFolder = getCurrentWorkspaceFolder;
function isMicrocontrollerProject() {
    if (getCurrentWorkspaceFile()) {
        var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", getCurrentWorkspaceFile());
        return lifeboatConfig.get("isMicrocontrollerProject");
    }
    else {
        return false;
    }
}
exports.isMicrocontrollerProject = isMicrocontrollerProject;
function isStormworksProject() {
    if (getCurrentWorkspaceFile()) {
        var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", getCurrentWorkspaceFile());
        return lifeboatConfig.get("isAddonProject") || lifeboatConfig.get("isMicrocontrollerProject");
    }
    else {
        return false;
    }
}
exports.isStormworksProject = isStormworksProject;
function doesFileExist(path, onExists, onNotExist) {
    return vscode.workspace.fs.stat(path)
        .then(() => {
        return onExists();
    }, (err) => {
        return onNotExist();
    });
}
exports.doesFileExist = doesFileExist;
//# sourceMappingURL=utils.js.map