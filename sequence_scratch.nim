import std/[times, monotimes]
let start = getMonoTime()
var myData = newSeq[int](1_000_000_000 + 1)
for x in 1..1_000_000_000:
  myData[x] = x * x

echo getMonoTime() - start
