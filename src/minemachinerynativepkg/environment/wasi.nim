# TODO: At a later point:
# TODO: Make a macro pragma to make it easier to define WASM functions

import std/[
  importutils
]

import ../core/machine

import wasm3
import wasm3/wasm3c

proc initHostWasiMethods(m: var Machine) =
  privateAccess(m.type)

  proc wasiExit(runtime: PRuntime; ctx: PImportContext; sp: ptr uint64; mem: pointer): pointer {.cdecl.} =
    proc proc_exit(exitCode: int32): void =
      echo exitCode

    callWasm(proc_exit, sp, mem)

  m.hostProcs.add wasmHostProc("wasi_snapshot_preview1", "proc_exit", "v(i)", wasiExit)