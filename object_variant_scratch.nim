import math

# from: https://www.youtube.com/watch?v=Q4bAgoeU8SI
type
  ShapeKind = enum
    Circle, Square
  Shape = object
    color: string
    case kind: ShapeKind
    of Circle:
      radius: float
    of Square:
      length: float

let redCircle = Shape(color: "red", kind: Circle, radius: 9.0)
let blueSquare = Shape(color: "blue", kind: Square, length: 16.0)

let shapes = @[redCircle, blueSquare]

echo shapes

func calcArea(shape: Shape): float =
  case shape.kind
  of Circle:
    result = Pi * shape.radius^2
  of Square:
    result = shape.length^2

echo redCircle.calcArea
echo blueSquare.calcArea

func `==`(shape1, shape2: Shape): bool =
  if shape1.kind != shape2.kind or shape1.color != shape2.color: return false
  case shape1.kind:
  of Circle: result = shape1.radius == shape2.radius
  of Square: result = shape1.length == shape2.length

echo redCircle == blueSquare
echo redCircle == redCircle


# from Mastering Nim p89
type
  NodeKind = enum
    nkInt,
    nkFloat,
    nkString,
    nkAdd,
    nkSub,
    nkIf
  Node = ref NodeObj
  NodeObj = object
    case kind: NodeKind
    of nkInt: intVal: int
    of nkFloat: floatVal: float
    of nkString: strVal: string
    of nkAdd, nkSub:
      leftOp, rightOp: Node
    of nkIf:
      condition, thenPart, elsePart: Node

var n = Node(kind: nkIf, condition: nil)

n.thenPart = Node(kind: nkFloat, floatVal: 2.0)

# invalid as it knows that this isn't an nkString
# n.strVal = ""

# invalid: would change the active object branch
# n.kind = nkInt

var node = Node(kind: nkAdd, leftOp: Node(kind: nkInt, intVal: 4),
                          rightOp: Node(kind: nkInt, intVal: 2))

echo node.kind

# valid as this doesn't change the active object branch
node.kind = nkSub
echo node.kind

#[

# discord discussion: https://discord.com/channels/371759389889003530/371759389889003532/1061411722503659542

I hit a dead-end when trying to use the same field for multiple (but not all) variants within an object variant.  Did some searching and found that this is an issue with history going back to 2015: https://github.com/nim-lang/RFCs/issues/368

It sounds like there's some disagreement about the syntax to resolve this, but that a lot of people think this would be a valuable addition to Nim.

In the interim, what do most people do with current Nim to work around this limitation?  Using different names for the same field feels like the only option, but it's pretty ugly.

mocked-up example problem that doesn't compile because of Error: attempt to redefine: 'x':

type
  DimensionKind = enum
    Zero, One, Two, Three
  DimensionalShape = object
    color: string
    case kind: DimensionKind
      of Zero: nil
      of One: x: int
      of Two:
        x: int
        y: int
      of Three:
        x: int
        y: int
        z: int
]#

# one solution from Elegantbeef on discord: https://discord.com/channels/371759389889003530/371759389889003532/1061414615021535412

import std/macros
type
  DimensionKind = enum
    Zero, One, Two, Three
  DimensionalShape = object
    color: string
    xVal, yVal, zVal: int
    kind: DimensionKind

template genProps(allowed: set[DimensionKind], name, field: untyped) =
  proc name(dim: DimensionalShape): typeof(dim.field) =
    doAssert dim.kind in allowed
    dim.field
  
  # proc name(dim: var DimensionalShape): var typeof(dim.field) =
    # doAssert dim.kind in allowed
    # dim.field

  proc `name =`(dim: var DimensionalShape, val: typeof(dim.field)) =
    doassert dim.kind in allowed
    dim.field = val

expandMacros:
  genProps({One, Two, Three}, x, xVal)
  genProps({Two, Three}, y, yVal)
  genProps({Three}, z, zVal)

var dim = DimensionalShape(kind: Three)
dim.z = 300
dim.x = 10
echo dim
echo dim.x
echo dim.z


# another hard-coded version of this, this is still kind of ugly

type
  DimensionKind2 = enum
    Zero2, One2, Two2, Three2
  DimensionalShape2 = object
    color: string
    case kind: DimensionKind2
      of Zero2: nil
      of One2: xOne: int
      of Two2: xTwo, yTwo: int
      of Three2: xThree, yThree, z: int

proc x(shape: DimensionalShape2): int =
  case shape.kind:
    of Zero2: raiseAssert "Zero2 doesn't have an x field"
    of One2: shape.xOne
    of Two2: shape.xTwo
    of Three2: shape.xThree

proc y(shape: DimensionalShape2): int =
  case shape.kind:
    of Zero2, One2: raiseAssert $shape.kind & " doesn't have a y field"
    of Two2: shape.yTwo
    of Three2: shape.yThree

var dim2 = DimensionalShape(kind: Three)
dim2.z = 300
dim2.x = 10
echo dim2
echo dim2.x
echo dim2.z