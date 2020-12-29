@echo off

rem fileencoding:SJIS(cp932).

set ps_name="ZeroTier One"

rem ********
rem settings
rem ********

rem set the zerotier network id
set zerotier_id=""



rem ********************************************
rem run this script with administrator authority
rem ********************************************

rem chcek whether this script running with administrator authority or not
openfiles > nul
if %errorlevel% neq 0 (
  powershell start-process %~0 %1 -verb runas
  echo not runnning with administrator authority. re-run with administrator authority
  exit /b
)


if "%1" == "" (
  echo run with an argument. args:[start, stop, join, leave]
  pause
  exit /b
)

if "%1" == "start" (
  call :start 
  rem
)
if "%1" == "stop" (
  call :stop 
  rem
)
if "%1" == "join" (
  call :join 
  rem
)
if "%1" == "leave" (
  call :leave 
  rem
)
pause
exit /b


rem **************
rem start zerotier
rem **************
:start 
for /f "usebackq" %%i in (`powershell Get-Process -name ""%ps_name%""`) do (
  set flag=%%i
)
if "%flag%" == "+" (
  echo starting zerotier...
  powershell Start-Process ""%ps_name%""
  echo coplete.
) else (
  echo %ps_name% is already running
)
exit /b


rem *************
rem stop zerotier
rem *************
:stop 
for /f "usebackq" %%i in (`powershell Get-Process -name ""%ps_name%""`) do (
  set flag=%%i
)
if not "%flag%" == "+" (
  echo stopping zerotier...
  powershell Stop-Process -name ""%ps_name%""
) else ( 
  echo %ps_name% is not running
)
exit /b


rem ****************
rem join the network
rem ****************
:join 
rem if zerotier is not running, start zerotier
call :start
powershell zerotier-cli status
powershell zerotier-cli join %zerotier_id%
echo joined  %zerotier_id%



rem **********************
rem leave from the network
rem **********************
:leave 
echo leaving from %zerotier_id% ...
powershell zerotier-cli leave %zerotier_id%
exit /b
