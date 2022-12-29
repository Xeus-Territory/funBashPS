#!/bin/bash
read -r -p "The name you want to give the container is: " namecontainer
docker pull mhart/alpine-node:14
docker build -t nodejs14:Q4 /${PWD#/*}
docker run -d --name $namecontainer -p 3000:3000 nodejs14:Q4 
sleep 3
test=$(http --body localhost:3000) 
if [[ "$test" == "Hello Node!" ]]

then 
        echo "Local web server is running"
else 
        echo "WARM: Local web server is not running"
fi  

