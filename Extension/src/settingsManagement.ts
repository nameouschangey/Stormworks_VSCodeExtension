import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";
import { debug } from 'console';


export function getLibraryPaths(context : vscode.ExtensionContext)
{
	let workspaceFolder = utils.getCurrentWorkspaceFolder();
	let lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", workspaceFolder);
	let lbPaths : {[path:string] : boolean;} = {};

	// sanitized library paths from settings
	let libraryPaths : string[] = lifeboatConfig.get("libraryPaths") ?? [];
	for (let path of libraryPaths)
    {
        lbPaths[utils.sanitisePath(path)] = true;
    }

	lbPaths[utils.sanitisePath(workspaceFolder?.uri.fsPath ?? "") + "_build/libs/"] = true;

	// add lifeboatAPI to the library path
	if(utils.isMicrocontrollerProject())
    {
		lbPaths[utils.sanitisePath(context.extensionPath) + "assets/LifeBoatAPI/Microcontroller/"] = true;
        lbPaths[utils.sanitisePath(context.extensionPath) + "assets/LifeBoatAPI/Tools/"] = true;
	}
	else
	{
		lbPaths[utils.sanitisePath(context.extensionPath) + "assets/LifeBoatAPI/Addons/"] = true;
		lbPaths[utils.sanitisePath(context.extensionPath) + "assets/LifeBoatAPI/Tools/"] = true;
	}

	return Object.keys(lbPaths);
}

// specific for getting the paths that Lua Intellisense wants (separate to runtime + library paths)
function getLuaIntellisenseRequirePaths(context : vscode.ExtensionContext)
{
	let workspaceFolder = utils.getCurrentWorkspaceFolder();
	let lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", utils.getCurrentWorkspaceFile());
	let lbPaths : {[path:string] : boolean;} = {};

	// sanitized library paths from settings
	let libraryPaths : string[] = lifeboatConfig.get("libraryPaths") ?? [];
	for (let path of libraryPaths)
    {
        lbPaths[utils.sanitisePath(path)] = true;
    }

	lbPaths[utils.sanitisePath(workspaceFolder?.uri.fsPath ?? "") + "_build/libs/"] = true;

	// add lifeboatAPI to the library path
	if(utils.isMicrocontrollerProject())
    {
		lbPaths[utils.sanitisePath(context.extensionPath) + "assets/LifeBoatAPI/Microcontroller/"] = true;
	}
	else
	{
		lbPaths[utils.sanitisePath(context.extensionPath) + "assets/LifeBoatAPI/Addons/"] = true;
	}

	let paths = Object.keys(lbPaths);
	paths.forEach(function(val, ind, array) {
		array[ind] = val + "?.lua";
	});
	paths.push("?.lua");
	return paths;
}

export function getDebugPaths(context : vscode.ExtensionContext)
{
	let debugPaths = [
		utils.sanitisePath(context.extensionPath) + "assets/luasocket/?.lua",
	];
	for(let path of getLibraryPaths(context))
	{
		debugPaths.push(path + "?.lua"); // irritating difference between how the debugger and the intellisense check paths
	}
	return debugPaths;
}

export function getDebugCPaths(context : vscode.ExtensionContext)
{
	let luaDebugConfig = vscode.workspace.getConfiguration("lua.debug.settings");

	// fix for updated config in extension
	let cpathString : string = luaDebugConfig.get("cpath") ?? "";
	if (typeof cpathString !== 'string')
	{
		cpathString = "";
	}
	
	let existingAsList : string[] = cpathString.split(";");
	const defaultCPaths = [
		utils.sanitisePath(context.extensionPath) + "assets/luasocket/dll/socket/core.dll",
		utils.sanitisePath(context.extensionPath) + "assets/luasocket/dll/mime/core.dll",
	];
	for(const cPathElement of defaultCPaths)
	{
		if(!existingAsList.includes(cPathElement))
		{
			existingAsList.push(cPathElement);
		}
	}
	
	return existingAsList.join(";");
}

export function updateLuaLibraryPaths(context: vscode.ExtensionContext, folder?:vscode.WorkspaceFolder) {
	folder = folder || utils.getCurrentWorkspaceFolder();

	let luaLibWorkspace = vscode.workspace.getConfiguration("Lua.workspace", folder);
	let luaLibRuntime = vscode.workspace.getConfiguration("Lua.runtime", folder);

	return Promise.resolve()
	.then( () => {
		if(!utils.getCurrentWorkspaceFolder())
		{
			return Promise.reject("Can't update settings while no workspace is active");
		}
	}).then( () => { 
		return luaLibWorkspace.update("library", getLibraryPaths(context), vscode.ConfigurationTarget.WorkspaceFolder);
	}).then( () => { 
		return luaLibRuntime.update("path", getLuaIntellisenseRequirePaths(context), vscode.ConfigurationTarget.WorkspaceFolder);
	});
}