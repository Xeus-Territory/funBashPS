#!/bin/bash

# Move on the src folder and after that execute the docker script
cp -r $PWD/../src/ $PWD/../Docker/
cd $PWD/../Docker/ || exit

# Pull and create each website with specified name
docker build --target webpage -t webpage8001:latest --build-arg msg="APP 1 !" .
sleep 3
docker build --target webpage -t webpage8002:latest --build-arg msg="APP 2 !" .
sleep 3
docker build --target webpage -t webpage8003:latest --build-arg msg="APP 3 !" .
sleep 3
docker build --target webpage -t webpage8004:latest --build-arg msg="APP 4 !" .

rm -rf src/

# Docker run with specified name and bind port to local machine

docker run -d --name webpage8001 -p 8001:3000 webpage8001:latest
docker run -d --name webpage8002 -p 8002:3000 webpage8002:latest
docker run -d --name webpage8003 -p 8003:3000 webpage8003:latest
docker run -d --name webpage8004 -p 8004:3000 webpage8004:latest
