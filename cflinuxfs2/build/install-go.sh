set -e -x

GO_VERSION=${1}

if [ -z "$GO_VERSION" ]; then
    echo "usage: ${0} [VERSION]."
    exit 1
fi

pushd /tmp
  if [ "`uname -m`" == "ppc64le" ]; then
    GO_TAR_FILE="go-$GO_VERSION-ppc64le.tar.gz"
    wget "http://ftp.unicamp.br/pub/ppc64el/ubuntu/14_04/cloud-foundry/$GO_TAR_FILE"
  else
    GO_TAR_FILE="go$GO_VERSION.linux-amd64.tar.gz"
    wget "https://buildpacks.cloudfoundry.org/concourse-binaries/go/$GO_TAR_FILE"
  fi
  tar -xvf $GO_TAR_FILE
  mv go /usr/local/go1.7
popd

rm "/tmp/$GO_TAR_FILE"




