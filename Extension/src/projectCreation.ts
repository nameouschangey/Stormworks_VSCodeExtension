import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextDecoder, TextEncoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";

export function beginCreateNewProjectFolder(context:vscode.ExtensionContext, isMicrocontrollerProject: boolean)
{
	const fileDialog: vscode.OpenDialogOptions = {
		canSelectFiles: false,
		canSelectFolders: true,
		canSelectMany: false,
		title: "Select or Create empty Project Folder",
		defaultUri: (vscode.workspace.workspaceFolders === undefined || vscode.workspace.workspaceFolders.length === 0)? vscode.Uri.file("C:/") : vscode.Uri.file(path.dirname(vscode.workspace.workspaceFolders[0].uri.fsPath))
	};
		
	return vscode.window.showOpenDialog(fileDialog)
	.then((folders) => {
		if (folders !== undefined)
		{
			let workspaceCount = vscode.workspace.workspaceFolders ? vscode.workspace.workspaceFolders.length : 0;
			let projectName = path.basename(folders[0].fsPath);
			return {
				isMicrocontroller: isMicrocontrollerProject,
				selectedFolder: {index: workspaceCount, uri:folders[0], name: projectName},
				settingsFilePath: vscode.Uri.prototype,
				launchFilepath: vscode.Uri.prototype
			};
		}
		else
		{
			return Promise.reject("No folder selected");
		}
	})
	.then(
		(params) => {
			params.settingsFilePath = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/.vscode/settings.json");
            return vscode.workspace.fs.readFile(params.settingsFilePath).then(
                (data) => { // get existing settings file if there is one
                    const stringData = new TextDecoder().decode(data);
                    const jsonData = JSON.parse(stringData);
                    return jsonData;
                },
                (err) => {
                    return {};
                }
            ).then(
                (settingsJson) => {
                    settingsJson["lifeboatapi.stormworks.isMicrocontrollerProject"] = isMicrocontrollerProject;
                    settingsJson["lifeboatapi.stormworks.isAddonProject"] = !isMicrocontrollerProject;

					// addon project overwrites the default Minifier settings for a better user experience
					if (!isMicrocontrollerProject) {
						settingsJson["lifeboatapi.stormworks.minimizer.removeComments"] 			= false;
						settingsJson["lifeboatapi.stormworks.minimizer.reduceAllWhitespace"] 		= false;
						settingsJson["lifeboatapi.stormworks.minimizer.reduceNewlines"] 			= true;
						settingsJson["lifeboatapi.stormworks.minimizer.removeRedundancies"] 		= true;
						settingsJson["lifeboatapi.stormworks.minimizer.shortenVariables"] 			= false;
						settingsJson["lifeboatapi.stormworks.minimizer.shortenGlobals"] 			= false; 
						settingsJson["lifeboatapi.stormworks.minimizer.shortenNumbers"] 			= false;
						settingsJson["lifeboatapi.stormworks.minimizer.shortenStringDuplicates"] 	= false; 
						settingsJson["lifeboatapi.stormworks.minimizer.forceNCBoilerplate"] 		= true; 
						settingsJson["lifeboatapi.stormworks.minimizer.forceBoilerplate"] 			= true;
					}

					settingsJson["Lua.diagnostics.disable"] = [
						"lowercase-global",
						"undefined-doc-name"
					];

					settingsJson["Lua.diagnostics.globals"] = [
						"__simulator",
						"print",
						"simulator"
					];
					settingsJson["Lua.runtime.version"] = "Lua 5.3";

					settingsJson["Lua.runtime.builtin"] = {
						"coroutine": "enable",
						"bit32": "enable",
						"bit": "enable",
						"builtin": "enable",
						"utf8": "enable",
						"package": "enable",
						"os": "enable",
						"jit": "enable",
						"io": "enable",
						"ffi": "enable",
						"debug": "enable",
						"basic": "enable"
					};

					settingsJson["Lua.workspace.ignoreDir"] = [
						".vscode",
						"/out/",
						"/_build/",
						"/_examples_and_tutorials/"
					];

					if(isMicrocontrollerProject){
						settingsJson["Lua.workspace.library"] = [
							utils.sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Microcontroller/",
							utils.sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Tools/"
						];

						settingsJson["Lua.runtime.path"] = [
							utils.sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Microcontroller/?.lua",
							"?.lua"
						];
					}
					else
					{
						settingsJson["Lua.workspace.library"] = [
							utils.sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Addons/",
							utils.sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Tools/"
						];

						settingsJson["Lua.runtime.path"] = [
							utils.sanitisePath(context.extensionPath) + "/assets/LifeBoatAPI/Addon/?.lua",
							"?.lua"
						];
					}

                    return vscode.workspace.fs.writeFile(params.settingsFilePath, new TextEncoder().encode(JSON.stringify(settingsJson, null, 4)))
				             .then(() => params);
                }
            );
		}
	)
	.then(
		(params) => {
			params.launchFilepath = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/.vscode/launch.json");
            return vscode.workspace.fs.readFile(params.launchFilepath).then(
                (data) => { // get existing launch if there is one
                    const stringData = new TextDecoder().decode(data);
                    const jsonData = JSON.parse(stringData);
                    return jsonData;
                },
                (err) => {
                    return {
						version: "0.2.0",
						configurations: []
					};
                }
            ).then(
                (launchJson) => {
					launchJson["configurations"].push({
						name: "Run Lua",
						type: "lua",
						request: "launch",
						program: "${file}",
					});

                    return vscode.workspace.fs.writeFile(params.launchFilepath, new TextEncoder().encode(JSON.stringify(launchJson, null, 4)))
				             .then(() => params);
                }
            );
		}
	)
	.then ( (params) => {
		if(params.isMicrocontroller)
		{
			return setupMicrocontrollerFiles(context, params).then(() => params);
		}
		else
		{
			return setupAddonFiles(context, params).then(() => params);
		}
	})
	.then((params) => vscode.commands.executeCommand("workbench.view.explorer").then(() => params))
	.then( 
		(params) => {
			//if(!vscode.workspace.workspaceFile)
			//{
			//	let workspaceName = path.basename(params.selectedFolder.uri.fsPath);
			//	let workspaceFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/.vscode/" + workspaceName + ".code-workspace");
			//	return vscode.workspace.fs.writeFile(
			//		workspaceFile,
			//		new TextEncoder().encode(JSON.stringify({
			//			"folders": [
			//				{
			//					"path": ".."
			//				}
			//			]
			//		}, null, 4)))
			//	 .then(
			//		 () => vscode.commands.executeCommand("vscode.openFolder", workspaceFile)
			//	 );
			//}
			return vscode.workspace.updateWorkspaceFolders(0, 0, params.selectedFolder);
		}
	);
}

export function addUserBoilerplate(text : string)
{
	let lifeboatConfig 	= vscode.workspace.getConfiguration("lifeboatapi.stormworks.user", utils.getCurrentWorkspaceFile());
	let authorName	  = "-- Author: " + (lifeboatConfig.get("authorName") ?? "<Authorname> (Please change this in user settings, Ctrl+Comma)");
	let githubLink    = "-- GitHub: " + (lifeboatConfig.get("githubLink") ?? "<GithubLink>");
	let workshopLink  = "-- Workshop: " + (lifeboatConfig.get("workshopLink") ?? "<WorkshopLink>");
	let extendedLines : string | undefined = lifeboatConfig.get("extendedBoilerplate");

	let extendedBoilerplate = "";
	if(extendedLines)
	{
		for(let line of extendedLines.split("\n"))
		{
			extendedBoilerplate += "\n--" + line;
		}
		return authorName + "\n" + githubLink + "\n" + workshopLink + "\n" + extendedBoilerplate + "\n" + text;
	}
	else
	{
		return authorName + "\n" + githubLink + "\n" + workshopLink + "\n" + text;
	}
}

export function addBoilerplate(text : string)
{
	let lifeboatConfig 	= vscode.workspace.getConfiguration("lifeboatapi.stormworks.user", utils.getCurrentWorkspaceFile());
	let authorName	  = "-- Author: " + (lifeboatConfig.get("authorName") ?? "<Authorname> (Please change this in user settings, Ctrl+Comma)");
	let githubLink    = "-- GitHub: " + (lifeboatConfig.get("githubLink") ?? "<GithubLink>");
	let workshopLink  = "-- Workshop: " + (lifeboatConfig.get("workshopLink") ?? "<WorkshopLink>");
	let extendedLines : string | undefined = lifeboatConfig.get("extendedBoilerplate");

	let extendedBoilerplate = "";
	if(extendedLines)
	{
		for(let line of extendedLines.split("\n"))
		{
			extendedBoilerplate += "\n--" + line;
		}
	}

	let nameousBoilerplate = 
`--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey`;

	return authorName + "\n" + githubLink + "\n" + workshopLink + "\n" + extendedBoilerplate + "--\n" + nameousBoilerplate + "\n" + text;
}

function copyAllFiles(sourceFolder : vscode.Uri, destinationFolder : vscode.Uri, overwrite: boolean)
{
	return vscode.workspace.fs.readDirectory(sourceFolder).then(
			(files) => {
				let thenables : Thenable<any>[] = [];

				for(let file of files)
				{
					if(file[1] === 1)
					{
						thenables.push(vscode.workspace.fs.copy(vscode.Uri.file(sourceFolder.path + "/" + file[0]),
																vscode.Uri.file(destinationFolder.path + "/" + file[0]),
																{overwrite: overwrite}));
					}
					else
					{
						thenables.push(copyAllFiles(vscode.Uri.file(sourceFolder.path + "/" + file[0]),
													vscode.Uri.file(destinationFolder.path  + "/" + file[0]),
													overwrite));
					}
				}
				return Promise.all(thenables);
			});
}

function setupMicrocontrollerFiles(context : vscode.ExtensionContext, params : any)
{
	return copyAllFiles(vscode.Uri.file(context.extensionPath + "/assets/default_project_files/microcontroller/"),
						vscode.Uri.file(params.selectedFolder.uri.fsPath), false);
}

function setupAddonFiles(context : vscode.ExtensionContext, params : any)
{
	return copyAllFiles(vscode.Uri.file(context.extensionPath + "/assets/default_project_files/addon/"),
						vscode.Uri.file(params.selectedFolder.uri.fsPath), false);
}