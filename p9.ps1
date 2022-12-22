#!/usr/bin/env pwsh

# 9. Write a Powershell script and a Bash script that enable/disable SSH on a Windows/Linux machine

$mode = Read-Host -prompt "Enable/Disable SSH"
if ($mode -eq "Enable" -or $mode -eq "enable")
{
    Start-Service -name SSDPSRV -force
    Set-Service -name SSDPSRV -StartupType Manual
    Get-Service SSDPSRV
}
if ($mode -eq "Disable" -or $mode -eq "disable")
{
    Stop-Service -name SSDPSRV -force
    Set-Service -name SSDPSRV -StartupType Disabled
    Get-Service SSDPSRV
}