all: trusty64.tar.gz

# trusty stack targets
trusty64.cid: trusty64/Dockerfile
	docker build -t cloudfoundry/trusty64 trusty64

	# create a container to export
	docker run --cidfile=trusty64.cid cloudfoundry/trusty64 dpkg -l | tee rootfs_trusty_dpkg_l.out

trusty64.tar: trusty64.cid
	docker export `cat trusty64.cid` > trusty64.tar
	rm trusty64.cid

trusty64.tar.gz: trusty64.tar
	tar -C trusty64/assets -f trusty64.tar -r etc/hosts etc/timezone
	gzip -f trusty64.tar

rootfs.tgz: trusty64.tar.gz
  cp trusty64.tar.gz trusty64/rootfs.tgz
