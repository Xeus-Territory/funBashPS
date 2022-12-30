#!/bin/bash
sudo docker rm -f $(docker ps -a)

sudo docker rmi $(docker image list)