;*****************************************
;WinHelp4Win10.au3 by hhonisch
;Created with ISN AutoIt Studio v. 1.11
;*****************************************

; Log message
Func LogMsg($Msg)
	ConsoleWrite($Msg & @CRLF)
EndFunc



; Main
Func Main()
	Local $Result
	
	Call(LogMsg, "Starting...")
	Local $SetupExe = $CmdLine[1]

	; Launching installer
	Call(LogMsg, "Launching installer...")
	Local $Pid = Run($SetupExe)

	; Waiting for wizard window
	Call(LogMsg, "Waiting for wizard window...")
	Local $WizardWinHandle = WinWait("[CLASS:TWizardForm; REGEXPTITLE:(?i)WinHelp for Windows 10]",  "Select Destination Location",  10)
	If $WizardWinHandle = 0 Then
		Call(LogMsg, "Waiting timed out")
		Exit 1
	EndIf	

	; Click "Next"
	Call(LogMsg, "Clicking 'Next'...")
	If not ControlClick($WizardWinHandle, "", "[CLASS:TNewButton; TEXT:&Next]") Then
		Call(LogMsg, "Error clicking 'Next'")
		Exit 1
	EndIf

	; Click "Install"
;~ 	Call(LogMsg, "Clicking 'Install'...")
;~ 	If not ControlClick($WizardWinHandle, "", "[CLASS:TNewButton; TEXT:&Install]") Then
;~ 		Call(LogMsg, "Error clicking 'Install'")
;~ 		Exit 1
;~ 	EndIf

;~ 	Exit 1

	; Close wizard
	Call(LogMsg, "Closing wizard window...")
	$Result = WinClose($WizardWinHandle)
	If $Result = 0 Then 
		Call(LogMsg, "Error closing wizard window")
		Exit 1
	EndIf
	
	; Confirm close
	Call(LogMsg, "Confirming close...")
	$Result = ControlClick("Exit Setup", "", 6)
	If $Result = 0 Then 
		Call(LogMsg, "Error confirming close")
		Exit 1
	EndIf
	
	
	Call(LogMsg, "Done")
EndFunc

Call(Main)