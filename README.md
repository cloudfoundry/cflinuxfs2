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

# Creating a BOSH release from the rootfs tarball

To start, clone the repository containing the cflinuxfs2-rootfs BOSH release:

```shell
git clone git@github.com:cloudfoundry/cflinuxfs2-rootfs-release.git`
cd cflinuxfs2-rootfs-release`
```

Replace the old cflinuxfs2 tarball with the new tarball created above:

```shell
rm -f config/blobs.yml
mkdir -p blobs/rootfs
cp <path-to-new-tarball>/cflinuxfs2.tar.gz blobs/rootfs/cflinuxfs2-new.tar.gz
```

Create a dev release and upload it to your BOSH deployment:

```shell
bosh create release --force --with-tarball --name cflinuxfs2-rootfs
bosh upload release <generated-dev-release-tar-file>
```

If your Diego deployment manifest has `version: latest` indicated for the `cflinuxfs2-rootfs` release, then redeploying your Diego will enable this new rootfs to be used in your app containers.


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