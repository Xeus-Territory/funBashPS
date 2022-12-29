#!/bin/bash
docker pull mhart/alpine-node:14
docker build -t nodejs14:Q3 /${PWD#/*}
docker run --hostname nodjs_hello -p 3000:3000 nodejs14:Q3

