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


const newFileData = `
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "3x3")
    simulator:setProperty("ExampleNumberProperty", 123)

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)

        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)

        -- NEW! button/slider options from the UI
        simulator:setInputBool(31, simulator:getIsClicked(1))       -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))        -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))       -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50)   -- set input 32 to the value from slider 2 * 50
    end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

ticks = 0
function onTick()
    ticks = ticks + 1
end

function onDraw()
    screen.drawCircle(16,16,5)
end
`;

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
				let data = projectCreation.addBoilerplate("");;
				if(utils.isMicrocontrollerProject(folder))
				{
					data += newFileData;
				}

				let edit = new vscode.WorkspaceEdit();
				edit.insert(document.uri, new vscode.Position(0, 0), data);
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

