#!/usr/bin/env node

const { spawn } = require("child_process");
const path = require("path");

const targetIp = process.env.AXUNIT_TARGET_IP;
const input = path.join("bin", targetIp ? "axunit" : "axunit-llvm");
const runner = `axunit-runner-${targetIp ? "mc7plus" : "llvm"}`;
const targetArgs = targetIp ? ["--targetIP", targetIp] : [];

const { APAX_TEST_ARGS } = process.env;
const additionalArgs = APAX_TEST_ARGS ? JSON.parse(APAX_TEST_ARGS) : [];

const runnerProcess = spawn(
  runner,
  ["--input", input, ...targetArgs, ...adapt_args_V1_to_V2(additionalArgs)],
  {
    stdio: "inherit",
    // only used to automatically resolve the extension for the command (e.g. .exe on Windows)
    shell: true,
  }
);
runnerProcess.on("error", (error) => {
  throw error;
});
runnerProcess.on("exit", (code, signal) => {
  if (code !== 0) {
    if (code) {
      process.exitCode = code;
    }
    if (signal) {
      throw new Error(`Process terminated by signal ${signal}.`);
    }
  }
});

function adapt_args_V1_to_V2(args){
	var newargs = [];
	var skipNextTrue = false;
	
	for(var i=0; i < args.length; i++){
		if (skipNextTrue && args[i].toLowerCase()==="true")
			continue;
		
		newargs.push(args[i]);
		
		skipNextTrue = ["--only-meta","--machine-readable","--nologo"].indexOf(args[i])>=0;
	}
	
	return newargs;
}
