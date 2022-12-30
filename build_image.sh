#!/bin/bash

read -p "What version of nodejs image you want to build: " version

if [[ $version -eq 12 ]]
then 
    sudo docker pull mhart/alpine-node:12
    sudo docker build -t nodejs12:v12 ./Node_Hello_14/
    sudo docker run --hostname nodejs12_hello -p 3000:3000 nodejs12:v12
fi

if [[ $version -eq 14 ]]
then 
    sudo docker pull mhart/alpine-node:14
    sudo docker build -t nodejs14:v14 ./Node_Hello_14/
    sudo docker run --hostname nodejs14_hello -p 3001:3001 nodejs14:v14
fi





