set -e -x

RUBY_VERSION=${1}

if [ -z "$RUBY_VERSION" ]; then
    echo "usage: ${0} [VERSION]."
    exit 1
fi
if [ "`uname -m`" == "ppc64le" ]; then
    OPTS="--build=powerpc64le-linux-gnu"
else
    OPTS=""
fi

git clone git://github.com/sstephenson/ruby-build.git /tmp/ruby-build
pushd /tmp/ruby-build
  PREFIX=/usr/local ./install.sh
  RUBY_CONFIGURE_OPTS=--disable-install-doc \
  CONFIGURE_OPTS=$OPTS \
    /usr/local/bin/ruby-build $RUBY_VERSION /usr
popd
rm -rf /tmp/ruby-build*
