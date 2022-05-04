#!/usr/bin/env node

const { spawnSync } = require("child_process");
const fs = require('fs');
const path = require("path");
const input = path.resolve(path.join("bin", "axunit-llvm"));
const tests_exe = path.join(input, "tests.exe");
const testrunner_ll = path.join(input, "Testrunner.ll");
const testrunner_c = path.join(input, "Testrunner.c");

cleanOutputs = () => {
  try {
    if (fs.accessSync(testrunner_c, fs.constants.W_OK)) {
      fs.unlinkSync(testrunner_c);
    }
    else
    {
      throw new Error(`Cannot delete ${testrunner_c}`)
    }
  } catch (error) {} // OK, file not found

  try {
    if (fs.accessSync(testrunner_ll, fs.constants.W_OK)) {
      fs.unlinkSync(testrunner_ll);
    }
    else
    {
      throw new Error(`Cannot delete ${testrunner_ll}`)
    }
  } catch (error) {}  // OK, file not found

  try {
    if (fs.accessSync(tests_exe, fs.constants.W_OK)) {
      fs.unlinkSync(tests_exe);
    }
    else
    {
      throw new Error(`Cannot delete ${tests_exe}`)
    }
  } catch (error) {}  // OK, file not found
};

buildRunnerExecutable = (appFile) => {
  const buildProcess = spawnSync(
    "compile-app",
    [appFile, testrunner_c, "-o", tests_exe],
    {
      stdio: "inherit",
      // only used to automatically resolve the extension for the command (e.g. .exe on Windows)
      shell: true,
    }
  );

  if (buildProcess.error) {
    throw buildProcess.error;
  }

  if (buildProcess.signal) {
    throw new Error(`Process terminated by signal ${buildProcess.signal}.`);
  }

  if (buildProcess.status !== 0) {
    process.exitCode = buildProcess.status;
  }
}

const generator = `axunit-runner-gen`;

/// Script Entry point /////////////////////////

const generatorProcess = spawnSync(
  generator,
  ["-i", input, "-o", testrunner_c],
  {
    stdio: "inherit",
    // only used to automatically resolve the extension for the command (e.g. .exe on Windows)
    shell: true,
  }
);

if (generatorProcess.error) {
  throw generatorProcess.error;
}

if (generatorProcess.signal) {
  throw new Error(`Process terminated by signal ${generatorProcess.signal}.`);
}

if (generatorProcess.status !== 0) {
  process.exitCode = generatorProcess.status;
}
else {
  cleanOutputs();

  const appFiles = fs.readdirSync(input).filter(fn => fn.endsWith('.app'));
  const countAppFiles = appFiles.length;

  if (countAppFiles == 1) {
    buildRunnerExecutable(path.join(input, appFiles[0]));
  } else {
    throw new Error(`Expected exactly one .app file to build, but found ${countAppFiles}.`);
  }
}
