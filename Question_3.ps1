$string = Read-Host -Prompt 'Please Input' 

If ([String]::IsNullOrWhiteSpace($string)) {
    Write-Host "---------------------"
    $new_string = Read-Host 'Your input is empty, please make new script' 
    if (Test-Path -Path $new_string -PathType Leaf){
        Write-Host "File exists."
    } else {
        New-Item $new_string
        wsl nano $new_string
        Write-Host "---------------------"
        Write-Host "Print the new script: "
        Get-Content $new_string

        Write-Host "---------------------"
        Write-Host "Path of new script: "  
        $father_path = Split-Path -Parent $MyInvocation.MyCommand.Definition
        $full_path = $father_path + "\" +$new_string
        Write-Host $full_path
    
        Write-Host "---------------------"
        Write-Host "Name of the new script: "          
        $newVariable = Split-Path $total -Leaf |ForEach-Object -Process {[System.IO.Path]::GetFileNameWithoutExtension($_)} 
        Write-Host $newVariable

        Write-Host "---------------------"
        Write-Host "Excute new script: " 
        powershell.exe -ExecutionPolicy ByPass -File "$total"
    }
} else {
    Write-Host "Input is NOT empty"
}

