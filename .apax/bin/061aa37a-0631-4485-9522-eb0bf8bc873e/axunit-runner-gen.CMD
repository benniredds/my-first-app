@SETLOCAL
@IF EXIST "%~dp0\node.exe" (
  "%~dp0\node.exe"  "%~dp0\..\..\packages\@ax\axunit-llvm-runner-gen\axunit-runner-gen.js" %*
) ELSE (
  @SET PATHEXT=%PATHEXT:;.JS;=;%
  node  "%~dp0\..\..\packages\@ax\axunit-llvm-runner-gen\axunit-runner-gen.js" %*
)
