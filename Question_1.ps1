
Write-Output "Question 1. Check input date"
$Date = Read-Host -Prompt 'Input a date'
$regex = "[a-zA-z]{6,9}[,] [a-zA-z]{4,9} (0[1-9]|[12][0-9]|3[01])[,] (19|20)[0-9]{2}"
#check format
if ($Date -match $regex) {
    Write-Output "- Validate input: Right format"

     # Check leap year
    $Year = ($Date  -split "," -replace " ")[-1]
    if (($Year % 4 -eq 0) -and ($Year % 400 -eq 0) -and ($Year % 100 -eq 0)){
        Write-Output "- Validate year: This is a leap year"
    } else {
        Write-Output "- Validate year: This is not a leap year"
    }

     # Check weekend
    $Day = ($Date  -split "," -replace " ")[0]
    if ($Day -eq "Sunday"){
        Write-Output "- Validate weekend: This is a weekend"
    } else {
        Write-Output "- Validate year: This is not weekend"
    }
}
else {
    Write-Host "- Validate input: Not right format. Please enter follow format: Day, Month dd, yyyy"
}



