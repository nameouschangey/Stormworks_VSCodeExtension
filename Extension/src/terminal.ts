import * as vscode from 'vscode';
import * as path from 'path';
import { Func } from 'mocha';
import { TextEncoder } from 'util';
import { settings } from 'cluster';
import * as utils from "./utils";
import { debug } from 'console';

export class TerminalHandler
{
    private static instance : TerminalHandler;
    private runningProcesses : Map<string, (value: vscode.Terminal|PromiseLike<vscode.Terminal>)=>void> = new Map();

    public static get() {
        if (!this.instance) {
            this.instance = new TerminalHandler();
        } 
        return this.instance;
    };

    public onTerminalClosed(terminal : vscode.Terminal) {
        let promiseTrigger = this.runningProcesses.get(terminal.name);
        if (promiseTrigger) 
        {
            promiseTrigger(terminal);
        }
    }

    public awaitTerminal(terminalOptions : vscode.TerminalOptions) {
        let terminal = vscode.window.createTerminal(terminalOptions);
        terminal.show();

        if(terminal.exitStatus === undefined)
        {
            let promise = new Promise<vscode.Terminal>((resolve) => {
                this.runningProcesses.set(terminal.name, resolve);
            });
            return promise;
        }
        else
        {
            return Promise.resolve(terminal);
        }
        
    }

    private constructor() {
    };
}