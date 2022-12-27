$father_path = Split-Path -Parent $MyInvocation.MyCommand.Definition 
Remove-Item $father_path -Include *.* -Recurse 
