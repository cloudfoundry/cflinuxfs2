#!/bin/bash
# vim: set ft=sh

set -e -x

source /etc/lsb-release

function apt_get() {
  apt-get -f -y --force-yes --no-install-recommends "$@"
}

cat /etc/hosts

packages="
  bind9-host
  bison
  build-essential
  curl
  dnsutils
  flex
  gdb
  git-core
  imagemagick
  iputils-arping
  libcap2-bin
  libaio1
  libbz2-dev
  libcurl3
  libcurl3-dev
  libmagick9-dev
  libmysqlclient-dev
  libncurses5-dev
  libpq-dev
  libreadline6-dev
  libsqlite-dev
  libsqlite3-dev
  libssl-dev
  libxml2
  libxml2-dev
  libxslt1-dev
  libxslt1.1
  libyaml-dev
  lsof
  openssh-server
  psmisc
  quota
  rsync
  strace
  sysstat
  tcpdump
  traceroute
  unzip
  wget
  zip
"

# disable interactive dpkg
echo "debconf debconf/frontend select noninteractive" | debconf-set-selections

# timezone
dpkg-reconfigure -fnoninteractive -pcritical tzdata

# locale
locale-gen en_US.UTF-8
dpkg-reconfigure -fnoninteractive -pcritical libc6
dpkg-reconfigure -fnoninteractive -pcritical locales

# apt sources
cat > /etc/apt/sources.list <<EOS
deb http://archive.ubuntu.com/ubuntu $DISTRIB_CODENAME main universe multiverse
deb http://archive.ubuntu.com/ubuntu $DISTRIB_CODENAME-updates main universe multiverse
deb http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security main universe multiverse
EOS

# upgrade upstart first to prevent it from messing up our stubs and starting daemons anyway
apt_get install gpgv
apt_get update
apt_get install upstart
#apt_get dist-upgrade
apt_get install $packages
apt-get clean

# install ruby using ruby-build
git clone git://github.com/sstephenson/ruby-build.git /tmp/ruby-build
pushd /tmp/ruby-build
  PREFIX=/usr/local ./install.sh
  /usr/local/bin/ruby-build 1.9.3-p392 /usr
popd
rm -rf /tmp/ruby-build*
