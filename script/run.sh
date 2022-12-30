#!/bin/bash

# pull image nodejs14 on Dockerhub
docker pull mhart/alpine-node:14

# copy folder /src into folder /docker for dockerfile can read /src
cp -r $(pwd)/../src/ $(pwd)/../docker/

# build 4 image by dockerfile
docker build -t web:v1 $(pwd)/../docker/
docker build -t web:v2 $(pwd)/../docker/
docker build -t web:v3 $(pwd)/../docker/
docker build -t web:v4 $(pwd)/../docker/

# remove folder /src out of folder /docker
rm -rf $(pwd)/../docker/src/

# build 4 container through docker-compose
docker-compose up --detach
