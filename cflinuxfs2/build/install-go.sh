set -e -x

GO_VERSION=${1}

if [ -z "$GO_VERSION" ]; then
    echo "usage: ${0} [VERSION]."
    exit 1
fi

if [ "`uname -m`" == "ppc64le" ]; then
  echo "Go $GO_VERSION is not available for download for ppc64le"
else
  pushd /tmp
    GO_TAR_FILE="go$GO_VERSION.linux-amd64.tar.gz"
    wget "https://buildpacks.cloudfoundry.org/concourse-binaries/go/$GO_TAR_FILE"
    tar -xvf $GO_TAR_FILE
    mv go /usr/local/go1.7
  popd

  rm "/tmp/$GO_TAR_FILE"
fi



