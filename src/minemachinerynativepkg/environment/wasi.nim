# TODO: At a later point:
# TODO: Make a macro pragma to make it easier to define WASM functions

import std/[
  importutils
]

import ../core/machine

import wasm3
import wasm3/wasm3c

type Iovec = object
  buf, buf_len: uint32

proc len(i: Iovec): uint32 = i.buf_len

proc readIovec(sp: ptr uint64): Iovec =
  var sp = cast[uint64](sp)
  let res = cast[ptr int32](sp)
  sp += sizeof(int)
  var leftVal = cast[ptr int32](sp)
  sp += sizeof(int)
  var rightVal = cast[ptr int32](sp)
  res[] = leftVal + rightVal

proc initHostWasiMethods*(m: var Machine) =
  privateAccess(m.type)

  proc wasiExit(runtime: PRuntime, ctx: PImportContext, sp: ptr uint64, mem: pointer): pointer {.cdecl.} =
    proc proc_exit(exitCode: uint32): void =
      echo exitCode

    callWasm(proc_exit, sp, mem)

  proc wasiFdWrite(runtime: PRuntime, ctx: PImportContext, sp: ptr uint64, mem: pointer): pointer {.cdecl.} =
    proc fd_write(fd: uint32, iovs: pointer, iovsLen: uint32, nwritten: ptr uint32): uint32 =
      
      return 1

    callWasm(fd_write, sp, mem)

  m.hostProcs.add wasmHostProc("wasi_snapshot_preview1", "proc_exit", "v(i)", wasiExit)
  m.hostProcs.add wasmHostProc("wasi_snapshot_preview1", "fd_write", "i(i*i*)", wasiFdWrite)