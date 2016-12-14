all: cflinuxfs2.tar.gz

ifndef GO_URL
  GO_URL="https://buildpacks.cloudfoundry.org/concourse-binaries/go/go1.7.3.linux-amd64.tar.gz"
endif

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
	docker build --no-cache -f $(docker_file) -t cloudfoundry/cflinuxfs2 --build-arg go_url=$(GO_URL) cflinuxfs2
	docker run --cidfile=cflinuxfs2.cid cloudfoundry/cflinuxfs2 dpkg -l | tee cflinuxfs2/cflinuxfs2_dpkg_l.out

cflinuxfs2.tar: cflinuxfs2.cid
	mkdir -p tmp
	docker export `cat cflinuxfs2.cid` > tmp/cflinuxfs2.tar
	# Always remove the cid file in order to grab updated package versions.
	rm cflinuxfs2.cid

cflinuxfs2.tar.gz: cflinuxfs2.tar
	docker run -w /stacks -v `pwd`:/stacks $(docker_image) ./bin/make_tarball.sh cflinuxfs2
