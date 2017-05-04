all: cflinuxfs2.tar.gz

arch:=$(shell uname -m)
ifeq ("$(arch)","ppc64le")
        docker_image := "ppc64le/ubuntu:trusty"
        docker_file := cflinuxfs2/Dockerfile.$(arch)
        $(shell cp cflinuxfs2/Dockerfile $(docker_file))
        $(shell sed -i 's/FROM ubuntu:trusty/FROM ppc64le\/ubuntu:trusty/g' $(docker_file))
else
        docker_image := "ubuntu:trusty"
        docker_file := cflinuxfs2/Dockerfile
endif

cflinuxfs2.cid: 
	docker build --no-cache -f $(docker_file) -t cloudfoundry/cflinuxfs2 cflinuxfs2
	docker run --cidfile=cflinuxfs2.cid cloudfoundry/cflinuxfs2 dpkg -l | tee cflinuxfs2/cflinuxfs2_dpkg_l.out

cflinuxfs2.tar: cflinuxfs2.cid
	mkdir -p tmp
	docker export `cat cflinuxfs2.cid` > tmp/cflinuxfs2.tar
	# Always remove the cid file in order to grab updated package versions.
	rm cflinuxfs2.cid

cflinuxfs2.tar.gz: cflinuxfs2.tar
	docker run -w /cflinuxfs2 -v `pwd`:/cflinuxfs2 "ubuntu:trusty" bash -c "gzip -f tmp/cflinuxfs2.tar && mv tmp/cflinuxfs2.tar.gz ."
