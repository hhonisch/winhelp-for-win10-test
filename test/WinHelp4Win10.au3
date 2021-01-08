#include <StringConstants.au3>
#include <ScreenCapture.au3>
#include <WinAPIShPath.au3>
#include "Utils.au3"


; Global variables for script
Global $SetupExe = ""
Global $SetupLogFile = ""
Global $DelayMs = 0
Global $ScreenShotDir = ""
Global $ScreenShotCount = 0
Global $InstallWaitTimeoutSec = 30
Global $UninstallWaitTimeoutSec = 30
Global $TestNames = ""



; Parse command line
Func ParseCommandLine()
	Local $i, $str
	LogDebug("Parsing command line...")
	For $i = 1 To UBound($CmdLine) - 1
		$str = StringStripWS($CmdLine[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		LogDebug($str)
		If StringCompare(StringLeft($str, 7), "/Tests:", $STR_NOCASESENSEBASIC) = 0 Then
			$TestNames = StringMid($str, 8)
		ElseIf StringCompare(StringLeft($str, 7), "/Setup:", $STR_NOCASESENSEBASIC) = 0 Then
			$SetupExe = StringMid($str, 8)
		ElseIf StringCompare(StringLeft($str, 10), "/SetupLog:", $STR_NOCASESENSEBASIC) = 0 Then
			$SetupLogFile = StringMid($str, 11)
		ElseIf StringCompare(StringLeft($str, 7), "/Delay:", $STR_NOCASESENSEBASIC) = 0 Then
			$DelayMs = Number(StringMid($str, 8))
		ElseIf StringCompare(StringLeft($str, 13), "/Screenshots:", $STR_NOCASESENSEBASIC) = 0 Then
			$ScreenShotDir = StringMid($str, 14)
		ElseIf StringCompare(StringLeft($str, 10), "/LogLevel:", $STR_NOCASESENSEBASIC) = 0 Then
			SetLogLevel(Number(StringMid($str, 11)))
		EndIf
	Next
	
	; Print command line params
	if $SetupExe <> "" Then
		LogInfo("CmdLine Setup Exe: " & $SetupExe)
	EndIf
	if $SetupLogFile <> "" Then
		LogInfo("CmdLine Setup Logfile: " & $SetupLogFile)
	EndIf
	LogInfo("Delay (ms): " & $DelayMs)
	if $ScreenShotDir <> "" Then
		LogInfo("Save screenshots to: " & $ScreenShotDir)
	EndIf

	
EndFunc   ;==>ParseCommandLine



; Exit on error with message
Func ErrorExit($Msg, $hWnd)
	LogError($Msg)
	If $ScreenShotDir <> "" Then
		Sleep(500)
		Local $ScreenShotName = _WinAPI_PathAppend($ScreenShotDir, "Error.jpg")
		LogError("Saving screenshot to " & $ScreenShotName)
		If $hWnd = 0 Then
			_ScreenCapture_Capture($ScreenShotName)
		Else
			_ScreenCapture_CaptureWnd($ScreenShotName, $hWnd)
		EndIf
	EndIf
	Exit 1
EndFunc   ;==>ErrorExit



; Test install via GUI
Func TestInstallGUI()
	LogInfo("Testing install with GUI")
	
	; Launch installer
	Local $Cmd = """" & $SetupExe & """"
	If $SetupLogFile <> "" Then
		$Cmd = $Cmd & " /LOG=""" & $SetupLogFile & """"
	EndIf
	
	LogInfo("Launching " & $Cmd & "...")
	Local $Pid = Run($Cmd)
	if $Pid = 0 Then
		ErrorExit("Error launching " & $Cmd, 0)
	EndIf

	Local $WinHandle
	; Wait for wizard window "Select destination Location"
	LogInfo("Waiting for wizard window (Select Destination Location)...")
	$WinHandle = WinWait("[CLASS:TWizardForm; REGEXPTITLE:(?i)WinHelp for Windows 10]", "Select Destination Location", $InstallWaitTimeoutSec)
	If $WinHandle = 0 Then
		ErrorExit("Waiting timed out", 0)
	EndIf
	Sleep($DelayMs)

	; Click "Next"
	LogInfo("Clicking 'Next'...")
	If not ControlWaitAndClick($WinHandle, "", "[CLASS:TNewButton; TEXT:&Next]") Then
		ErrorExit("Error clicking 'Next'", $WinHandle)
	EndIf
	Sleep($DelayMs)

	; Wait for wizard window "Ready to Install"
	LogInfo("Waiting for wizard window (Ready to Install)...")
	$WinHandle = WinWait("[CLASS:TWizardForm; REGEXPTITLE:(?i)WinHelp for Windows 10]", "Ready to Install", $InstallWaitTimeoutSec)
	If $WinHandle = 0 Then
		ErrorExit("Waiting timed out", 0)
	EndIf

	; Click "Install"
	LogInfo("Clicking 'Install'...")
	If not ControlWaitAndClick($WinHandle, "", "[CLASS:TNewButton; TEXT:&Install]") Then
		ErrorExit("Error clicking 'Install'", $WinHandle)
	EndIf
	Sleep($DelayMs)
	
	; Wait for wizard window "Setup has finished installing"
	LogInfo("Waiting for wizard window (Setup has finished installing)...")
	$WinHandle = WinWait("[CLASS:TWizardForm; REGEXPTITLE:(?i)WinHelp for Windows 10]", "Setup has finished installing", $InstallWaitTimeoutSec)
	If $WinHandle = 0 Then
		ErrorExit("Waiting timed out", 0)
	EndIf

	; Click "Finish"
	LogInfo("Clicking 'Install'...")
	If not ControlWaitAndClick($WinHandle, "", "[CLASS:TNewButton; TEXT:&Finish]") Then
		ErrorExit("Error clicking 'Finish'", $WinHandle)
	EndIf
	Sleep($DelayMs)
	
	LogInfo("Done")
EndFunc   ;==>TestInstallGUI



; Test uninstall via GUI
Func TestUninstallGUI()
	LogInfo("Testing uninstall with GUI")
	
	; Reading uninstaller from registry
	Local $Cmd = RegRead("HKLM64\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinHelp4Win10_is1", "UninstallString")
	LogDebug("Uninstaller: " & $Cmd)

	If $SetupLogFile <> "" Then
		$Cmd = $Cmd & " /LOG=""" & $SetupLogFile & """"
	EndIf
	
	LogInfo("Launching " & $Cmd & "...")
	Local $Pid = Run($Cmd)
	if $Pid = 0 Then
		ErrorExit("Error launching " & $Cmd, 0)
	EndIf
	
	Local $WinHandle
	
	; Wait for "are you sure" uninstall message
	LogInfo("Waiting for ""are you sure"" uninstall message...")
	$WinHandle = WinWait("[REGEXPTITLE:(?i)WinHelp for Windows 10 Uninstall]", "Are you sure", $UninstallWaitTimeoutSec)
	If $WinHandle = 0 Then
		ErrorExit("Waiting timed out", 0)
	EndIf
	Sleep($DelayMs)

	; Click "Yes"
	LogInfo("Clicking 'Yes'...")
	If not ControlWaitAndClick($WinHandle, "", "[CLASS:Button; ID:6]") Then
		ErrorExit("Error clicking 'Yes'", $WinHandle)
	EndIf
	Sleep($DelayMs)

	; Wait for "successfully removed" uninstall message
	LogInfo("Waiting for ""successfully removed"" uninstall message...")
	$WinHandle = WinWait("[REGEXPTITLE:(?i)WinHelp for Windows 10 Uninstall]", "successfully removed", $UninstallWaitTimeoutSec)
	If $WinHandle = 0 Then
		ErrorExit("Waiting timed out", 0)
	EndIf
	Sleep($DelayMs)

	; Click "OK"
	LogInfo("Clicking 'OK'...")
	If not ControlWaitAndClick($WinHandle, "", "[CLASS:Button; ID:2]") Then
		ErrorExit("Error clicking 'OK'", $WinHandle)
	EndIf
	
	Sleep($DelayMs)
	LogInfo("Done")
EndFunc   ;==>TestUninstallGUI



; Test silent install
Func TestInstallSilent()
	LogInfo("Testing silent install")
	
	; Launch installer
	Local $Cmd = """" & $SetupExe & """ /SILENT"
	If $SetupLogFile <> "" Then
		$Cmd = $Cmd & " /LOG=""" & $SetupLogFile & """"
	EndIf
	
	LogInfo("Launching " & $Cmd & "...")
	Local $Pid = Run($Cmd)
	if $Pid = 0 Then
		ErrorExit("Error launching " & $Cmd, 0)
	EndIf

	; Wait for installer to exit
	LogInfo("Waiting for installer to exit...")
	Local $Result = ProcessWaitClose($Pid, $InstallWaitTimeoutSec)
	If $Result = 0 Then
		ErrorExit("Waiting timed out", 0)
	EndIf

	; Check error code
	If @extended <> 0 Then
		ErrorExit("Installer exited with error code: " & @extended, 0)
	EndIf
	
	LogInfo("Done")
EndFunc   ;==>TestInstallSilent



; Test silent uninstall
Func TestUninstallSilent()
	LogInfo("Testing silent uninstall")
	
	; Reading uninstaller from registry
	Local $Cmd = RegRead("HKLM64\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinHelp4Win10_is1", "QuietUninstallString")
	LogDebug("Uninstaller: " & $Cmd)

	If $SetupLogFile <> "" Then
		$Cmd = $Cmd & " /LOG=""" & $SetupLogFile & """"
	EndIf
	
	LogInfo("Launching " & $Cmd & "...")
	Local $Pid = Run($Cmd)
	if $Pid = 0 Then
		ErrorExit("Error launching " & $Cmd, 0)
	EndIf
	
	; Wait for installer to exit
	LogInfo("Waiting for uninstaller to exit...")
	Local $Result = ProcessWaitClose($Pid, $InstallWaitTimeoutSec)
	If $Result = 0 Then
		ErrorExit("Waiting timed out", 0)
	EndIf

	; Check error code
	If @extended <> 0 Then
		ErrorExit("Uninstaller exited with error code: " & @extended, 0)
	EndIf
	LogInfo("Done")
EndFunc   ;==>TestUninstallGUI


; Main
Func Main()
	; Parse command line
	ParseCommandLine()
	
	If $TestNames = "" Then
		ErrorExit("No test name given", 0)
	EndIf
	
	LogInfo("Tests to run: " & $TestNames)
	$TestNamesArray = StringSplit($TestNames, ",")
	Local $i, $TestName
	For $i = 1 to UBound($TestNamesArray) - 1
		$TestName = StringStripWS($TestNamesArray[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		LogInfo("Starting Test " & $TestName)
		Call("Test" & $TestName)
	Next
	

EndFunc   ;==>Main


; Call Main function
SetLogLevel($LOGLEVEL_ERROR)
Main()
