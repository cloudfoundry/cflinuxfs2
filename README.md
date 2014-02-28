### To recreate the rootfs:

```
make
docker push cloudfoundry/lucid64
```

This should generate lucid64.tar.gz

### To use the new rootfs in inigo

```
goto inigo
make
/scripts/dev-test
docker push cloudfoundry/inigo-ci
```

### To upload the new rootfs to diego-release's blobstore

```
goto diego-release
bosh add blob ~/workspace/stacks/lucid64.tar.gz rootfs
bosh upload blobs
```
