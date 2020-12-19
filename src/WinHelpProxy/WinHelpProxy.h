#pragma once

#include "resource.h"


// Window function
LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

// Start WinHelp application
int StartWinHelp(LPTSTR newCmdLine);

// Build new command line
int BuildNewCommandLine(LPTSTR newCmdLine, size_t newCmdLineSize, LPTSTR lpCmdLine);

// Skip one command line argument
LPCTSTR SkipCmdLineArgument(LPCTSTR lpCmdLine);
