@SETLOCAL
@IF EXIST "%~dp0\node.exe" (
  "%~dp0\node.exe"  "%~dp0\..\..\packages\@ax\build-native-winx64\bin\compile-native.js" %*
) ELSE (
  @SET PATHEXT=%PATHEXT:;.JS;=;%
  node  "%~dp0\..\..\packages\@ax\build-native-winx64\bin\compile-native.js" %*
)
