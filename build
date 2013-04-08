#!/bin/bash

set -e

STACK_NAME=$1

if [ -z "$STACK_NAME" ]; then
  echo 'Usage: build.sh STACK_NAME (e.g. lucid64)'
  exit 1
fi

export VAGRANT_CWD=$STACK_NAME
vagrant up
echo "Created file $STACK_NAME/rootfs.tgz"
vagrant destroy -f
