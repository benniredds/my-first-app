# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

### Features

### Changes

### Fixes

### Security

## 0.16.0 (2022-03-11)

### Features

- Signature checks in mon/mod/sdb to detect when binaries on PLC were changed and no longer match the debug information.
- Libraries can now be debugged in sdb if the .lib file is used as symbol path.

### Changes

- The startup parameter `symbolsPath` of sdb has to be a .app or .lib file.

### Fixes

- mon and sdb will be exited when the connection to the PLC gets lost. The default timeout is 2 seconds.
- Watchpoints on temp/in/out variables now consider variable lifetimes.

### Security

## 0.15.3 (2021-12-15)

### Fixes

- Mon/Sdb no longer crashes when watching/monitoring elements of type REF_TO or interface-types

## 0.14.0 (2021-11-16)

### Features

- The debugger supports checksums for source files. This allows to check if the source files are still the same as the compiled files.
- Mon/sdb supports complex types now (e.g.: Arrays of struct, structs with arrays, classes, classes with arrays,...).

### Changes

- Debugger can now check if files have changed since compiling via checksums.
- _Breaking_: Output format has changed to support complex types.
- Sdb now supports output option "-o json".

### Fixes

- Monitoring/watching of arrays and structures now shows all elements.
- Arrays with more than 200 elements are supported.
  - Exception: Monitoring of arrays with the "\*" notation still supports a maximum of 200 elements.
- Monitoring/watching arrays with the "\*" notation now works correct and shows a result for each index.
- When monitoring/watching instances of derived classes, members of the base-class are now shown as expected.
