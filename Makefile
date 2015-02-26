all: rootfs.tgz

cflinuxfs2.cid: cflinuxfs2/Dockerfile
	docker build -t cloudfoundry/cflinuxfs2 cflinuxfs2
	docker run --cidfile=cflinuxfs2.cid cloudfoundry/cflinuxfs2 dpkg -l | tee cflinuxfs2/cflinuxfs2_dpkg_l.out

cflinuxfs2.tar: cflinuxfs2.cid
	docker export `cat cflinuxfs2.cid` > cflinuxfs2.tar
	# Always remove the cid file in order to grab updated package versions.
	rm cflinuxfs2.cid

cflinuxfs2.tar.gz: cflinuxfs2.tar
	tar -C cflinuxfs2/assets -f cflinuxfs2.tar -r etc/hosts etc/timezone
	gzip -f cflinuxfs2.tar

rootfs.tgz: cflinuxfs2.tar.gz
	cp cflinuxfs2.tar.gz cflinuxfs2/rootfs.tgz

upload_cflinuxfs2:
	# Depends on cflinuxfs2/rootfs.tgz existing, but does not explicitly say this
	# so that the rootfs.tgz is not remade when uploading.
	./upload_stack cflinuxfs2 > etag
	./docker_push.sh
	echo "Rootfs SHASUM: `shasum cflinuxfs2/rootfs.tgz`" > cflinuxfs2/cflinuxfs2_receipt
	echo "Docker Image: `docker images | grep cloudfoundry/cflinuxfs2 | grep latest | awk '{ print $3 }'`" >> cflinuxfs2/cflinuxfs2_receipt
	echo "S3 ETag: `cat etag`" >> cflinuxfs2/cflinuxfs2_receipt
	echo "" >> cflinuxfs2/cflinuxfs2_receipt
	cat cflinuxfs2/cflinuxfs2_dpkg_l.out >> cflinuxfs2/cflinuxfs2_receipt
	rm etag
	rm cflinuxfs2/rootfs.tgz
	echo "Don't forget to save the cflinuxfs2/cflinuxfs2_receipt file"
