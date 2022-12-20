#[ 
    nim doesn't have interfaces, but you can use generics and concepts to get 
    to the same place

    the Mastering Nim book (ch. 8) talks about how types are commonly 
    "underspecified" generics use "specialization" for its generics.  

    Every new concrete type found when compiling like `int` or `string` produces 
    specialized code there is no runtime reflection or overhead to using 
    generics.  Generics are gone at run time
]#

#[
    example of an underspecified value,  We never created a contract anywhere 
    that said that `T` has to have a `foo` value on it, but the compiler 
    enforces this
]#
proc underspecified_field_foo*[T](obj: T): string = obj.foo

#[
    or, alternatively, this is pretty close to an interface where we can use a 
    "concept" to specify a type that we expect to have a `foo` and then we can 
    tell the compiler that we expect a `T` that `HasP` for better documentation 
    and errors
]#
type
  HasFoo = concept hasFoo
    hasFoo.foo is string
proc get_foo_from_generic_with_has_foo_concept*[T: HasFoo](
  obj: T): string = obj.foo


# this type directly has a `foo` field on it
type
  FooHolder = object
    foo: string

let fh = FooHolder(foo: "value in FooHolder")
echo fh.underspecified_field_foo
echo fh.get_foo_from_generic_with_has_foo_concept

# type holds a value, but the value isn't named foo
type
  ValueHolder = object
    value: string

# but we have an adapter proc that allows us to adapt valueHolder to return foo
proc foo(valueHolder: ValueHolder): string = valueHolder.value

let vh = ValueHolder(value: "value in ValueHolder")

echo vh.underspecified_field_foo
echo vh.get_foo_from_generic_with_has_foo_concept


# this type does not have a foo and does not have an adapter proc so it errors
type
  BarHolder = object
    bar: string

let bh = BarHolder(bar: "cannot get foo from this")


#[
    this will throw this compile time error, because the underspecified type 
    that is expecting a `foo` isn't available:

    Error: type mismatch: got <BarHolder>
    but expected one of:
    proc foo(valueHolder: ValueHolder): string
        first type mismatch at position: 1
        required type for valueHolder: ValueHolder
        but expression 'obj' is of type: BarHolder

    expression: foo(obj)
]#

# bh.underspecified_field_foo

#[
another compile time error from this, but has more detail from the concept:

    Error: type mismatch: got <BarHolder>
    but expected one of:
    proc get_foo_from_generic_with_has_foo_concept[T: HasFoo](obj: T): string
        first type mismatch at position: 1
        required type for obj: T: HasFoo
        but expression 'bh' is of type: BarHolder
    /Users/tednaleid/Documents/archives/workspace/nim/nim_scratch/object_scratch.nim(30, 6) HasFoo: type mismatch: got <Alias>
    but expected one of:
    proc foo(valueHolder: ValueHolder): string
        first type mismatch at position: 1
        required type for valueHolder: ValueHolder
        but expression 'x' is of type: Alias

    expression: foo(x)
    /Users/tednaleid/Documents/archives/workspace/nim/nim_scratch/object_scratch.nim(30, 6) HasFoo: expression '' has no type (or is ambiguous)
    /Users/tednaleid/Documents/archives/workspace/nim/nim_scratch/object_scratch.nim(30, 5) HasFoo: concept predicate failed

    expression: get_foo_from_generic_with_has_foo_concept(bh)
]#

# echo bh.get_foo_from_generic_with_has_foo_concept
