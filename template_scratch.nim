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