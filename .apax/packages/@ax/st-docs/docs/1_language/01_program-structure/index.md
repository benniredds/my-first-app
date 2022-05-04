# Program structure

ST supports you in modularizing and structuring your program by providing several code elements.

> TIP
>
> For the sake of simplicity, the following code samples only contain the minimal skeleton of the respective element. Contained elements, e.g. the interface or statements, are left out intentionally.

## Example program

A minimal program that assigns the first input word to the third output word look like that:

```iecst
CONFIGURATION PLC_1
    VAR_GLOBAL
        In AT %IW0 : INT;
        Out AT %QW2 : INT;
    END_VAR
    TASK Main(Interval := T#1000ms, Priority := 1);
    PROGRAM P1 WITH Main : ExampleProgram;
END_CONFIGURATION

PROGRAM ExampleProgram
    VAR_EXTERNAL
        In : INT;
        Out : INT;
    END_VAR
    Out := In;
END_PROGRAM
```
