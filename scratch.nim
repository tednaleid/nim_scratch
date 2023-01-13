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

echo $doubledLetters
echo $doubledString


import regex_scratch

when isMainModule:
  echo "FooBar".toKebabCase
  echo "foo-bar".toKebabCase
  echo "FooBAR".toKebabCase
  echo "FooBAr".toKebabCase
  echo "BAZqux".toKebabCase
