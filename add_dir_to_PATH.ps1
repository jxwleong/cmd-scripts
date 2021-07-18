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

Log-Message "Current File Dir: $PSScriptRoot"
Log-Message "File Name: $filename"
Log-Message "Full File Path: $PSCommandPath"

