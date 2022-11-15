import wasm3

type Command* = distinct string

type
  EventBase = ref object of RootObj

  CommandRecieveEvent = ref object of EventBase
    command*: Command

const WASM_SHELL_PROGRAM = staticRead("../../programs/helloworld.wasm")

var HIGHEST_ID: uint32 = 0

type MachineConfig* = object
  programSearchPaths*: seq[string] # ~ All the paths to search in to find a program
  maxBytes*: uint32 # ~ The maximum amount of bytes a machine can have

# ~ Basic new config function
proc new*(_: typedesc[MachineConfig], programSearchPaths: seq[string]=newSeq[string](0),
maxBytes:uint32=4194304): MachineConfig =
  result.programSearchPaths = programSearchPaths
  result.maxBytes = maxBytes

let globalMachineConfig = MachineConfig.new()

type Machine* = object
  config*: MachineConfig
  hostProcs: seq[WasmHostProc] # ~ A field that should only be used for internal usage
  # commandQueue: seq[Command] # ? Look at a better name for this, work on a minimal event API that is integer
  # ? based, so interop with WASM and the host is easy.
  env: WasmEnv # ~ The WASM execution environment for a machine
  id: uint32 # ~ WASM is 32 based (wasm32) so use uint32, the ID is read only too
  label*: string # ~ The name/label for a machine, by default this should be the ID prefixed by `machine_`

proc id*(m: Machine): uint32 = m.id # ~ a getter for the ID

# ~ Our function to create a new Machine
proc new*(_: typedesc[Machine], config: MachineConfig=globalMachineConfig, id:uint32=HIGHEST_ID+1): Machine =
  result = Machine()
  result.hostProcs = newSeq[WasmHostProc]()
  result.config = config
  result.id = id

proc createWasmEnvironment*(m: var Machine) =
  m.env = loadWasmEnv(WASM_SHELL_PROGRAM, stackSize=m.config.maxBytes, hostProcs=m.hostProcs)



#[
#! BEGIN PSEUDOCODE
var COMMAND_RECIEVE: seq[proc(event: CommandRecieveEvent)] #! When converted, move field to `Machine` 

proc sendCommand(m: Machine, command: Command) = # ? maybe convert to string?
  let c = doCommandProcessing(m, command) # TODO: Replace this with actual code :P
  if c.success # TODO again pseudocode that doesnt exist
  for i in COMMAND_RECIEVE: #! When converted, change to m.COMMAND_RECIEVE
    let event = CommandRecieveEvent(command: command) 
    i(event) # ~ "In theory, this works, in reality, you've got no god damn clue" - Clova, 2022
  

#! END PSEUDOCODE
]#