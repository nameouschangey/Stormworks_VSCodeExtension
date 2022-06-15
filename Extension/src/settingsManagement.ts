import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";
import { debug } from 'console';


export function getLibraryPaths(context : vscode.ExtensionContext, folder: vscode.WorkspaceFolder | undefined)
{
	let lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", folder);
	let libraryPaths : string[] = lifeboatConfig.get("libraryPaths") ?? [];

	// sanitized library paths from settings
	let uniquePaths : Set<string> = new Set();

	// current workspace
	uniquePaths.add(utils.sanitizeFolderPath(folder?.uri.fsPath ?? ""));

	// default extension paths
	uniquePaths.add(utils.sanitizeFolderPath(context.extensionPath) + "assets/lua/Common/");
	if(utils.isMicrocontrollerProject(folder))
	{
		uniquePaths.add(utils.sanitizeFolderPath(context.extensionPath) + "assets/lua/Microcontroller/");
	}
	else
	{
		uniquePaths.add(utils.sanitizeFolderPath(context.extensionPath) + "assets/lua/Addon/");
	}

	// hardcoded user paths
	for (let path of libraryPaths)
    {
        uniquePaths.add(utils.sanitizeFolderPath(path));
    }

	// lastly, git library paths
	uniquePaths.add(utils.sanitizeFolderPath(folder?.uri.fsPath ?? "") + "_build/libs/");
	
	return Array.from(uniquePaths);
}

export function getDebugPaths(context : vscode.ExtensionContext, folder: vscode.WorkspaceFolder | undefined)
{
	let debugPaths = [
		utils.sanitizeFolderPath(context.extensionPath) + "assets/luasocket/?.lua",
	];
	for(let path of getLibraryPaths(context, folder))
	{
		debugPaths.push(path + "?.lua"); // irritating difference between how the debugger and the intellisense check paths
		debugPaths.push(path + "?.luah"); // "hidden" lua that will run, but not appear in intellisense
		debugPaths.push(path + "?/init.lua"); // library initializers
	}
	return debugPaths;
}

export function getDebugCPaths(context : vscode.ExtensionContext)
{
	// no user-defined cpaths allowed, as it opens up people including and using dangerous dlls very easily
	const defaultCPaths = [
		utils.sanitizeFolderPath(context.extensionPath) + "assets/luasocket/dll/socket/core.dll",
		utils.sanitizeFolderPath(context.extensionPath) + "assets/luasocket/dll/mime/core.dll",
	];

	return defaultCPaths.join(";");
}

export function updateLuaLibraryPaths(context: vscode.ExtensionContext, folder:vscode.WorkspaceFolder|undefined) {
	return Promise.resolve().then( () => {
		let luaLibWorkspace = vscode.workspace.getConfiguration("Lua.workspace", folder);
		return luaLibWorkspace.update("library", getLibraryPaths(context, folder), vscode.ConfigurationTarget.WorkspaceFolder);
	});
}