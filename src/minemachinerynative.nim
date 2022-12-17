import minemachinerynativepkg/core/[
  machine
]

#[
import minemachinerynativepkg/environment/[
  execution
]
]#

import std/[
  importutils
]

import wasm3
import wasm3/wasm3c


when isMainModule:
  echo("Running as main module!")

  var m = Machine.new()
  m.initialiseWasmEnvironment()

  privateAccess(m.type)
  discard m.env.findFunction("main").call(WasmVal.i32)