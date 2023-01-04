import std/macros

proc addFour(x: int): int =
    x + 4

#[
dumpTree will emit the AST tree for the code inside, ex:

StmtList
  VarSection
    IdentDefs
      Ident "seven"
      Empty
      Call
        Ident "addFour"
        IntLit 3
  Command
    Ident "echo"
    Ident "seven"
]#
dumpTree:
    var seven = addFour(3)
    echo seven

when isMainModule:
    echo addFour(8)

# when compiles could possibly be used for mocking out expensive behavior
# apparently adding pragmas to things is another way of tagging things
# could be possible to add something like a .stub. pragma to a method to allow
# it to be swapped out...

when compiles(addFour):
    echo "addFour compiles"

when not compiles(addFour2):
    echo "addFour2 doesn't compile"

# can be used as an expression
echo when not compiles(addFour2):
    7
