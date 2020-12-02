# Hung Lang 2

A programming language that is created to teach beginner with computer programming, in a way that is easy as python,
retain c-like syntax as java but still is not very confusing too learn.

# Features

Hung lang 2 is an interpreted programming language with first class support for function, the features available is as
follows.

## Datatypes

| Name    | Primitive                            | Support    |
| ------- | ------------------------------------ | ---------- |
| Number  | No (Will be primitive in the future) | Full       |
| Boolean | Yes                                  | Full       |
| String  | No                                   | Fulll |
| Array   | No                                   | Full       |
| Map | No |Planned|

> Primitive means it is not pass by reference thus will always create instance with the same in when initialize. (instance id can be checked with id()).

> To verify if a data has a certain data type, use isType.

Currently, the generation of custom data structure is not yet possible, update is planned to fix this.

### Expression-First Approach

The programming language is design in a way that almost all of it's feature is intended to be expression, thus we can
pass around these data for a more fluid way of programming.

Available expression:

- Expression
- If Expression
- Function Expression
- Call expression

Available Statemnet:

- Var statement
- Return Statement
- Multiline Statement
- Expression statement

### Operators

These are a few operators that is available on hung lang 2

| Operator  | boolean | number | string                      |
| --------- | ------- | ------ | --------------------------- |
| ==        | y       | y      | y                           |
| !=        | y       | y      | y                           |
| ! (unary) | y       | y      | n (will be treated as true) |
| - (unary) | n       | y      | n                           |
| +         | n       | y      | y                           |
| -         | n       | y      | n                           |
| *         | n       | y      | n                           |
| /         | n       | y      | y (split)                   |
| <         | n       | y      | n                           |
| >         | n       | y      | n                           |

### Builtin Functions

Some feature in hung lang 2, is designed with function in mind to make it easier to use, one such feature is array, the
array does not use any special notation (like [] in other langauge) but rather use builtin function to create and update
it's value.

Available builitn functions

#### Array

- array(args) : create a new array
- add(array, index, value) : add a new value at specified index
- remove(array, index) : remove a value at specified index
- update(array, index, value) : update the value at specific index
- get(array,index) : get a value of index in array

#### Conversion

- num(string) : convert string to number return false if fail
- str(data) : convert data to string

### Loop

- each(array, func) : loop through each element of array
- for(start, end, increment, f) : run f and supply up to 3 args until end is reached.

#### Others

- Id(data) : return hashcode of object
- isType(a,b) : return if a is the same type with b
- random(max) : return a random number between 0 and max
- len(data) : return the length of string or array
- read( ) : read user cli input as string.
- eval(data) : eval result of data (in hung lang 2 syntax)
- and(a,b) : return the result of and operation between a and b
- or(a,b) : return the result of or operation between a and b
- mod(a,b) : return a mod b
- write(data) : write data to console





