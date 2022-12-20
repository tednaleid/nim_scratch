# from https://www.reddit.com/r/nim/comments/8fi5ce/comment/dy3rg26/
import os, random, strutils, terminal

randomize() # Initializes the RNG with a new seed each run
hideCursor() # Hides the cursor during runtime

var target, output: string

if paramCount() >= 1:
    target = paramStr(1)
else:
    target = "Hello, world"
output = spaces(target.len)

for i, x in target:
    while x != output[i]:
        output[i] = chr(rand(32..126))
        eraseLine() # Instead of writing a bunch of new lines, we can just write to the same line repeatedly
        stdout.write(output)
        stdout.flushFile() # Force writing to console every iteration
        sleep(3)
showCursor()
echo() # Adds a new line at the end of program execution to keep the terminal tidy
