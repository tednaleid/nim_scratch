import strutils, tables

type
  NumberEnum = enum
    One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Eleven, Twelve,
    Thireen, Fourteen, Fifteen, Sixteen, Seventeen, Eighteen, Nineteen, Twenty
  AlphaEnum = enum
    Alpha, Bravo, Charlie, Delta, Echo, Foxtrot, Golf, Hotel, India, Juliet,
    Kilo, Lima, Mike, November, Oscar, Papa, Quebec, Romeo, Sierra, Tango, 
    Uniform, Victor, Whiskey, Xray, Yankee, Zulu
  MatchResultKind = enum
    None, Single, Multi
  MatchResult[T] = ref object
    case kind: MatchResultKind
      of None: nil
      of Single: value: T
      of Multi: values: seq[T]

proc `$`(matchResult: MatchResult): string =
  result = case matchResult.kind
    of None: "None"
    of Single: $matchResult.value
    of Multi: $matchResult.values

proc prefixTable(): Table[string, seq[NumberEnum]] =
  for e in NumberEnum:
    let normalized = ($e).toLower
    for i in (0..<normalized.len):
      let substr = normalized[0 .. i]
      result[substr]= result.mgetOrPut(substr, @[]) & e

let numbersForPrefix = prefixTable()

proc prefixTable[T: enum](enumType: typedesc[T]): Table[string, seq[T]] =
  for e in enumType:
    let normalized = ($e).toLower
    for i in (0..<normalized.len):
      let substr = normalized[0 .. i]
      result[substr] = result.mgetOrPut(substr, @[]) & e

proc find[T](lookup: Table[string, seq[T]], pattern: string): MatchResult[T] =
  let match:seq[T] = lookup.getOrDefault(pattern, @[])

  return case match.len:
    of 0: MatchResult[T](kind: None)
    of 1: MatchResult[T](kind: Single, value: match[0])
    else: MatchResult[T](kind: Multi, values: match)

when isMainModule:
  var numberLookup = prefixTable(NumberEnum)

  echo numberLookup.find("one")
  echo numberLookup.find("o")
  echo numberLookup.find("t")
  echo numberLookup.find("tw")
  echo numberLookup.find("two")

  var alphaLookup = prefixTable(AlphaEnum)
  echo alphaLookup.find("c")
  echo alphaLookup.find("f")
  