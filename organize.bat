@echo off
:: File Organizer - Windows Batch Wrapper
:: This makes it easier to use the organizer from Windows Explorer

if "%~1"=="" (
    echo.
    echo 📁 File Organizer - Windows
    echo ═════════════════════════════
    echo.
    echo USAGE:
    echo   Drag and drop a folder onto this batch file to organize it
    echo   OR
    echo   Run: organize.bat "C:\path\to\folder"
    echo   Run: organize.bat "C:\path\to\folder" --dry-run
    echo.
    echo EXAMPLES:
    echo   organize.bat "%USERPROFILE%\Downloads"
    echo   organize.bat "%USERPROFILE%\Desktop" --dry-run
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

:: Check if organize.exe exists in the same directory
if not exist "%~dp0organize.exe" (
    echo ERROR: organize.exe not found in %~dp0
    echo Please ensure organize.exe is in the same folder as this batch file.
    echo.
    pause
    exit /b 1
)

:: Run the organizer with provided arguments
echo Running File Organizer on: %1
echo.
"%~dp0organize.exe" %*

:: Keep window open after execution
echo.
echo ════════════════════════════════════════
echo Operation completed.
echo Press any key to close this window...
pause >nul
