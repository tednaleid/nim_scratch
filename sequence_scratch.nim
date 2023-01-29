import std/[times, monotimes]
let start = getMonoTime()
var myData = newSeq[int](1_000 + 1)
for x in 1..1_000:
  myData[x] = x * x

echo getMonoTime() - start

var mySeq: seq[string] = @[]
mySeq.add("foo")
echo mySeq


# get the last value from a seq

echo "last"
echo @[1, 2, 3][^1]