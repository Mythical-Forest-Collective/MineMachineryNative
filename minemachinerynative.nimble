# Package

version       = "0.1.0"
author        = "Technisha"
description   = "MineMachineryNative will be the core of our Java mod, MineMachine, a WebAssembly-based alternative to ComputerCraft! This repo will also include a standalone application to run MineMachine on! Java will mainly be for bootstrapping and interacting with the Minecraft world, so will not be included in this repo!"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["minemachinerynative"]


# Dependencies
requires "nim >= 1.6.8"
requires "https://github.com/beef331/micros"