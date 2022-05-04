#!/usr/bin/env node

const { spawn } = require("child_process");

const args = process.argv.slice(2); // Skip executable

const clangProcess = spawn(
  "clang",
  [
    "-gdwarf-4",
    "-fuse-ld=lld-link.exe",
    "-Xlinker /subsystem:console",
    "-Xlinker /ignore:longsections",
    "--no-warnings",
    ...args,
  ],
  {
    stdio: "inherit",
    // only used to automatically resolve the extension for the command (e.g. .exe on Windows)
    shell: true,
  }
);

clangProcess.on("error", (error) => {
  throw error;
});

clangProcess.on("exit", (code, signal) => {
  if (code !== 0) {
    if (code) {
      process.exitCode = code;
    }
    if (signal) {
      throw new Error(`Process terminated by signal ${signal}.`);
    }
  }
});
