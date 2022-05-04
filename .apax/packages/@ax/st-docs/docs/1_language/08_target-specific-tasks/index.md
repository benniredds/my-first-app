# Target-specific tasks

Certain target systems provide very specific and powerful ways to trigger program execution. One example of this is the support for Isochronous Realtime Communication between several Profinet-based devices (e.g. PLCs, IO devices and drives).

> TIP
>
> More information about the SIMATIC S7-1500 and its functionalities relating to tasks and process images can be found in the [SIMATIC System Manual](https://sie.ag/2P6LR3U).

As mentioned above this kind of functionality is not available on all target systems. Because of that, support for such target-specific tasks is not baked into our tool chain but instead delivered separately.

## S7-1500 task library

This task library provides support for tasks specific to the S7-1500 line of PLCs.

### Installation

via [Apax](/docs/apax):

```sh
apax add @ax/simatic-1500
```

### Tasks

#### ProgramCycle

Programs scheduled with this task are executed within the program cycle of the target PLC.

_Example usage:_

```iecst
CONFIGURATION Cfg
    TASK MyProgramCycleTask : Siemens.Simatic.S71500.Tasks.ProgramCycle;
    PROGRAM MyCyclicProgram WITH MyProgramCycleTask : Prg;
END_CONFIGURATION

PROGRAM Prg
    ;
END_PROGRAM
```

#### CyclicInterrupt

Programs scheduled with this task are executed in a cyclic manner.

_Configuration parameters:_

| Name                  | Data type | Description                                            |
| --------------------- | --------- | ------------------------------------------------------ |
| CycleTime             | TIME      | Time interval between two calls.                       |
| PhaseOffset           | TIME      | Time interval offset.                                  |
| ProcessImagePartition | UINT      | The process image partition assigned to this task.     |
| EventPriority         | USINT     | Priority of the task. Higher value is higher priority. |

> StartTime = n \* CycleTime + PhaseOffset {n = 0, 1, 2 ... }

_Example usage:_

```iecst
CONFIGURATION Cfg
    TASK MyInterruptTask : Siemens.Simatic.S71500.Tasks.CyclicInterrupt := (
        CycleTime := T#100ms,
        PhaseOffset := T#13ms,
        ProcessImagePartition := UINT#16#FFFF,
        EventPriority := USINT#13
    );
    PROGRAM MyProgram WITH MyInterruptTask : Prg;
END_CONFIGURATION

PROGRAM Prg
    ;
END_PROGRAM
```

#### IsochronousInterrupt

Programs scheduled with this task are executed within a synchronous cycle.

> TIP
>
> To use this task you first need to configure a sync domain in your hardware configuration. [TIA instructions here.](1_synchronous-tasks-tia-instructions.md)
>
> More information about SIMATIC and PROFINET functionality can be found [here](https://sie.ag/2Paxfkk).

_Configuration parameters:_

| Name                  | Data type | Description                                                                                    |
| --------------------- | --------- | ---------------------------------------------------------------------------------------------- |
| IoSystemNumber        | USINT     | The IO system number for the sync domain. Can be retrieved from hardware configuration.        |
| ProcessImagePartition | UINT      | The process image partition for the sync domain. Can be retrieved from hardware configuration. |
| DelayTime             | TIME      | The communication delay time of the sync domain. Can be retrieved from hardware configuration. |
| CycleReductionFactor  | UINT      | The factor that describes after how many cycles to trigger program execution.                  |
| EventPriority         | USINT     | Priority of the task. Higher value is higher priority.                                         |

_Example usage:_

```iecst
CONFIGURATION Cfg
    TASK MySynchronousCycleTask : Siemens.Simatic.S71500.Tasks.IsochronousInterrupt := (
        IoSystemNumber := USINT#100,
        ProcessImagePartition := UINT#1,
        DelayTime := TIME#12345ns,
        CycleReductionFactor := UINT#2,
        EventPriority := USINT#21
    );
    PROGRAM MySynchronousCycleProgram WITH MySynchronousCycleTask : Prg;
END_CONFIGURATION

PROGRAM Prg
    ;
END_PROGRAM
```
