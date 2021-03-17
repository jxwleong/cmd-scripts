@echo off
SetLocal EnableDelayedExpansion

REM countdown of 5 seconds
set count=5
set pbe_address=https://www.pbebank.com/
REM prepare carriage return
FOR /F %%a IN ('copy /Z "%~dpf0" nul') DO set "carret=%%a"

:ONE_SEC
REM print message
set /p =Go to %pbe_address% in %count% seconds...!carret!<nul
REM wait one sec
ping -n 2 127.0.0.1 > nul 2>&1
REM decrement
set /a count-=1
IF %count% GTR 0 goto :ONE_SEC

REM last print, now you can use echo but don't forget: you have to override each character of the previous print! so fill all remaining place with whitespaces
start %pbe_address%
REM  X seconds to go...

EndLocal
exit /b 0