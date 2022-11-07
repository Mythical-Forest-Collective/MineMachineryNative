import wasm3

type Command* = distinct string

type
  EventBase = ref object of RootObj

  CommandRecieveEvent = ref object of EventBase
    command*: Command


type MachineConfig* = object
  programSearchPaths*: seq[string] # ~ All the paths to search in to find a program
  maxBytes*: int32 # ~ The maximum amount of bytes (should it be changed to bytes?) a machine can have

# ~ Basic new function
proc new(_: typedesc[MachineConfig], programSearchPath: seq[string]= @["programs"],
maxBytes:int32=4194304): MachineConfig =
  result.programSearchPath = programSearchPath
  result.maxBytes = maxBytes

type Machine* = object
  config*: MachineConfig
  hostProcs: seq[WasmHostProc] # ~ A field that should only be used for internal usage
  # commandQueue: seq[Command] # ? Look at a better name for this, work on a minimal event API that is integer
  # ? based, so interop with WASM and the host is easy.
  env: WasmEnv # ~ The WASM execution environment for a machine
  id: int32 # ~ WASM is 32 based (wasm32) so use int32, the ID is read only too
  label*: string # ~ The name/label for a machine, by default this should be the ID prefixed by `machine_`

proc new(_: typedesc[Machine], config: MachineConfig=MachineConfig.new()): Machine =
  result = Machine()

proc id*(m: Machine): int32 = m.id # ~ a getter for the ID



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