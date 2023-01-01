#!/bin/bash

# -------- PULL IMAGE ------------
    # pull image nodejs14
    docker pull mhart/alpine-node:14

    # pull image nGINX
    docker pull nginx:latest
# --------------------------------


# -------------------------------- CREATE IMAGE ---------------------------------
    # copy folder /src into folder /docker/frontend for dockerfile can read /src
    cp -r $(pwd)/../src/ $(pwd)/../docker/frontend/

    # build 4 image WEB by dockerfile
    docker build -t website:1 $(pwd)/../docker/frontend/
    docker build -t website:2 $(pwd)/../docker/frontend/
    docker build -t website:3 $(pwd)/../docker/frontend/
    docker build -t website:4 $(pwd)/../docker/frontend/

    # remove folder /src out of folder /docker/frontend
    rm -rf $(pwd)/../docker/frontend/src/

    # build image NGINX by dockerfile 
    docker build -t nginx:server $(pwd)/../docker/backend/
#-------------------------------------------------------------------------------


# ---------- CREATE CONTAINER ----------------
    # build 4 container through docker-compose
    docker-compose up --detach
# --------------------------------------------
