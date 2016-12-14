set -e -x

GO_URL=${1}

if [ -z "$GO_URL" ]; then
    echo "usage: ${0} [URL]."
    exit 1
fi

pushd /tmp
  wget $GO_URL
  tar -xvf ${GO_URL##*/}
  mv go /usr/local/go1.7
popd

rm "/tmp/${GO_URL##*/}"




