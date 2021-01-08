#include-once

#include <Timers.au3>
#include "Logging.au3"


; Wait for control to appear
Func ControlWait($title, $text, $controlID, $timeout = 0)
	Local $Handle, $Timer
	LogDebug("ControlWait:" & $title & "," & $text & "," & $controlID)
	; Timer for timeout
	If $timeout > 0 Then
		$Timer = _Timer_Init()
	EndIf
	While(1)
		; Try to get control handle
		LogDebug("Trying to get control handle...")
		$Handle = ControlGetHandle($title, $text, $controlID)
		; Return success if control found
		If $Handle <> 0 Then
			LogDebug("Success, exiting")
			Return 1
		EndIf
		LogDebug("No success")
		; Check timeout and return failure if timeout has passed
		If $timeout > 0 Then
			If _Timer_Diff($Timer) > $timeout Then
				LogDebug("Timeout, exiting")
				Return 0
			EndIf
		EndIf
		; Wait and retry
		Sleep(100)
	WEnd
EndFunc   ;==>ControlWait



; Wait for control and click
Func ControlWaitAndClick($title, $text, $controlID, $timeout = 0)
	If ControlWait($title, $text, $controlID, $timeout) Then
		Return ControlClick($title, $text, $controlID)
	Else
		Return 0
	EndIf
EndFunc   ;==>ControlWaitAndClick



