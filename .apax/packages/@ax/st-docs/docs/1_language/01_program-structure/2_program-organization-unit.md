# Program organization unit

A program organization unit (POU) can be used to modularize and structure a portion of the application. The POU has a defined interface with inputs and outputs and may be called and executed several times.

## Program declaration

A program declaration defines a program, its used variables and the executed code body.

```iecst
PROGRAM SampleProgram
    ;
END_PROGRAM
```

![Syntax Diagram](./../diagrams/programDeclaration.svg "Syntax-Diagram")

> TIP
>
> A program may declare the following sections:
>
> - [Temp](./4_pou-interface.md#temp-section)
> - [Static](./4_pou-interface.md#static-section)
> - [External](./4_pou-interface.md#external-section)

Variables declared inside the [Static](./4_pou-interface.md#static-section) section of a program can be declared [retentive](4_pou-interface.md#retentive-variables-retain) to keep it's value even after a power loss.

### Example: Program

```iecst
PROGRAM SampleProgram
    VAR RETAIN
        y : INT := 3;
    END_VAR
    VAR_TEMP
        i : INT;
    END_VAR

    i := 2 * y;
END_PROGRAM
```

## Class declaration

A class is the basic construct to support object-oriented programming in ST. It encapsulates a set of data (field) and behaviors (methods) that belong together as a logical unit. The fields and methods are members of the class.
More in-depth information about object-oriented programming can be found [here](../02_oop/index.md).

```iecst
CLASS Motor

END_CLASS
```

![Syntax Diagram](./../diagrams/classDeclaration.svg "Syntax-Diagram")

> TIP
>
> A class may declare the following sections for its fields:
>
> - [Static](./4_pou-interface.md#static-section)

### Example: Class

```iecst
CLASS Motor
    VAR PRIVATE
        isRunning : BOOL;
    END_VAR
END_CLASS
```

### Class constants

Class constants are constant fields inside a class that are declared by adding the `CONSTANT` keyword to a `VAR` section in the class.
The visibility of these constants may be controlled with [access modifiers](../03_access-modifier.md#access-modifier).
If an access-modifier is used, the syntax is: `VAR CONSTANT ACCESS-MODIFIER` (e.g. `VAR CONSTANT PUBLIC`).

```iecst
CLASS ProcessConstants
    VAR CONSTANT PUBLIC
        ProcessValue1 : REAL := REAL#123.4;
        ProcessValue2 : DWORD := DWORD#16#F00D;
    END_VAR
    VAR CONSTANT PRIVATE
        InternalProcessValue : REAL := REAL#567.8;
    END_VAR

    METHOD PRIVATE Foo
        IF ProcessValue1 > InternalProcessValue THEN
        ;
        END_IF;
    END_METHOD
END_CLASS

FUNCTION_BLOCK Compare
    VAR_INPUT
        actual : REAL;
    END_VAR
    VAR
        constants : ProcessConstants;
    END_VAR

    IF actual > constants.ProcessValue1 THEN
        ;
    END_IF;
END_FUNCTION_BLOCK
```

Class constants behave exactly like [global constants](./4_pou-interface.md#global-constants), except that their accessability is restricted by the visibility of the class field declaration.

## Method declaration

A method is a POU similar to a [function](#function-declaration), but it is only callable with an instance of the declaring class.

```iecst
CLASS Motor
    METHOD PUBLIC Start
        ;
    END_METHOD

    METHOD PUBLIC Stop
        ;
    END_METHOD
END_CLASS
```

![Syntax Diagram](./../diagrams/methodDeclaration.svg "Syntax-Diagram")

> TIP
>
> A method may declare the following sections
>
> - [Input](./4_pou-interface.md#input-section)
> - [Inout](./4_pou-interface.md#inout-section)
> - [Output](./4_pou-interface.md#output-section)
> - [Temp](./4_pou-interface.md#temp-section)
> - [External](./4_pou-interface.md#external-section)

### Example: Method

```iecst
CLASS Motor
    VAR PRIVATE
        isRunning : BOOL;
    END_VAR

    METHOD PUBLIC Start
        isRunning := TRUE;
    END_METHOD

    METHOD PUBLIC Stop
        isRunning := FALSE;
    END_METHOD
END_CLASS
```

## Function declaration

A function is a POU which does not store its state, i.e. inputs, internals and outputs/results. It may or may not additionally declare a return value.

```iecst
FUNCTION Abs : INT
    ;
END_FUNCTION
```

![Syntax Diagram](./../diagrams/functionDeclaration.svg "Syntax-Diagram")

> TIP
>
> A function may declare the following sections
>
> - [Input](./4_pou-interface.md#input-section)
> - [Inout](./4_pou-interface.md#inout-section)
> - [Output](./4_pou-interface.md#output-section)
> - [Temp](./4_pou-interface.md#temp-section)
> - [External](./4_pou-interface.md#external-section)

### Example: Function

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

## Function block declaration

A function block is a program organization unit (POU) which represents for the purpose of modularization and structuring a well-defined portion of the program. Its declaration is similar to that of a [function](#function-declaration) while it is able to persist its state over multiple cycles, like a [class](#class-declaration). Also similar to a class, it may have multiple instances, each of which preserves its own state.

![Syntax Diagram](./../diagrams/functionBlockDeclaration.svg "Syntax-Diagram")

> TIP
>
> A function block may declare the following sections
>
> - [Static](./4_pou-interface.md#static-section)
> - [Input](./4_pou-interface.md#input-section)
> - [Inout](./4_pou-interface.md#inout-section)
> - [Output](./4_pou-interface.md#output-section)
> - [Temp](./4_pou-interface.md#temp-section)
> - [External](./4_pou-interface.md#external-section)

The behavior of a function block differs from a function. While all variables in a function are only valid in the function's scope, the variables of a function block remain valid outside its scope. Hence, a function block also defines a struct, containing the variables of the sections `VAR_INPUT`, `VAR_OUTPUT` and `VAR`. Variables declared in `VAR_IN_OUT` or `VAR_TEMP`are not part of that struct, hence they are only available inside the function block.

The accessibility rules to the fields of such a struct and the possibility to issue a call to a function block instance are as follows:

- Variables declared in `VAR` section are only accessible inside the function block.
- A call of a function block instance is not allowed, if the instance is declared in the `VAR_INPUT` section. Also the modification of the instance is not allowed.
- Variables declared in the `VAR_OUTPUT` section of a function block are only writable inside that function block.
- To call an instance of a function block, you may omit actual parameters for `VAR_INPUT` and `VAR_OUTPUT` partly or completely.

In the following example, please note the change of values after each call of the function block instance due to its preservation of input, output and static variables.

### Example: Function block

```iecst
PROGRAM P1
    VAR
        increaseInstance: Increase;
        res: INT;
    END_VAR
    IncreaseInstance(x:=1);          //increaseInstance.x=1, increaseInstance.s=1, increaseInstance.y=1
    IncreaseInstance();              //increaseInstance.x=1, increaseInstance.s=2, increaseInstance.y=3
    increaseInstance(x:=7, y=>res);  //increaseInstance.x=7, increaseInstance.s=9, increaseInstance.y=12, res=12
    res:=increaseInstance.x;         //res=7
END_PROGRAM

FUNCTION_BLOCK Increase
    VAR_INPUT
        x : INT;
    END_VAR
    VAR_OUTPUT
        y : INT;
    END_VAR
    VAR
        s : INT;
    END_VAR
    s := s + x;
    y := y + s;
END_FUNCTION_BLOCK
```
