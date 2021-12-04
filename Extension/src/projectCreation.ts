import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextDecoder, TextEncoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";


const microControllerDefaultScript =
`
--- With LifeBoatAPI; you can use the "require(...)" keyword to use code from other files!
---     This lets you share code between projects, and organise your work better.
---     The below, includes the content from SimulatorConfig.lua in the generated /_build/ folder
--- (If you want to include code from other projects, press CTRL+COMMA, and add to the LifeBoatAPI library paths)
require("_build.SimulatorConfig")


--- default onTick function; called once per in-game tick (60 per second)
ticks = 0
function onTick()
    ticks = ticks + 1
    local myRandomValue = math.random()

    if(ticks%100 == 0) then
        -- Debugging Tip (F6 to run Simulator):
        --  By clicking just left of the line number (left column), you can set a little red dot; called a "breakpoint"
        --  When you run this in the LifeBoatAPI Simulator, the debugger will stop at each breakpoint and let you see the memory values
        -- You can also look at the "callstack" to see which functions were called to get where you are.
        --  Put a breakpoint to the left of this a = nil statement, and you'll be able to see what the value of "myRandomValue" is by hovering over it
        a = nil;
    end
end

--- default onDraw function; called once for each monitor connected each tick, order is not guaranteed
function onDraw()
	-- when you simulate, you should see a slightly pink circle growing over 10 seconds and repeating.
	screen.setColor(255, 125, 125)
	screen.drawCircleF(16, 16, (ticks%600)/60)
end


--- Ready to put this in the game?
--- Just hit F7 and then copy the (now tiny) file from the /out/ folder

`;

const microControllerDefaultSimulatorConfig =
`
--- Note: code wrapped in ---@section <Identifier> <number> <Name> ... ---@endsection <Name>
---  Is only included in the final output if <Identifier> is seen <number> of times or more
---  This means the code below will not be included in the final, minimized version
---  And you can do the same to wrap library code; so that it's there if you use it, and deleted if you don't!
---  No more manual cutting/pasting code out!

---@section __SIMULATORONLY__ 1 _MAIN_SIMSECTION_INIT

    --- Runs once when the simulator starts up
    --- Put simulator configuration here, included automatic handlers for inputs, or screen sizes
    ---@param simulator LBSimulator
    ---@param config LBSimulatorConfig
    ---@param helpers LBSimulatorInputHelpers
    function onLBSimulatorInit(simulator, config, helpers)
        config:configureScreen(1, "3x2", true, false)
        config:setProperty("ExampleProperty", 50)

        -- handlers that automatically update the inputs each frame
        -- useful for simple inputs (sweeps/wraps etc.)
        config:addBoolHandler(10,   function() return math.random() * 100 < 20 end)
        config:addNumberHandler(10, function() return math.random() * 100 end)
    end

    --- runs every tick, prior to onTick and onDraw
    --- Usually not needed, can allow you to do some custom manipulation
    --- Or set breakpoints based on simulator state
    ---@param simulator LBSimulator
    function onLBSimulatorTick(simulator)end

    --- For easier debugging, called when an output value is changed
    function onLBSimulatorOutputBoolChanged(index, oldValue, newValue)end
    function onLBSimulatorOutputNumberChanged(index, oldValue, newValue)end
---@endsection _MAIN_SIMSECTION_INIT


`;

const addonDefaultScript =
`

function onTick(game_ticks)
end

`;

const preBuildActionsDefault =
`
-- This file is called just prior to the build process starting
-- Can add any pre-build actions; such as any code generation processes you wish, or other tool chains
-- Regular lua - you have access to the filesystem etc. via LBFilesystem
-- Recommend using LBFilepath for paths, to keep things easy

-- default is no actions
print("Build Started - No additional actions taken in _build/_pre_buildactions.lua")
`;


const postBuildActionsDefault =
`
-- This file is called after the build process finished
-- Can be used to copy data into the game, trigger deployments, etc.
-- Regular lua - you have access to the filesystem etc. via LBFilesystem
-- Recommend using LBFilepath for paths, to keep things easy

-- default is no actions
print("Build Success - No additional actions in _build/_post_buildactions.lua file")
`;


export function beginCreateNewProjectFolder(isMicrocontrollerProject: boolean)
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
			return {
				isMicrocontroller: isMicrocontrollerProject,
				selectedFolder: {index: workspaceCount, uri:folders[0], name: projectName},
				settingsFilePath: vscode.Uri.prototype
			};
		}
		else
		{
			return Promise.reject("No folder selected");
		}
	}).then(
		(params) => {
			params.settingsFilePath = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/.vscode/settings.json");
			return utils.doesFileExist(params.settingsFilePath,
					() => {
						return vscode.window
						.showErrorMessage("Project folder isn't empty. Are you sure?", ...["Overwrite existing", "Cancel"])
						.then(
							(item) => {
								return (item === "Overwrite existing") ? params : Promise.reject();
							}
						);
					},
					() => {
						return params; // we don't want that settings file to already exist, otherwise a misclick could trample somebody's project.
					}
			);
		}
	)	
	.then(
		(params) => {
            return vscode.workspace.fs.readFile(params.settingsFilePath).then(
                (data) => {
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

                    return vscode.workspace.fs.writeFile(params.settingsFilePath, new TextEncoder().encode(JSON.stringify(settingsJson, null, 4)))
				             .then(() => params);
                }
            );
		}
	)
	.then ( (params) => {
		if(params.isMicrocontroller)
		{
			return setupMicrocontrollerFiles(params);
		}
		else
		{
			return setupAddonFiles(params);
		}
	})
	.then(
		(params) => {
			// must be last in the chain, as it can cause VSCode to restart
			vscode.workspace.updateWorkspaceFolders(0, 0, params.selectedFolder);
		}
	);
}

export function addUserBoilerplate(text : string)
{
	var lifeboatConfig 	= vscode.workspace.getConfiguration("lifeboatapi.stormworks.user", utils.getCurrentWorkspaceFile());
	var authorName	  = "-- Author: " + (lifeboatConfig.get("authorName") ?? "<Authorname> (Please change this in user settings, Ctrl+Comma)");
	var githubLink    = "-- GitHub: " + (lifeboatConfig.get("githubLink") ?? "<GithubLink>");
	var workshopLink  = "-- Workshop: " + (lifeboatConfig.get("workshopLink") ?? "<WorkshopLink>");
	var extendedLines : string | undefined = lifeboatConfig.get("extendedBoilerplate");

	var extendedBoilerplate = "";
	if(extendedLines)
	{
		for(var line of extendedLines.split("\n"))
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
	var lifeboatConfig 	= vscode.workspace.getConfiguration("lifeboatapi.stormworks.user", utils.getCurrentWorkspaceFile());
	var authorName	  = "-- Author: " + (lifeboatConfig.get("authorName") ?? "<Authorname> (Please change this in user settings, Ctrl+Comma)");
	var githubLink    = "-- GitHub: " + (lifeboatConfig.get("githubLink") ?? "<GithubLink>");
	var workshopLink  = "-- Workshop: " + (lifeboatConfig.get("workshopLink") ?? "<WorkshopLink>");
	var extendedLines : string | undefined = lifeboatConfig.get("extendedBoilerplate");

	var extendedBoilerplate = "";
	if(extendedLines)
	{
		for(var line of extendedLines.split("\n"))
		{
			extendedBoilerplate += "\n--" + line;
		}
	}

	var nameousBoilerplate = 
`-- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--      By Nameous Changey (Please retain this notice at the top of the file as a courtesy; a lot of effort went into the creation of these tools.)`;

	return authorName + "\n" + githubLink + "\n" + workshopLink + "\n" + extendedBoilerplate + "--\n" + nameousBoilerplate + "\n" + text;
}

function setupMicrocontrollerFiles(params : any)
{
	const scriptFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/MyMicrocontroller.lua");
	return utils.doesFileExist(scriptFile,
		() => params,
		() => {
			return vscode.workspace.fs.writeFile(scriptFile, new TextEncoder().encode(addBoilerplate(microControllerDefaultScript)))
					.then( () => params );
		})
		.then(
		() => {
			const basicConfigFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/SimulatorConfig.lua");
			return utils.doesFileExist(basicConfigFile,
				() => params,
				() => {
					return vscode.workspace.fs.writeFile(basicConfigFile, new TextEncoder().encode(addBoilerplate(microControllerDefaultSimulatorConfig)))
							.then( () => params );
				});
		}).then(
			() => {
				const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_post_buildactions.lua");
				return utils.doesFileExist(buildActionsFile,
					() => params,
					() => {
						return vscode.workspace.fs.writeFile(buildActionsFile, new TextEncoder().encode(addBoilerplate(postBuildActionsDefault)))
								.then( () => params );
					});
		}).then(
			() => {
				const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_pre_buildactions.lua");
				return utils.doesFileExist(buildActionsFile,
					() => params,
					() => {
						return vscode.workspace.fs.writeFile(buildActionsFile, new TextEncoder().encode(addBoilerplate(preBuildActionsDefault)))
								.then( () => params );
					});
		});
}

function setupAddonFiles(params : any)
{
	const scriptFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/script.lua");
	return utils.doesFileExist(scriptFile,
		() => params,
		() => {
			return vscode.workspace.fs.writeFile(scriptFile, new TextEncoder().encode(addBoilerplate(addonDefaultScript)))
					.then( () => params );
		}).then(
			() => {
				const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_post_buildactions.lua");
				return utils.doesFileExist(buildActionsFile,
					() => params,
					() => {
						return vscode.workspace.fs.writeFile(buildActionsFile, new TextEncoder().encode(addBoilerplate(postBuildActionsDefault)))
								.then( () => params );
					});
		}).then(
			() => {
				const buildActionsFile = vscode.Uri.file(params.selectedFolder.uri.fsPath + "/_build/_pre_buildactions.lua");
				return utils.doesFileExist(buildActionsFile,
					() => params,
					() => {
						return vscode.workspace.fs.writeFile(buildActionsFile, new TextEncoder().encode(addBoilerplate(preBuildActionsDefault)))
								.then( () => params );
					});
		});
}