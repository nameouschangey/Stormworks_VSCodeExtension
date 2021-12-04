"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require("vscode");
const utils = require("./utils");
const projectCreation = require("./projectCreation");
const settingsManagement = require("./settingsManagement");
const runSimulator = require("./runSimulator");
const runBuild = require("./runBuild");
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function activate(context) {
    console.log('LifeBoatAPI for Stormworks Lua now active. Please contact Nameous Changey if you discover issues.');
    // when a lua file is created, if it's empty - add the boilerplate
    vscode.workspace.onDidOpenTextDocument((document) => {
        if (utils.isStormworksProject()
            && document.languageId === "lua"
            && document.lineCount === 1) {
            const boilerPlate = projectCreation.addBoilerplate("");
            var edit = new vscode.WorkspaceEdit();
            edit.insert(document.uri, new vscode.Position(0, 0), boilerPlate);
            return vscode.workspace.applyEdit(edit);
        }
    }, null, context.subscriptions);
    // if config changes, we need to update the Lua library paths next time we are back on a file
    vscode.workspace.onDidChangeConfiguration((e) => {
        if (e.affectsConfiguration("lifeboatapi.stormworks.projectSpecificLibraryPaths")
            || e.affectsConfiguration("lifeboatapi.stormworks.workspaceLibraryPaths")
            || e.affectsConfiguration("lifeboatapi.stormworks.globalLibraryPaths")
            || e.affectsConfiguration("lifeboatapi.stormworks.ignorePaths")) {
            context.workspaceState.update("lifeboatapi.lastWorkspace", null);
        }
    }, null, context.subscriptions);
    // when changing files, if the workspace changed - we need to change the library paths
    vscode.window.onDidChangeActiveTextEditor((e) => {
        const currentWorkspace = utils.getCurrentWorkspaceFolder();
        const lastWorkspace = context.workspaceState.get("lifeboatapi.lastWorkspace");
        if (currentWorkspace
            && currentWorkspace !== lastWorkspace
            && utils.isStormworksProject()) {
            context.workspaceState.update("lifeboatapi.lastWorkspace", currentWorkspace);
            settingsManagement.beginUpdateWorkspaceSettings(context).then(() => vscode.window.showInformationMessage(`Changed workspace, updated settings`));
        }
    }, null, context.subscriptions);
    // COMMAND HANDLING --------------------------------------------------------------------------------
    // Simulate current file
    context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.simulate', () => {
        return runSimulator.beginSimulator(context);
    }));
    // Build current workspace
    context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.build', (uri) => {
        return runBuild.beginBuild(context, uri);
    }));
    // New MC
    context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.newMCProject', () => {
        projectCreation.beginCreateNewProjectFolder(true)
            .then((folder) => vscode.commands.executeCommand("workbench.view.explorer"));
    }));
    // New Addon
    context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.newAddonProject', () => {
        projectCreation.beginCreateNewProjectFolder(false)
            .then((folder) => vscode.commands.executeCommand("workbench.view.explorer"));
    }));
}
exports.activate = activate;
// this method is called when your extension is deactivated
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map