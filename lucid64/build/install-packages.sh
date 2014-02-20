set -e -x

source /etc/lsb-release

function apt_get() {
  apt-get -f -y --force-yes --no-install-recommends "$@"
}

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
  less
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
  netcat
  openssh-server
  python
  psmisc
  quota
  rsync
  strace
  sysstat
  tcpdump
  traceroute
  unzip
  vim
  wget
  zip
"

cat > /etc/apt/sources.list <<EOS
deb http://archive.ubuntu.com/ubuntu $DISTRIB_CODENAME main universe multiverse
deb http://archive.ubuntu.com/ubuntu $DISTRIB_CODENAME-updates main universe multiverse
deb http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security main universe multiverse
EOS

# install gpgv so we can update
apt_get install gpgv

apt_get update

# upgrade upstart first to prevent it from messing up our stubs and starting daemons anyway
apt_get install upstart

apt_get install $packages
apt-get clean
