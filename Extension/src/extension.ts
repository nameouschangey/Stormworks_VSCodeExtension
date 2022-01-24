// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";
import * as projectCreation from "./projectCreation";
import * as settingsManagement from "./settingsManagement";
import * as runSimulator from "./runSimulator";
import * as runBuild from "./runBuild";

// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext)
{
	console.log('LifeBoatAPI for Stormworks Lua now active. Please contact Nameous Changey if you discover issues.');

	// when folders change, check if there's any code-workspace files that could be opened
	// (this may become annoying for experienced devs)
	{
		if(vscode.workspace.workspaceFolders
			&& vscode.workspace.workspaceFolders.length === 1
			&& !vscode.workspace.workspaceFile)
		{
			let config = vscode.workspace.getConfiguration("lifeboatapi.stormworks");
			if(config.get("shouldOpenWorkspacesFound") === true) {
			//&& !vscode.workspace.workspaceFolders) {
				vscode.workspace.findFiles(new vscode.RelativePattern(vscode.workspace.workspaceFolders[0].uri, "**/*.code-workspace"))
				.then((wsFilesFound) => {
					if (wsFilesFound.length > 0) {
						return vscode.window.showInformationMessage(`Found ${wsFilesFound.length} workspaces in this folder. Did you mean you open them instead? (lifeboatapi.stormworks.shouldOpenWorkspacesFound)`, "Open Them (recommended)", "Ignore")
								.then( (selected) => {
									if(selected === "Open Them (recommended)") {
										return wsFilesFound;
									}
									else{
										return Promise.reject();
									}
								});
					} else {
						// no need to continue, nothing to load
						return Promise.reject();
					}
				}).then(
					(filesFound) => {
						let openFolderTasks = [];
						for(let wsFile of filesFound)
						{
							openFolderTasks.push(vscode.commands.executeCommand("vscode.openFolder", wsFile, true));
						}
						return Promise.all(openFolderTasks);
				});
			}
		}
	}
	
	// when a lua file is created, if it's empty - add the boilerplate
	vscode.workspace.onDidOpenTextDocument(
		(document) => {
			if (utils.isStormworksProject() 
				&& document.languageId === "lua"
				&& document.lineCount === 1)
			{
				const boilerPlate = projectCreation.addBoilerplate("");
				let edit = new vscode.WorkspaceEdit();
				edit.insert(document.uri, new vscode.Position(0, 0), boilerPlate);
				return vscode.workspace.applyEdit(edit);
			}
		}, null, context.subscriptions);

	// if config changes, we need to update the Lua library paths next time we are back on a file
	vscode.workspace.onDidChangeConfiguration(
	(e) => {	
		if(e.affectsConfiguration("lifeboatapi.stormworks.libs.projectSpecificLibraryPaths")
			|| e.affectsConfiguration("lifeboatapi.stormworks.libs.workspaceLibraryPaths")
			|| e.affectsConfiguration("lifeboatapi.stormworks.libs.globalLibraryPaths")
			|| e.affectsConfiguration("lifeboatapi.stormworks.libs.ignorePaths"))
		{
			return context.workspaceState.update("lifeboatapi.lastWorkspace", null);
		}
	}, null, context.subscriptions);


	// when changing files, if the workspace changed - we need to change the library paths
	vscode.window.onDidChangeActiveTextEditor(
	(e) => {
		const currentWorkspace = utils.getCurrentWorkspaceFolder();
		const lastWorkspace = context.workspaceState.get("lifeboatapi.lastWorkspace");
		if(currentWorkspace
			&& currentWorkspace !== lastWorkspace
			&& utils.isStormworksProject())
		{
			context.workspaceState.update("lifeboatapi.lastWorkspace", currentWorkspace);
			return settingsManagement.beginUpdateWorkspaceSettings(context);
		}
	}, null, context.subscriptions);



	// COMMAND HANDLING --------------------------------------------------------------------------------
	// Simulate current file
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.simulate',
	() => {
		return runSimulator.beginSimulator(context);
	}));

	// Build current workspace
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.build',
	() => {
			return runBuild.beginBuild(context);
	}));

	// New MC
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.newMCProject',
	() =>{
		return projectCreation.beginCreateNewProjectFolder(context, true);
	}));
	
	// New Addon
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.newAddonProject',
	() =>{
		return projectCreation.beginCreateNewProjectFolder(context, false);
	}));
}

// this method is called when your extension is deactivated
export function deactivate() {}
