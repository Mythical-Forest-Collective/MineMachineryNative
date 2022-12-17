import std/[
  importutils
]

import wasm3
import wasm3/wasm3c

import ../core/machine

proc registerMineApi*(m: var Machine) =
  privateAccess(Machine)

  block: # ~ IO-related operations
    proc file_write(runtime: PRuntime; ctx: PImportContext; sp: ptr uint64; mem: pointer): pointer {.cdecl.} =
      proc (a: cstring): int32 =
        return a * b

      callWasm(doStuff, sp, mem)

    m.hostProcs.add wasmHostProc("minemachine", "file_write", "", )