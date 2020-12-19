// WinHelpProxy.cpp : Defines the entry point for the application.
//

#include "framework.h"
#include "WinHelpProxy.h"


// Global Variables:
HINSTANCE hInst;                                // current instance



// Debug output
void dbgprint(const TCHAR *func, int line, const TCHAR *fmt, ...) {
	// Fomat the string, maybe with vsprintf, log it, etc.
	const size_t msgBufSize = 500;
	size_t msgIndex = 0;
	TCHAR debugMsg[msgBufSize];
	// Print function name and line
	if (FAILED(StringCchPrintf(debugMsg, msgBufSize, _T("%s(%d):"), func, line)))
	{
		_ASSERT(FALSE);
		return;
	}

	// Append custom debug message
	if (FAILED(StringCchLength(debugMsg, msgBufSize, &msgIndex)))
	{
		_ASSERT(FALSE);
		return;
	}

	va_list ap;
	va_start(ap, fmt);
	if (FAILED(StringCchVPrintf(&debugMsg[msgIndex], msgBufSize - msgIndex, fmt, ap)))
	{
		_ASSERT(FALSE);
		return;
	}
	va_end(ap);

	// Append newline
	if (FAILED(StringCchCat(debugMsg, msgBufSize, _T("\n"))))
	{
		_ASSERT(FALSE);
		return;
	}

	OutputDebugString(debugMsg);
}

#define DBGPRINT(fmt, ...) dbgprint(_T(__FUNCTION__), __LINE__, fmt, __VA_ARGS__)



// Start WinHelp application
int StartWinHelp(LPTSTR newCmdLine)
{
	// Register the window class.
	const TCHAR CLASS_NAME[] = _T("WinHelpProxy");
	WNDCLASS wc = {};
	wc.lpfnWndProc = WindowProc;
	wc.hInstance = hInst;
	wc.lpszClassName = CLASS_NAME;
	RegisterClass(&wc);

	// Create the window
	HWND hwnd = CreateWindowEx(
		0,                              // Optional window styles.
		CLASS_NAME,                     // Window class
		_T("WinHelp Proxy Window"),    // Window text
		WS_OVERLAPPEDWINDOW,            // Window style

										// Size and position
		CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,

		NULL,       // Parent window    
		NULL,       // Menu
		hInst,      // Instance handle
		NULL        // Additional application data
	);

	// Exit on error
	if (hwnd == NULL)
	{
		DBGPRINT(_T("Error registering window => exit"));
		return 1;
	}

	ShowWindow(hwnd, SW_HIDE);

	STARTUPINFO si = { 0 };
	si.cb = sizeof(si);
	PROCESS_INFORMATION pi = { 0 };
	// Strart actual WinHelp application
	DBGPRINT(_T("Launching process"));
	if (!CreateProcess(0, newCmdLine, 0, 0, FALSE, 0, 0, 0, &si, &pi)) {
		DBGPRINT(_T("Error launching process => exit"));
		return 1;
	}

	// Wait until WinHelp is ready for input
	DBGPRINT(_T("Wait for idle input"));
	WaitForInputIdle(pi.hProcess, 5000);
	DBGPRINT(_T("Done: Wait for idle input"));

	MSG msg;
	BOOL bRet;

	// Create timer for exit
	DBGPRINT(_T("Create quit timer"));
	const int IDT_TIMER_QUIT = 100;
	SetTimer(hwnd, IDT_TIMER_QUIT, 5000, 0);

	// Run message loop
	DBGPRINT(_T("Enter message loop"));
	while (TRUE)
	{
		bRet = GetMessage(&msg, NULL, 0, 0);
		DBGPRINT(_T("Got Message: %d"), msg.wParam);

		if (bRet <= 0)
		{
			break;
		}

		if (msg.message == WM_TIMER && msg.wParam == IDT_TIMER_QUIT)
		{
			DBGPRINT(_T("Got quit timer message"));
			PostQuitMessage(0);
		}
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	DBGPRINT(_T("Regular exit"));
	return (int)msg.wParam;
}



// Build new command line
int BuildNewCommandLine(LPTSTR newCmdLine, size_t newCmdLineSize, LPTSTR lpCmdLine)
{
	TCHAR *newCmdLinePos = newCmdLine;
	TCHAR *newCmdLineEnd = &newCmdLine[newCmdLineSize];

	// Start with quotes
	*newCmdLinePos = _T('"');
	newCmdLinePos++;

	// Get path to WinHelp application
	if (!GetModuleFileName(0, newCmdLinePos, (DWORD)(newCmdLineEnd - newCmdLinePos)))
	{
		DBGPRINT(_T("Error getting module filename => exit"));
		return 1;
	}
	// Scan for last backslash
	DBGPRINT(_T("Module filename: %s"), newCmdLinePos);
	TCHAR *p = _tcsrchr(newCmdLinePos, _T('\\'));
	if (p == 0)
	{
		DBGPRINT(_T("Error finding module path => exit"));
		return 1;
	}
	newCmdLinePos = p + 1;
	// Append new exe name
	if (_tcscpy_s(newCmdLinePos, newCmdLineEnd - newCmdLinePos, _T("mywinhlp32.exe")) != 0)
	{
		DBGPRINT(_T("Error appending mywinhlp32.exe to command line => exit"));
		return 1;
	}
	// Append quotes
	if (_tcscat_s(newCmdLinePos, newCmdLineEnd - newCmdLinePos, _T("\"")) != 0)
	{
		DBGPRINT(_T("Error appending quotes to command line => exit"));
		return 1;
	}

	// Skip one command line arg
	LPCTSTR argsStart = SkipCmdLineArgument(lpCmdLine);
	if (argsStart != 0) {
		if (_tcscat_s(newCmdLinePos, newCmdLineEnd - newCmdLinePos, argsStart) != 0)
		{
			DBGPRINT(_T("Error appending cmd line args"));
			return 1;
		}
	}
	return 0;
}



// Skip one command line argument
LPCTSTR SkipCmdLineArgument(LPCTSTR lpCmdLine)
{
	const TCHAR* p = lpCmdLine;
	int state = 0;
	int nextState = 0;
	while (*p != _T('\0'))
	{
		switch (state)
		{

		case 0: // At the beginning
			if (*p == _T(' '))
			{
				// skip whitespaces
				nextState = 0;
			}
			else if (*p == _T('"'))
			{
				// exe name starts with dblquote = > scan to next dblquote
				nextState = 1;
			}
			else
			{
				// exe name starts with other character => scan to next space
				nextState = 2;
			}
			break;


		case 1: // Scanning for next dblquote
			if (*p == _T('"'))
			{
				// found end of exe name
				p++;
				return p;
			}
			else
			{
				// Continue scanning
				nextState = 1;
			}
			break;

		case 2: // Scanning for next space
			if (*p == _T(' '))
			{
				// found end of exe name
				return p;
			}
			else
			{
				// Continue scanning
				nextState = 2;
			}
			break;

		}
		p++;
		state = nextState;

	}
	return 0;
}


// WinMain
int APIENTRY _tWinMain(_In_ HINSTANCE hInstance,
	_In_opt_ HINSTANCE hPrevInstance,
	_In_ LPTSTR    lpCmdLine,
	_In_ int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

	DBGPRINT(_T("Command line: %s"), lpCmdLine);

	// Build new command line
	const int newCmdLineSize = 4096;
	TCHAR newCmdLine[newCmdLineSize];

	if (BuildNewCommandLine(newCmdLine, newCmdLineSize, lpCmdLine) != 0)
	{
		DBGPRINT(_T("Error in BuildNewCommandLine() => exit"));
		return 1;
	}

	DBGPRINT(_T("New command line: %s"), newCmdLine);

	return StartWinHelp(newCmdLine);
}


// Window proc
LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;

	case WM_PAINT:
	{
		PAINTSTRUCT ps;
		HDC hdc = BeginPaint(hwnd, &ps);

		FillRect(hdc, &ps.rcPaint, (HBRUSH)(COLOR_WINDOW + 1));

		EndPaint(hwnd, &ps);
	}
	return 0;

	}
	return DefWindowProc(hwnd, uMsg, wParam, lParam);
}