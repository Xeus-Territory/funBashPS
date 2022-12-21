#!/usr/bin/pwsh

# 1. Write a Powershell function and a Shell Script function that:
# - Take a string input as a date (i.e. Thursday, July 21, 2022)
# - Check if the date is in the right format “dddd,MM dd,YYYY”
# (using regex)
# - Check if the year is a leap year
# - Check if it is a weekend

$ChallengeName="P1 - Powershell"

echo "Hey this is my first $ChallengeName"
$Daytoday = Read-Host -Prompt "Which day you want to check"

if ($Daytoday -match '[A-Za-z]{6,9}, [A-Za-z]{3,9} [0-3]{1}[0-9]{1}, [1-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}')
{
    echo "Right format"
    $Day, $Year  = ($Daytoday -replace " " -split ",")[0,-1]
    if ((($Year % 4) -eq 0 -And ($Year % 100) -ne 0) -Or (($Year % 400) -eq 0 ))
    {
        echo "$Year is the leap year"
    }
    else
    {
        echo "$Year is not the leap year"
    }
    if (($Day -eq "Sunday"))
    {
        echo "$Daytoday is the weekend"
    }
    else
    {
        echo "$Daytoday is not the weekend"
    }
}
else
{
    echo "Not right format"
}