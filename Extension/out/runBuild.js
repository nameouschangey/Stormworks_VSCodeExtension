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

require("LifeBoatAPI.Tools.Builder.LBBuilder")

local luaDocsAddonPath = LBFilepath:new(arg[1]);
local luaDocsMCPath = LBFilepath:new(arg[2]);
local outputDir = LBFilepath:new(arg[3]);
local params = {boilerPlate = arg[4]};
local rootDirs = {};

for i=5, #arg do
    table.insert(rootDirs, LBFilepath:new(arg[i]));
end

local _builder = LBBuilder:new(rootDirs, outputDir, luaDocsMCPath, luaDocsAddonPath)`;
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
            let buildLine = isMC ? `_builder:buildMicrocontroller([[${relativePath}]], LBFilepath:new([[${file.fsPath}]]), params)`
                : `_builder:buildAddonScript([[${relativePath}]], LBFilepath:new([[${file.fsPath}]]), params)`;
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
                    projectCreation.addUserBoilerplate("")
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