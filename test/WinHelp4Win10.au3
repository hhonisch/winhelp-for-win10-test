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
Global $WaitTimeoutSec = 10
Global $TestName = ""



; Parse command line
Func ParseCommandLine()
	Local $i, $str
	LogDebug("Parsing command line...")
	For $i = 1 To UBound($CmdLine) - 1
		$str = StringStripWS($CmdLine[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		LogDebug($str)
		If StringCompare(StringLeft($str, 6), "/Test:", $STR_NOCASESENSEBASIC) = 0 Then
			$TestName = StringMid($str, 7)
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

	Local $WizardWinHandle
	; Wait for wizard window "Select destination Location"
	LogInfo("Waiting for wizard window (Select Destination Location)...")
	$WizardWinHandle = WinWait("[CLASS:TWizardForm; REGEXPTITLE:(?i)WinHelp for Windows 10]", "Select Destination Location", $WaitTimeoutSec)
	If $WizardWinHandle = 0 Then
		ErrorExit("Waiting timed out", 0)
	EndIf
	Sleep($DelayMs)

	; Click "Next"
	LogInfo("Clicking 'Next'...")
	If not ControlWaitAndClick($WizardWinHandle, "", "[CLASS:TNewButton; TEXT:&Next]") Then
		ErrorExit("Error clicking 'Next'", $WizardWinHandle)
	EndIf
	Sleep($DelayMs)

	; Wait for wizard window "Ready to Install"
	LogInfo("Waiting for wizard window (Ready to Install)...")
	$WizardWinHandle = WinWait("[CLASS:TWizardForm; REGEXPTITLE:(?i)WinHelp for Windows 10]", "Ready to Install", $WaitTimeoutSec)
	If $WizardWinHandle = 0 Then
		ErrorExit("Waiting timed out", 0)
	EndIf

	; Click "Install"
	LogInfo("Clicking 'Install'...")
	If not ControlWaitAndClick($WizardWinHandle, "", "[CLASS:TNewButton; TEXT:&Install]") Then
		ErrorExit("Error clicking 'Install'", $WizardWinHandle)
	EndIf
	Sleep($DelayMs)
	
	; Wait for wizard window "Setup has finished installing"
	LogInfo("Waiting for wizard window (Setup has finished installing)...")
	$WizardWinHandle = WinWait("[CLASS:TWizardForm; REGEXPTITLE:(?i)WinHelp for Windows 10]", "Setup has finished installing", $WaitTimeoutSec)
	If $WizardWinHandle = 0 Then
		ErrorExit("Waiting timed out", 0)
	EndIf

	; Click "Finish"
	LogInfo("Clicking 'Install'...")
	If not ControlWaitAndClick($WizardWinHandle, "", "[CLASS:TNewButton; TEXT:&Finish]") Then
		ErrorExit("Error clicking 'Finish'", $WizardWinHandle)
	EndIf
	Sleep($DelayMs)
	
	LogInfo("Done")
EndFunc   ;==>TestInstallGUI



; Main
Func Main()
	; Parse command line
	ParseCommandLine()
	
	If $TestName = "" Then
		ErrorExit("No test name given", 0)
	EndIf
	
	Call("Test" & $TestName)
	

EndFunc   ;==>Main

; Call Main function
SetLogLevel($LOGLEVEL_DEBUG)
Main()
