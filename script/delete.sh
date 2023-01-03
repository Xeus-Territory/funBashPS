#!/bin/bash

# stop container
docker kill $(docker ps -q)

# remove all container 
docker container prune --force 

# remove all image 
docker image prune -a -f 
