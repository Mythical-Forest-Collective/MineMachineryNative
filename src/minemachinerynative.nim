import minemachinerynativepkg/core/[
  machine
]

import minemachinerynativepkg/environment/[
  execution,
  wasi
]

import std/[
  importutils
]

import wasm3
import wasm3/wasm3c


when isMainModule:
  echo("Running as main module!")

  var m = Machine.new()
  m.initHostWasiMethods()
  m.createWasmEnvironment()

  privateAccess(m.type)
  m.env.findFunction("_start").call(WasmVal.i32)