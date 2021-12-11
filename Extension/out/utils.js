"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.doesFileExist = exports.isStormworksProject = exports.isMicrocontrollerProject = exports.getCurrentWorkspaceFolder = exports.getCurrentWorkspaceFile = exports.sanitisePath = void 0;
const vscode = require("vscode");
String.prototype.replaceAll = function (searchValue, replacement) {
    let current = String(this);
    let changed = String(this);
    do {
        current = changed;
        changed = current.replace(searchValue, replacement);
    } while (current !== changed);
    return current;
};
function sanitisePath(path) {
    path = path.replaceAll("\\", "/");
    if (path.charAt(path.length - 1) !== "/") {
        return path + "/";
    }
    return path;
}
exports.sanitisePath = sanitisePath;
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
        let lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", getCurrentWorkspaceFile());
        return lifeboatConfig.get("isMicrocontrollerProject") ?? false;
    }
    else {
        return false;
    }
}
exports.isMicrocontrollerProject = isMicrocontrollerProject;
function isStormworksProject() {
    if (getCurrentWorkspaceFile()) {
        let lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", getCurrentWorkspaceFile());
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