@echo off
setlocal enabledelayedexpansion

:loop
cls

REM Check if the current directory contains a .git directory
if not exist .git (
    echo This directory does not contain a .git directory.
    pause
    exit /b 1
)

REM Get changed files into array
set i=0
set "files="
for /f "delims=" %%F in ('git status --porcelain') do (
    set /a i+=1
    REM Get the file path after the status chars (e.g. " M file.txt")
    set "line=%%F"
    set "filepath=!line:~3!"
    set "files[!i!]=!filepath!"
)

if %i%==0 (
    echo No changes to commit.
    pause
    goto loop
)

REM Show files with index
echo Changed files:
for /L %%j in (1,1,%i%) do (
    echo [%%j] !files[%%j]!
)

REM Prompt which files to stage
:askFiles
set /p choice=Choose files to stage by index (e.g. 1,3) or type "all": 
if /i "%choice%"=="all" (
    git add .
) else (
    REM Validate input and stage selected files
    setlocal enabledelayedexpansion
    set valid=1
    for %%c in (%choice%) do (
        REM Remove commas
        set idx=%%c
        set idx=!idx:,=!
        REM Check if idx is numeric and in range
        for /f "delims=0123456789" %%x in ("!idx!") do set valid=0
        if !idx! gtr %i% set valid=0
    )
    if !valid! neq 1 (
        echo Invalid input. Please enter valid indices separated by commas, or "all".
        endlocal
        goto askFiles
    )
    REM Stage chosen files
    for %%c in (%choice%) do (
        set idx=%%c
        set idx=!idx:,=!
        git add "!files[!idx!]!"
    )
    endlocal
)

REM Ask for commit message
set /p commitMessage=Enter commit message: 

REM Get remote name
for /f "tokens=*" %%r in ('git remote') do set remoteName=%%r
if "%remoteName%"=="" (
    echo No remote found in the .git/config file.
    pause
    exit /b 1
)

REM Get remote URL
for /f "tokens=*" %%u in ('git config --get remote.%remoteName%.url') do set repoUrl=%%u
if "%repoUrl%"=="" (
    echo No URL found for remote '%remoteName%' in the .git/config file.
    pause
    exit /b 1
)

REM Get current branch
for /f "tokens=*" %%b in ('git branch --show-current') do set branchName=%%b

echo Repository: %repoUrl%
echo Branch: %branchName%

REM Commit and push
git commit -m "%commitMessage%"
git push %remoteName% %branchName%

pause
goto loop
