#include <StringConstants.au3>
#include <ScreenCapture.au3>
#include <WinAPIShPath.au3>


Global $SetupExe = ""
Global $SetupLogFile = ""
Global $Delay = 0
Global $ScreenShotDir = ""
Global $ScreenShotCount = 0


; Log message
Func LogMsg($Msg)
	ConsoleWrite($Msg & @CRLF)
EndFunc   ;==>LogMsg



; Parse command line
Func ParseCommandLine()
	Local $i, $str
	Call(LogMsg, "Parsing command line...")
	For $i = 1 To UBound($CmdLine) - 1
		$str = StringStripWS($CmdLine[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		Call(LogMsg, $str)
		If StringCompare(StringLeft($str, 7), "/Setup:", $STR_NOCASESENSEBASIC) = 0 Then
			$SetupExe = StringMid($str, 8)
		ElseIf StringCompare(StringLeft($str, 10), "/SetupLog:", $STR_NOCASESENSEBASIC) = 0 Then
			$SetupLogFile = StringMid($str, 11)
		ElseIf StringCompare(StringLeft($str, 7), "/Delay:", $STR_NOCASESENSEBASIC) = 0 Then
			$Delay = Number(StringMid($str, 8))
		ElseIf StringCompare(StringLeft($str, 13), "/Screenshots:", $STR_NOCASESENSEBASIC) = 0 Then
			$ScreenShotDir = StringMid($str, 14)
		EndIf
	Next
EndFunc   ;==>ParseCommandLine



; Exit on error with message
Func ErrorExit($Msg, $hWnd)
	Call(LogMsg, $Msg)
	If $ScreenShotDir <> "" Then
		Sleep(500)
		Local $ScreenShotName = _WinAPI_PathAppend($ScreenShotDir, "Error.jpg")
		Call(LogMsg, "Saving screenshot to " & $ScreenShotName)
		If $hWnd = 0 Then
			_ScreenCapture_Capture($ScreenShotName)
		Else
			_ScreenCapture_CaptureWnd($ScreenShotName, $hWnd)
		EndIf
	EndIf
	Exit 1
EndFunc   ;==>ErrorExit



; Main
Func Main()
	Local $Result
	
	Call(LogMsg, "Starting...")

	; Parse command line
	Call(ParseCommandLine)
	
	; Print command line params
	Call(LogMsg, "CmdLine Setup Exe: " & $SetupExe)
	Call(LogMsg, "CmdLine Setup Logfile: " & $SetupLogFile)
	Call(LogMsg, "Delay(ms): " & $Delay)
	if $ScreenShotDir <> "" Then
		Call(LogMsg, "Save screenshots to: " & $ScreenShotDir)
	EndIf

	; Launch installer
	Local $Cmd = """" & $SetupExe & """"
	If $SetupLogFile <> "" Then
		$Cmd = $Cmd & " /LOG=""" & $SetupLogFile & """"
	EndIf
	
	Call(LogMsg, "Launching " & $Cmd & "...")
	Local $Pid = Run($Cmd)

	; Wait for wizard window
	Call(LogMsg, "Waiting for wizard window...")
	Local $WizardWinHandle = WinWait("[CLASS:TWizardForm; REGEXPTITLE:(?i)WinHelp for Windows 10]", "Select Destination Location", 10)
	If $WizardWinHandle = 0 Then
		Call(ErrorExit, "Waiting timed out", 0)
	EndIf
	Sleep($Delay)

	; Click "Next"
	Call(LogMsg, "Clicking 'Next'...")
	If not ControlClick($WizardWinHandle, "", "[CLASS:TNewButton; TEXT:&Next]") Then
		Call(ErrorExit, "Error clicking 'Next'", $WizardWinHandle)
	EndIf
	Sleep($Delay)

	; Click "Install"
	Call(LogMsg, "Clicking 'Install'...")
	If not ControlClick($WizardWinHandle, "", "[CLASS:TNewButton; TEXT:&Install]") Then
		Call(ErrorExit, "Error clicking 'Install'", $WizardWinHandle)
	EndIf

	; Close wizard
	Call(LogMsg, "Closing wizard window...")
	$Result = WinClose($WizardWinHandle)
	If $Result = 0 Then
		Call(ErrorExit, "Error closing wizard window", $WizardWinHandle)
	EndIf
	Sleep($Delay)
	
	; Confirm close
	Call(LogMsg, "Confirming close...")
	$Result = ControlClick("Exit Setup", "", 6)
	If $Result = 0 Then
		Call(ErrorExit, "Error confirming close", $WizardWinHandle)
	EndIf
	Sleep($Delay)
	
	
	Call(LogMsg, "Done")
EndFunc   ;==>Main

; Call Main function
Call(Main)
