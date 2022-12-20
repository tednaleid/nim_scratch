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
