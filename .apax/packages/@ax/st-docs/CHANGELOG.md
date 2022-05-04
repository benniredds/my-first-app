# Changelog

### 2.4 (2022-03-15)

### Fixed

- HA-1900: Fix initialization of array of structs/classes from libraries.
- HA-1953: Fix unsafe assignment from temp reference to temp reference.
- HA-1987: Problems with REF_TO ARRAY \*.
- HA-1988: Fix STC crash when compiling only with `-f text` for target 1500.

# Changed

## 2.3 (2022-02-22)

### Added

- HA-1046: Add the feature of reference to array of variable length.

### Fixed

- HA-1828: Fix the conversion error when initializing a REAL or LREAL variable with integer expression.
- HA-1891: Fix a semantical error in a code example for usages of abstract classes.
- HA-1792: The block quotes in the documentation are now follow warning notice system definitions.
- HA-1860: Fix wrong WSTRING length when initializing WSTRING variable with max capacity larger than 256 wchars.

### Changed

- HA-1792: Remove extra files being copied to output folder.

## 2.2 (2022-02-08)

### Added

### Fixed

- HA-1612: Fixed missing return statement
- HA-1478: Fixed App-file locking on Windows.
- HA-1400: Fix intrinsic functions of shift/rotate regarding using variable as index and others.

## 2.1 (2021-11-26)

### Added

### Fixed

- HA-891: Fixes crash due to too large number. Now compiler throws error in case of overflow.
- HA-1478: Fixed App-file locking on Windows

## 2.0 (2021-11-05)

This release contains breaking changes that requires a rebuild of libraries.

### Added

- HA-279: Fix collision detection of private methods in derived classes. In such cases OVERRIDE is not required anymore.
- HA-139: Create checksums for each source file in debug info.
- HA-1028: Support for declaring string variables in VAR CONSTANT.

### Changed

- HA-293: _BREAKING_: Changed library encryption to standard .NET encryption algorithm.
- HA-323: Add explicit lock support to make sure the app package stays consistent during longer running operations.

### Fixed

- HA-1205: Fix string encoding in STC for special characters
- HA-1028: Fix crash in case no explicit conversion for variable initializer in constant section, which is then used as array index
- HA-1121: _BREAKING_: Fix errors regarding assignment attempts between class and interface. Add member "inst_byte_size" to class descriptor, so libraries including classes and interfaces need to be recompiled.

## 1.25 (2021-10-07)

### Added

- HA-772: Add support for retentive variables in `VAR_GLOBAL` and in `VAR` sections of a `PROGRAM`. Currently `RETAIN` and `NON_RETAIN` can only be specified at a variable and not at type level.
- CA-910: New MC7+ target attribute 'signature' that allows to set a signature for a function instead of calculating it by its paramters.

### Fixed

- HA-94: Initialize local memory according to variable type instead of byte after byte, so that further optimization works.
- HA-1019: Fix and optimize the generated MC7+ code:
  - Grant the pointer correct length for return value of intrinsic function, so that assign attempt (?=) of interface to interface works properly.
  - Grant the pointer correct length for persistent reference => persistent reference => interface descriptor.
  - Remove unnecessary preserving of references before comparing temp "ref to interface".

### Changed

- HA-293: Change the way library code is encrypted. The compiler knows how to read libraries using the old format, but will write libraries in an updated format. Support for the old format will be dropped some time in the future.

## 1.24 (2021-09-09)

### Added

- HA-745: support all conversions regarding ANY_CHAR.

### Fixed

- HA-882: Removed regrant of instance in functions with instance parameter in MC7+.
  - We cannot set the grant length by the static type of the class inside a method. This would prevent dynamic casts on "THIS" in a base class method if the instance of "THIS" is a derived class that implements different interfaces. Then the grant length of the static type of the base class is too short for the cast.
- CA-825: Use CONSTANT of NamedValue Type as function parameter is working fine now.
- HA-983: enhance library handling in STC when loading dependent libraries:
  - Respect dependencies between libraries and do not depend on the order of command line arguments
  - Report an error if a dependent library, including version information, is missing
  - Report an error on cyclic dependencies between libraries
  - Report an error on version mismatches of dependent libraries
- HA-959: the type name of an anonymous array type was assembled using the element type symbol and not declaration name. This lead to different casings on type names.
- HA-956: bugfix for overload resolution for arguments that are named values lead to change in overload resolution. Overloading now prefers the functions/methods with the least amount of implicit conversions (prior, those functions/methods were ignored that lead to the bug).

### Removed

- HA-762: Public API `IStorageDeclaration.IsReadOnly`, use `IStorageDeclaration.IsDeclaredReadOnly` instead.
- HA-761: Support for non norm conform syntax `VAR <access> CONSTANT`.

## 1.23 (2021-09-02)

### Added

- HA-25: change allocation of block pointers to TIA calling conventions. For FCs, the first pointer parameter will have number 2. For FBs, the first pointer parameter is the instance with number 4.
- HA-372: add version information to library buckets for frontend (Frontend Version) and backend (ABI Version).
- HA-622: reserve 4 bytes at the start of an FB in type lowering. This is to keep FB layout compatible with TIA FBs.

### Changed

- Speedup compile times of small programs by instantiate the target plugin in background.

### Fixed

- HA-53: Fixed stack overflow when computing the constant value in an initializer if the variable referenced itself.
- Fixed crash when using an enum value originated in a library.
- HA-750: Fixed crash with partial access of static variable in FBs and classes.
- HA-757: Fixed crash when using NULL as initializer of an interface type in a library.
- HA-842: Pragmas at function blocks were not considered in target code generation. This does not affect pragmas at function block variables. These were considered.
- HA-882: Removed regrant of instance in functions with instance parameter in MC7+.
  - We cannot set the grant length by the static type of the class inside a method. This would prevent dynamic casts on "THIS" in a base class method if the instance of "THIS" is a derived class that implements different interfaces. Then the grant length of the static type of the base class is too short for the cast.
- HA-850: Lowering for structure initializers compared member names case sensitive leading to wrong initialization.
- HA-850: Missing entry code for generated interface intermediate trampoline functions.
- HA-893: Correctly generate basic blocks out of binary for functions from library.

### Removed

- command line option `--compile-to-lib`. Use `--compile-to` instead.
- AX-5477: `AX.ST.Semantic.TypeSystem` with `DataType`.
- Public API `ISemanticConstantExpression.SyntaxKind`

### Deprecated

- `IStorageDeclaration.IsReadOnly` is deprecated. Use `IStorageDeclaration.IsDeclaredReadOnly` instead.

## 1.21

### Added

- Added new flag `GenerateUnusedFunctions` to `AX.Target.MC7plus.BuilderParams`. If set to true, this will generate code for all dependencies of the module, including all referenced libraries transitive. If set to false, the default behavior is used, that generates only used dependencies.
- AX-4200: Add the generator version to the ST library meta.
- CA-27: Allow tasks to be passed as input parameter for e.g. the `SetDelayTime` firmware call.

### Fixed

- HA-82: fix `CLASS VAR CONSTANT PUBLIC` order of access- and section-modifier respect to norm.
- HA-83: passing a member access as argument to ARRAY\* parameter will generate wrong LLVM IR.
- AX-10188: interpret bit pattern literals as unsigned with full type range. Howver, the literal value will overflow when assigned to a signed type. E.g. the literal SINT#16#FF will result in a SINT#-1.
- AX-11035: fix return type of bit partial access, so that it can be used further correctly in logical operations, assignments and so on.
- Fixed log level parsing that was done at an inappropriate time.
- HA-465: Fixed findings.
- HA-646: Enhanced logging to log the internal error instead of swallowing it.
- HA-646: Fixed compiler crash when doing a partial access on ordered types or use a partial access in a constant initializer.
- HA-648: Fixed issue with log information being not written to console.
- HA-665: fix STC crash when explicitly initializing an Interface variable with NULL.

### Deprecated

- AX-5477: `AX.ST.Semantic.TypeSystem` with `DataType` is deprecated. This includes `PredefinedDataType`. As replacement `ITypeDeclaration` and `PredefiniedTypeDeclarations` should be used. The old typesystem will be removed soon.
- HA-82: The non norm conform variable declaration syntax `VAR <access> CONSTANT` is deprecated and will lead to a warning.

## 1.20

### Added

- AX-10599: STC now additionally creates `.app` packages for app builds.
- AX-10599: Added new command line option `--compile-to` to unify creation of app and lib packages. See help.

### Deprecated

- command line option `--compile-to-lib`. This is still supported but not shown in help anymore.
- single file output in app builds. Use the .app package instead.

### Fixed

## 1.19

### Added

### Fixed

- AX-10815: invalid debug info for cyclic types
- AX-9721: add bugfix that allows elementary datatypes as type for namedvalues, also support implicit convertion
- AX-10804: write missing OptiInfo and ImmediateLongs for OBs to loadable
- AX-9964: LS crashes when using a keyword inside an enum

## 2021.5

### Added

- AX-10003: print out warning if user environment variable `STC_PLUGIN_DIR` is set Windows.
- AX-9032: add new developer options, not available in public build:
  - support `EXTERN` function prototypes in ST
  - add new command line option `--static-link-ir` for LLVM to link a custom IR file to the compiled module
  - add new command line option `--native-target` for generating modules for a native target system like win-x64-msvc oder linux-x64-gnu
- AX-10002: print STC version before compile.
- AX-10007: added overall consistency check. _BREAKING_ consistency hashes have been moved to a single file.

### Fixed

- AX-10112: add bugfix that always enables comparison of interface typed variables, e.g. runtime checks are performed.
- AX-9032: fix ABI for struct of String datatype in llvm backend (max size of string/wstring was wrong).

## 2021.4

### Added

- Add explicit convert `TO_LDATE`.
- AX-8296: add converts for `TIME` and `LTIME` to `LINT` and vice versa.
- AX-8445: introduce NAME_OF operator.

### Fixed

- AX-10205: fix MC7plus DebugInfo for 'this' parameter has invalid lifetimes.
- AX-9752: use stdio and stdlib in internal implementations of LLVM's intrinsics, hence existance of those c-runtime libraries is obligatory.
- AX-8945: introduce "extern" memory that supports late linking in MC7+.

## 2021.3

### Added

- AX-8192: performance and code size optimization for MC7+ target for REF_TO local variables and parameters. New argument for output format in CLI: -f textWithSac.
- AX-7752: support for indexed string access. Using indexed string access for VAR_IN_OUT is not supported.
- AX-7991: compute lifetimes for local variables in the debug information for MC7+. Needs debug info format version 0.2+.
- AX-6199: add support for variable-length arrays.
- AX-6200: add intrinsic functions LOWER_BOUND and UPPER_BOUND to determine the bounds of variable-length arrays.

### Fixed

- AXSUPPORT-540: allow `BOOL` to integer type conversions.
- AXSUPPORT-531: check literals in class vars also.
- AX-9117: a call is not a valid assignment target.
- AX-8721: linker error in MC7+ for missing implementations of ?= operator.
- AX-8464: un-escaping of string literals before using their values.

## 2021.2

### Added

- AX-7835 migrate intrinsic calls to full expressions for converts, shift, rotate and date/time arithmetic

### Fixed

- AX-8408: fix crash in named values in case of trailing comma after last value.
- AX-8692: avoid duplicated debug info for FBs.

## 2021.1.1

### Fixed

- AX-8692: avoid duplicated debug info for FBs.

## 2021.1

Sadly, no info here :(

## 2020.13

Sadly, no info here :(

## 2020.12.1

### Fixed

- AX-7837: LLVM hard error using strings.
- AX-7834: Debugging st code with STRINGS no longer works.
- Enable create debugInfo for Internal variables.

## 2020.12

### Added

- AX-4959: Create DebugInfo for MC7+.
- AX-6009: Add support for STRING and WSTRING data type.

### Fixed

- Fix crash in TypeLookup when meeting lower-/mixed-case literal shorthands.
- AX-7640: Ensure TsL bit size is multiple of 64 in target MC7+. This is required by OCO.
- AX-7181: Avoid creating an empty library file.
- AX-7115: Avoid crash for invalid namespace syntax.
- External functions where added multiple times, which caused linker issues, when generating the exe file (using -t llvm).
- Comparing methods was case sensitive; comparing POU declarations was not aware of parameter sections.
- The keyword 'IMPLEMENTS' is only applicable for interfaces. Prior is was possible to issue 'IMPLEMENTS' also for abstract classes.
