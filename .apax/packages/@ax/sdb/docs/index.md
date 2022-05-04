# Debug (sdb)

## Security Disclaimer

> WARNING
>
> Currently it is not possible to distinguish between different instances on the PLC (e.g.: debugging a variable of a class that is instantiated multiple times). Therefore it can not be determined which instance is debugged.

## Prerequisites

[See here](/docs/get-started/prerequisites)

Use the `sdb` command line tool to watch variables within SIMATIC PLCs inside your ST code.

> WARNING
>
> The error message `No debug information found` indicates that either no debug information exists or it's in the wrong format.
>
> Don't forget to compile your source code with debug information by setting the compiler option `-d, --debug`). 
> You can do this by adding the following to the `variables` section in your `apax.yml`: `APAX_BUILD_ARGS: [ --debug ]`
>
> Also **don't** compile with the `--Optimize, -O` compiler option, since this will break some debug features.
>
> See [`stc` documentation](/docs/st/cli#command-line-interface) and [`apax.yml` reference](/docs/apax/yml#variables)for more information.

> TIP
>
> The `sdb` CLI is available via the [Apax package](/docs/apax/packages) `@ax/sdb` (which is also part of the Apax package `@ax/sdk`).
> Find an example on how to use it in the Desktop IDE [here](/docs/axcode/debugging-on-plc#debugging-values-on-plc).

## How it works

Each `watch add` command creates watchpoints that trigger on each execution of the line. For every function that includes any watchpoint there is one watchjob installed on the PLC. That means that when you set a watchpoint in a function that didn't have a watchpoint yet, the sdb creates a watchpoint in this line and a watchjob for this function and installs it on the PLC.

The debugger collects values every cycle, but for performance reasons only sends about 10 results per second.

If a watchpoint is in a code branch that is not executed (e.g. an if statement that is not reached) it will show an invalid value and return an age greater than zero. The age of the value retrieved from the executed line will be shown in brackets at the end of each value information (e.g. (0)).

## Command Line Interface

### Start Debugger Session

**_Synopsis_**

First, start the debugger session with the following command:

```sh
sdb -t targetIP
```

**_Description_**

- **_-?|-h|--help_** Show help information
- **_--version_** Show version information
- **_-t|--targetIP_** The target PLC IP address
- **_-s|--symbolsPath_** The symbol path, if not set the debug symbols are loaded from the PLC.
- **_-p|--password_** Add a legitimation password for the PLC (e.g. \"-p:MY_PASSWORD\"), note that this password is submitted in clear text. If you use the flag without value (e.g. \"-p\") a secure prompt will appear and you can enter the password in a safe way.
- **_-C|--certificate_** The file containing the public key (exported from TIA Portal) for communicating with the PLC.
- **_-b|--baseFolder_** Use this for source path remapping: The folder where the project has been compiled. This should be the same path as used in 'stc -i'-option. --remappingPath also have to be specified when using this option.
- **_-r|--remappingPath_** Use this for source path remapping: The target directory where your source code is located now. --baseFolder also have to be specified when using this option.
- **_-o|--output_** Specify how the monitor data will be formatted on the console. If not specified, the user-friendly format will be used.
  - The following values are supported:
    - "json" - This is the default and will provide a json format.
    - "user" - will show the values in a user-friendly format.

### Add and Remove Watch Points

The CLI provides commands for adding and removing watch points.
After the debugger session has started you can use the following commands.

**_Synopsis_**

Add and accordingly remove a watch point at a function:

```sh
watch add <function> <variables>
watch remove <function> <variables>
```

Add and accordingly remove a watch point at a line number in a ST file:

```sh
watch add <filepath>:<line>:<checksum> <variables>
watch remove <filepath>:<line>:<checksum> <variables>
```

**_Description_**

- **filepath** The path to the specific st file that should be debugged. When using a relational path, the debugger will try to find the right file. For more complicated path scenarios, check the next chapter [Source Path Remapping](#source-path-remapping).
- **line** The line in the source file where the variables should be watched, starting at 1.
- **checksum** (optional) The MD5 checksum of the source file. You will need st-compiler v2.x for it to work. "watch add" will fail if checksum does not align with checksum in debug info.
- **variables** Add one or more variables, separated by ';' (e.g. watch add myFunction variable1;variable2)

### Symbols Path

Normally the debug symbols are loaded form the PLC, therefore no symbol path is needed.
If the debug symbols are not available to the PLC (e.g. when debugging a library) the .lib file including the debug symbols can be used as symbol path.

### Source Path Remapping

When building a project on your machine with the stc --debug flag set, the STC will generate debug information. This debug information contains a mapping from your ST-Code variables to a physical address on the PLC. This mapping contains the location (path, filename, linenumber) of an variable in the code. The path is specific to the machine where the code has been built.
If you want to debug code on a PLC from a different environment than it has been built on, it might be necessary to apply source path remapping. With source path remapping it is possible to replace the source paths in the debug information with new paths.
Source path remapping may also be helpful when having more complex folder structures.

#### Remap on start

You can remap the folder structure on starting the sdb with the `-b|--baseFolder` and `-r|--remappingPath`.

Example:

```sh
sdb --targetIP 192.168.0.1 --baseFolder /home/path/to/online/workspace --remappingPath c:/path/to/local/workspace
```

#### Remap while sdb is running

With the `set source-map` command you can also remap your source path while the debugger is already running.

**_Synopsis_**

```sh
set source-map <path-from> <path-to>
```

**_Description_**

- **path-from** The path where the original ST data (including debug information) was stored. Has to be the same path as provided to the 'stc -i'-option.
- **path-to** The path where you want to redirect the sources to. This would probably be the directory where you are debugging from.

**_Example_**

```sh
set source-map /home/path/to/online/workspace c:/path/to/local/workspace
```

### Json output

Selecting Json as format changes all output to json.
Each line represents a well formed json-object. Therefore you can read each line as an independent object.
Here is an example how the json-output format is printed at stdout:

```sh
watch add D:\AX\DocuAdapt\CombinedTestProject\src\config.st:48 myInt
```

This will create output similar to the following (the output has been reduced for clarity):

```console
{
    "DebugLocationName": "...\\src\\test.st:48",
    "ResultAge": 0,
    "UserSymbolInputResults": [
        {
            "UserSymbolInput": "myInt",
            "TypeResults": [
                {
                    "ElementName": "myINT",
                    "HasError": false,
                    "HasValue": true,
                    "Value": "2631",
                    "TypeName": "INT",
                    "ChildTypeResults": [],
                    "HasChildTypeResults": false,
                    "ClassType": "TypeResultDto"
                }
            ],
            "ClassType": "UserSymbolInputResultDto"
        }
    ],
    "ClassType": "WatchPointResultDto"
}
```

### Stop Debugger Session

Stop the debugger session with the following command:

```sh
exit
```

## Limitations

The debugger doesn't support:

- Debugging of any interface-type
- Debugging of REF_TO types

> WARNING
>
> Trying to debug variables of interface-types or REF_TO types will result in the error message `UnknownSymbol`. When debugging classes that contain members of these types, the members will not be shown in any way.

The logpoints are also limited to maximum:

- 16 functions
- 50 logpoints per function
- 50 variables per logpoint
- 200 variables per function
