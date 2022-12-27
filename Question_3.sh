read -p "Please input: " string

# check empty
if test -z "$string" 
then
    read -p "Your input is empty, please make new script: " new_string
    if [ -f "$new_string" ] ;
    then
        echo "File exists."
    else
        # nano $new_string 
        echo "-----------------"
        echo "Print the new script: "
        cat $new_string

        echo "-----------------"
        echo "Path of the new script: "
        path=$(realpath "${BASH_SOURCE:-$0}")
        echo $path

        echo "-----------------"
        echo "Name of the new script: "
        echo $new_string | cut -f 1 -d '.'

        echo "-----------------"
        echo "Excute the new script: "
        ./$new_string
    fi
else
      echo "Input is NOT empty"
fi



