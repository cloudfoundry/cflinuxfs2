Cloud Foundry Stacks
====================

This repo contains scripts for creating warden root filesystems.

* cflinuxfs2 derived from Ubuntu 14.04 (Trusty Tahr)

# Dependencies

* GNU make
* Docker

# Adding a new package to the rootfs

`cflinuxfs2/build/install-packages.sh` has a list of packages passed to `apt-get install` as well.

# Creating a rootfs tarball

To create a rootfs for the cflinuxfs2 stack:

```shell
make
```

This will create the `cflinuxfs2.tar.gz` file, which is the artifact used as the rootfs in Cloud Foundry deployments.

# Release pipeline

The generation and release of a new rootfs happens on the [stacks](https://buildpacks.ci.cf-app.com/pipelines/stacks) CI pipeline.

* A new stack is generated with `make`.

* The generated tarball is deployed with the [runtime-passed branch](https://github.com/cloudfoundry/cf-release/tree/runtime-passed) of BOSH cf-release.

	```shell
	mv stacks/cflinuxfs2.tar.gz cf-release/blobs/rootfs/cflinuxfs2.tar.gz
	cd cf-release
	bosh -n create release --force
	bosh -n upload release
	bosh -n deploy
	```
	
* The [cf-acceptance-tests](https://github.com/cloudfoundry/cf-acceptance-tests) of that cf-release are then run against that deployment.

	```shell
	cd cf-release/src/github.com/cloudfoundry/cf-acceptance-tests
	go get github.com/tools/godep
	godep restore
	./bin/test --nodes=4
	```

* Once all tests pass, the rootfs tarball can be found as a [Github Release](https://github.com/cloudfoundry/stacks/releases) and a [Docker Image](https://registry.hub.docker.com/u/cloudfoundry/cflinuxfs2/).