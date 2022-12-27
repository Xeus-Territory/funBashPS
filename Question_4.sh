read -p "What text file you want to kill: " filename

command=$(ps -aux | grep nano | grep $filename | awk '{print $2}')
if [ $command -ne 0 ]
then 
    echo "Process ID you kill is "$command
    echo "Kill Done"
    kill $command
else 
    echo "Do not have text file"
fi

