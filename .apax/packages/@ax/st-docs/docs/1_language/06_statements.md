# Statements

A statement represents a single rule that is to be executed as part of the program. Statements are executed in the order of their declaration.

![Syntax Diagram](./diagrams/statementList.svg "Syntax-Diagram")

## Assignment

An assignment assigns a new value to a memory location. The memory location is specified with the first expression of the assign statement. The new value with the second expression.

Both expressions must evaluate to the same type, or an implicit conversion from the type of the second expression to the type of first expression must exist.

```iecst
a := b + c;
```

![Syntax Diagram](./diagrams/assignStatement.svg "Syntax-Diagram")

### Example: Assignment

```iecst
FUNCTION AddOne : INT
    VAR_INPUT
        a : INT;
    END_VAR
    AddOne := a + 1; (* assigns "a + 1" to "AddOne". *)
END_FUNCTION
```

### Assigning arrays

> TIP
>
> Assigning [arrays](./04_types-and-variables.md#array) is not restricted to the exact type of the array but to the structural equality. Structural equality is defined by:
>
> - Both arrays have the same element type
> - Both arrays have the same count of dimensions
> - Both arrays have the same count of elements in each dimension
>
> Taking these rules it does not matter if an array is [named](./04_types-and-variables.md#named-array) or [anonymous](./04_types-and-variables.md#array) as long as they are structurally equal, they may be assigned to one another.

## Assignment attempt

With an assignment attempt `?=` you can try to assign a (possibly reference-typed) object to another reference-typed object. If the dynamic type of the referenced instance on the right side is assignable to the static typed variable on the left side, the variable on the left side then references the instance on the right side. Otherwise, the left side variable will be `NULL`. It is similar to a so-called _dynamic cast_ in the `C++` language or `as` in the `C#` language.

> TIP
>
> This check can only be done at runtime, hence expect performance drawbacks if used extensively. Usually, the assignment attempt is needed, when you have to assign a variable to a variable with a more concrete type.
>
> ```iecst
> INTERFACE ITop
>     // ...
> END_INTERFACE
> INTERFACE IBottom EXTENDS ITop
>     // ...
> END_INTERFACE
> CLASS C IMPLEMENTS ITop
>     // ...
> END_CLASS
> CLASS D IMPLEMENTS IBottom
>     // ...
> END_CLASS
>
> FUNCTION foo
>     VAR_INPUT
>         it : ITop;
>     END_VAR
>     VAR_TEMP
>         ib : IBottom;
>     END_VAR
>         // some code ...
>
>         ib ?= it;   // is the concrete type of 'it' implementing IBottom?
>                     // in case, 'it' is of 'CLASS D', then yes! 'ib' then will be valid.
>                     // in case, 'it' is of 'CLASS C', then no! 'ib' will then be 'NULL'.
>
>         IF ib <> NULL THEN
>             ;   // ... some code ...
>         END_IF;
>
> END_FUNCTION
> ```

> TIP
>
> - It is only applicable for variables of type `INTERFACE`, `CLASS`, `REF_TO CLASS`.
> - The variable on the left side _must_ be of reference type, while the variable on the right side _can be value-typed, if the left side is of type of an `INTERFACE`_. A dereference operator (`^`) must not be applied to an interface-typed variable, nor a `REF` operator must be applied to a value-typed object, if it is assigned to an interface-typed variable. This is an implication of the IEC61131-3, as an `INTERFACE` is implicitly a reference type, but `my_itf_var ?= my_value_class_var` must be supported.

### Example: Assignment attempt

The following example shows some more usage of assignment attempt. It omits method declarations in interfaces as they are not important for this showcase.

```iecst
INTERFACE ITop
END_INTERFACE
INTERFACE ILeft EXTENDS ITop
END_INTERFACE
INTERFACE IRight EXTENDS ITop
END_INTERFACE
INTERFACE IBottom EXTENDS ILeft, IRight // ILeft is only for the purpose of showing multi inheritance using interfaces
END_INTERFACE

INTERFACE IOtherBottom EXTENDS ITop
END_INTERFACE

CLASS A IMPLEMENTS IBottom
END_CLASS
CLASS B EXTENDS A IMPLEMENTS IOtherBottom
    METHOD GetAsARef : REF_TO A
        GetAsARef ?= REF(THIS); // note the difference of the right side in comparison when attempting the assignment to an interface typed value
    END_METHOD
    METHOD GetAsOtherBottom : IOtherBottom
        GetAsOtherBottom ?= THIS;
    END_METHOD
END_CLASS

PROGRAM P
    VAR
        b : B;
        bRef : REF_TO B := REF(b);
        a : A;
        aRef : REF_TO A := REF(a);
        ir : IRight;
        ib : IBottom;
        iob : IOtherBottom;
    END_VAR

    bRef ?= aRef; // 'bRef' is NULL, because 'aRef' references a type 'A', that is not assignable to 'B'

    bRef := REF(b);
    aRef ?= bRef; // -> type 'B' is assignable to type 'A', so afterwards 'aRef' references 'b', but only methods of 'A' are available; hint: 'aRef := bRef' is equivalent

    bRef ?= aRef; // -> 'bRef' remains unchanged, but now methods of 'B' are available; hint: 'bRef := aRef' is not possible, because statically type 'A' is not assignable to type 'B'

    ir := a;    // 'ir' references 'a' (methods of 'IRight' are available); note that on right side 'REF(a)' is not possible
    aRef ?= ir; // -> 'aRef' references 'a' (methods of type A are available)

    ib ?= ir; // -> 'ib' references 'a', methods of 'IBottom' (and thus 'ITop', 'ILeft', 'IRight') are available

    iob ?= ib; // 'iob' is NULL, because 'ib' references a type 'A', that does not implement 'IOtherBottom'

    bRef ?= ib; // 'bRef' is NULL, because 'ib' references a type 'A', that is not assignable to 'B'

    iob ?= b; // -> 'iob' references 'b', but only methods of 'IOtherBottom' (and 'ITop') are available

    aRef ?= iob; // 'aRef' references 'b', because type 'B' extends type 'A'

END_PROGRAM
```

## Conditional statement

![Syntax Diagram](./diagrams/conditionalStatement.svg "Syntax-Diagram")

A conditional statement (also known as `IF` statement) makes a choice between several lists of statements. At most one of the lists is executed.

All expressions of a conditional statement must evaluate to type `BOOL`.

First the initial expression is evaluated.

If that evaluates to `TRUE`, the first statement list is executed and after that execution continues after the conditional statement.

If it evaluates to `FALSE` all the `ELSIF` statements are evaluated in declaration order in the same manner. If no condition of any `ELSIF` statement evaluates to `TRUE` (or if there are no `ELSIF` statements) execution continues with the list of statements of the ELSE statement (in case it is declared), and then continues after the conditional statement.

**_Example_**

```iecst
FUNCTION IfExample : Int
    VAR_TEMP
        a,b,c : BOOL;
        i : INT;
    END_VAR
    i := 0;
    IF a THEN
        i := 1;
    END_IF;
    // if a is true, then i equals 1, otherwise 0

    IF b THEN
        i := 2;
    ELSIF c THEN
        i := 3;
    ELSE
        i := 4;
    END_IF;
    // if b is true then i equals 2
    // if b is false and c is true then i equals 3
    // otherwise i equals 4.
END_FUNCTION
```

## CASE statement

Sometimes we need to evaluate one single expression to decide which code blocks should be executed, i.e., different values of this expression lead to execution of different blocks. Especially when the number of choices is large, the `CASE` statement is more convenient than an equivalent chain of `IF-THEN-ELSIF-THEN-...-ELSIF-THEN-ELSE` statements.

![Syntax Diagram](./diagrams/caseStatement.svg "Syntax-Diagram")

As shown in the syntax diagram of `CASE` statement, an expression of `integer` or `enum` data type follows the `CASE` keyword. This expression is used as the “selector”, whose value selects which statement list should be executed. Each statement list is labeled by a “case list”. A “case list” consists of one or more “case list elements”, each being a constant integer, an enumerated value, or a range of constant integers. If the selector expression equals or belongs to the range of one case list element, the corresponding statement list will be executed.

If the selector expression does not match any case list and the keyword `ELSE` exists in the `CASE` statement, the statement list following `ELSE` will be executed.

If the selector expression does not match any case list and there is no `ELSE` keyword, none of the statement lists will be executed.

The selector expression must be comparable with the case list elements. This requires that all case list elements must have the same data type with the selector expression.

Each value in the case list elements is allowed to exist only once. It is not allowed to write overlapping ranges or values existing more than once, e.g.,

`0..5` and `3..6`

is not allowed, because the values 3, 4 and 5 appear twice.

### Example: CASE statement

```iecst
FUNCTION SwitchInput : INT
    VAR_INPUT
        a : INT := 42;
    END_VAR
    VAR_TEMP
        i : int;
    END_VAR

    CASE a OF           // selector 'a' has value 42
        -32..-12, 15:   // no match
            i := 1;
        -11..3, 19:     // no match
            i := 5;
        4..10, 20..46:  // match, because 'a' is in range 20..46
            i := 10;
        ELSE
            i:= -1;
    END_CASE;
END_FUNCTION
```

```iecst
TYPE
    Colors : (Red, Green, Blue);        // definition of the enum Colors
END_TYPE

PROGRAM Demo
    VAR
        color : Colors;
        res : Int;
    END_VAR

    color := Colors#Green;

    CASE color OF                       // selector 'color' has value Colors#Green
        Colors#Red : res := 1;          // no match
        Colors#Green : res := 6;        // match
        Colors#Blue : res := 5;         // no evaluation
    END_CASE;
END_PROGRAM
```

## Iteration statements

Iteration statements may be used to execute a set of statements multiple times. The amount of iterations may be restricted by a particular condition.

![Syntax Diagram](./diagrams/iterationStatement.svg "Syntax-Diagram")

### FOR statement

The `FOR` statement executes a list of statements while a specified expression evaluates to `TRUE`.

At any point within the `FOR` statement list, you can break out of the loop by using the [EXIT](#exit-statement) statement, or step to the next iteration in the loop by using the [CONTINUE](#continue-statement) statement.

As shown in the syntax diagram, the `FOR` statement defines an `assignStatement` as initializer, a `TO` expression as final value, and optionally an incrementor expression starting with `BY`. These expressions shall be of the same signed or unsigned integer type ( `(U)SINT`, `(U)INT`, `(U)DINT` or `(U)LINT` ). Furthermore, IEC 61131-3 does not allow to modify the control variable of the `FOR` loop inside the loop's body. This implies, that only elementary local variables can be used as the control variable (elements of arrays and structs - as well as global variables - can be accidentally modified in other functions, while the loop is executed).

![Syntax Diagram](./diagrams/forStatement.svg "Syntax-Diagram")

> TIP
>
> The `FOR` statement may be used in case the amount of iterations is known, e.g. iterating [arrays](04_types-and-variables.md#array).

### Example 1: FOR statement

```iecst
FUNCTION Sum: INT
    VAR_INPUT
        lowerBound: INT;
        upperBound: INT;
    END_VAR
    VAR
        i: INT;
    END_VAR

    Sum := 0;
    FOR i := lowerBound TO upperBound BY 1 DO
    // the by-expression can be omitted when it evaluates to 1, simplified as "FOR i := begin TO end DO"
        Sum := Sum + i;
    END_FOR;
    // i will contain the value upperBound + 1
END_FUNCTION
```

#### Initializer assignment

The `assignStatement` in the initializer is executed only once, before entering the loop.

The accessed variable (control variable) shall not be altered by any of the repeated statements.

#### Final value expression

The final value `expression` will be evaluated only once, before entering the loop.

#### Incrementor value expression

The incrementor value `expression` will be evaluated only once, before entering the loop.

If it is omitted the incrementor will default to the value of `1`.

The incrementor value and the final value together specify the termination condition; if the incrementor expression value is less than `0` the loop will terminate when the accessed variable value is less than the final value expression, otherwise it will terminate when the accessed variable value is greater than the final value.

- `FOR i := 1 TO 5 BY 1 DO` will result in an exit condition of `i > 5`
- `FOR i := 10 TO 5 BY -1 DO` will result in an exit condition of `i < 5`

The earlier example for summation using iteration with ascending order is equivalent to following code using iteration with descending order.

### Example 2: FOR statement

```iecst
FUNCTION Sum: INT
    VAR_INPUT
        lowerBound: INT;
        upperBound: INT;
    END_VAR
    VAR
        i: INT;
    END_VAR

    Sum := 0;
    FOR i := upperBound TO lowerBound BY -1 DO
        Sum := Sum + i;
    END_FOR;
    // i will contain the value lowerBound - 1
END_FUNCTION
```

### WHILE Statement

The `WHILE` statement executes a list of statements while a specified Boolean expression evaluates to `TRUE`. Because that expression is evaluated before each execution of the loop, a `WHILE` loop executed zero or more times.

At any point within the `WHILE` statement list, you can break out of the loop by using the [EXIT](#exit-statement) statement, or step to the next expression evaluation by using the [CONTINUE](#continue-statement) statement.

![Syntax Diagram](./diagrams/whileStatement.svg "Syntax-Diagram")

> TIP
>
> The WHILE statement may be used in case the amount of iterations is _not_ known.

#### Example: WHILE statement

```iecst
FUNCTION Loops
    VAR_TEMP
        x : INT := 0;
    END_VAR

    WHILE x < 10 DO
        x := x + 1;
    END_WHILE;
    // x will contain the value 10
END_FUNCTION
```

### REPEAT Statement

The `REPEAT` statement executes a list of statements while a specified Boolean expression evaluates to `TRUE`. Because that expression is evaluated after each execution of the loop, a `REPEAT` loop executes one or more times.

At any point within the `REPEAT` statement list, you can break out of the loop by using the [EXIT](#exit-statement) statement, or step to the next expression evaluation by using the [CONTINUE](#continue-statement) statement.

![Syntax Diagram](./diagrams/repeatStatement.svg "Syntax-Diagram")

> TIP
>
> The REPEAT statement may be used in case the amount of iterations is _not_ known and the loop shall be executed at least once.

#### Example: REPEAT statement

```iecst
FUNCTION Loops
    VAR_TEMP
        x : INT := 0;
    END_VAR

    REPEAT
        x := x + 1;
        UNTIL x >= 10
    END_REPEAT;
    // x will contain the value 10
END_FUNCTION
```

## Jump Statements

Jump statements may be used to manually interrupt the control flow of the program.

![Syntax Diagram](./diagrams/jumpStatement.svg "Syntax-Diagram")

### CONTINUE Statement

The `CONTINUE` statement passes control to the next iteration of the enclosing [loop](#iteration-statements) in which it appears.

![Syntax Diagram](./diagrams/continueStatement.svg "Syntax-Diagram")

> TIP
>
> A continue statement may only be used inside a [loop](#iteration-statements).

#### Example: CONTINUE statement

```iecst
FUNCTION SkipIterations
    VAR_TEMP
        x: INT := 0;
        y: INT := 0;
    END_VAR

    WHILE x < 10 DO
        x := x + 1;
        IF y >= 5 THEN
            CONTINUE;
        END_IF;
        y := y + 1;
    END_WHILE;
    // x will contain the value 10, y will contain the value 5
END_FUNCTION
```

### EXIT Statement

The `EXIT` statement terminates the enclosing [loop](#iteration-statements) in which it appears.

![Syntax Diagram](./diagrams/exitStatement.svg "Syntax-Diagram")

> TIP
>
> An exit statement may only be used inside a [loop](#iteration-statements).

#### Example: EXIT statement

```iecst
FUNCTION BreakIterations
    VAR_TEMP
        x: INT := 0;
        y: INT := 0;
    END_VAR

    WHILE x < 10 DO
        x := x + 1;
        IF y >= 5 THEN
            EXIT;
        END_IF;
        y := y + 1;
    END_WHILE;
    // x will contain the value 6, y will contain the value 5
END_FUNCTION
```

### RETURN Statement

The `RETURN` statement terminates execution of the [program organization unit](./01_program-structure/2_program-organization-unit.md#program-organization-unit) in which it appears.

![Syntax Diagram](./diagrams/returnStatement.svg "Syntax-Diagram")

> TIP
>
> A return statement may only be used inside the following [POU](./01_program-structure/2_program-organization-unit.md#program-organization-unit):
>
> - [Program](./01_program-structure/2_program-organization-unit.md#program-declaration)
> - [Function](./01_program-structure/2_program-organization-unit.md#function-declaration)
> - [Method](./01_program-structure/2_program-organization-unit.md#method-declaration)

#### Example: RETURN statement

```iecst
PROGRAM Caller
    VAR
        res : INT;
    END_VAR
    res := callee(in := 5);
END_PROGRAM

FUNCTION callee : INT
    VAR_INPUT
        in : INT;
    END_VAR
    IF in >= 5 THEN
        callee := 23;
        RETURN;
    END_IF;
    callee := 42;
END_FUNCTION
// res will contain the value 23, not 42
```
