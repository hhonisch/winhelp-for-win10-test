@echo off
setlocal enableextensions enabledelayedexpansion
set MYDIR=%~dp0%
set MYDIR=%MYDIR:~0,-1%

set SCRIPT_TITLE=Build project

echo ************************************************************
echo *** %SCRIPT_TITLE%: Start %DATE% %TIME:~0,-3%
echo ************************************************************

set BIN_DIR=%MYDIR%\..\bin
set DIST_DIR=%MYDIR%\..\dist

echo.
echo Change to %MYDIR%\..\src\WinHelpProxy...

rem Build WinHelpProxy
pushd "%MYDIR%\..\src\WinHelpProxy"


rem Build and export WinHelpProxy x86
echo.
echo *** Building WinHelpProxy x86...
msbuild WinHelpProxy.sln /t:Rebuild /p:Configuration=Release /p:Platform=x86 || goto error

echo.
echo *** Exporting x86 WinHelpProxy.exe to %BIN_DIR%\x86...
mkdir "%BIN_DIR%\x86"
copy /Y Release\WinHelpProxy.exe "%BIN_DIR%\x86" || goto error


rem Build and export WinHelpProxy x64
echo.
echo *** Building WinHelpProxy x64...
msbuild WinHelpProxy.sln /t:Rebuild /p:Configuration=Release /p:Platform=x64 || goto error

echo.
echo *** Exporting x64 WinHelpProxy.exe to %BIN_DIR%\x64...
mkdir "%BIN_DIR%\x64"
copy /Y x64\Release\WinHelpProxy.exe "%BIN_DIR%\x64" || goto error

popd

rem Build and export installer
pushd "%MYDIR%\..\src\Setup"
set INSTALLER_EXE=Output\Setup_WinHelp4Win10.exe

echo.
echo *** Building installer...
if exist "%INSTALLER_EXE%" del "%INSTALLER_EXE%" || goto error
iscc WinHelp4Win10.iss || goto error
copy /Y "%INSTALLER_EXE%" "%DIST_DIR%" || goto error

popd


goto :end

:error
set ERROR_OCCURRED=1

:end
echo.
echo ************************************************************
if "%ERROR_OCCURRED%"=="1" (
  echo *** %SCRIPT_TITLE%: ERROR^(s^) %DATE% %TIME:~0,-3%
  echo *** One or more errors occurred.
) else (
  echo *** %SCRIPT_TITLE%: SUCCESS %DATE% %TIME:~0,-3%
)
echo ************************************************************

if "%ERROR_OCCURRED%"=="1" (
  cmd /c exit 1
) else (
  cmd /c exit 0
)
exit 1