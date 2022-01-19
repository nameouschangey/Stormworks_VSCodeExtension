import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";
import { debug } from 'console';


export function getLibraryPaths(context : vscode.ExtensionContext)
{
	let lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", utils.getCurrentWorkspaceFile());

	let lbPaths : string[] = [];
	let lifeboatLibraryPaths : string[] = lifeboatConfig.get("projectSpecificLibraryPaths") ?? [];
    let wslifeboatLibraryPaths : string[] = lifeboatConfig.get("workspaceLibraryPaths") ?? [];
    let userlifeboatLibraryPaths : string[] = lifeboatConfig.get("globalLibraryPaths") ?? [];

	for (let path of lifeboatLibraryPaths)
    {
        lbPaths.push(utils.sanitisePath(path));
    }

    for (let path of wslifeboatLibraryPaths)
    {
        lbPaths.push(utils.sanitisePath(path));
    }

    for(let path of userlifeboatLibraryPaths)
    {
        lbPaths.push(utils.sanitisePath(path));
    }

	// add lifeboatAPI to the library path
	if(utils.isMicrocontrollerProject())
    {
		lbPaths.push(utils.sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Microcontroller/");
        lbPaths.push(utils.sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Tools/");
	}
	else
	{
		lbPaths.push(utils.sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Addons/");
		lbPaths.push(utils.sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Tools/");
	}

	return lbPaths;
}

export function getDebugPaths(context : vscode.ExtensionContext)
{
	let debugPaths = [
		utils.sanitisePath(context.extensionPath) + "/assets/luasocket/?.lua",
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

	const defaultCPaths = [
		utils.sanitisePath(context.extensionPath) + "/assets/luasocket/dll/socket/core.dll",
		utils.sanitisePath(context.extensionPath) + "/assets/luasocket/dll/mime/core.dll"
	];

	let existing : string[] = luaDebugConfig.get("cpath") ?? [];
		
	for(const cPathElement of defaultCPaths)
	{
		if(existing.indexOf(cPathElement) === -1)
		{
			existing.push(cPathElement);
		}
	}
	return existing;
}

export function beginUpdateWorkspaceSettings(context: vscode.ExtensionContext) {
	let lifeboatLibConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", utils.getCurrentWorkspaceFile());
	let lifeboatMainConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", utils.getCurrentWorkspaceFile());
    let lifeboatLibraryPaths = getLibraryPaths(context);
	let lifeboatIgnorePaths : string[]= lifeboatLibConfig.get("ignorePaths") ?? [];

	// add standard ignores
	if (!lifeboatIgnorePaths.includes(".vscode"))
	{
		lifeboatIgnorePaths.push(".vscode");
	}

	if (!lifeboatIgnorePaths.includes("/out/"))
	{
		lifeboatIgnorePaths.push("/out/");
	}

	if (!lifeboatIgnorePaths.includes("/_build/"))
	{
		lifeboatIgnorePaths.push("/_build/");
	}

	if (!lifeboatIgnorePaths.includes("/_examples_and_tutorials/"))
	{
		lifeboatIgnorePaths.push("/_examples_and_tutorials/");
	}

	let luaDiagnosticsConfig = vscode.workspace.getConfiguration("Lua.diagnostics");
	let luaRuntimeConfig = vscode.workspace.getConfiguration("Lua.runtime");
	let luaLibWorkspace = vscode.workspace.getConfiguration("Lua.workspace");
	let luaDebugConfig = vscode.workspace.getConfiguration("lua.debug.settings");
	let luaIntellisense = vscode.workspace.getConfiguration("Lua.IntelliSense");

	return Promise.resolve()
	.then( () => {
		if(!utils.getCurrentWorkspaceFolder())
		{
			return Promise.reject("Can't update settings while no workspace is active");
		}

	}).then( () => {
		//Lua.diagnostics.disable
		let existing : string[] = luaLibWorkspace.get("disable") ?? [];
		if(existing.indexOf("lowercase-global") === -1)
		{
			existing.push("lowercase-global");
		}
		if(existing.indexOf("undefined-doc-name") === -1)
		{
			existing.push("undefined-doc-name");
		}
		return luaDiagnosticsConfig.update("disable", existing, vscode.ConfigurationTarget.Workspace);

	}).then( () => luaRuntimeConfig.update("version", "Lua 5.3", vscode.ConfigurationTarget.Workspace)
	).then( () => {
		let shouldDisableIntellisense = lifeboatMainConfig.get("lifeboatapi.stormworks.shouldDisableNonSWIntellisense");
		let enableLibraryValue = shouldDisableIntellisense ? "disable" : "enable";

		// disable intellisense for lua modules that aren't available in stormworks
		let luaModulesToDisable = {
				"coroutine": 	enableLibraryValue,
				"bit32": 		enableLibraryValue,
				"bit": 			enableLibraryValue,
				"builtin": 		enableLibraryValue,
				"utf8": 		enableLibraryValue,
				"package": 		enableLibraryValue,
				"os": 			enableLibraryValue,
				"jit": 			enableLibraryValue,
				"io": 			enableLibraryValue,
				"ffi": 			enableLibraryValue,
				"debug": 		enableLibraryValue,
				"basic":		enableLibraryValue
		};

		luaRuntimeConfig.update("builtin", luaModulesToDisable, vscode.ConfigurationTarget.Workspace);
		
	}).then( () => {
		//Lua.workspace.ignoreDir
		return luaLibWorkspace.update("ignoreDir", lifeboatIgnorePaths, vscode.ConfigurationTarget.Workspace);

	}).then(() => {
		// lua.debug.cpath
		return luaDebugConfig.update("cpath", getDebugCPaths(context), vscode.ConfigurationTarget.Workspace);

	}).then(() => {
		//lua.debug.path
		return luaDebugConfig.update("path", getDebugPaths(context), vscode.ConfigurationTarget.Workspace);
	}).then( () => { 
		//Lua.workspace.library
		let docConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.nelo", utils.getCurrentWorkspaceFile());

		// Nelo Docs root
		let neloAddonDoc = utils.sanitisePath(context.extensionPath) + "/assets/nelodocs/docs_missions.lua";
		let neloMCDoc = utils.sanitisePath(context.extensionPath) + "/assets/nelodocs/docs_vehicles.lua";
		if (docConfig.get("overwriteNeloDocsPath") === true)
		{
			neloAddonDoc = docConfig.get("neloAddonDocPath") ?? neloAddonDoc; // if the user screws it up, just use our bundled one
			neloMCDoc = docConfig.get("neloMicrocontrollerDocPath") ?? neloMCDoc;
		}

		// Nelo Docs should only be in the library path for the relevant project type
		if (lifeboatMainConfig.get("isAddonProject") === true) {
			lifeboatLibraryPaths.push(neloAddonDoc);
		} else {
			lifeboatLibraryPaths.push(neloMCDoc);
		}

		return luaLibWorkspace.update("library", lifeboatLibraryPaths, vscode.ConfigurationTarget.Workspace);
	}).then( () => luaDebugConfig.update("luaVersion", "5.3", vscode.ConfigurationTarget.Workspace))
	.then( () => luaDebugConfig.update("luaArch", "x86", vscode.ConfigurationTarget.Workspace) )
	.then( () => luaIntellisense.update("traceBeSetted", true))
	.then( () => luaIntellisense.update("traceFieldInject", true))
	.then( () => luaIntellisense.update("traceLocalSet", true))
	.then( () => luaIntellisense.update("traceReturn", true));
}