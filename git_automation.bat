@echo off
setlocal enabledelayedexpansion

REM Check if the current directory contains a .git directory
if not exist .git (
    echo This directory does not contain a .git directory.
    pause
    exit /b 1
)

REM Get list of changed files
set i=0
set changes=0
for /f "delims=" %%f in ('git status --porcelain') do (
    set /a i+=1
    set "fileLine[!i!]=%%f"
    set "fileName[!i!]=%%f"
    set changes=1
)

if %changes%==0 (
    echo No changes to commit.
    pause
    exit /b 0
)

echo.
echo Changed files:
echo.

for /l %%j in (1,1,%i%) do (
    set "line=!fileLine[%%j]!"
    REM Remove the status prefix (e.g., " M ") to isolate filename
    set "name=!line:~3!"
    echo [%%j] !name!
)

echo.
set /p indexList=Choose files to stage (e.g., 1,3,4): 

REM Stage selected files
for %%k in (%indexList%) do (
    set "line=!fileLine[%%k]!"
    set "filename=!line:~3!"
    git add "!filename!"
)

REM Ask for commit message
set /p commitMessage=Enter commit message: 

REM Get remote name
for /f "tokens=*" %%i in ('git remote') do set remoteName=%%i

if "%remoteName%"=="" (
    echo No remote found.
    pause
    exit /b 1
)

REM Get remote URL
for /f "tokens=*" %%i in ('git config --get remote.%remoteName%.url') do set repoUrl=%%i

if "%repoUrl%"=="" (
    echo No URL found for remote '%remoteName%'.
    pause
    exit /b 1
)

REM Get current branch name
for /f "tokens=*" %%i in ('git branch --show-current') do set branchName=%%i

echo.
echo Repository: %repoUrl%
echo Branch: %branchName%

REM Commit and push
git commit -m "%commitMessage%"
git push %remoteName% %branchName%

pause
