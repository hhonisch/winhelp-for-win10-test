#include-once

; Loglevel constants
Global Const $LOGLEVEL_DEBUG = 4
Global Const $LOGLEVEL_INFO = 3
Global Const $LOGLEVEL_WARN = 2
Global Const $LOGLEVEL_ERROR = 1
Global Const $LOGLEVEL_NONE = 0

; Current loglevel
Global $_Logging_LogLevel = $LOGLEVEL_NONE


; Set loglevel
Func SetLogLevel($Loglevel)
	$_Logging_LogLevel = $Loglevel
EndFunc   ;==>SetLogLevel



; Log debug message
Func LogDebug($Msg)
	If $_Logging_LogLevel >= $LOGLEVEL_DEBUG Then
		ConsoleWrite(@HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC & " DBG:" & $Msg & @CRLF)
	EndIf
EndFunc   ;==>LogDebug



; Log info message
Func LogInfo($Msg)
	If $_Logging_LogLevel >= $LOGLEVEL_INFO Then
		ConsoleWrite(@HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC & " INFO:" & $Msg & @CRLF)
	EndIf
EndFunc   ;==>LogInfo



; Log warn message
Func LogWarn($Msg)
	If $_Logging_LogLevel >= $LOGLEVEL_WARN Then
		ConsoleWrite(@HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC & " WARN:" & $Msg & @CRLF)
	EndIf
EndFunc   ;==>LogWarn



; Log error message
Func LogError($Msg)
	If $_Logging_LogLevel >= $LOGLEVEL_ERROR Then
		ConsoleWrite(@HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC & " ERR:" & $Msg & @CRLF)
	EndIf
EndFunc   ;==>LogError








