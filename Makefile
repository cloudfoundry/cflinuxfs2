all: cflinuxfs2.tar.gz lucid64.tar.gz

cflinuxfs2.cid: cflinuxfs2/Dockerfile
	docker build --no-cache -t cloudfoundry/cflinuxfs2 cflinuxfs2
	docker run --cidfile=cflinuxfs2.cid cloudfoundry/cflinuxfs2 dpkg -l | tee cflinuxfs2/cflinuxfs2_dpkg_l.out

cflinuxfs2.tar: cflinuxfs2.cid
	docker export `cat cflinuxfs2.cid` > cflinuxfs2.tar
	# Always remove the cid file in order to grab updated package versions.
	rm cflinuxfs2.cid

cflinuxfs2.tar.gz: cflinuxfs2.tar
	tar -C cflinuxfs2/assets -f cflinuxfs2.tar -r etc/hosts etc/timezone
	gzip -f cflinuxfs2.tar

lucid64.cid: lucid64/Dockerfile
	docker build --no-cache -t cloudfoundry/lucid64 lucid64
	docker run --cidfile=lucid64.cid cloudfoundry/lucid64 dpkg -l | tee lucid64/lucid64_dpkg_l.out

lucid64.tar: lucid64.cid
	docker export `cat lucid64.cid` > lucid64.tar
	# Always remove the cid file in order to grab updated package versions.
	rm lucid64.cid

lucid64.tar.gz: lucid64.tar
	tar -C lucid64/assets -f lucid64.tar -r etc/hosts etc/timezone
	gzip -f lucid64.tar
