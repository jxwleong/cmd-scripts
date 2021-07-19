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

$file = New-Object System.IO.FileInfo($PSCommandPath)
$filename = -join($file.BaseName, $file.Extension)
$ScriptName = $MyInvocation.MyCommand.Name
Write-Output "`nName of the script : $scriptName"
$Currentlocation = Get-Location
Log-Message "Current File Dir: $Currentlocation"
Write-Host (Get-Item .).FullName
Log-Message "File Name: $filename"
Log-Message "Full File Path: $PSCommandPath"
Log-Message "Current Working Directory: $pwd"


# https://stackoverflow.com/a/53134449
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
{ 
   $ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition 
}
else
{ 
   $ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0]) 
   if (!$ScriptPath){ $ScriptPath = "." } 
}
return $ScriptPath
Write-Host $ScriptPath
Start-Sleep -s 5