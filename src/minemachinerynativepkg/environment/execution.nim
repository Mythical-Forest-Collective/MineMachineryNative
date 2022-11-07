import std/[
  sequtils,
  strutils,
  strformat,
  os
]

import ../core/machine

var programSearchDirectories*: seq[string]

proc flatListPrograms(m: Machine): seq[string] =
  for path in m.config.programSearchPaths:
    for file in os.walkDirRec(path):
      if file.endsWith(".wasm") or file.endsWith(".wat"):
        result.add file

proc programExists*(m: Machine, programName: string): bool =
  result = false

  if programName in flatListPrograms(m):
    result = true