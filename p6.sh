#!/bin/bash

# 6. Delete everything in a folder, mute all outputs and continue if any error

read -p "What the folder you want to delete: " folder

# Run with one command

# if [[ -d $folder ]]
# then
#     command=$(rm -rf $folder)
#     echo "delete complete"
# else
#     echo "This folder is not existed"
# fi


# Run with remove stderr ignore and dev/null
if [[ -d $folder ]]
then 
    for filename in $folder/*
    do
        rm $filename 2> /dev/null || continue
    done
    rmdir $folder 2> /dev/null || exit 0
fi