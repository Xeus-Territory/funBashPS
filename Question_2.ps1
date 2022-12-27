Write-Host "================================================"
Write-Host "List all files in the current directory, sorts the output, remove file extensions: "
Get-ChildItem | Sort-Object| ForEach-Object -Process {[System.IO.Path]::GetFileNameWithoutExtension($_)} 


Write-Host "================================================"
Write-Host "List only show .txt files: "
$txt = Get-ChildItem -Filter "*.txt"
Write-Host $txt

Write-Host "================================================"

Write-Host "List files and folders that have been created within 1 day: "
Get-ChildItem | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-1)}



