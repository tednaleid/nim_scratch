import sequtils, strformat


const
    ScreenWidth = 1024
    ScreenHeight = 768

type
    Point = object
        x: int
        y: int


template boundsCheck(p: Point) =
    if p.x < 0 or p.x >= ScreenWidth or
       p.y < 0 or p.y >= ScreenHeight:
      return

proc safePutPixel(p: Point) =
    boundsCheck(p)
    echo fmt"safe: {p}"

safePutPixel(Point(x: 3, y: 10))


# you can pass a body in as `untyped` and get it inserted in the template
template wrap(body: untyped) =
    echo "before"
    body
    echo "after"

wrap:
    echo "between"


# use templates instead of closures 
# from: https://forum.nim-lang.org/t/6399
# (alternate closure versions in closure_scratch)
template twiceIt(input, body: untyped): untyped =
  type T = typeof(input)
  let fn = proc(n: T): T =
    let it {.inject.} = n
    `body`
  fn(fn(input))

let y1 = twiceIt 10:
  echo "Gratuitous echo!"
  return it * it
echo y1

let y2 = twiceIt(10, it*it)
echo y2

# or let the caller specify the variable name
template twiceT(input, name, body: untyped): untyped =
  type T = typeof(input)
  let fn = proc(n: T): T =
    let `name` {.inject.} = n
    `body`
  fn(fn(input))

let y3 = twiceT(10, n):
  echo "Gratuitous echo!"
  return n * n
echo y3


template t(body: untyped) =
  proc p = echo "hey"
  block:
    body

t:
  p() 



var observed: seq[string] = @[]

let ip = proc(value: string): int =
  observed.add(value)
  result = 0

echo ip("foo") == 0
echo observed[0] == "foo"

# template version of ^^ 

var observed2: seq[string] = @[]

template inlineProc(obs: untyped): untyped =
  (proc(value: string): int =
    obs.add(value)
    result = 0)

let ip2 = inlineProc(observed2)

echo ip2("bar") == 0
echo observed2[0] == "bar"



type MyContext* = ref object
  sayHello*: proc(context: MyContext, name: string): string

proc defaultSayHello(context: MyContext, name: string): string = "hello " & name

proc buildContext( 
  sayHello: proc(context: MyContext, name: string): string = defaultSayHello): 
  MyContext = MyContext(sayHello: sayHello)

let context1 = buildContext()

assert context1.sayHello(context1, "world") == "hello world"

proc testHello(): bool =
  var observed: seq[string] = @[]
  let observedHello = (proc(context: MyContext, name: string): string =
    observed.add(name)
    result = defaultSayHello(context, name))

  var context = buildContext(observedHello)

  assert context.sayHello(context1, "boo-urns") == "hello boo-urns"
  assert observed[0] == "boo-urns"
  result = true

echo testHello()

template observeName(obs: seq[string]): proc(context: MyContext, name: string): string =
  (proc(context: MyContext, name: string): string =
    obs.add(name)
    result = defaultSayHello(context, name)
  )
  

proc testHello2(): bool =
  var observed: seq[string] = @[]
  let observedHello = observeName(observed)
  var context = buildContext(observedHello)

  assert context.sayHello(context1, "burns") == "hello burns"
  assert observed[0] == "burns"
  result = true

echo testHello2()

