
import std/sha1, strutils

proc hashLine(line: string) =
  let pieces = line.split(" ", 1) 
  echo pieces[0] & " " & $secureHash(pieces[1])

proc hashFileLines(file: File) =
  var line: string = ""
  while file.readLine(line):
    hashLine(line)

when isMainModule:
  hashFileLines(stdin)