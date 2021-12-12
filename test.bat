@echo off & setlocal enabledelayedexpansion

set /P branch_name= Enter new branch name: 
set /P commit_des= Enter commit description: 

for %%i in (!branch_name!,!commit_des!)do Echo/%%~i
pause 
git add .
git stash
git branch !branch_name!
git checkout !branch_name!
git stash pop
git add .
git commit -m '!commit_des!'
endlocal
