import os, osproc

var command = ""

let args = commandLineParams()

if args.len() == 1:
    command = args[0]

proc log(msg: string) =
    stderr.write(msg & "\n")

("running: " & command).log

let returnCode = execCmd(command)

log "returnCode: " & $returnCode

# let outputAndExitCode = execCmdEx(command)

# log "outputAndExitCode: " & $outputAndExitCode
# log "output: " & outputAndExitCode.output
# log "exit code: " & $outputAndExitCode.exitCode

const opts = {poUsePath, poDaemon, poEchoCmd}

# var p: Process = startProcess("cat", "", ["shell_scratch.nim"], nil, opts)
var p: Process = startProcess("./input/slow.sh", "", ["3"], nil, opts)

var i = 0
for line in p.lines:
    i.inc
    echo $i & " -> " & line
    if i >= 5: break

# returns -1 if this hasn't exited yet
echo "exit code: " & $p.peekExitCode
p.close
