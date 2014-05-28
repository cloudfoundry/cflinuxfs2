all: lucid64.tar.gz

# lucid stack targets
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


# trusty stack targets
trusty64.cid: trusty64/Dockerfile
	docker build -t cloudfoundry/trusty64 trusty64

	# create a container to export
	docker run -cidfile=trusty64.cid cloudfoundry/trusty64 ls

trusty64.tar: trusty64.cid
	docker export `cat trusty64.cid` > trusty64.tar
	rm trusty64.cid

trusty64.tar.gz: trusty64.tar
	tar -C trusty64/assets -f trusty64.tar -r etc/hosts etc/timezone
	gzip -f trusty64.tar
