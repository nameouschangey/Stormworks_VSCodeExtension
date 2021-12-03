import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings } from 'cluster';

export function getCurrentWorkspaceFile() {
	return vscode.window.activeTextEditor?.document.uri;
}

export function getCurrentWorkspaceFolder() {
	const currentFile = getCurrentWorkspaceFile();
	if(currentFile)
	{
		return vscode.workspace.getWorkspaceFolder(currentFile);
	}
	return undefined;
}

export function isMicrocontrollerProject() {
	if(getCurrentWorkspaceFile())
	{
		var lifeboatConfig = vscode.workspace.getConfiguration("lifeboatapi.stormworks", getCurrentWorkspaceFile());
		return lifeboatConfig.get("isMicrocontrollerProject");
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