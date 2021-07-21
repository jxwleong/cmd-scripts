# https://stackoverflow.com/a/38519670
function Log-Message
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$LogMessage
    )

    Write-Output ("{0} - {1}" -f (Get-Date), $LogMessage)
}



function Udf-GetDir
{
    # Get directory of current file 
    # [CmdletBinding()]
    # https://stackoverflow.com/a/53134449
    if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
    { 
        $ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition 
        Log-Message $ScriptPath
        Log-Message "External"
    }
    else
    { 
        $ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0]) 
        if (!$ScriptPath){ $ScriptPath =  $(Get-Location)} 
    }
    return $ScriptPath
}

function Udf-AddDirToPath{
    # Add to system variable
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Path
    )
    $PathArray = $env:Path.Split(";")
    $RegexStr = [Regex]::Escape($PathArray)
    $RegexStr = -join("$RegexStr", "$")
    if ($PathArray -Match $RegexStr)
    {
        Log-Message "'$Path' found in `$env:Path."
        return
    }
    else 
    {
        Log-Message "'$Path' NOT found in `$env:Path."
        # https://stackoverflow.com/a/2571200
        # "Machine" => "User" to set User variables
        Log-Message "Adding $Path to `$env:Path."
        $NewPath = -join($env:Path, ";$(Udf-GetDir)")
        Log-Message $NewPath
        [Environment]::SetEnvironmentVariable("Path", $NewPath, "Machine")
        [Environment]::SetEnvironmentVariable("Path", $NewPath, "Process")
        Log-Message "NEW Path: $env:Path"
        #[Environment]::SetEnvironmentVariable(
    #"Path",
    #[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$Newpath",
    #[EnvironmentVariableTarget]::Machine)
        # For cmd
        refreshenv
        # https://stackoverflow.com/a/22670892
        foreach($level in "Machine","User") {
            [Environment]::GetEnvironmentVariables($level)
         }
        Log-Message "Try restart the system if no PATH is not updated."
    }

}

# https://stackoverflow.com/a/37024745
function Set-Path ([string]$newPath, [bool]$permanent=$false, [bool]$forMachine=$false )
{
    $Env:Path += ";$newPath"

    $scope = if ($forMachine) { 'Machine' } else { 'User' }

    if ($permanent)
    {
        $command = "[Environment]::SetEnvironmentVariable('PATH', $env:Path, $scope)"
        Start-Process -FilePath powershell.exe -ArgumentList "-noprofile -command $Command" -Verb runas
    }

}
function Udf-RemoveDirFromPath
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Path
    )
    $PathArray = $env:Path.Split(";")
    $RegexStr = [Regex]::Escape($PathArray)
    $RegexStr = -join("$RegexStr", "$")
    if ($PathArray -Match $RegexStr)
    {
        Log-Message "'$Path' found in `$env:Path."
        Log-Message "Removing $Path from `$env:Path."
        $Remove = $Path
        $env:Path = ($env:Path.Split(';') | Where-Object -FilterScript {$_ -ne $Remove}) -join ';'
        Log-Message "New `$env:Path: $env:Path"
        [Environment]::SetEnvironmentVariable("Path", $env:Path, "Machine")
        refreshenv
        Log-Message "Try restart the system if no PATH is not updated."
    }
    else
    {
        Log-Message "'$Path' NOT found in `$env:Path."
        return

    }

}

# https://stackoverflow.com/a/34844707
function Add-EnvPath {
    param(
        [Parameter(Mandatory=$true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )

    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -notcontains $Path) {
            $persistedPaths = $persistedPaths + $Path | where { $_ }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $Path) {
        $envPaths = $envPaths + $Path | where { $_ }
        $env:Path = $envPaths -join ';'
    }
}

# This file is intended to add the current directory 
# to the system variables (PATH).
# So must run in directory where the PATh need to be appeneded.
if ($(Udf-GetDir) -eq $pwd)
{
    Log-Message "Current File Directory MUST be same as Current Working Directory."
    Log-Message "Make sure to run this file in the corrrect directory."
    Log-Message "Current File Directory: $(Udf-GetDir)"
    Log-Message "Current Working Directory: $pwd"
    Exit 1
}


Udf-AddDirToPath($(Udf-GetDir))
#$NewPath = -join($env:Path, ";$(Udf-GetDir)")
#Set-Path($NewPath, $true, $true)
#Add-EnvPath($(Udf-GetDir))
# $newPath = $(Add-EnvPath($(Udf-GetDir)))
#Log-Message $newPath
Log-Message "New Path: $env:Path"
Log-Message $(Udf-GetDir)
Start-Process powershell -Verb runAs
Log-Message "ALLOHA"
#Bank
#Udf-RemoveDirFromPath($(Udf-GetDir))
Log-Message "Delay for 5 seconds before exit."
Start-Sleep -s 5