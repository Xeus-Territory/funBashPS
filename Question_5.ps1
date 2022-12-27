$URL = Read-Host -Prompt "Input URL link you want to download"
$File_name = $URL.split("/")[-1]  
$Folder_name = $File_name.Replace('.zip','') 

$father_path = Split-Path -Parent $MyInvocation.MyCommand.Definition 

$Folder_path = $father_path +"\"+ $Folder_name
$File_path = $father_path + "\" + $File_name

Invoke-WebRequest -URI $URL -OutFile $File_path
Expand-Archive -Path $File_path -Destination $Folder_path


