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

export function sanitisePath(path : string)
{
	path = path.replaceAll("\\", "/");
	if(path.charAt(path. length-1) !== "/")
	{
		return path + "/";
	}
	return path;
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

export function isMicrocontrollerProject() : boolean
{
	if(getCurrentWorkspaceFile())
	{
		var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", getCurrentWorkspaceFile());
		return lifeboatConfig.get("isMicrocontrollerProject") ?? false;
	}
	else
	{
		return false;
	}
}

export function isStormworksProject() {
	if(getCurrentWorkspaceFile())
	{
		var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", getCurrentWorkspaceFile());
		return lifeboatConfig.get("isAddonProject") || lifeboatConfig.get("isMicrocontrollerProject");
	}
	else
	{
		return false;
	}
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