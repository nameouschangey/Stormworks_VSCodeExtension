import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder, TextDecoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";
import { debug } from 'console';
import { relative } from 'path';
import { Octokit } from '@octokit/rest';
import * as https from 'https';
import { API as GitAPI, GitExtension } from './typings/git'; 
import { TerminalHandler } from './terminal';

export interface GistSetting
{
    relativePath : string,
    gistUrl : string,
    isDirty : boolean,
    gistID : string
}

export function shareSelectedFile(context : vscode.ExtensionContext, file: vscode.Uri)
{
    let selectedFile = file ?? utils.getCurrentWorkspaceFile();
    let selectedFolder = utils.getCurrentWorkspaceFolder();

    if (selectedFile && selectedFolder)
    {
        let relativePath = vscode.workspace.asRelativePath(selectedFile);
        let fileName = path.basename(relativePath);
        return vscode.workspace.fs.readFile(selectedFile).then(
            (fileData) => {
                return new TextDecoder().decode(fileData);
            }
        ).then(
            (fileContents) => {
                let libConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", selectedFolder);
                let existingGists : GistSetting[] = libConfig.get("sharedGistFiles") ?? [];
                for(let gist of existingGists)
                {
                    if(gist.relativePath === relativePath)
                    {
                        if(!gist.isDirty)
                        {
                            vscode.env.clipboard.writeText(gist.gistUrl);
                            return vscode.window.showInformationMessage("Copied " + gist.gistUrl + " to the clipboard for " + relativePath + " ready to share!");
                        }
                        else
                        {
                            return updateGist(libConfig, existingGists, gist, relativePath, fileName, fileContents);
                        }
                    }
                }
        
                // no existing gist found, create a new one
                return createGist(libConfig, existingGists, relativePath, fileName, fileContents);
        });
    }
}

function updateGist(libConfig : vscode.WorkspaceConfiguration, existingGists: GistSetting[], gist: GistSetting, relativePath: string, fileName: string, fileContents: string)
{
    return vscode.authentication.getSession("github", ['gist'], {createIfNone: true})
    .then(
        (session) => {
            if(session)
            {
                // valid github session
                const url = 'https://api.github.com';
                const rejectUnauthorized = true;
                const agent = new https.Agent({ rejectUnauthorized });
                let octokit = new Octokit({ auth: session.accessToken});

                let files : {[name:string] : {content:string}} = {};
                files[fileName] = {content : fileContents};

                let request = {
                    // eslint-disable-next-line @typescript-eslint/naming-convention
                    gist_id : gist.gistID,
                    description : "Stormworks LifeboatAPI - Gist - " + fileName,
                    files : files
                };

                return octokit.gists.update(request).then(
                    (response) => {
                        if ((response.status === 200) && response.data.git_pull_url)
                        {
                            gist.isDirty = false;
                            return libConfig.update("sharedGistFiles", existingGists).then(
                                () => {
                                    vscode.env.clipboard.writeText(response.data.git_pull_url ?? "FATAL ERROR");
                                    return vscode.window.showInformationMessage("Updated gist, link copied to clipboard: " + response.data.git_pull_url + " for " + relativePath + " ready to share!");
                                }
                            );
                        }
                        else
                        {
                            return vscode.window.showWarningMessage("Gist failed to update, HTTP status code: " + response.status);
                        }
                    }
                );
            }
            else
            {
                return vscode.window.showWarningMessage("A github account must be connected in order to update gist's. Please see VSCode user accounts.");
            }
        }
    );
}

function createGist(libConfig : vscode.WorkspaceConfiguration, existingGists: GistSetting[], relativePath: string, fileName: string, fileContents: string)
{
    return vscode.authentication.getSession("github", ['gist'], {createIfNone: true})
    .then(
        (session) => {
            if(session)
            {
                let octokit = new Octokit({ auth: session.accessToken});

                let files : {[name:string] : {content:string}} = {};
                files[fileName] = {content : fileContents};

                let request = {
                    description : "Stormworks LifeboatAPI - Gist - " + fileName,
                    files : files,
                    public : true
                };

                return octokit.gists.create(request).then(
                    (response) => {
                        if ((response.status === 201) && response.data.git_pull_url && response.data.id)
                        {
                            existingGists.push({
                                gistUrl: response.data.git_pull_url,
                                relativePath:relativePath,
                                isDirty: false,
                                gistID: response.data.id});

                            return libConfig.update("sharedGistFiles", existingGists).then(
                                () => {
                                    vscode.env.clipboard.writeText(response.data.git_pull_url ?? "FATAL ERROR");
                                    return vscode.window.showInformationMessage("Created new gist, link copied to clipboard: " + response.data.git_pull_url + " for " + relativePath + " ready to share!");
                                }
                            );
                        }
                        else
                        {
                            return vscode.window.showWarningMessage("Gist failed to create, HTTP status code: " + response.status);
                        }
                    }
                );
            }
            else
            {
                return vscode.window.showWarningMessage("A github account must be connected in order to create gist's. Please see VSCode user accounts.");
            }
        }
    );
}

interface GitLibSetting
{
    name : string,
    gitUrl : string
}

export function addLibraryFromURL(context : vscode.ExtensionContext)
{
    return vscode.window.showInputBox({
        placeHolder : "https//github.com/example_link.git",
        prompt: "Enter the git URL of the library",
        title: "Add Git Library",
        ignoreFocusOut: false})
        .then(
            (url) => {
                if (url) {
                    let workspaceFolder = utils.getCurrentWorkspaceFolder();
                    if (workspaceFolder)
                    {
                        let config = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", workspaceFolder);
                        let gitLibs : GitLibSetting[] = config.get("gitLibraries") ?? [];
                        let urlEnding = path.basename(url, ".git");
                        let urlUser = path.basename(path.dirname(url));

                        let libName = urlEnding;
                        if (!urlUser.includes(".")) {
                            libName = urlUser + "/" + urlEnding;
                        }

                        for(let lib of gitLibs)
                        {
                            if(lib.gitUrl === url)
                            {
                                return vscode.window.showInformationMessage("Library already in project - see settings.json if this is wrong").then();
                            }
                        }

                        let gitExtension = vscode.extensions.getExtension<GitExtension>('vscode.git')?.exports;
                        if (gitExtension)
                        {
                            let gitPath = gitExtension.getAPI(1).git.path;

                            return TerminalHandler.get().awaitTerminal({
                                    cwd: utils.sanitisePath(workspaceFolder?.uri.fsPath ?? "") + "_build/libs/",
                                    shellArgs: ["clone", url, libName],
                                    name: "add library",
                                    hideFromUser: false,
                                    shellPath: gitPath,
                                }).then((terminal) => {
                                    if(terminal.exitStatus?.code === 0)
                                    {
                                        gitLibs.push({ name: libName, gitUrl: url });
                                        return config.update("gitLibraries", gitLibs);
                                    }
                                });
                        }
                    }
                }
            });
}

export function removeSelectedLibrary(context : vscode.ExtensionContext, file: vscode.Uri)
{
    let workspaceFolder = utils.getCurrentWorkspaceFolder();

    let sanitized = utils.sanitisePath(vscode.workspace.asRelativePath(file));
    if (workspaceFolder)
    {
        let config = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", workspaceFolder);
        let gitLibs : GitLibSetting[] = config.get("gitLibraries") ?? [];

        let libsToDelete = [];
        let libsTokeep = [];
        for(let lib of gitLibs)
        {
            if(!sanitized.includes("_build/libs/" + lib.name))
            {
                libsTokeep.push(lib);
            }
            else
            {
                libsToDelete.push(lib);
            }
        }

        let promises = [];
        for(let lib of libsToDelete)
        {
            promises.push(vscode.workspace.fs.delete(vscode.Uri.file(utils.sanitisePath(workspaceFolder.uri.fsPath) + "_build/libs/" + lib.name), {recursive: true, useTrash: false}));
        }
        Promise.all(promises);

        return config.update("gitLibraries", libsTokeep);
    }
}

export function updateLibraries(context: vscode.ExtensionContext) {
    let workspaceFolder = utils.getCurrentWorkspaceFolder();
    let gitExtension = vscode.extensions.getExtension<GitExtension>('vscode.git')?.exports;
    if(gitExtension && workspaceFolder)
    {
        let gitPath = gitExtension.getAPI(1).git.path;
        let config = vscode.workspace.getConfiguration("lifeboatapi.stormworks.libs", workspaceFolder);
        let gitLibs : GitLibSetting[] = config.get("gitLibraries") ?? [];

        let promises = [];
        for(let lib of gitLibs)
        {
            let libPath = utils.sanitisePath(workspaceFolder?.uri.fsPath ?? "") + "_build/libs/" + lib.name;

            let promise = utils.doesFileExist(vscode.Uri.file(libPath), 
                () => {
                    // update latest
                    TerminalHandler.get().awaitTerminal({
                        cwd: libPath,
                        shellArgs: ["pull"],
                        name: "update libraries",
                        hideFromUser: false,
                        shellPath: gitPath,
                    });
                },
                () => {
                    TerminalHandler.get().awaitTerminal({
                        cwd: utils.sanitisePath(workspaceFolder?.uri.fsPath ?? "") + "_build/libs/",
                        shellArgs: ["clone", lib.gitUrl, lib.name],
                        name: "clone missing lib",
                        hideFromUser: false,
                        shellPath: gitPath,
                    });
                });

            promises.push(promise);
        }

        return Promise.all(promises);
    }
}