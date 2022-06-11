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

interface GistSetting
{
    relativePath : string,
    gistUrl : string
}

export function shareSelectedFile(context : vscode.ExtensionContext)
{
    let selectedFile = utils.getCurrentWorkspaceFile();
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
                        vscode.env.clipboard.writeText(gist.gistUrl);
                        return vscode.window.showInformationMessage("Copied " + gist.gistUrl + " to the clipboard for " + relativePath + " ready to share!");
                    }
                }
        
                // no existing gist found, create a new one
                return vscode.authentication.getSession("github", ['gist'], {createIfNone: true})
                .then(
                    (session) => {
                        if(session)
                        {
                            // valid github session
                            const url = 'https://api.github.com';
                            const rejectUnauthorized = true;
                            const agent = new https.Agent({ rejectUnauthorized });
                            const config = { baseUrl: url, agent };
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
                                    if ((response.status === 201 || response.status === 202) && response.data.git_pull_url)
                                    {
                                        existingGists.push({gistUrl: response.data.git_pull_url, relativePath:relativePath});
                                        return libConfig.update("sharedGistFiles", existingGists).then(
                                            () => {
                                                vscode.env.clipboard.writeText(response.data.git_pull_url ?? "FATAL ERROR");
                                                return vscode.window.showInformationMessage("Created new gist, copied to clipboard: " + response.data.git_pull_url + " to the clipboard for " + relativePath + " ready to share!");
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
        });
    }
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