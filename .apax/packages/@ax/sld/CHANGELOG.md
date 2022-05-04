# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

### Features

### Changes

### Fixes

### Security

## 0.11.0 (2022-03-11)

### Features

- We added a consistency feature which will prevent that any content gets changed while downloading.
- Write code signature to PLC during download. This allows us to detect changes on the PLC and stop running debugger sessions.

## 0.9.0 (2021-10-29)

### Features

- Loader supports Retentive variables (RETAIN). Read more about retentive variables in the [st documentation](https://console.prod.ax.siemens.cloud/docs/st/language/program-structure/pou-interface#retentive-variables-retain).

### Changes

- Loader can now be used 6 months instead of three.
