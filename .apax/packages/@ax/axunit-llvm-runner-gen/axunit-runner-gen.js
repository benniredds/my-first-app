#!/usr/bin/env node

const { spawn } = require("child_process");

const childProcess = spawn(
  "dotnet",
  [".apax/packages/@ax/axunit-llvm-runner-gen/bin/LLVM.Runner.Generator.dll", ...process.argv.slice(2)],
  {
    stdio: "inherit",
  }
);
childProcess.on("error", (error) => {
  throw error;
});
childProcess.on("exit", (code, signal) => {
  if (code !== 0) {
    if (code) {
      process.exitCode = code;
    }
    if (signal) {
      throw new Error(`Process terminated by signal ${signal}.`);
    }
  }
});
