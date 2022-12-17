import strutils, sequtils, sugar

let contents = readFile("input/test.txt")
echo contents

let people = contents.splitLines()
echo people

for line in lines "input/test.txt":
  echo line

let doubledtransformer = proc(str: string): string = str & str
let letters = @["f", "o", "o", "bar"]

let doubledLetters = letters.map(doubledtransformer)

let doubledString = letters.map(x => x & x).foldl(a & b, "")

log $doubledLetters
log $doubledString