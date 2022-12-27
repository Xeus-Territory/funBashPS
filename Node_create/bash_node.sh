#!/bin/bash

read -p "Which node image do you want to work: " version

if [[ $version != "12" && $version != "14" ]]
then
    echo "$version is not supported"
    exit 1
else
    docker build -t nodejs:lastestv$version --build-arg version=$version .
fi