# Types

## Primitive
1. string
    i. interpolation   eg: `"Hello, ${var.name}!"`
    ii. directive   eg: `"Hello, %{ if var.name!= ""} ${var.name} %{else} unnamed %{endif}"`
2. number
3. bool

## no type
1. null

## collection
1. list(tuple)
2. map(object)


# Operators
1. a * b
2. a / b
3. a % b
4. a + b
5. a - b
6. -a
7. a == b
8. a != b
9. a < b, a <= b, a > b, a >= b
10. a || b
11. a && b
12. !a

# Conditional
1. condition ? true_val : false_val   eg: var.a != "" ? var.a : "deafult_value"

# For expressions
1. input can be list, set, tuple, map, or an object   eg: `[for s in var.list : upper(s)]`
2. eg: `[for k,v in var.map : length(k) + length(v)]`
3. eg: `[for i,v in var.list : "${i} is ${v}"]`   and   eg: `[for s in var.list : upper(s) if s != "" ]`
4. [] returns a tuple
5. {} returns a object

# Splat expressions
-> A Splat operator is represented by an asterisk(*), it originates from the ruby language.
-> Splats in Terraform are used to rollup or soak up a bunch of iterations in a *for* expression

eg: `[for o in var.list : o.interfaces[0].name]` - can be written as -> `var.list[*].interfaces[0].name`

-> special behavior when we apply SPLAT expressions to *lists*
1. If the value is anything other than null value then the splat expression will transform it into a single-element list
2. If the value is null then the splat expression will return an empty tuple.


# Dynamic Blocks
Dynamic block allows us to dynamically construct repeatable nested blocks

