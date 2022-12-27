folder=$(pwd)
for file in $folder/*
do 
    if [[ -d $file ]] 
    then
        for sub_file in $file/*
        do
            rm $sub_file 2> /dev/null || continue
        done 
    rmdir $file 2> /dev/null || continue
    else 
    rm $file 2> /dev/null || continue
    fi
done 
rmdir $folder 2> /dev/null 
