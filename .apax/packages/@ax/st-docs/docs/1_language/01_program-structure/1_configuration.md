# Configuration

A configuration is used to abstract the hardware from the software part of the application. It defines all resources of an application and consists of [tasks](#task-configuration), used to describe the order of execution of [programs](./2_program-organization-unit.md#program-declaration) and [global variables](./4_pou-interface.md#global-variables) which declares I/O specific dependencies.

## Configuration declaration

```iecst
CONFIGURATION PLC_1

END_CONFIGURATION
```

![Syntax Diagram](./../diagrams/configDeclaration.svg "Syntax-Diagram")

## Global variables

Are declared inside the configuration. They can, but must not, address hardware. See [global variables](./4_pou-interface.md#global-variables).

## Task configuration

A task is an element of program execution that is executed either periodically or in the event of a rising edge of a `BOOL` variable.
To take effect, a task must get linked to a program with a [program configuration](#program-configuration).

![Syntax Diagram](./../diagrams/taskConfig.svg "Syntax-Diagram")

More powerful task configuration is made available via [target-specific tasks](../08_target-specific-tasks/index.md).

## Program configuration

A program configuration defines the programs of a resource and assigns them to tasks. If no task is assigned, a default cyclic task with lowest priority is automatically generated for the program.

![Syntax Diagram](./../diagrams/progConfig.svg "Syntax-Diagram")

## Example: Configuration declaration

```iecst
CONFIGURATION PLC_1
    TASK Main(Interval := T#1000ms, Priority := 1);
    PROGRAM P1 WITH Main : ExampleProgram;
END_CONFIGURATION
```
