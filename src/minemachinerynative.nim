import minemachinerynativepkg/environment/[
  execution,
  wasi
]

import wasm3 #
import wasm3/wasm3c


when isMainModule:
  import os

  programSearchDirectories.add "programs"

  echo("Running as main module!")
  if paramCount() != 1:
    quit("We only accept one program name!", 1)

  let programPath = lookupProgram(paramStr(1))

  #echo env.findFunction("_start").call(WasmVal.i32)