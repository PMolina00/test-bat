@echo off & setlocal enabledelayedexpansion

set /P stash_name= Enter stash name: 
set /P branch_name= Enter new branch name: 
set /P commit_des= Enter commit description: 
set /P isFeature= Is it a feature?Y/N: 
set branch_type= features/

if /i "!isFeature!" == "N" set branch_type= bugs/
for %%i in (!branch_type!,!stash_name!,!branch_name!)do Echo/%%~i

:Ask_Again
set /P areYouSure= You are going to create a branch named "!branch_type!!branch_name!", are u sure? [Y/N]:

echo/!areYouSure!|"%__APPDIR__%Findstr.exe" /bei "Y  N" >nul || goto :Ask_Again

if /i "!areYouSure!" == "Y" ( 
      for %%i in (
      stash save %stash_name%,
      checkout pre-dev,
      pull origin pre-dev,
      stash pop stash@^{0^},
      stash save %stash_name%,
      checkout root-branch,
      pull origin root-branch,
      branch %branch_type%%branch_name%,
      checkout %branch_type%%branch_name%,
      stash apply stash@^{0^}
      add .,
      commit -m "%branch_name% %commit_des%",
      push origin %branch_type%%branch_name%,
      checkout pre-dev,
      pull origin pre-dev,
      stash apply stash@^{0^}
      add .,
      commit -m "%branch_name%# %commit_des%",
      push origin pre-dev 
    )do Git %%~i || "%__APPDIR__%Timeout.exe" -1 
) else echo/areYouSure = N 
endlocal
