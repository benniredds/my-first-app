# Monitor (mon)

Use the `mon` command line tool to monitor variables within SIMATIC PLCs.

## Security Disclaimer

> WARNING
>
> The monitor may be not able to update the values at each cycle of the PLC. The minimum refresh rate is 100 ms. Depending on the configured cycle time the monitor can miss values.

## Prerequisites

[See here](/docs/get-started/prerequisites)

## Command Line Interface

**_Synopsis_**

```sh
mon -t targetIP -f path_to_monitor_file [-c]
```

**_Description_**

- **_-?|-h|--help_** Show help information
- **_--version_** Show version information
- **_-t|--targetIP_** The target PLC IP address to monitor on
- **_-f|--file_** The file containing the symbols/addresses to get or monitor values
- **_-s|--symbols_** List of variables to monitor, separated by spaces, e.g. -s "var1 var2 var3".
- **_-c|--continuously_** Set this flag to monitor continuously. If not set values will be requested per oneshot. Default: false.
- **_-o|--output_** Defines the output format. Currently providing json and table support. Default: table.
- **_-p|--password_** Add a legitimation password for the PLC (e.g. \"-p:MY_PASSWORD\"), note that this password is submitted in clear text. If you use the flag without value (e.g. \"-p\") a secure prompt will appear and you can enter the password in a safe way.
- **_-C|--certificate_** The file containing the public key (exported from TIA Portal) for communicating with the PLC.

> TIP
>
> You can exit the mon CLI by pressing the key `x`.

> TIP
>
> - When monitoring continuously (**_-c|--continuously_**) and the PLC is in RUN the outputs are monitored at the start of the cycle and the inputs and all other addresses at the end of the cycle. If the PLC is in STOP the addresses are monitored all together.
> - When monitoring oneshot (default) the addresses are monitored all together, immediately and once only.

### Monitor File

The monitor file (.mon) is a text file containing the list of variables (symbols and absolute addresses) that you want to monitor. Each line refers to one variable and is either:  
(1) a symbol name (of an [elementary type](/docs/st/language/types-and-variables#supported-elementary-data-types), a [structured type](/docs/st/language/types-and-variables#structured-type) or an [array](/docs/st/language/types-and-variables#array))  
(2) an absolute address along with its [ST type information](/docs/st/language/types-and-variables#supported-elementary-data-types).  
Note that you can also mark a line as comment by starting with `#`.

**_Format_**

```sh
<symbolName>
<symbolNameOfStructuredType>
<symbolNameOfStructuredType>.<symbolNameOfField>
<symbolNameOfArray>
<symbolNameOfArray>[arrayIndex]
<symbolNameOfArray>[arrayIndex, *, arrayIndex]
<absoluteAddress>:<type>
# this is a comment
```

## Errors

The following errors are handled by the mon CLI.

| Error Code                          | Description                                                                            |
| ----------------------------------- | -------------------------------------------------------------------------------------- |
| `UnknownSymbol`                     | The `<symbolName>` was not found on the PLC.                                           |
| `UnsupportedType`                   | Symbols of `<type>` are currently not supported.                                       |
| `AbsoluteAddressInvalid`            | The `<absoluteAddress>` is malformed.                                                  |
| `AbsoluteAddressUnknownType`        | The `<type>` is unknown.                                                               |
| `AbsoluteAddressTypeMismatch`       | The size specifier of the `<absoluteAddress>` does not match the size of the `<type>`. |
| `AbsoluteAddressMissingType`        | The `<type>` of the `<absoluteAddress>` is missing.                                    |
| `ElementOfArrayIsOutOfBoundary`     | The `<arrayIndex>` of the `<symbolNameOfArray>` is out of boundary.                    |
| `DimensionCountOfArrayDoesNotMatch` | The number of dimensions of the `<symbolNameOfArray>` is wrong.                        |
| `OnlyOneWildcardIsSupported`        | The `<symbolNameOfArray>` supports only one wildcard `*` as arrayIndex.                |
| `AddressSignatureMismatch`          | The program on the PLC was changed and does no longer match the symbol information.    |
| `AddressBlockOrAreaNotExisting`     | The addressed data block or data area is not existing.                                 |
| `AddressBlockOrAreaTooShort`        | The addressed data block or data area is too short.                                    |
| `AddressOverlapsModuleBoundary`     | The symbol overlaps the boundaries of an IO module.                                    |
| `AddressAccessTimeout`              | A timeout occured while accessing the symbol.                                          |
| `AddressOnlyPartiallyAccessible`    | The symbol is bigger than the the accessable memory, and is only partly valid          |
| `ReplacedValue`                     | The actual value is overwritten by a configured replace value.                         |
| `PartiallyReplacedValue`            | The actual value is partly overwritten by a configured replace value.                  |

## Example

**_ST File_**

Given the following ST file on the PLC.

```iecst
CONFIGURATION PLC_1
    VAR_GLOBAL
        myBOOL : BOOL;
        myINT : INT;
        myDINT : DINT;
        myLINT : LINT;
        mySINT : SINT;
        myUINT AT %MW3 : UINT;
        myUDINT : UDINT;
        myULINT : ULINT;
        myUSINT : USINT;
        myREAL : REAL;
        myLREAL : LREAL;
        myMotor : Motor;
        mySimpleArray : ARRAY [0..2] OF BOOL;
        myArray : ARRAY [0..1, 1..2] of INT;
    END_VAR

    TASK Main(Interval := T#3000ms, Priority := 1);
    PROGRAM P1 WITH Main : SampleProgram;
END_CONFIGURATION
TYPE
    Motor : STRUCT
        is_running        : BOOL;
        power_consumption : REAL;
        hours_operating   : INT;
    END_STRUCT;
END_TYPE
PROGRAM SampleProgram
    VAR_EXTERNAL
        myBOOL : BOOL;
        myINT : INT;
        myDINT : DINT;
        myLINT : LINT;
        mySINT : SINT;
        myUINT : UINT;
        myUDINT : UDINT;
        myULINT : ULINT;
        myUSINT : USINT;
        myREAL : REAL;
        myLREAL : LREAL;
        myMotor: Motor;
        mySimpleArray : ARRAY [0..2] OF BOOL;
        myArray : ARRAY [0..1, 1..2] of INT;
    END_VAR

    myINT := myINT + 3;
    myDINT := DINT#-56;
    myLINT := LINT#512;
    mySINT := SINT#-5;
    myUINT := myUINT + UINT#10000;
    myUDINT := UDINT#512;
    myULINT := ULINT#512;
    myUSINT := USINT#5;
    myREAL := REAL#5.0;
    myLREAL := 3.14159;
    myMotor.is_running := true;
    myMotor.power_consumption := REAL#10.0;
    myMotor.hours_operating := 255;
    IF myINT MOD 2 = 0 THEN
        myBOOL := TRUE;
    ELSE
        myBOOL := FALSE;
    END_IF;

    mySimpleArray[0] := TRUE;
    mySimpleArray[1] := FALSE;
    mySimpleArray[2] := TRUE;
    myArray[0,1] := 1;
    myArray[0,2] := 2;
    myArray[1,2] := 5;
END_PROGRAM
```

**_Command_**

```sh
mon -t 111.222.333.444 -f C:\myMonitorFile.mon -c
```

**_Monitor File (C:\myMonitorFile.mon)_**

The following example shows a possible monitor file, which specifies the variables to be monitored.

```sh
myBOOL
myINT
myDINT
# this is a comment
# myLINT
mySINT
myUINT
myUDINT
myULINT
# myUSINT
myREAL
myLREAL
myImaginarySymbol
%IW0:sint
%QW0
%MW3:UInt
%I0.1:boll
%Q2.1:BOOL
%M0.1:Bool
%J3.4:Bool
myMotor
myMotor.is_running
myMotor.power_consumption
myMotor.hours_operating
mySimpleArray
myArray[1,2]
myArray[0,*]
myArray[1,2,3]
myArray[1,100]
myArray[*,*]
```

**_Table Output Format_**

The `mon` utility will output the data in a table like format by default.
The command shown above continuously lists the current values of the variables specified in C:\myMonitorFile.mon as well as detected errors as shown in the following example.

```sh
myBOOL -> True
myINT -> 156
myDINT -> -56
mySINT -> -5
myUINT -> 61248
myUDINT -> 512
myULINT -> 512
myREAL -> 5
myLREAL -> 3.14159
%MW3:UInt -> 61248
%Q2.1:BOOL -> False
%M0.1:Bool -> False
myMotor:
   myMotor.is_running -> True
   myMotor.power_consumption -> 10
   myMotor.hours_operating -> 255
myMotor.is_running -> True
myMotor.power_consumption -> 10
myMotor.hours_operating -> 255
mySimpleArray:
   mySimpleArray[0] -> True
   mySimpleArray[1] -> False
   mySimpleArray[2] -> True
myArray[1,2] -> 5
myArray[0,*]:
   myArray[0,1] -> 1
   myArray[0,2] -> 2
myArray[*,*]:
   myArray[0,1] -> 1
   myArray[0,2] -> 2
   myArray[1,1] -> 0
   myArray[1,2] -> 5
====================================================
=                  Warnings/Errors                 =
====================================================
myImaginarySymbol -> UnknownSymbol
%IW0:sint -> UnsupportedType
%QW0 -> AbsoluteAddressInvalid
%I0.1:boll -> UnsupportedType
%J3.4:Bool -> AbsoluteAddressInvalid
myArray[1,2,3] -> DimensionCountOfArrayDoesNotMatch
myArray[1,100] -> ElementOfArrayIsOutOfBoundary
```

**_Json Output Format_**

Selecting Json as format changes all output to json.
Each line represents a well formed json-object. Therefore you can read each line as an independent object.
Here is an example command that sets json as output format:

```sh
mon -t targetIP -s listOfSymbols -c --output:json
```

This will create output similar to the following (symbol names and values depend on the monitoring file; the output has been reduced for clarity):

```console
{
    "CommandName": "Monitor values",
    "CommandState": "Running",
    "ClassType": "CommandInfoDto"
}
{
    "UserSymbolInputResults": [
        {
            "UserSymbolInput": "myBOOL",
            "TypeResults": [
                {
                    "ElementName": "myBOOL",
                    "HasError": false,
                    "HasValue": true,
                    "Value": "True",
                    "TypeName": "BOOL",
                    "ChildTypeResults": [],
                    "HasChildTypeResults": false,
                    "ClassType": "TypeResultDto"
                }
            ],
            "ClassType": "UserSymbolInputResultDto"
        },
    ],
    "ClassType": "MonitorJobResultDto"
}
{
    "CommandName": "Monitor values",
    "CommandState": "Completed",
    "ClassType": "CommandInfoDto"
}
```

**_Redirect Output_**

To be able to access the monitored data within a third party tool, you can redirect the the output to a file or use it as input stream for another application.

The following command will redirect the monitor data to a file:

```sh
mon -t targetIP -f path_to_monitor_file -c -o:json >> MonitorData.json
```

## Limitations

The monitor doesn't support:

- Monitoring of any interface-type
- Monitoring of REF_TO types
- More than 200 variables per monitor file

> WARNING
>
> Trying to monitor variables of interface-types or REF_TO types will result in the error message `UnknownSymbol`.
> When monitoring classes that contain members of these types, the members will not be shown in any way.
