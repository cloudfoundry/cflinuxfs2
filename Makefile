all: opensuse42.tar.gz

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

opensuse42.cid:
	docker build --no-cache -f $(docker_file) -t splatform/opensuse42 cflinuxfs2
	docker run --cidfile=opensuse42.cid splatform/opensuse42 zypper se --installed-only --details | tee cflinuxfs2/opensuse42_zypper.out

opensuse42.tar: opensuse42.cid
	docker export `cat opensuse42.cid` > opensuse42.tar
	# Always remove the cid file in order to grab updated package versions.
	rm opensuse42.cid

opensuse42.tar.gz: opensuse42.tar
	docker run -w /opensuse42 -v `pwd`:/opensuse42 splatform/opensuse42 bash -c "gzip -f opensuse42.tar"
