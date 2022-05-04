# Diagnostics Tool <Badge text="Experimental" type="warn" />

Use the `diag` command line tool to investigate diagnostics after an error on occured on a PLC.

> TIP
>
> The `diag` CLI is available via the [Apax package](/docs/apax/packages) `@ax/diag` (which is also part of the Apax package `@ax/sdk`).

## Command Line Interface

**_Description_**

- **_-?|-h|--help_** Show help information
- **_--version_** Show version information
- **_find-error-location_** Find the source code location that causes a runtime error on the PLC.

### Find source location of error command

**_Synopsis_**

```txt
> diag find-error-location -d diagnosticBufferText -p pathToLoadable
```

**_Description_**

- **_-d|--diagnostic-buffer-text_** The text output in the diagnostic buffer of the PLC
- **_-p|--loadable-path_** The path to the loadable created by the compiler

> TIP
>
> You can get the diagnostics buffer text either by using the PLC Webserver or by using the TIA Portal.

> TIP
>
> Make sure the loadable path matches the active PLC program.

## Example

**_ST File_**

Downloading the following ST file will result in a runtime error because of an out of bounds array access.

```iecst
CONFIGURATION PLC_1
    VAR_GLOBAL
        globalIntArray : ARRAY[0..9] OF INT;
    END_VAR

    TASK Main(Interval := T#3000ms, Priority := 1);
    PROGRAM P1 with Main : ExampleProgram;
END_CONFIGURATION

PROGRAM ExampleProgram
    VAR_EXTERNAL
        globalIntArray : ARRAY[0..9] OF INT;
    END_VAR
    VAR_TEMP
        tempInt : INT;
    END_VAR
    tempInt := globalIntArray[15];  //Array access out of bounds
END_PROGRAM
```

**_Command_**

The following command gets you the source file and the line number of the error.

```txt
> diag find-error-location -d diagnosticBufferText -p pathToLoadable
```

**_Using the Command Line Interface in a Task_**

```json

"version": "2.0.0",
"tasks": [
    {
        "label": "GetDiagnosticsLocation",
        "type": "shell",
        "command": "apax diagnosticsbuffer -d \"${input:diagBufferText}\" -s \"${input:pathToLoadable}\"",
        "problemMatcher": []
    }
],
"inputs": [
    {
        "type": "promptString",
        "id": "diagBufferText",
        "description": "The diagnostics buffer text"
    },
    {
        "type": "promptString",
        "id": "pathToLoadable",
        "description": "The path to the loadable directory"
    }
]

```
