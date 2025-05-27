@echo off 
setlocal 

REM Enable delayed expansion for dynamic variable reading 
setlocal enabledelayedexpansion 

REM Infinite loop 
:loop
	cls
	REM Check if the current directory contains a .git directory
	if not exist .git (
	    echo This directory does not contain a .git directory.
	    pause
	    exit /b 1
	)
	
	REM Check if there are any changes
	set changes=0
	for /f %%i in ('git status --porcelain') do (
	    set changes=1
	)
	if %changes%==0 (
	    cd
	    echo No changes to commit.
	    pause
	    goto loop
	)
	
	REM Show the changed files
	echo Changed files:
	git status -s
	
	REM Ask for commit message
	set /p commitMessage=Enter commit message: 
	
	REM Assign the output of 'git remote' to a variable
	for /f "tokens=*" %%i in ('git remote') do set remoteName=%%i
	
	REM Check if the remote name was found
	if "%remoteName%"=="" (
	    echo No remote found in the .git/config file.
	    pause
	    exit /b 1
	)
	
	git branch -r
	
	REM Get the remote URL from the .git/config file
	for /f "tokens=*" %%i in ('git config --get remote.%remoteName%.url') do set repoUrl=%%i
	
	if "%repoUrl%"=="" (
	    echo No URL found for remote '%remoteName%' in the .git/config file.
	    pause
	    exit /b 1
	)
	
	REM Get the current branch name
	for /f "tokens=*" %%i in ('git branch --show-current') do set branchName=%%i
	
	REM Show the repository and branch
	echo Repository: %repoUrl%
	echo Branch: %branchName%
	
	REM Add changes, commit, and push
	git add .
	git commit -m "%commitMessage%"
	git push %remoteName% %branchName%
	
	pause
	timeout /t 1 >nul 
	goto loop 
:end 
endlocal
