# Interface

Interfaces allow you to express a contract which classes must implement.
This enables you to write code which depends on abstractions instead of concrete implementations, which can help you to decouple your software and increase maintainability.

## Interface declaration

An interface is declared using the `INTERFACE` keyword and may contain an arbitrary amount of `METHOD` prototypes.
A `METHOD` prototype is very similar to a normal `METHOD`, but may not specify any implementation detail like `VAR_TEMP` or a code body.
Interfaces may extend an arbitrary number of other interfaces using the `EXTENDS` keyword, as long as the hierarchy contains no cycles.

```iecst
INTERFACE SuperInterface
    METHOD MyMethod : INT
        VAR_INPUT
            a, b : INT;
        END_VAR
    END_METHOD
END_INTERFACE

INTERFACE DerivedInterface EXTENDS SuperInterface
    METHOD AnotherMethod : INT
    END_METHOD
END_INTERFACE
```

## Implementing interfaces

A class can implement an arbitrary number of interfaces using the `IMPLEMENTS` keyword.
By doing this, the class must implement all methods defined by all implemented interfaces.

```iecst
CLASS MyImplementation IMPLEMENTS DerivedInterface
    METHOD PUBLIC MyMethod : INT        // Interface methods must be implement as PUBLIC
        VAR_INPUT
            a, b : INT;
        END_VAR
        VAR_TEMP
            temp : INT;     // You can add temporary variables and code as required.
        END_VAR
        MyMethod := 10;
    END_METHOD

    // Error: Class does not implement all interfaces. 'AnotherMethod' is missing.
END_CLASS
```

## Using interfaces

Variables which are typed as 'interface' are initialized with `NULL` until a compatible variable or instance is assigned.
Note that a compatible variable is a variable whose type is a subtype of the variable that it is assigned to.

> TIP
>
> A variable typed as 'interface' can not be used to **initialize** another variable. It can be assigned in the code section only.

```iecst
CONFIGURATION Default
    PROGRAM P1 : Entry;
    VAR_GLOBAL
        o1 : O := (i := 1);
        o2 : O := (i := 2);
        i1 : I := o1;
        i2 : I := o2;
        res_foo1 : INT;
        res_foo2 : INT;
        res_foo3 : INT;
        res_foo4 : INT;
    END_VAR
END_CONFIGURATION

PROGRAM Entry
    VAR_EXTERNAL
        o1 : O;
        o2 : O;
        i1 : I;
        i2 : I;
        res_foo1 : INT;
        res_foo2 : INT;
        res_foo3 : INT;
        res_foo4 : INT;
    END_VAR

    res_foo1 := i1.foo();
    res_foo2 := i2.foo();

    i1 := o2;
    res_foo3 := i1.foo();

    i2 := i1;
    res_foo4 := i2.foo();

END_PROGRAM

INTERFACE I
    METHOD foo : INT END_METHOD
END_INTERFACE

CLASS O IMPLEMENTS I
    VAR PUBLIC
        i : INT;
    END_VAR

    METHOD PUBLIC foo : INT
        foo := i;
    END_METHOD

END_CLASS
```

## Basic example

The following example declares an `INTERFACE` 'ICalculator' which defines a 'Calc' method with two `INT` variables.

```iecst
INTERFACE ICalculator
    METHOD Calc : INT
        VAR_INPUT
            a, b : INT;
        END_VAR
    END_METHOD
END_INTERFACE

CLASS AddCalculator IMPLEMENTS ICalculator
    METHOD PUBLIC Calc : INT
        VAR_INPUT
            a, b : INT;
        END_VAR
        Calc := a + b;
    END_METHOD
END_CLASS

CLASS SubCalculator IMPLEMENTS ICalculator
    METHOD PUBLIC Calc : INT
        VAR_INPUT
            a, b : INT;
        END_VAR
        Calc := a - b;
    END_METHOD
END_CLASS

FUNCTION Func : INT
    VAR_INPUT
        impl : ICalculator;
    END_VAR
    // Result could be 8 or -2, depending on which implementation of 'ICalculator' is given.
    Func := impl.Calc(3, 5);
END_FUNCTION

PROGRAM Prog
    VAR
        addCalc : AddCalculator;
        subCalc : SubCalculator;
        calc : ICalculator := addCalc;  // Concrete implementation is bound to interface
    END_VAR

    Func(calc);
END_PROGRAM
```
