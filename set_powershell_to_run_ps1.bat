@echo off
REM Src: https://superuser.com/a/852877
REM --> add the following to the top of your bat file--

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    goto start

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
    goto start
:--------------------------------------

:start
echo Setting registry key (HKCR\Microsoft.PowerShellScript.1\Shell\Open\Command) default value to
echo ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "%%1")
REG ADD HKCR\Microsoft.PowerShellScript.1\Shell\Open\Command /f /t REG_SZ /ve /d "\"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe\" \"%%1\"
echo Ignore the "ERROR: Access is denied."
echo Check the value via regedit.msc (Computer\HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.1\Shell\Open\Command)
REM Default value: "C:\Windows\System32\notepad.exe" "%1"
exit /B %errorlevel%