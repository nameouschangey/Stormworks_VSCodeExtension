import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings, worker } from 'cluster';
import * as utils from "./utils";
import * as projectCreation from "./projectCreation";
import * as settingsManagement from "./settingsManagement";

function generateBuildLua(workspace: vscode.Uri, isMC : boolean, context:vscode.ExtensionContext)
{
    var content =  `
require("LifeBoatAPI.Tools.Builder.LBBuilder")

local neloAddonPath = LBFilepath:new(arg[1]);
local neloMCPath = LBFilepath:new(arg[2]);
local outputDir = LBFilepath:new(arg[3]);
local params = {boilerPlate = arg[4]};
local rootDirs = {};

for i=5, #arg do
    table.insert(rootDirs, LBFilepath:new(arg[i]));
end

local _builder = LBBuilder:new(rootDirs, outputDir, neloMCPath, neloAddonPath)`;

    var pattern = new vscode.RelativePattern(workspace, "**/*.lua");
    return vscode.workspace.findFiles(pattern, "**/{out,.vscode}/**")
    .then(
        (files) => {
            
            var buildActionsFile = null;
            for(var file of files)
            {
                // turn the relative path into a lua require
                var relativePath = file.fsPath.replace(workspace.fsPath, "");
                //relativePath = relativePath.replace(path.extname(relativePath), "");

                if(relativePath.substr(0,1) === "\\") // remove initial "." that might be left
                {
                    relativePath = relativePath.substr(1);
                }

                if(relativePath.includes("_BuildActions.lua"))
                {
                    buildActionsFile = relativePath;
                }

                var buildLine = isMC ? `_builder:buildMicrocontroller([[${relativePath}]], LBFilepath:new([[${file.fsPath}]]), params)`
                                     : `_builder:buildAddonScript([[${relativePath}]], LBFilepath:new([[${file.fsPath}]]), params)`;
                content += "\n" + buildLine;
            }

            if(buildActionsFile)
            {
                buildActionsFile = buildActionsFile.replace(path.extname(buildActionsFile), "");
                buildActionsFile = buildActionsFile.replace("\\\\", "\\");
                buildActionsFile = buildActionsFile.replace("\\", "."); 
                buildActionsFile = buildActionsFile.replace("/", ".");
            
                if(buildActionsFile.substr(0,1) === ".") // remove initial "." that might be left
                {
                    relativePath = buildActionsFile.substr(1);
                }

                content += `\nrequire([[${buildActionsFile}]])`;
            }
            
            return content;
    });
}


export function beginBuild(context:vscode.ExtensionContext)
{
    var lifeboatapiConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", utils.getCurrentWorkspaceFile());
    var workspace = utils.getCurrentWorkspaceFolder();
    // we build an entire workspace at once, as the majority of the cost is starting up the combiner
    if (workspace)
    {
        var neloAddonDoc = context.extensionPath + "/assets/nelodocs/docs_missions.lua";
        var neloMCDoc = context.extensionPath + "/assets/nelodocs/docs_vehicles.lua";
        if(lifeboatapiConfig.get("overwriteNeloDocsPath"))
        {
            neloAddonDoc = lifeboatapiConfig.get("neloAddonDocPath") ?? neloAddonDoc; // if the user screws it up, just use our bundled one
            neloMCDoc = lifeboatapiConfig.get("neloMicrocontrollerDocPath") ?? neloMCDoc;
        }

        
        var buildLuaFile = vscode.Uri.file(workspace.uri.fsPath + "/out/_process/__build.lua");
        var outputDir = workspace.uri.fsPath + "/out/";
        var rootDir = workspace.uri.fsPath;

        return generateBuildLua(workspace.uri, utils.isMicrocontrollerProject(), context)
        .then(
            (buildLua) => vscode.workspace.fs.writeFile(buildLuaFile, new TextEncoder().encode(buildLua))
        ).then(
            () => {
                var config = {
                    name: "Build Workspace",
                    type: "lua",
                    request: "launch",
                    program: `${buildLuaFile?.fsPath}`,
                    stopOnEntry: false,
                    stopOnThreadEntry: false,
                    arg: [
                        neloAddonDoc,
                        neloMCDoc,
                        outputDir,
                        projectCreation.addUserBoilerplate("")
                    ]
                };
                // all remaining args are root paths to load scripts from
                const libPaths = settingsManagement.getLibraryPaths(context);
                for(var dir of libPaths)
                {
                    config.arg.push(dir);
                }
                config.arg.push(rootDir);

                vscode.window.showInformationMessage(`Simulating file: ${utils.getCurrentWorkspaceFile()?.fsPath}`);
                return vscode.debug.startDebugging(workspace, config);
            }
        );
    }

    return Promise.reject();
}