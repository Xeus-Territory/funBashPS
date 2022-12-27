echo "Question 1. Check input date"
read -p "Input a date:" Date  

#check format
if [[ $Date =~ [a-zA-z]{6,9},[[:space:]]*[A-Za-z]{3,9}[[:space:]]*[0-3]{1}[0-9]{1},[[:space:]]*[1-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}$ ]]
then 
    echo "- Validate input: Right format"

    # Check leap year
    Year=$(echo $Date | cut -d "," -f 3)
    if [[ $(($Year % 4)) -eq 0 &&  $(($Year % 400)) -eq 0  &&  $(($Year % 100 )) -ne 0 ]]
    then 
        echo "- Validate year: This is a leap year"
    else    
        echo "- Validate year: This is not a leap year"
    fi

    # Check weekend
    Day=$(echo $Date | cut -d "," -f 1)
    if [ $Day = "Sunday" ]
    then 
        echo "- Validate weekend: This is a weekend"
    else 
        echo "- Validate weekend: This is not a weekend"
    fi 

else
    echo "- Validate input: Not right format. Please enter follow format: Day, Month dd, yyyy"
fi



