import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder, TextDecoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";
import { debug } from 'console';
import { relative } from 'path';
import { Octokit, RestEndpointMethodTypes } from '@octokit/rest';
import * as https from 'https';

//class GistsService {
//
//  
//    public delete(
//      params: RestEndpointMethodTypes['gists']['delete']['parameters']
//    ) {
//      return this.octokit.gists.delete(params);
//    }
//  
//    public get(params: RestEndpointMethodTypes['gists']['get']['parameters']) {
//      return this.octokit.gists.get(params);
//    }
//  
//    public list(params?: RestEndpointMethodTypes['gists']['list']['parameters']) {
//      return this.octokit.gists.list(params);
//    }
//  
//    public listStarred(
//      params?: RestEndpointMethodTypes['gists']['listStarred']['parameters']
//    ) {
//      return this.octokit.gists.listStarred(params);
//    }
//  
//    public update(
//      params: RestEndpointMethodTypes['gists']['update']['parameters']
//    ) {
//      return this.octokit.gists.update(params);
//    }
//  }
//  
//  export const gists = GistsService.getInstance();

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


function shareRepository(context : vscode.ExtensionContext)
{
}

export function removeSelectedLibrary(context : vscode.ExtensionContext)
{
}

export function addLibraryFromURL(context : vscode.ExtensionContext)
{
    // 
}

export function updateLibraries(context: vscode.ExtensionContext) {

}