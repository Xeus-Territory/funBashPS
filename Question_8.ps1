$port = Read-Host -Prompt "Input port you want to check"
$check_port = (Test-NetConnection -ComputerName "www.orientsoftware.com" -Port $port).TcpTestSucceeded
if ($check_port -eq "True"){
    Write-Host $port "is open"
} 
