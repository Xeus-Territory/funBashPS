$string = Read-Host -Prompt "Input following below to choose which app you want kill
1. notepad
2. wordpad
2. WINWORD
Enter app "
$ID = Get-Process $string  | Select-Object -ExpandProperty Id
Stop-Process -Id $ID -PassThru -Force
