# Stormworks Lua with LifeBoatAPI

An extension to provide proper build processes to the Stormworks community.
Current modding efforts are significantly limited by use of improper tooling (such as the ingame editor)
This extension aims to provide a clear, professional-level, build toolset to solve this.

Key Features:
- Do you hate trying to figure out why a certain value is wrong in a calculation?
- Do you hate writing all your code in one big, disorganised file?
- Do you hate the 4000 character limit?
- Do you wish you could make well-structured code libraries, and use that code on multiple projects without copy/pasting?

LifeBoatAPI solves these by providing:
- An extremely powerful Minimizer, that can remove redudant code and shrink files massively
- A Combiner, that can trace the "require(...)" keyword so you can write code across multiple files
- A full Debugger that can show you the memory values of your Microcontroller
- A Simulator that support multiple screens simultaneously
- Full type hinting and error checking to avoid typos
- A solid library of code, the LifeBoatAPI, to simplify writing Stormworks code.

Developed by Nameous Changey: https://github.com/nameouschangey
With integrated lua-docs from 'Nelo: https://github.com/Rene-Sackers/StormworksLuaDocsGen

## Features


Describe specific features of your extension including screenshots of your extension in action. Image paths are relative to this README file.

For example if there is an image subfolder under your extension project workspace:

\!\[feature X\]\(images/feature-x.png\)

> Tip: Many popular extensions utilize animations. This is an excellent way to show off your extension! We recommend short, focused animations that are easy to follow.

## Requirements

The LifeBoatAPI simulator was written for Windows, unfortunately as Nameous Changey has no access to a Mac - this is unlikely to change in the near future; unless there is significant demand for it to be ported.

All other requirements are installed automatically with this extension:
Lua by sumneko
Lua-Debug by actboy168

## Extension Settings

Include if your extension adds any VS Code settings through the `contributes.configuration` extension point.

For example:

This extension contributes the following settings:

* `myExtension.enable`: enable/disable this extension
* `myExtension.thing`: set to `blah` to do something


### 1.0.0

Initial release