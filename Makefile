all: rootfs.tgz

cflinuxfs2.cid: cflinuxfs2/Dockerfile
	docker build -t cloudfoundry/cflinuxfs2 cflinuxfs2
	docker run --cidfile=cflinuxfs2.cid cloudfoundry/cflinuxfs2 dpkg -l | tee cflinuxfs2_dpkg_l.out

cflinuxfs2.tar: cflinuxfs2.cid
	docker export `cat cflinuxfs2.cid` > cflinuxfs2.tar
	rm cflinuxfs2.cid

cflinuxfs2.tar.gz: cflinuxfs2.tar
	tar -C cflinuxfs2/assets -f cflinuxfs2.tar -r etc/hosts etc/timezone
	gzip -f cflinuxfs2.tar

rootfs.tgz: cflinuxfs2.tar.gz
	cp cflinuxfs2.tar.gz cflinuxfs2/rootfs.tgz
