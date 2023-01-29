import sequtils, sugar, nre

let splitConfigsRegex = re"""([^=,]+)=([^=]+)(,|$)"""

iterator parseConfig*(config: string): tuple[key: string, value: string] =
  for match in config.findIter(splitConfigsRegex):
    let captures = match.captures
    yield (key: captures[0], value: captures[1])


let pairs = "one=two,foo=bar,baz,qux=wibble".parseConfig.toSeq
echo $pairs
   