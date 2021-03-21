function Invoke-UdfGetLastOperationStatus(){
    If ($? -eq $True){
        return "PASS"
    } Else {
        return "FAIL"
    }
}

Write-Output "$(Get-Date) Starting CCleaner..."
CCleaner.exe /AUTO
Write-Output "$(Get-Date) CCleaner launch status: $(Invoke-UdfGetLastOperationStatus)"

# https://docs.microsoft.com/en-us/windows/security/threat-protection/microsoft-defender-antivirus/command-line-arguments-microsoft-defender-antivirus
Write-Output "$(Get-Date) Starting Microsoft Defender with Quick Scan"
MpCmdRun.exe -Scan -ScanType 1
Write-Output "$(Get-Date) Microsoft Defender status: $(Invoke-UdfGetLastOperationStatus)"