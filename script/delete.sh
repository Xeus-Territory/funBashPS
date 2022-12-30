#!/bin/bash

# remove all container 
docker rm -f $(docker ps -a)

# remove all image 
docker rmi $(docker image list)
