@echo off
set filepath=%~f0
set filedir=%~dp0
set filename=%~n0%~x0 
REM filename without extension
REM filename=%~n0
echo %filepath%
echo %filedir%
echo %filename%