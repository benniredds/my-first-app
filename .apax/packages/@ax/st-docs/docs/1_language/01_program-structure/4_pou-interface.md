# Variable sections

Variable sections may be used to describe the interface of a [program organization unit](./2_program-organization-unit.md#program-organization-unit) (POU) by declaring variables. The sections enable the caller to pass and retrieve values from the POU. Additionally internal states may be persisted throughout the complete cycle of the application.

![Syntax Diagram](./../diagrams/varDeclarationSection.svg "Syntax-Diagram")

## Global variables

Global variables are symbols that are globally available among all [program organization units](./2_program-organization-unit.md#program-organization-unit).

```iecst
VAR_GLOBAL

END_VAR
```

> TIP
>
> This section may be declared by the following language element:
>
> - [Configuration](./1_configuration.md#configuration)

> TIP
>
> Variables declared inside this section may only be accessible when re-declared in an [external section](#external-section)

A direct access at input (I), output (Q) or memory (M) area of the PLC can be designated as a global variable using the keyword `AT`. After the letter indicating the area, use X (BIT), B (BYTE), W (WORD), D (DWORD) or L (LWORD) to indicate the width. When no letter for width is used, it is recognized as a bit. See following examples.

### Example: Global variables declaration

```iecst
CONFIGURATION PLC_1
    VAR_GLOBAL
        counter : INT;  //Global var with no direct access
        myBool1 AT %I0.3 : BOOL;
        myBool2 AT %MX1 : BOOL;  //Equivalent to %MX1.0, %M1.0, %M1

        mySInt AT %QB1 : SINT := SINT#-7;  //Direct access with initializer
        myULInt AT %IL5 : ULINT;

        myChar AT %MB0 : CHAR := 'F';
        myWChar AT %QW1 : WCHAR;

        myByte AT %QB8 : BYTE := BYTE#123;
        myDWord AT %MD5 : DWORD;
    END_VAR
END_CONFIGURATION
```

#### Global constants

Global constants are declared at configuration level like every other global variable, by adding the `CONSTANT` keyword to the `VAR_GLOBAL` section.

```iecst
CONFIGURATION Default
    PROGRAM P1 : Main;

    VAR_GLOBAL CONSTANT
        ProcessValue1 : REAL := REAL#123.4;
        ProcessValue2 : DWORD := DWORD#16#F00D;
    END_VAR
END_CONFIGURATION
```

Like any other global variable, a global constant variable is not accessible in a [POU](./2_program-organization-unit.md#program-organization-unit) unless it is re-declared in the `VAR_EXTERNAL` section of the POU again with the `CONSTANT`modifier.

```iecst
PROGRAM Main
    VAR_EXTERNAL CONSTANT
        ProcessValue1 : REAL;
        ProcessValue2 : DWORD;
    END_VAR
    ;
END_PROGRAM
```

> TIP
>
> It is not possible to use global constants in type declarations inside a `TYPE`..`END_TYPE` section or in [class](./2_program-organization-unit.md#class-declaration) declarations. There is no concept like a `VAR_EXTERNAL CONSTANT` section for importing global constants in type declarations, because allowing global constants in type declarations would lead to implicit, undeclared dependencies to global declarations.

## Retentive variables (RETAIN)

A variable declared with the storage modifier `RETAIN` will keep its value, last written to, after a **warm start** of the PLC. It's important to understand that a warm start of the PLC is only a power off / power on transition. This may be caused by using a physical switch or by a power loss.

> TIP
>
> The value of a retentive variable is not kept after a download or after doing a memory reset on the PLC. In this case the initial value of the variable is used, if any given, after start up.

```iecst
CONFIGURATION Default
    VAR_GLOBAL RETAIN
        ProcessValue1 : REAL := REAL#123.4;
        ProcessValue2 : DWORD := DWORD#16#F00D;
    END_VAR

    VAR_GLOBAL
        ProcessValueRef : REF_TO REAL := REF(ProcessValue1);
    END_VAR
END_CONFIGURATION
```

In the example above, the last written values of `ProcessValue1` and `ProcessValue2` are kept after a power loss. During a cold start, their initial values are used. It is also possible to mix references between `RETAIN` and other variables. In general there are no restrictions on retentive variables except that no direct addressing (`AT`) is possible.

### Explicit non retentive variables (NON_RETAIN)

The `NON_RETAIN` storage modifier has no effect on variables because all variables are non retentive by default. It is supported for completeness of the compiler according to the norm and can be left out.

```iecst
CONFIGURATION Default
    VAR_GLOBAL NON_RETAIN // This has no effect
        ProcessValue1 : REAL := REAL#123.4;
    END_VAR
END_CONFIGURATION
```

## External section

The external section may be used to reference globally declared variables. It offers the means to explicitly declare dependencies on global variables.

```iecst
VAR_EXTERNAL

END_VAR
```

> TIP
>
> This section may be declared by the following program organization units:
>
> - [Program](./2_program-organization-unit.md#program-declaration)
> - [Method](./2_program-organization-unit.md#method-declaration)
> - [Function](./2_program-organization-unit.md#function-declaration)
> - [Function block](./2_program-organization-unit.md#function-block-declaration)

### Example: External variables declaration

> TIP
>
> A corresponding [global variable](#global-variables) must have been declared.

```iecst
FUNCTION Counter
    VAR_EXTERNAL
        counter : INT;
    END_VAR
    ;
END_FUNCTION
```

### Read-only global variables

The `CONSTANT` modifier at the `VAR_EXTERNAL` section may also be used to prevent writing to global variables that are not declared `CONSTANT`. This can be intended by the programmer to circumvent runtime errors by accidentally writing to global variables that affect other program parts. Here the compiler will help by issuing an error that the variable cannot be written.

```iecst{26}
CONFIGURATION Default
    PROGRAM P1 : Main;
    VAR_GLOBAL
        ProcessValue : REAL;
    END_VAR
END_CONFIGURATION

PROGRAM Main
    VAR_EXTERNAL
        ProcessValue : REAL;
    END_VAR

    // Should not modify global variables
    Algorithm();

    IF ProcessValue = REAL#1.0 THEN
        ProcessValue := REAL#2.0;
    END_IF;
END_PROGRAM

FUNCTION Algorithm
    VAR_EXTERNAL CONSTANT
        ProcessValue : REAL;
    END_VAR

    ProcessValue := REAL#1.0; // Oh! Never intended to write to ProcessValue!
END_FUNCTION
```

## Input section

The input section may be declared to pass arguments, for further processing, from the caller to the called [program organization units](./2_program-organization-unit.md#program-organization-unit).

```iecst
VAR_INPUT

END_VAR
```

> TIP
>
> This section may be declared by the following program organization units:
>
> - [Method](./2_program-organization-unit.md#method-declaration)
> - [Function](./2_program-organization-unit.md#function-declaration)
> - [Function block](./2_program-organization-unit.md#function-block-declaration)

### Example: Input variables declaration

```iecst
FUNCTION Abs : INT
    VAR_INPUT
        value : INT;
    END_VAR
    IF value < 0 THEN
        Abs := value * -1;
    ELSE
        Abs := value;
    END_IF;
END_FUNCTION
```

## Inout section

The inout section may be declared to pass arguments, for further processing, from the caller to the called [program organization units](./2_program-organization-unit.md#program-organization-unit). Additionally it provides the possibility to store a processing result, generated within the called unit, directly in a variable outside the called unit.

```iecst
VAR_IN_OUT

END_VAR
```

> TIP
>
> This section may be declared by the following program organization units:
>
> - [Method](./2_program-organization-unit.md#method-declaration)
> - [Function](./2_program-organization-unit.md#function-declaration)
> - [Function block](./2_program-organization-unit.md#function-block-declaration)

### Example: Inout variables declaration

```iecst
FUNCTION Abs
    VAR_IN_OUT
        value : INT;
    END_VAR
    IF value < 0 THEN
        value := value * -1;
    END_IF;
END_FUNCTION
```

## Output section

The output section may be used to pass a result from inside the declaring [program organization unit](./2_program-organization-unit.md#program-organization-unit) to its caller. This can be used to pass more than the return value from callee to caller if necessary.

```iecst
VAR_OUTPUT

END_VAR
```

> TIP
>
> This section may be declared by the following program organization units:
>
> - [Program](./2_program-organization-unit.md#program-declaration)
> - [Method](./2_program-organization-unit.md#method-declaration)
> - [Function](./2_program-organization-unit.md#function-declaration)
> - [Function block](./2_program-organization-unit.md#function-block-declaration)

### Example: Output variables declaration

```iecst
FUNCTION Abs
    VAR_INPUT
        value : INT;
    END_VAR
    VAR_OUTPUT
        result : INT;
    END_VAR
    IF value < 0 THEN
        result := value * -1;
    ELSE
        result := value;
    END_IF;
END_FUNCTION
```

> TIP
>
> Differences between inout section and output section:
>
> - For a variable of inout section, its value change inside the POU is directly written to the corresponding variable outside the POU. For a variable of output section, only its final value after execution of POU is written to the corresponding variable outside the POU.
>
> - For [function blocks](./2_program-organization-unit.md#function-block-declaration), a variable of output section is part of the data structure of the function block. Hence it's preserved across multiple cycles and can be accessed even from outside the function block. In contrast, a variable of inout section is just a pointer to the actual variable outside. Therefore it's not preserved.
>
> For more details, see [parameter passing](#parameter-passing).

## Temp section

The temp section may be used to store interim results during the execution of a [program organization unit](2_program-organization-unit.md#program-organization-unit).

> TIP
>
> Values stored inside variables declared in this section will get lost after the execution of the POU.

```iecst
VAR_TEMP

END_VAR
```

> TIP
>
> This section may be declared by the following program organization units:
>
> - [Program](./2_program-organization-unit.md#program-declaration)
> - [Method](./2_program-organization-unit.md#method-declaration)
> - [Function](./2_program-organization-unit.md#function-declaration)
> - [Function block](./2_program-organization-unit.md#function-block-declaration)

### Example: Temp variables declaration

```iecst
FUNCTION Abs : INT
    VAR_TEMP
        tmpValue : INT;
    END_VAR
    ;
END_FUNCTION
```

## Static section

The static section may be used to store values that need to be available among multiple cycles.

> TIP
>
> The expression _static_ does not imply that variables/values are shared by multiple instances. Every instance of a POU declaring this section accesses only its own memory.

```iecst
VAR

END_VAR
```

This section may be declared by the following program organization units:

- [Program](./2_program-organization-unit.md#program-declaration)
- [Class](./2_program-organization-unit.md#class-declaration)
- [Method](./2_program-organization-unit.md#method-declaration)
- [Function](./2_program-organization-unit.md#function-declaration)
- [Function block](./2_program-organization-unit.md#function-block-declaration)

> TIP
>
> In the scope of methods and functions, no static variables will be stored among multiple cycles, therefore the behavior of this section is equivalent to the [temp section](#temp-section).

### Example: Static variables declaration

```iecst
CLASS Motor
    VAR
        displacement : INT;
    END_VAR
END_CLASS
```

### Local constants

Local constants are declared at [POU](./2_program-organization-unit.md#program-organization-unit) level in a `VAR` section by adding the `CONSTANT` keyword to it.

```iecst
FUNCTION Main
    VAR_INPUT
        actual : REAL;
    END_VAR
    VAR CONSTANT
        LocalProcessValue : REAL := REAL#100.0;
    END_VAR

    IF actual > LocalProcessValue THEN
        ;
    END_IF;
END_FUNCTION
```

Local constants behave exactly like [global constants](#global-constants) except that their accessability is restricted to the POU they are declared in.

## Parameter passing

Parameter Passing, or more formally, [evaluation strategy](https://en.wikipedia.org/wiki/Evaluation_strategy), defines how arguments are passed to a [program organization unit](./2_program-organization-unit.md#program-organization-unit).

### Call by value

This evaluation strategy creates a copy of the passed argument. The called [program organization unit](./2_program-organization-unit.md#program-organization-unit) only works on this copy. Any change to the variable won't be directly reflected to the caller.

Sections adhering this evaluation strategy:

- [Input](#input-section)
- [Output](#output-section)

#### Example: Call by value

```iecst
FUNCTION Callee
    VAR_INPUT
        input : Int;
    END_VAR
    VAR_OUTPUT
        output: Int;
    END_VAR
    output := input + 1;
END_FUNCTION

FUNCTION Caller
    VAR_TEMP
        tmp1 : Int;
        tmp2: Int;
    END_VAR
    tmp1 := 1;
    Callee(input := tmp1, output => tmp2);
END_FUNCTION
```

> TIP
>
> This evaluation strategy might cause a higher memory consumption, since additional memory has to be allocated for each parameter. Except for [function blocks](./2_program-organization-unit.md#function-block-declaration), because INPUT and OUTPUT are just the "members" of the block.

### Call by reference

This evaluation strategy does not create a copy of the argument, but passes the actual memory address. The called [program organization unit](./2_program-organization-unit.md#program-organization-unit) works directly on the address provided. Any change to the variable will be directly reflected to the caller.

Sections adhering this evaluation strategy:

- [Inout](#inout-section)

#### Example: Call by reference

```iecst
FUNCTION Callee
    VAR_IN_OUT
        inout : Int;
    END_VAR
    inout := 4;
END_FUNCTION

FUNCTION Caller
    VAR_TEMP
        tmp : Int;
    END_VAR
    tmp := 1;

    Callee(inout := tmp);
    (* tmp has the value 4 *)
END_FUNCTION
```

> NOTICE
>
> This evaluation strategy might cause unexpected behavior, in case the passed arguments are altered unintentionally inside the called [program organization unit](./2_program-organization-unit.md#program-organization-unit).
