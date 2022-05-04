# `stc` Command Line Reference

The `stc` command line tool is used to compile ST programs for further download onto SIMATIC PLCs.

`stc` outputs a _loadable_, which consists of a `loadable.json` file (meta information), and a set of `.bin` files (mc7+ binary code).

## Command Line Interface

**_Synopsis_**

```sh
stc -i directory ... -t target [-o output_folder] [-1] [-O] [-l log_level] [-s] [--lib library file] [--compile-to <type>:<name>:<semver>]
```

**_Description_**

- **_-?, -h, --help_** Show help information
- **_--version_** Show version information
- **_--input, -i_** A directory, containing all source files to be compiled. Multiple input parameters are allowed. **Mandatory.**
- **_--output, -o_** The directory where all compile artifacts are output to. If omitted, an "output" subfolder will be automatically created in the current working directory.
- **_--enable-feature_** Enable not-yet-released features. Use at your own risk. Available features: None, Warn4RetValAssign, SupportCaseStatement.
- **_--1core, -1_** Forces the compiler to run with 1 processor core only. If omitted, all available cores are used.
- **_--log, -l_** Controls the output verbosity of the compiler. Defaults to `Information`. Supported values: `Trace`, `Debug`, `Information`, `Warning`, `Error`, `Critical`, `None`.
- **_--Optimize, -O_** Enables selected optimizations for target code generation. If omitted, no optimizations are performed. This option can be used as a flag, in which case `Full` optimizations are used. You can also specify the value explicitly with `-O=value`. Supported values: `None`, `Full`.
- **_--target, -t_** Specifies for which target to compile. Run `stc -h` for a list of available targets. Currently you can choose between `-t 1500` and `-t llvm`. **Mandatory.**
- **_-s, --simulation_** Specifies to compile to the PlcSim Advanced simulation target. Use only in conjunction with `-t 1500`.
- **_-d, --debug_** Generates debug information.
- **_--lib_** Specifies a library file to be linked during code generation. The option can appear multiple times to pass multiple libraries. See [Libraries](#libraries).
- **_--compile-to_** Generates a versioned app or lib package. The argument must be of the form `<type>:<name>:<semver>`.Where `<type>` must either be `app` or `lib`. If omitted, a default app package will be created.
  - `--compile-to app:MyApp:1.0.3`: will create the app package _MyApp.app_ in version 1.0.3.
  - `--compile-to lib:MyLib:2.3.3-prerelease`: will create the lib _MyLib.lib_ in version 2.3.3-prerelease.

**NOTE: The Know-How Protection of blocks can be weakened by a simulation.**

> TIP
>
> Artifacts compiled with target option `-t llvm` cannot be downloaded to a PLC.

## Control Diagnostics

You can control the severity of some diagnostics via additional command line options:

- **-fwarn-output-not-assigned**: Generate a warning if output variables are not assigned.
- **-ferror-implicit-conversion**: Generate an error if implicit conversions occur.
- **-fignore-implicit-conversion**: Don't generate a warning if implicit conversions occur.

> TIP
>
> Please let us know if you think fine-grained control of diagnostics is valuable to your project.

## Examples

```sh
stc -i input -o gen -t 1500
```

Compiles all ST files in the folder `input` into a loadable inside folder `gen` targeting `1500` PLCs.

```sh
stc -i myProgram -i myLibrarySrc -o gen -t 1500
```

Compiles all ST files in the folders `myProgram` and `myLibrarySrc` into a loadable inside folder `gen` targeting `1500` PLCs.

```sh
stc -i myProgram --lib drive.lib --lib sys.lib -o gen -t 1500
```

Compiles all ST files in the folders `myProgram` into a loadable inside folder `gen` targeting `1500` PLCs. The binary libraries `drive.lib` and `sys.lib` are considered to produce the final loadable binary.

## Libraries

> TIP
>
> Library support is at a very early stage.
>
> - There is no guarantee that a library created with a previous version of `stc` is compatible with a later version. So, another compile run after a version update might be necessary.
>
> - Make sure to only use libraries that match the target, i.e. do not use a library, which is generated with `-t llvm`, in an executable to generate with `-t 1500`, and vice versa.

By adding support for libraries the `stc` can produce two different kinds of output.

### Library

A library is a collection of reusable functionality. It differs from an executable:

- A library is a way to modularize software, hence it should describe its provided functionality semantically. Namespaces are a good means to do so. It is not possible to have a library without a namespace, nor a library with more than one top level namespace. Underneath the top level namespace it can have an arbitrary amount of child namespaces.

- It can contain classes, functions or type definitions. It **cannot** contain a `CONFIGURATION` or a `PROGRAM` and no global variables as its functionality can only be executed within an [executable](#executable).

- As long as the library artifact (.lib-file) lies inside the project workspace, its contents (classes, functions or type definitions) will automatically take effect for the project.

```iecst
NAMESPACE Engine.Drives
    CLASS Drive
        METHOD PUBLIC Operate
            // Operate logic
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE

NAMESPACE Engine.Control
    // Functions for control algorithms
END_NAMESPACE
```

#### Using APAX

The preferred way for producing a library is to use the [APAX](/docs/apax) package manager. After creating an `apax.yml` in the source directory of the library source we set the type of the project type to `lib` and the `apax build` command will produce a library package.

```yml{3}
version: 0.0.1
name: engine
type: lib
targets:
  - "1500"
dependencies:
  "@ax/ax.platform": latest
  "@ax/stc.target.mc7plus": latest
registries:
  "@ax": <YOUR-REGISTRY-URL>
```

```sh
apax build
```

#### Using STC command line

To instruct `stc` to produce a library and not an executable, the `--compile-to-lib` command line option can be used. `stc` will recognize this option and output a library package instead of a loadable. This package can then be used as a referenced library via `--lib` command line option.

Taking the source code from above, it can be compiled to a library by running the following command:

```sh
stc -i engineSrc -o bin -t 1500 --compile-to-lib engine:1.0.0
```

This will create the `engine.lib` in the specified output directory.

### Executable

An executable is a program that can be downloaded and executed on a PLC as usual. These programs usually have a `CONFIGURATION` and they can use global variables. The executable can refer to libraries for reusing implementations. These implementations are downloaded together with the executable files in a consistent way.

> TIP
>
> To ensure consistency, delta download of parts of the program (e.g. libraries) is not supported, yet.

```iecst
CONFIGURATION Plant
    PROGRAM P : EngineControl;

    VAR_GLOBAL
        // Using types from namespace "Engine"
        drive1 : Engine.Drives.Drive;
        drive2 : Engine.Drives.Drive;
    END_VAR
END_CONFIGURATION

PROGRAM EngineControl
    drive1.Operate();
END_PROGRAM
```

Compile the `plant` executable with functionality imported by `engine.lib`. Then download everything to run the plant.

```sh
stc -i plant --lib engine.lib -o plant\gen -t 1500
sld -t 192.168.0.1 -i plant\gen --accept-security-disclaimer
```

### Currently known limitations

- Despite of language server, there is neither IDE nor test explorer support for an executable that depends on libraries.
