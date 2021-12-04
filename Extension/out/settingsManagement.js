"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.beginUpdateWorkspaceSettings = exports.getLibraryPaths = void 0;
const vscode = require("vscode");
const utils = require("./utils");
function sanitisePath(path) {
    path = path.replace("\\", "/");
    if (path.charAt(path.length - 1) !== "/") {
        return path + "/";
    }
    return path;
}
function getLibraryPaths(context) {
    var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", utils.getCurrentWorkspaceFile());
    var lbPaths = [];
    var lifeboatLibraryPaths = lifeboatConfig.get("projectSpecificLibraryPaths") ?? [];
    var wslifeboatLibraryPaths = lifeboatConfig.get("workspaceLibraryPaths") ?? [];
    var userlifeboatLibraryPaths = lifeboatConfig.get("globalLibraryPaths") ?? [];
    for (var path of lifeboatLibraryPaths) {
        lbPaths.push(sanitisePath(path));
    }
    for (var path of wslifeboatLibraryPaths) {
        lbPaths.push(sanitisePath(path));
    }
    for (var path of userlifeboatLibraryPaths) {
        lbPaths.push(sanitisePath(path));
    }
    // add lifeboatAPI to the library path
    if (utils.isMicrocontrollerProject()) {
        lbPaths.push(sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Microcontroller/");
        lbPaths.push(sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Tools/");
    }
    else {
        lbPaths.push(sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Addons/");
        lbPaths.push(sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Tools/");
    }
    return lbPaths;
}
exports.getLibraryPaths = getLibraryPaths;
function beginUpdateWorkspaceSettings(context) {
    var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", utils.getCurrentWorkspaceFile());
    var lifeboatLibraryPaths = getLibraryPaths(context);
    var lifeboatIgnorePaths = lifeboatConfig.get("ignorePaths") ?? [];
    // add standard ignores
    lifeboatIgnorePaths.push(".vscode");
    lifeboatIgnorePaths.push("/out/");
    var luaDiagnosticsConfig = vscode.workspace.getConfiguration("Lua.diagnostics");
    var luaRuntimeConfig = vscode.workspace.getConfiguration("Lua.runtime");
    var luaLibWorkspace = vscode.workspace.getConfiguration("Lua.workspace");
    var luaDebugConfig = vscode.workspace.getConfiguration("lua.debug.settings");
    var luaIntellisense = vscode.workspace.getConfiguration("Lua.IntelliSense");
    return Promise.resolve()
        .then(() => {
        if (!utils.getCurrentWorkspaceFolder()) {
            return Promise.reject("Can't update settings while no workspace is active");
        }
    }).then(() => {
        //Lua.diagnostics.disable
        var existing = luaLibWorkspace.get("disable") ?? [];
        if (existing.indexOf("lowercase-global") === -1) {
            existing.push("lowercase-global");
        }
        if (existing.indexOf("undefined-doc-name") === -1) {
            existing.push("undefined-doc-name");
        }
        return luaDiagnosticsConfig.update("disable", existing, vscode.ConfigurationTarget.Workspace);
    }).then(() => luaRuntimeConfig.update("version", "Lua 5.3", vscode.ConfigurationTarget.Workspace)).then(() => {
        //Lua.workspace.ignoreDir
        return luaLibWorkspace.update("ignoreDir", lifeboatIgnorePaths, vscode.ConfigurationTarget.Workspace);
    }).then(() => {
        // lua.debug.cpath
        var existing = luaDebugConfig.get("cpath") ?? [];
        const defaultCPaths = [
            context.extensionPath + "/assets/luasocket/dll/socket/core.dll",
            context.extensionPath + "/assets/luasocket/dll/mime/core.dll"
        ];
        for (const cPathElement of defaultCPaths) {
            if (existing.indexOf(cPathElement) === -1) {
                existing.push(cPathElement);
            }
        }
        return luaDebugConfig.update("cpath", existing, vscode.ConfigurationTarget.Workspace);
    }).then(() => {
        //lua.debug.path
        var debugPaths = [
            context.extensionPath + "/assets/luasocket/?.lua",
        ];
        for (var path of lifeboatLibraryPaths) {
            debugPaths.push(path + "?.lua"); // irritating difference between how the debugger and the intellisense check paths
            debugPaths.push(path + "?.lbinternal"); // paths we want to be useable as lua, that we didn't want intellisense to see (ignore directories doesn't actually work)
        }
        return luaDebugConfig.update("path", debugPaths, vscode.ConfigurationTarget.Workspace);
    }).then(() => {
        //Lua.workspace.library
        var docConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.nelo", utils.getCurrentWorkspaceFile());
        // Nelo Docs root
        var neloAddonDoc = context.extensionPath + "/assets/nelodocs/docs_missions.lua";
        var neloMCDoc = context.extensionPath + "/assets/nelodocs/docs_vehicles.lua";
        if (docConfig.get("overwriteNeloDocsPath") === true) {
            neloAddonDoc = docConfig.get("neloAddonDocPath") ?? neloAddonDoc; // if the user screws it up, just use our bundled one
            neloMCDoc = docConfig.get("neloMicrocontrollerDocPath") ?? neloMCDoc;
        }
        lifeboatLibraryPaths.push(neloAddonDoc);
        lifeboatLibraryPaths.push(neloMCDoc);
        return luaLibWorkspace.update("library", lifeboatLibraryPaths, vscode.ConfigurationTarget.Workspace);
    }).then(() => luaDebugConfig.update("luaVersion", "5.3", vscode.ConfigurationTarget.Workspace))
        .then(() => luaDebugConfig.update("luaArch", "x86", vscode.ConfigurationTarget.Workspace))
        .then(() => luaIntellisense.update("traceBeSetted", true))
        .then(() => luaIntellisense.update("traceFieldInject", true))
        .then(() => luaIntellisense.update("traceLocalSet", true))
        .then(() => luaIntellisense.update("traceReturn", true));
}
exports.beginUpdateWorkspaceSettings = beginUpdateWorkspaceSettings;
//# sourceMappingURL=settingsManagement.js.map