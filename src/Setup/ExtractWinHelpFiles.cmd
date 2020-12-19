@echo off
setlocal enableextensions enabledelayedexpansion
set MSU64=%~1
set TARGET_DIR=%~2
set DO_PAUSE=%~3

if not exist "%MSU64%" (
  echo MSU file "%MSU64%" not found
  goto error
)

rem Create target dir
echo Creating %TARGET_DIR%...
mkdir "%TARGET_DIR%" || goto error

rem Extract CAB from MSU
set CAB_NAME=Windows8.1-KB917607-x64.cab
echo Extracting %CAB_NAME% from %MSU64% to %TARGET_DIR%...
expand "%MSU64%" -F:"%CAB_NAME%" "%TARGET_DIR%" >nul || goto error

rem Extract files from CAB
echo Extracting %CAB_NAME% to %TARGET_DIR%...
expand "%TARGET_DIR%\%CAB_NAME%" -F:* "%TARGET_DIR%" >nul || goto error

rem Finished
goto end

:error
set ERROR_OCCURRED=1
echo Error occurred

:end

if "%ERROR_OCCURRED%"=="1" (
  cmd /c exit 1
) else (
  cmd /c exit 0
)
if "%DO_PAUSE%"=="1" (
  Pause
)
