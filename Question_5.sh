read -p "Input URL link you want to download : " URL
sub_url='.zip'
if grep -q "$sub_url" <<< "$URL ";
then
    wget $URL
    file_zip=$(ls | egrep '\.zip')
    folder_zip=$(echo $file_zip | rev | cut -c5- | rev)
    mkdir $folder_zip
    # sudo apt -y install zip
    unzip $file_zip -d $folder_zip
    echo "-------------------------------"
    echo "Download and Unzip successfully"

else 
    echo "URL zip is false"
fi
