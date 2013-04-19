Cloud Foundry Stacks
====================

This repo contains scripts for creating warden root filesystems.

To create a rootfs for the lucid64 stack:

```shell
./init
./build_stack lucid64
```

To upload the new rootfs to s3:

```shell
export AMAZON_ACCESS_KEY_ID=your-aws-id
export AMAZON_SECRET_ACCESS_KEY=your-aws-key
./upload_stack lucid64
```
