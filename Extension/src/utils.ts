import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings } from 'cluster';

declare global
{
	interface String {
		replaceAll(searchValue: string | RegExp, replacement: string): string;
	}
}

String.prototype.replaceAll = function (searchValue: string | RegExp, replacement: string)
{
	let current = String(this);
	let changed = String(this);
	do 
	{
		current = changed;
		changed = current.replace(searchValue, replacement);
	}
	while(current !== changed);

	return current;
};

export function relativePath(file: vscode.Uri)
{
	let folder = getContainingFolder(file);
	if(folder)
	{
		let fileSanitized = sanitizeFilePath(file.fsPath);
		let folderSanitized = sanitizeFolderPath(folder.uri.fsPath);

		let relative = sanitizeFolderPath(fileSanitized.replace(folderSanitized, ""));
		return relative;
	}

	// is not a child of any of the workspace folders
	return undefined;
}

export function getContainingFolder(file: vscode.Uri)
{
	return vscode.workspace.getWorkspaceFolder(file);
}

export function ensureBuildFolderExists(folder : vscode.WorkspaceFolder | undefined)
{
	return vscode.workspace.fs.createDirectory(vscode.Uri.file(sanitizeFolderPath(folder?.uri.fsPath ?? "") + "_build/libs/"));
}

export function sanitizeFolderPath(resourcePath : string)
{
	resourcePath = resourcePath.replaceAll("\\", "/");
	if(resourcePath.charAt(resourcePath. length-1) !== "/")
	{
		return resourcePath + "/";
	}
	return resourcePath;
}

export function sanitizeFilePath(resourcePath : string)
{
	resourcePath = resourcePath.replaceAll("\\", "/");
	return resourcePath;
}

export function getCurrentWorkspaceFile() {
	return vscode.window.activeTextEditor?.document.uri;
}

export function getCurrentWorkspaceFolder()
{
	const currentFile = getCurrentWorkspaceFile();
	if(currentFile)
	{
		return vscode.workspace.getWorkspaceFolder(currentFile);
	}
	return undefined;
}

export function isMicrocontrollerProject(folder: vscode.WorkspaceFolder | undefined) : boolean
{
	if (folder)
	{
		let lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", folder);
		return lifeboatConfig.get("isMicrocontrollerProject") ?? false;
	}
	return false;
}

export function isStormworksProject(folder: vscode.WorkspaceFolder | undefined) {
	if (folder)
	{
		let lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", folder);
		return lifeboatConfig.get("isAddonProject") || lifeboatConfig.get("isMicrocontrollerProject");
	}
	return false;
}

export function doesFileExist<T, U>(path : vscode.Uri, onExists: () => Thenable<T>|T, onNotExist: () => Thenable<U>|U) : Thenable<T> | Thenable<U>
{
	return vscode.workspace.fs.stat(path)
		.then(
			() => {
				return onExists();
			},
			(err) => {
				return onNotExist();
			}
	);
}