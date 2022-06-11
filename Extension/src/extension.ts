// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder, promisify} from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";
import * as projectCreation from "./projectCreation";
import * as settingsManagement from "./settingsManagement";
import * as runSimulator from "./runSimulator";
import * as runBuild from "./runBuild";

// this method is called when your extension is activated
// the extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext)
{
	// track the folders we've loaded settings for - avoid rewriting settings constantly
	let loadedFolders : Set<vscode.WorkspaceFolder | undefined> = new Set<vscode.WorkspaceFolder | undefined>();

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
			return false;
		}, null, context.subscriptions);

	// check if the settings need updated when the user swaps between editor windows
	vscode.window.onDidChangeActiveTextEditor(
		(e) => {
			let currentWorkspaceFolder = utils.getCurrentWorkspaceFolder();
			if (e
				&& currentWorkspaceFolder
				&& !loadedFolders.has(currentWorkspaceFolder)
				&& !e.document.fileName.includes("settings.json")
				&& !e.document.fileName.includes(".code-workspace")
				&& utils.isStormworksProject())
			{
				loadedFolders.add(currentWorkspaceFolder);
				return settingsManagement.updateLuaLibraryPaths(context, currentWorkspaceFolder);
			}
		}, null, context.subscriptions);

	// when the library paths are changed, this will have a knock-on to the other settings
	vscode.workspace.onDidChangeConfiguration(
		(e) => {
			if(e.affectsConfiguration("lifeboatapi.stormworks.libs.libraryPaths"))
			{
				loadedFolders.clear();
			}
		}, null, context.subscriptions);

	// COMMAND HANDLING --------------------------------------------------------------------------------
	// Simulate current file
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.simulate',
	() => {
		if(utils.isMicrocontrollerProject())
		{
			return runSimulator.beginSimulator(context);
		}
	}));

	// Build current workspace
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.build',
	() => {
		if(utils.isStormworksProject())
		{
			return runBuild.beginBuild(context);
		}
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
