all: cflinuxfs2.tar.gz

docker_image := "ubuntu:trusty"
docker_file := cflinuxfs2/Dockerfile

arch:=$(shell uname -m)
ifeq ("$(arch)","ppc64le")
        docker_image := "ppc64le/ubuntu:trusty"
        docker_file := cflinuxfs2/Dockerfile.$(arch)
        $(shell cp cflinuxfs2/Dockerfile $(docker_file))
        $(shell sed -i 's/FROM ubuntu:trusty/FROM ppc64le\/ubuntu:trusty/g' $(docker_file))
endif
ifeq ("$(arch)","armv7l")
        docker_image := "armv7/armhf-ubuntu_core:14.04"
        docker_file := cflinuxfs2/Dockerfile.$(arch)
        $(shell cp cflinuxfs2/Dockerfile $(docker_file))
        $(shell sed -i 's/FROM ubuntu:trusty/FROM armv7\/armhf-ubuntu_core:14.04/g' $(docker_file))
endif

cflinuxfs2.cid: 
	docker build  -f $(docker_file) -t cloudfoundry/cflinuxfs2 cflinuxfs2
	docker run --cidfile=cflinuxfs2.cid cloudfoundry/cflinuxfs2 dpkg -l | tee cflinuxfs2/cflinuxfs2_dpkg_l.out

cflinuxfs2.tar: cflinuxfs2.cid
	docker export `cat cflinuxfs2.cid` > cflinuxfs2.tar
	# Always remove the cid file in order to grab updated package versions.
	rm cflinuxfs2.cid

cflinuxfs2.tar.gz: cflinuxfs2.tar
	docker run -w /cflinuxfs2 -v `pwd`:/cflinuxfs2 $(docker_image) bash -c "gzip -f cflinuxfs2.tar"
