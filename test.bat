@echo off

echo %CD%

set file_dir=%~dp0

@echo off
Set filename="C:\Documents and Settings\All Users\Desktop\Dostips.cmd"
call :expand %filename%
:expand
set filename=%~nx1
echo The name of the file is %filename%
set folder=%~dp1
echo It's path is %folder%