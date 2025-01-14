@echo off
setlocal

:: Print the current working directory
echo Current directory: %CD%

:: Count the total files to unblock
set /a count=0
for /r %%i in (*) do (
  set /a count+=1
)
echo Total items to be unblocked: %count%

:: Confirmation prompt
set /p confirm="Proceed with unblocking files? (Y/N): "
if /i not "%confirm%"=="Y" (
  echo Unblocking cancelled.
  pause
  exit /b
)

:: Unblock files
for /r %%i in (*) do (
  echo Unblocking %%i
  powershell -command Unblock-File -Path "%%i"
)

pause
