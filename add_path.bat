@echo off
REM Ref: https://stackoverflow.com/a/16203904
for /f "delims=" %%i in ('set pathext') do set output=%%i

echo %output%


call :string_contain abcd bcd
echo %errorlevel%
:string_contain
echo "%1" | findstr /r /C:"%2" > nul 2> nul
