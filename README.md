Cloud Foundry Stacks
====================

This repo contains scripts for creating warden root filesystems.

# Dependencies

* Vagrant
* Ruby 1.9.3-p484 or higher

# Adding a new package to the rootfs

`lucid64/build` has a list of packages that are passed to `apt-get install`.
To add new packages, just add the name of the package to that list.

# Creating a rootfs tarball

To create a rootfs for the lucid64 stack:

```shell
gem install bundler
bundle install
./init
./build_stack lucid64
```

# Uploading to s3 bucket

s3 bucket is used by [warden-test-infrastructure](https://github.com/cloudfoundry/warden-test-infrastructure), so it needs to be uploaded there.

To upload the new rootfs to s3:

```shell
export AMAZON_ACCESS_KEY_ID=your-aws-id
export AMAZON_SECRET_ACCESS_KEY=your-aws-key
./upload_stack lucid64
```

# Updating rootfs blob in cf-release

To update rootfs package in cf-release overwrite rootfs blob cf-release/blobs/rootfs/lucid64.tar.gz with the new tarball.

Run `bosh upload blobs` to upload package to bosh blobstore.

After cf-release is updated with the new rootfs, future DEAs will automatically use that rootfs for its warden containers.
