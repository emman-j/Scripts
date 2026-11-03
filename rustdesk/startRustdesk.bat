@echo off
title RustDesk Launcher

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ==============================
echo        PC IP ADDRESS
echo ==============================

ipconfig | findstr /i "IPv4"

echo.
echo ==============================
echo       STARTING RUSTDESK
echo ==============================

:: Start RustDesk from the same folder as this BAT file
if exist "%~dp0rustdesk-1.4.8-x86_64.exe" (
    start "" "%~dp0rustdesk-1.4.8-x86_64.exe"
) else (
    echo ERROR: rustdesk.exe was not found.
    echo Expected location:
    echo %~dp0rustdesk.exe
    pause
    exit /b 1
)

echo.
echo RustDesk started as Administrator.
pause
