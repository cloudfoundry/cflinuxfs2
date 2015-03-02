#!/bin/bash

if [ -z $DOCKERHUB_EMAIL ]; then echo "Must set DOCKERHUB_EMAIL"; exit 1; fi
if [ -z $DOCKERHUB_PASSWORD ]; then echo "Must set DOCKERHUB_PASSWORD"; exit 1; fi
if [ -z $DOCKERHUB_USERNAME ]; then echo "Must set DOCKERHUB_USERNAME"; exit 1; fi

STACK=$1

docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD -e $DOCKERHUB_EMAIL
docker push cloudfoundry/$STACK:latest
