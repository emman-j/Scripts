@echo off
setlocal enabledelayedexpansion

:: Print the current working directory
echo Current directory: %CD%

:: Create a temporary file to store file list
set tempFile=%TEMP%\unblock_file_list.txt
del /f /q "%tempFile%" >nul 2>&1

:: Count total files and write to temp file
set /a count=0
for /r %%i in (*) do (
    echo %%i>>"%tempFile%"
    set /a count+=1
)
echo Total items to be unblocked: %count%

:: Confirmation prompt
set /p confirm="Proceed with unblocking files? (Y/N): "
if /i not "%confirm%"=="Y" (
    echo Unblocking cancelled.
    del "%tempFile%" >nul 2>&1
    pause
    exit /b
)

:: Unblock files one by one with progress
set /a index=0
for /f "usebackq tokens=*" %%i in ("%tempFile%") do (
    set /a index+=1
    echo Unblocking !index! of %count%: %%i
    powershell -command "Unblock-File -Path '%%i'"
)

:: Cleanup
del "%tempFile%" >nul 2>&1
pause
