import nre

let input = """
Metadata for all topics (from broker 1: esque-kafka:9092/1):
 1 brokers:
  broker 1 at esque-kafka:9092 (controller)
 4 topics:
  topic "ten-partitions-lz4" with 1 partitions:
    partition 0, leader 1, replicas: 1, isrs: 1
  topic "testtopic" with 1 partitions:
    partition 0, leader 1, replicas: 1, isrs: 1
  topic "ten-partitions-snappy" with 10 partitions:
    partition 0, leader 1, replicas: 1, isrs: 1
    partition 1, leader 1, replicas: 1, isrs: 1
"""

let topicRegex = re"""topic "(.*)" with (\d+) partitions:"""

proc findTopics(inString: string) =
  for a in inString.findIter(topicRegex): 
    echo a.match
    echo a.matchBounds
    echo a.captureBounds.toSeq
    echo a.captures.toSeq
    echo typeof a.captures
    echo a.captures.toSeq[0].get
    echo a.captures.toSeq[1].get



when isMainModule:
  input.findTopics

  echo "this shouldn't have any output as it won't match:"
  "shouldn't match".findTopics