import strformat, strutils

# create an iterator that will open a file, iterate over the lines and yield each, then close it
# emulating what file.readLines does more explicitly here
iterator fileLines(fileName: string): string =
    let file = open("input/test.txt")
    defer: file.close()

    while not file.endOfFile:
        yield file.readLine()

var wordCount = 0
for line in "input/test.txt".fileLines:
    wordCount += line.split(" ").len

echo fmt"file words: {wordCount}"
