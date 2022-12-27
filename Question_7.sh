read -p "What name of file json(without extension): " json_file
if [ -f $json_file.json ]
then
    length_image=$(jq length ./$json_file.json)
    echo ""
    echo "Length of Image in json file is: "$length_image
    echo "Image List:"
    for((i=0;i<$length_image;i++));
    do
        value_h0ffset=$(cat image.json | jq  ".Image[$i].h0ffset")
        value_v0ffset=$(cat image.json | jq  ".Image[$i].v0ffset")
        if [[ $value_h0ffset -eq $value_v0ffset ]]
        then
            cat image.json | jq -r ".Image[$i].name"
        else 
            continue
        fi
    done 
else 
    echo "File do not exist"
fi
