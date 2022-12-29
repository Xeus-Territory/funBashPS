#!/bin/bash

# Move on the src folder and after that execute the docker script
cp -r $PWD/../src/ $PWD/../Docker/
cd $PWD/../Docker/ || exit

# Pull and create each website with specified name
docker build -t webpage8001:latest -f Dockerfile.web .
docker build -t webpage8002:latest -f Dockerfile.web .
docker build -t webpage8003:latest -f Dockerfile.web .
docker build -t webpage8004:latest -f Dockerfile.web .

rm -rf src/

docker build -t nginx_alb:latest -f Dockerfile.server .

cd .. || exit

docker-compose up -d

# # Docker run with specified name and bind port to local machine

# docker run -d --name webpage8001 -p 8001:3000 webpage8001:latest
# docker run -d --name webpage8002 -p 8002:3000 webpage8002:latest
# docker run -d --name webpage8003 -p 8003:3000 webpage8003:latest
# docker run -d --name webpage8004 -p 8004:3000 webpage8004:latest
