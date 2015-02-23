#!/bin/bash

docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD -e $DOCKERHUB_EMAIL
docker push cloudfoundry/cflinuxfs2:latest
