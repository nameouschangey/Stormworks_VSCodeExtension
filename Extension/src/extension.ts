// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';

const defaultCPaths = [
	"abc"
];


// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {
	
	// Use the console to output diagnostic information (console.log) and errors (console.error)
	// This line of code will only be executed once when your extension is activated
	console.log('LifeBoatAPI for Stormworks Lua now active. Please contact Nameous Changey if you discover issues.');


	// listen for settings changes
	vscode.workspace.onDidChangeConfiguration( (e) => {	
		if(e.affectsConfiguration("lifeboatapi.stormworks.libraryPaths")
			|| e.affectsConfiguration("lifeboatapi.stormworks.ignorePaths"))
		{
			context.workspaceState.update("lifeboatapi.lastWorkspace", null);
		}
	}, null, context.subscriptions);



	vscode.window.onDidChangeActiveTextEditor( (e) => {
		const currentWorkspace = getCurrentWorkspaceFolder();
		const lastWorkspace = context.workspaceState.get("lifeboatapi.lastWorkspace");
		if(currentWorkspace
			&& currentWorkspace !== lastWorkspace
			&& isStormworksProject())
		{
			context.workspaceState.update("lifeboatapi.lastWorkspace", currentWorkspace);
			beginUpdateWorkspaceSettings()
			.then(() => vscode.window.showInformationMessage(`Changed workspace, updated settings`) );
		}
	}, null, context.subscriptions);


	// Build currently Workspace
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.build',
	(folder) => {
		vscode.window.showInformationMessage('Attempt to build current project.');
	}));


	// Simulate current file
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.simulate', () => {
		vscode.window.showInformationMessage('Attempt to simulate current project.');
		
		var workspace = getCurrentWorkspaceFolder();
		if (workspace)
		{
			var config =         {
				name: "Run Lua",
				type: "lua",
				request: "launch",
				program: "${file}"
			};
			vscode.window.showInformationMessage(`Simulating file: ${getCurrentWorkspaceFile()?.fsPath}`);
			vscode.debug.startDebugging(workspace, config);
		}
	}));


	// New MC
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.newMCProject', onNewMicrocontroller));
	

	// New Addon
	context.subscriptions.push(vscode.commands.registerCommand('lifeboatapi.newAddonProject', onNewAddon));
}

// this method is called when your extension is deactivated
export function deactivate() {}


function onNewMicrocontroller()
{
	beginCreateNewProjectFolder()
	.then((folder) => vscode.commands.executeCommand("workbench.view.explorer"));
}

function onNewAddon()
{
	beginCreateNewProjectFolder()
	.then((folder) => vscode.commands.executeCommand("workbench.view.explorer") );
}

function getCurrentWorkspaceFile() {
	return vscode.window.activeTextEditor?.document.uri;
}

function getCurrentWorkspaceFolder() {
	const currentFile = getCurrentWorkspaceFile();
	if(currentFile)
	{
		return vscode.workspace.getWorkspaceFolder(currentFile);
	}
	return undefined;
}

function isStormworksProject() {
	if(getCurrentWorkspaceFile())
	{
		var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", getCurrentWorkspaceFile());
		return lifeboatConfig.get("isAddonProject") || lifeboatConfig.get("isMicrocontrollerProject");
	}
	else
	{
		return false;
	}
}

function beginUpdateWorkspaceSettings() {
	var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", getCurrentWorkspaceFile());
	const lifeboatLibraryPaths : string[] = lifeboatConfig.get("libraryPaths") ?? [];
	const lifeboatIgnorePaths : string[]= lifeboatConfig.get("ignorePaths") ?? [];

	var luaDiagnosticsConfig = vscode.workspace.getConfiguration("Lua.diagnostics");
	var luaRuntimeConfig = vscode.workspace.getConfiguration("Lua.runtime");
	var luaLibWorkspace = vscode.workspace.getConfiguration("Lua.workspace");
	var luaDebugConfig = vscode.workspace.getConfiguration("lua.debug.settings");

	return Promise.resolve()
	.then( () => {
		if(!getCurrentWorkspaceFolder())
		{
			return Promise.reject("LifeBoatAPI: Can't update settings while no workspace is active");
		}
	}).then( () => {
		//Lua.diagnostics.disable
		var existing : string[] = luaLibWorkspace.get("disable") ?? [];
		if(existing.indexOf("lowercase-global") === -1)
		{
			existing.push("lowercase-global");
		}
		return luaDiagnosticsConfig.update("disable", existing, vscode.ConfigurationTarget.Workspace);
	}).then( () => luaRuntimeConfig.update("version", "Lua 5.3", vscode.ConfigurationTarget.Workspace)
	).then( () => {
		//Lua.workspace.ignoreDir
		return luaLibWorkspace.update("ignoreDir", lifeboatIgnorePaths, vscode.ConfigurationTarget.Workspace);
	}).then( () => {
		//Lua.workspace.library
		return luaLibWorkspace.update("library", lifeboatLibraryPaths, vscode.ConfigurationTarget.Workspace);
	}).then(() => {
		// lua.debug.cpath
		var existing : string[] = luaDebugConfig.get("cpath") ?? [];
		for(const cPathElement of defaultCPaths)
		{
			if(existing.indexOf(cPathElement) === -1)
			{
				existing.push(cPathElement);
			}
		}
		return luaDebugConfig.update("cpath", existing, vscode.ConfigurationTarget.Workspace);
	}).then(() => {
		//lua.debug.path
		return luaDebugConfig.update("path", lifeboatLibraryPaths, vscode.ConfigurationTarget.Workspace);
	}).then( () => luaDebugConfig.update("luaVersion", "5.3", vscode.ConfigurationTarget.Workspace)
	).then( () => luaDebugConfig.update("luaArch", "x86", vscode.ConfigurationTarget.Workspace) );
}

function beginCreateNewProjectFolder(isMicrocontrollerProject: boolean)
{
	const fileDialog: vscode.OpenDialogOptions = {
		canSelectFiles: false,
		canSelectFolders: true,
		canSelectMany: false,
		title: "Select or Create empty Project Folder",
		defaultUri: vscode.workspace.workspaceFolders === undefined ? vscode.Uri.file("C:/") : vscode.Uri.file(path.dirname(vscode.workspace.workspaceFolders[0].uri.fsPath))
	};
		
	return vscode.window.showOpenDialog(fileDialog)
	.then((folders) => {
		if (folders !== undefined)
		{
			var workspaceCount = vscode.workspace.workspaceFolders ? vscode.workspace.workspaceFolders.length : 0;
			var projectName = path.basename(folders[0].fsPath);
			var workspaceFolder = {index: workspaceCount, uri:folders[0], name: projectName};
			vscode.workspace.updateWorkspaceFolders(workspaceCount, null, workspaceFolder );

			return workspaceFolder;
		}
		else
		{
			return Promise.reject("No folder selected");
		}
	}).then(
		(folder) => {
			var settings = {
				"lifeboatapi.stormworks.libraryPaths": [
				],
				"lifeboatapi.stormworks.ignorePaths": [
					"/out/",
					".vscode"
				],
				"lifeboatapi.stormworks.enableNewProjectContextMenu" : true,
				"lifeboatapi.stormworks.isMicrocontrollerProject" : isMicrocontrollerProject,
				"lifeboatapi.stormworks.isAddonProject" : !isMicrocontrollerProject,
			};
		}
	);
}

