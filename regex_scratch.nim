# import nre, strutils

# let input = """
# Metadata for all topics (from broker 1: esque-kafka:9092/1):
#  1 brokers:
#   broker 1 at esque-kafka:9092 (controller)
#  4 topics:
#   topic "ten-partitions-lz4" with 1 partitions:
#     partition 0, leader 1, replicas: 1, isrs: 1
#   topic "testtopic" with 1 partitions:
#     partition 0, leader 1, replicas: 1, isrs: 1
#   topic "ten-partitions-snappy" with 10 partitions:
#     partition 0, leader 1, replicas: 1, isrs: 1
#     partition 1, leader 1, replicas: 1, isrs: 1
# """

# let topicRegex = re"""topic "(.*)" with (\d+) partitions:"""

# proc findTopics(inString: string) =
#   for a in inString.findIter(topicRegex): 
#     echo a.match
#     echo a.matchBounds
#     echo a.captureBounds.toSeq
#     echo a.captures.toSeq
#     echo typeof a.captures
#     echo a.captures.toSeq[0].get
#     echo a.captures.toSeq[1].get

# when isMainModule:
#   input.findTopics

#   echo "this shouldn't have any output as it won't match:"
#   "shouldn't match".findTopics


import nre, strutils 

proc toKebabCase*(orig: string): string =
  result = orig.replace(re"([a-z0–9])([A-Z])", 
    proc(match: RegexMatch): string = 
      return match.captures[0] & "-" & match.captures[1]
  ).toLower


when isMainModule:
  echo "FooBar".toKebabCase
  echo "foo-bar".toKebabCase
  echo "FooBAR".toKebabCase
  echo "FooBAr".toKebabCase
  echo "BAZqux".toKebabCase


proc regexGroupValue(match: Option[RegexMatch], group: int): string =
  result = ""
  if match.isSome:
    let captures = match.get.captures.toSeq
    let groupOption = captures[group]
    if groupOption.isSome:
      result = groupOption.get

let splitTopicFromPartitionRegex = re"""(.+)-([^-]+)"""

proc splitTopicFromPartition*(topicPartition: string): tuple[topic: string, partition: int] =
  let found = topicPartition.find(splitTopicFromPartitionRegex)
  result = (topic: found.regexGroupValue(0), partition: found.regexGroupValue(1).parseInt)

when isMainModule:
  echo "foo-bar-16".splitTopicFromPartition
