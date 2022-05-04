# Modify (mod)

Use the `mod` command line tool to modify global variables within SIMATIC PLCs.

The `mod` CLI is available via the [Apax package](/docs/apax/packages) `@ax/mod` (which is also part of the Apax package `@ax/sdk`).
Find an example on how to use it in the Desktop IDE [here](/plc-debugging/axcode/debugging-on-plc#modify-values-on-plc).

## Command Line Interface

**_Synopsis_**

```sh
mod -t targetIP -s symbolToModify -v newValue
```

**_Description_**

- **_-?|-h|--help_** Show help information
- **_--version_** Show version information
- **_-t|--targetIP_** The target PLC IP address
- **_-s|--symbol_** The symbol/address to modify
- **_-v|--value_** The value to be set for the symbol/address
- **_-p|--password_** Add a legitimation password for the PLC (e.g. \"-p:MY_PASSWORD\"), note that this password is submitted in clear text. If you use the flag without value (e.g. \"-p\") a secure prompt will appear and you can enter the password in a safe way.
- **_-C|--certificate_** The file containing the public key (exported from TIA Portal) for communicating with the PLC.

> WARNING
>
> - Only global variables can be modified
> - The following data types are currently not supported:
> - string types (`STRING`, `WSTRING`)
> - char types (`CHAR`, `WCHAR`)
> - date time types (`TIME`, `LTIME`, `DATE`, `LDATE`, `TIME_OF_DAY`, `LTIME_OF_DAY`, `DATE_AND_TIME`, `LDATE_AND_TIME`)

> TIP
>
> This command is executed once only and as quickly as possible without reference to a defined position (trigger point) in the user program.

## Example

**_ST File_**

Given the following ST file on the PLC.

```iecst
CONFIGURATION PLC_1
    VAR_GLOBAL
        globalInt : Int;
    END_VAR

    TASK Main(Interval := T#3000ms, Priority := 1);
    PROGRAM P1 with Main : ExampleProgram;
END_CONFIGURATION

PROGRAM ExampleProgram
    VAR_EXTERNAL
        globalInt : Int;
    END_VAR
    globalInt := globalInt + 1;
END_PROGRAM
```

**_Command_**

The following command sets the value of the global variable `globalInt` to 5.

```sh
mod -t 192.168.0.1 -s globalInt -v 5
```
