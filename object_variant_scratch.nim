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

var x = Node(kind: nkAdd, leftOp: Node(kind: nkInt, intVal: 4),
                          rightOp: Node(kind: nkInt, intVal: 2))

echo x.kind

# valid as this doesn't change the active object branch
x.kind = nkSub
echo x.kind
