$Image_objects = (Get-Content .\image.json | ConvertFrom-Json).Image
$Length_Image = $Image_objects.Length
Write-Host "Length of Image in json file is: $Length_Image"
Write-Host "Image List:"
($Image_objects | Where-Object {$_.hoffset -eq $_.woffset}).name
