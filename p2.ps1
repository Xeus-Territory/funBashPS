#!/usr/bin/env pwsh

# 2. Write a Powershell script and a Bash script that:
# - List all files in the current directory, sorts the output, remove file
# extensions
# - List only show .txt files
# - List files and folders that have been created within 1 day

echo "List all files in the current directory, sorts the output, remove file extensions"
$list = (Get-Item *).Basename | Sort-Object
echo $list
echo ""
echo ""

echo "List only show .txt files"
$txtList = (Get-ChildItem -Path $dir -Filter *.txt |Select -First 1).Name
echo $txtList
echo ""
echo ""

echo "List files and folders that have been created within 1 day"
$day_today = (Get-Date).Date
$1_day_create = Get-ChildItem -Path $dir -Force -Recurse -File -ErrorAction SilentlyContinue | 
Where-Object { $_.LastWriteTime -ge $day_today } | 
Sort-Object LastWriteTime -Descending | 
Format-Table -Wrap

echo $1_day_create