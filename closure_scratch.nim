import strformat, sugar

proc myService(arg: int, callback: proc (x: int): int): int =
  echo fmt"my service is going to call block({arg})"
  return callback(arg)

proc addTwo*(x: int): int = x + 2
proc addFour*(x: int): int = x + 4

when isMainModule:
  echo fmt"addTwo to 4: {myService(4, addTwo)}"
  echo fmt"addFour to 4: {myService(4, addFour)}"


proc mySugarService(arg: int, callback: (x: int) -> int): int =
  echo fmt"my sugar service is going to call block({arg})"
  return callback(arg)

when isMainModule:
  echo fmt"sugared addTwo to 4: {mySugarService(4, addTwo)}"
  echo fmt"sugared addFour to 4: {mySugarService(4, addFour)}"

# thread about verbose multi-line closures
# https://forum.nim-lang.org/t/6399

proc twice[T](input: T, fn: proc(t: T):T):T =
  fn(fn(input))

# original multi line notation for calling twice
let fourthPower = twice(10, 
  proc(n: int): int =
    echo "Gratuitous echo!"
    return n * n
)

# do notation
let plusTwo = twice(10) do (n:int) -> int:
  echo "Another gratuitious echo"
  n + 1

# sugar statement list expression, last expression treated as the value
let plusTwo2 = twice(10, n => (
  echo "Another gratuitious echo";
  n + 1
))

# sugar block expression 
let plusTwo3 = twice(10, n => (block:
  echo "Another gratuitious echo"
  n + 1
))

when isMainModule:
  echo fourthPower
  echo plusTwo
  echo plusTwo2
  echo plusTwo3

# use templates instead of closures, see twiceIt in template_scratch.nim