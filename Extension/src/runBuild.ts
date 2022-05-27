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
    let content =  `
--- @diagnostic disable: undefined-global

require("LifeBoatAPI.Tools.Build.Builder")

local luaDocsAddonPath  = LifeBoatAPI.Tools.Filepath:new(arg[1]);
local luaDocsMCPath     = LifeBoatAPI.Tools.Filepath:new(arg[2]);
local outputDir         = LifeBoatAPI.Tools.Filepath:new(arg[3]);
local params            = {
    boilerPlate             = arg[4],
    reduceAllWhitespace     = arg[5] == "true",
    reduceNewlines          = arg[6] == "true",
    removeRedundancies      = arg[7] == "true",
    shortenVariables        = arg[8] == "true",
    shortenGlobals          = arg[9] == "true",
    shortenNumbers          = arg[10]== "true",
    forceNCBoilerplate      = arg[11]== "true",
    forceBoilerplate        = arg[12]== "true",
    shortenStringDuplicates = arg[13]== "true",
    removeComments          = arg[14]== "true",
    skipCombinedFileOutput  = arg[15]== "true"
};
local rootDirs          = {};

for i=15, #arg do
    table.insert(rootDirs, LifeBoatAPI.Tools.Filepath:new(arg[i]));
end

local _builder = LifeBoatAPI.Tools.Builder:new(rootDirs, outputDir, luaDocsMCPath, luaDocsAddonPath)

if onLBBuildStarted then onLBBuildStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[${workspace.fsPath}]])) end
`;

    return vscode.workspace.findFiles(new vscode.RelativePattern(workspace, "**/*.lua"), "**/{_build,out,.vscode,_examples_and_tutorials}/**")
    .then(
        (files) => {
            for(let file of files)
            {
                // turn the relative path into a lua require
                let relativePath = file.fsPath.replaceAll(workspace.fsPath, "");
                //relativePath = relativePath.replaceAll(path.extname(relativePath), "");

                if(relativePath.substr(0,1) === "\\") // remove initial "." that might be left
                {
                    relativePath = relativePath.substr(1);
                }

                let buildLine = isMC ? `local combinedText, outText, outFile = _builder:buildMicrocontroller([[${relativePath}]], LifeBoatAPI.Tools.Filepath:new([[${file.fsPath}]]), params)`
                                     : `local combinedText, outText, outFile = _builder:buildAddonScript([[${relativePath}]], LifeBoatAPI.Tools.Filepath:new([[${file.fsPath}]]), params)`;
                content += `\nif onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[${workspace.fsPath}]]), [[${relativePath}]], LifeBoatAPI.Tools.Filepath:new([[${file.fsPath}]])) end\n`
                         + `\n${buildLine}`
                         + `\nif onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[${workspace.fsPath}]]), [[${relativePath}]], LifeBoatAPI.Tools.Filepath:new([[${file.fsPath}]]), outFile, combinedText, outText) end\n`;
            }
            return content;
    }).then(
        (content) => {
            return utils.doesFileExist(vscode.Uri.file(workspace.fsPath + "/_build/_buildactions.lua"),
                () => "\nrequire([[_build._buildactions]])" + content,
                () => content
            );
        }
    ).then(
        (content) => content + `\nif onLBBuildComplete then onLBBuildComplete(_builder, params, LifeBoatAPI.Tools.Filepath:new([[${workspace.fsPath}]])) end` 
                             + "\n--- @diagnostic enable: undefined-global\n"
    );
}


export function beginBuild(context:vscode.ExtensionContext)
{
    let lifeboatapiConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", utils.getCurrentWorkspaceFile());
    let workspace = utils.getCurrentWorkspaceFolder();
    // we build an entire workspace at once, as the majority of the cost is starting up the combiner
    if (workspace)
    {
        let neloAddonDoc = context.extensionPath + "/assets/nelodocs/docs_missions.lua";
        let neloMCDoc = context.extensionPath + "/assets/nelodocs/docs_vehicles.lua";
        if(lifeboatapiConfig.get("overwriteNeloDocsPath"))
        {
            neloAddonDoc = lifeboatapiConfig.get("neloAddonDocPath") ?? neloAddonDoc; // if the user screws it up, just use our bundled one
            neloMCDoc = lifeboatapiConfig.get("neloMicrocontrollerDocPath") ?? neloMCDoc;
        }

        let buildLuaFile = vscode.Uri.file(workspace.uri.fsPath + "/_build/_build.lua");
        let outputDir = workspace.uri.fsPath + "/out/";
        let rootDir = workspace.uri.fsPath;

        let path = settingsManagement.getDebugPaths(context);
        path.push(utils.sanitisePath(workspace.uri.fsPath) + "?.lua");

        return generateBuildLua(workspace.uri, utils.isMicrocontrollerProject(), context)
        .then(
            (buildLua) => vscode.workspace.fs.writeFile(buildLuaFile, new TextEncoder().encode(buildLua))
        ).then(
            () => {

                let minimizerConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.minimizer", utils.getCurrentWorkspaceFile());

                let config = {
                    name: "Build Workspace",
                    type: "lua",
                    request: "launch",
                    program: `${buildLuaFile?.fsPath}`,
                    stopOnEntry: false,
                    stopOnThreadEntry: false,
                    path: path.join(";"),
                    cpath: settingsManagement.getDebugCPaths(context),
                    arg: [
                        neloAddonDoc,
                        neloMCDoc,
                        outputDir,

                        projectCreation.addUserBoilerplate(""),
                        `${minimizerConfig.get("reduceAllWhitespace",       true)}`,
                        `${minimizerConfig.get("reduceNewlines",            true)}`,
                        `${minimizerConfig.get("removeRedundancies",        true)}`,
                        `${minimizerConfig.get("shortenVariables",          true)}`,
                        `${minimizerConfig.get("shortenGlobals",            true)}`,
                        `${minimizerConfig.get("shortenNumbers",            true)}`,
                        `${minimizerConfig.get("forceNCBoilerplate",        false)}`,
                        `${minimizerConfig.get("forceBoilerplate",          false)}`,
                        `${minimizerConfig.get("shortenStringDuplicates",   true)}`,
                        `${minimizerConfig.get("removeComments",            true)}`,
                        `${minimizerConfig.get("skipCombinedFileOutput",    false)}`
                    ]
                };
                // all remaining args are root paths to load scripts from
                const libPaths = settingsManagement.getLibraryPaths(context);
                for(let dir of libPaths)
                {
                    config.arg.push(dir);
                }
                config.arg.push(rootDir);

                return vscode.debug.startDebugging(workspace, config);
            }
        );
    }

    return Promise.reject();
}