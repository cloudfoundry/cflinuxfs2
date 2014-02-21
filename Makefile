all: lucid64.tar.gz

lucid64.cid: lucid64/Dockerfile
	docker build -t cloudfoundry/lucid64 lucid64

	# create a container to export
	docker run -cidfile=lucid64.cid cloudfoundry/lucid64 ls

lucid64.tar: lucid64.cid
	docker export `cat lucid64.cid` > lucid64.tar
	rm lucid64.cid

lucid64.tar.gz: lucid64.tar
	tar -C lucid64/assets -f lucid64.tar -r etc/hosts etc/timezone
	gzip -f lucid64.tar
