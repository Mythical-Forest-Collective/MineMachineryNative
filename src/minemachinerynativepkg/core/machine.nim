import wasm3

const WASM_SHELL_PROGRAM = staticRead("../../programs/wasi/helloworld.wasm")

var highestId: uint32 = 0

type MachineConfig* = object
  maxRam*: uint32 # ~ The maximum amount of RAM a machine can have
  maxDiskSize*: uint32 # ~ The maximum amount of storage a machine can use


# ~ Basic new config function
# ~ Default RAM is 4MB, likely won't change.
# ~ 
proc new*(_: typedesc[MachineConfig], maxRamInBytes:uint32=4194304, maxDiskSizeInKb:uint32=5120): MachineConfig =
  result.maxRam = maxRamInBytes
  result.maxDiskSize = maxDiskSizeInKb

const globalMachineConfig = MachineConfig.new()

type Machine* = object
  config*: MachineConfig
  hostProcs: seq[WasmHostProc] # ~ A field that should only be used for internal usage
  env: WasmEnv # ~ The WASM execution environment for a machine
  id: uint32 # ~ WASM is 32 based (wasm32) so use uint32, the ID is read only too
  label*: string # ~ The name/label for a machine, by default this should be the ID prefixed by `machine_`

proc id*(m: Machine): uint32 = m.id # ~ a getter for the ID


# ~ Our function to create a new Machine
proc new*(_: typedesc[Machine], config: MachineConfig=globalMachineConfig, id:uint32=highestId+1): Machine =
  result = Machine()
  result.hostProcs = newSeq[WasmHostProc]()
  result.config = config
  result.id = id

  highestId = id


proc initialiseWasmEnvironment*(m: var Machine) =
  m.env = loadWasmEnv(WASM_SHELL_PROGRAM, stackSize=m.config.maxRam, hostProcs=m.hostProcs)

# An alias for the non-brits in the world :p
template initializeWasmEnvironment*(m: var Machine) = initialiseWasmEnvironment(m)
