Cloud Foundry cflinuxfs2
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

To start, clone the [repository](https://github.com/cloudfoundry/cflinuxfs2-rootfs-release) containing the cflinuxfs2-rootfs BOSH release:

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

# Testing the rootfs

To run the local tests, just run `rspec`. If the top level of this repo contains a file named `cflinuxfs2.tar.gz`, the tests will be run against this file. Otherwise, `make` will  be run to create a new rootfs.

To test the rootfs BOSH release, see the instructions [here](https://github.com/cloudfoundry/cflinuxfs2-rootfs-release/blob/master/README.md)

# Release pipeline

The generation and release of a new rootfs happens on the [cflinuxfs2](https://buildpacks.ci.cf-app.com/pipelines/cflinuxfs2) CI pipeline.

* A new stack is generated with `make`.

* A dev BOSH release of that new stack is generated and deployed to the BOSH Lite at stacks.buildpacks.ci.cf-app.com and the rootfs smoke tests run.

* CF and Diego are deployed to that BOSH Lite. The [cf-acceptance-tests](https://github.com/cloudfoundry/cf-acceptance-tests) are then run against the deployment.

* Once all tests pass and the product manager ships the release, the rootfs tarball can be found as a [Github Release](https://github.com/cloudfoundry/cflinuxfs2/releases), [Docker Image](https://registry.hub.docker.com/u/cloudfoundry/cflinuxfs2/), and as a [BOSH release](https://github.com/cloudfoundry/cflinuxfs2-rootfs-release). A commit is also made to update the blobs on cf-release develop.
