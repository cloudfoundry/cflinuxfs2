set -e -x

git clone git://github.com/sstephenson/ruby-build.git /tmp/ruby-build
pushd /tmp/ruby-build
  PREFIX=/usr/local ./install.sh
  /usr/local/bin/ruby-build 1.9.3-p392 /usr
popd
rm -rf /tmp/ruby-build*
