"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.beginBuild = void 0;
const vscode = require("vscode");
const util_1 = require("util");
const utils = require("./utils");
const projectCreation = require("./projectCreation");
const settingsManagement = require("./settingsManagement");
function generateBuildLua(workspace, isMC, context) {
    let content = `
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
    forceBoilerplate        = arg[12]== "true"
    shortenStringDuplicates = arg[13]== "true"
    removeComments          = arg[14]== "true"      
};
local rootDirs          = {};

for i=15, #arg do
    table.insert(rootDirs, LifeBoatAPI.Tools.Filepath:new(arg[i]));
end

local _builder = LifeBoatAPI.Tools.Builder:new(rootDirs, outputDir, luaDocsMCPath, luaDocsAddonPath)`;
    return vscode.workspace.findFiles(new vscode.RelativePattern(workspace, "**/*.lua"), "**/{_build,out,.vscode}/**")
        .then((files) => {
        for (let file of files) {
            // turn the relative path into a lua require
            let relativePath = file.fsPath.replaceAll(workspace.fsPath, "");
            //relativePath = relativePath.replaceAll(path.extname(relativePath), "");
            if (relativePath.substr(0, 1) === "\\") // remove initial "." that might be left
             {
                relativePath = relativePath.substr(1);
            }
            let buildLine = isMC ? `_builder:buildMicrocontroller([[${relativePath}]], LifeBoatAPI.Tools.Filepath:new([[${file.fsPath}]]), params)`
                : `_builder:buildAddonScript([[${relativePath}]], LifeBoatAPI.Tools.Filepath:new([[${file.fsPath}]]), params)`;
            content += "\n" + buildLine;
        }
        return content;
    }).then((content) => {
        return utils.doesFileExist(vscode.Uri.file(workspace.fsPath + "/_build/_post_buildactions.lua"), () => content + "\nrequire([[_build._post_buildactions]])", () => content);
    }).then((content) => {
        return utils.doesFileExist(vscode.Uri.file(workspace.fsPath + "/_build/_pre_buildactions.lua"), () => "require([[_build._pre_buildactions]])\n" + content, () => content);
    }).then((content) => content + "\n" + "--- @diagnostic enable: undefined-global\n");
}
function beginBuild(context) {
    let lifeboatapiConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", utils.getCurrentWorkspaceFile());
    let workspace = utils.getCurrentWorkspaceFolder();
    // we build an entire workspace at once, as the majority of the cost is starting up the combiner
    if (workspace) {
        let neloAddonDoc = context.extensionPath + "/assets/nelodocs/docs_missions.lua";
        let neloMCDoc = context.extensionPath + "/assets/nelodocs/docs_vehicles.lua";
        if (lifeboatapiConfig.get("overwriteNeloDocsPath")) {
            neloAddonDoc = lifeboatapiConfig.get("neloAddonDocPath") ?? neloAddonDoc; // if the user screws it up, just use our bundled one
            neloMCDoc = lifeboatapiConfig.get("neloMicrocontrollerDocPath") ?? neloMCDoc;
        }
        let buildLuaFile = vscode.Uri.file(workspace.uri.fsPath + "/_build/_build.lua");
        let outputDir = workspace.uri.fsPath + "/out/";
        let rootDir = workspace.uri.fsPath;
        let path = settingsManagement.getDebugPaths(context);
        path.push(utils.sanitisePath(workspace.uri.fsPath) + "?.lua");
        return generateBuildLua(workspace.uri, utils.isMicrocontrollerProject(), context)
            .then((buildLua) => vscode.workspace.fs.writeFile(buildLuaFile, new util_1.TextEncoder().encode(buildLua))).then(() => {
            let minimizerConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.minimizer", utils.getCurrentWorkspaceFile());
            let config = {
                name: "Build Workspace",
                type: "lua",
                request: "launch",
                program: `${buildLuaFile?.fsPath}`,
                stopOnEntry: false,
                stopOnThreadEntry: false,
                path: path.join(";"),
                cpath: settingsManagement.getDebugCPaths(context).join(";"),
                arg: [
                    neloAddonDoc,
                    neloMCDoc,
                    outputDir,
                    projectCreation.addUserBoilerplate(""),
                    `${minimizerConfig.get("reduceAllWhitespace", true)}`,
                    `${minimizerConfig.get("reduceNewlines", true)}`,
                    `${minimizerConfig.get("removeRedundancies", true)}`,
                    `${minimizerConfig.get("shortenVariables", true)}`,
                    `${minimizerConfig.get("shortenGlobals", true)}`,
                    `${minimizerConfig.get("shortenNumbers", true)}`,
                    `${minimizerConfig.get("forceNCBoilerplate", false)}`,
                    `${minimizerConfig.get("forceBoilerplate", false)}`,
                    `${minimizerConfig.get("shortenStringDuplicates", true)}`,
                    `${minimizerConfig.get("removeComments", true)}`
                ]
            };
            // all remaining args are root paths to load scripts from
            const libPaths = settingsManagement.getLibraryPaths(context);
            for (let dir of libPaths) {
                config.arg.push(dir);
            }
            config.arg.push(rootDir);
            return vscode.debug.startDebugging(workspace, config);
        });
    }
    return Promise.reject();
}
exports.beginBuild = beginBuild;
//# sourceMappingURL=runBuild.js.map