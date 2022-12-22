#!/bin/bash

# 6. Delete everything in a folder, mute all outputs and continue if any error

read -p "What the folder you want to delete: " folder

if [[ -d $folder ]]
then
    command=$(rm -rf $folder)
    echo "delete complete"
else
    echo "This folder is not existed"
fi