Start-Process powershell.exe -Verb RunAs ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
$mode = Read-Host -prompt "Enable/Disable SSH"
if ($mode -eq "Enable" -or $mode -eq "enable") {
Start-Service -name SSDPSRV
Set-Service -name SSDPSRV -StartupType Manual
Get-Service SSDPSRV
}
if ($mode -eq "Disable" -or $mode -eq "disable") {
Stop-Service -name SSDPSRV -force
Set-Service -name SSDPSRV -StartupType Disabled
Get-Service SSDPSRV
}
