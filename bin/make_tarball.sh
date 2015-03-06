#!/bin/bash

make_tarball="
	mkdir -p /tmp/$1/etc
	cp $1/assets/etc/hosts /tmp/$1/etc/hosts
	cp $1/assets/etc/timezone /tmp/$1/etc/timezone
	tar -C /tmp/$1 -xf /tmp/${1}.tar
	ls /tmp/$1/ | xargs tar -C /tmp/$1 -czf ${1}.tar.gz 
	rm -rf /tmp/$1
"

if [ "$(uname)" == "Darwin" ]; then
  sudo bash -c "$make_tarball"
  sudo chmod a+rw ${1}.tar.gz
else
  bash -c "$make_tarball"
fi
