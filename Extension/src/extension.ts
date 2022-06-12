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
import * as handleGit from "./handleGit";
import { GistSetting, GitLibSetting } from './handleGit';
import { TerminalHandler } from './terminal';

// this method is called when your extension is activated
// the extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext)
{
	// reload all library paths at startup
	// "just restart VSCode becomes viable if things go out of sync"
	vscode.commands.executeCommand("lifeboatapi.updateAllSettings");

	let config = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs");
	if (config.get("autoUpdate"))
	{
		vscode.commands.executeCommand("lifeboatapi.updateAllLibraries");
	}

	vscode.workspace.onDidChangeWorkspaceFolders(
		(e) => {
			return vscode.commands.executeCommand("lifeboatapi.updateAllSettings")
			.then(() => {
				let config = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs");
				let promises = [];
				if(config.get("autoUpdate"))
				{
					for (let added of e.added)
					{
						promises.push(vscode.commands.executeCommand("lifeboatapi.updateLibraries", added.uri));
					}
				}
				return Promise.all(promises);
			});
		}, null, context.subscriptions);

	vscode.window.onDidCloseTerminal(
		(t) => {
			TerminalHandler.get().onTerminalClosed(t);
		}, null, context.subscriptions);


	// when a lua file is created, if it's empty - add the boilerplate
	vscode.workspace.onDidOpenTextDocument(
		(document) => {
			let folder = utils.getContainingFolder(document.uri);
			if (utils.isStormworksProject(folder) 
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

	vscode.workspace.onDidChangeTextDocument(
		(e) => {
			if(e.document && e.contentChanges.length > 0)
			{
				let relativePath = utils.relativePath(e.document.uri);
				let libConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", e.document.uri);
                let existingGists : GistSetting[] = libConfig.get("sharedGistFiles") ?? [];
				for (let gist of existingGists)
				{
					if (gist.relativePath === relativePath)
					{
						gist.isDirty = true;
						libConfig.update("sharedGistFiles", existingGists);
						return;
					}
				}
			}
		}, null, context.subscriptions);

	// when the library paths are changed, this will have a knock-on to the other settings
	vscode.workspace.onDidChangeConfiguration(
		(e) => {
			if(e && e.affectsConfiguration("lifeboatapi.stormworks.libs.libraryPaths"))
			{
				return vscode.commands.executeCommand("lifeboatapi.updateAllSettings");
			}
		}, null, context.subscriptions);

	// COMMAND HANDLING --------------------------------------------------------------------------------
	// Simulate current file
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.simulate',
	() => {
		let currentFolder = utils.getCurrentWorkspaceFolder();
		if(utils.isMicrocontrollerProject(currentFolder))
		{
			return utils.ensureBuildFolderExists(currentFolder)
			.then(() => runSimulator.beginSimulator(context));
		}
	}));

	// Build current workspace
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.build',
	() => {
		let currentFolder = utils.getCurrentWorkspaceFolder();
		if(utils.isStormworksProject(currentFolder))
		{
			return utils.ensureBuildFolderExists(currentFolder)
			.then(() => runBuild.beginBuild(context));
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

	// Share File Gist Link
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.shareFile',
	(file) => {
		return handleGit.shareSelectedFile(context, file);
	}));

	// Add Library
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.cloneGitLibrary',
	(file) => {
		return handleGit.addLibraryFromURL(context, file);
	}));

	// Remove Library
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.removeLibrary',
	(file) => {
		return handleGit.removeSelectedLibrary(context, file);
	}));

	// Update Libraries
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.updateLibraries',
	(file) => {
		return handleGit.updateLibraries(context, file);
	}));

	// Update All Settings
	context.subscriptions.push(vscode.commands.registerCommand("lifeboatapi.updateAllSettings",
	() => {
		let isSWWorkspace = false;
		let promises = [];
		for(let folder of vscode.workspace.workspaceFolders ?? [])
		{
			let isSWProject = utils.isStormworksProject(folder) === true;
			isSWWorkspace ||= isSWProject;

			if(isSWProject)
			{
				promises.push(settingsManagement.updateLuaLibraryPaths(context, folder));
			}
		}

		promises.push(vscode.commands.executeCommand('setContext', 'lifeboatapi.isSWWorkspace', isSWWorkspace));
		return Promise.all(promises);
	}));

	context.subscriptions.push(vscode.commands.registerCommand("lifeboatapi.updateAllLibraries",
	() => {
		let promises = [];
		for (let folder of vscode.workspace.workspaceFolders ?? [])
		{
			if(utils.isStormworksProject(folder))
			{
				let libConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", folder);
				promises.push(
					Promise.resolve().then(
					() => {
						// migration from old style -> git library style, to avoid too many complaints in one go
						// after this, no more migration really needed. Can just recommend people make new projects...probably
						let libraries : GitLibSetting[] | undefined = libConfig.get("gitLibraries");
						if (libraries === null)
						{
							if (!utils.isMicrocontrollerProject(folder))
							{ // addon
								return libConfig.update("gitLibraries", [{ name: "LifeBoatAPI", gitUrl: "https://github.com/nameouschangey/Stormworks_LifeBoatAPI_Addon.git" } ]);
							}
							else
							{ // mc
								return libConfig.update("gitLibraries", [{ name: "LifeBoatAPI", gitUrl: "https://github.com/nameouschangey/Stormworks_LifeBoatAPI_MC.git" }]);
							}
						}
					}
					).then(() => vscode.commands.executeCommand("lifeboatapi.updateLibraries", folder.uri)
				));
			}
		}
		return Promise.all(promises);
	}));
}

// this method is called when your extension is deactivated
export function deactivate() {}

