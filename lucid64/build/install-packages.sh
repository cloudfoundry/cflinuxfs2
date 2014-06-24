set -e -x

source /etc/lsb-release

function apt_get() {
  apt-get -f -y --force-yes --no-install-recommends "$@"
}

packages="
  bind9-host
  bison
  build-essential
  cron
  curl
  dnsutils
  fakeroot
  flex
  fuse-utils
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
  libfuse-dev
  libfuse2
  libicu-dev
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
  manpages
  manpages-dev
  openssh-server
  python
  python-central
  psmisc
  quota
  rsync
  sshfs
  strace
  sysstat
  tcpdump
  traceroute
  unzip
  vim
  wget
  zip
"

# ideally we'd just include ubuntu-minimal. but we can't.
#
# we can include this subset:
ubuntu_minimal_stripped="
adduser
apt
apt-utils
bzip2
dash
debconf
dhcp3-client
eject
gnupg
ifupdown
initramfs-tools
iproute
iputils-ping
kbd
less
locales
lsb-release
makedev
mawk
module-init-tools
net-tools
netbase
netcat-openbsd
ntpdate
passwd
procps
python
sudo
tasksel
tzdata
ubuntu-keyring
upstart
ureadahead
whiptail
"

# ...but this subset must be excluded, as they need --privileged:
#
# see https://github.com/dotcloud/docker/pull/2979
ubuntu_minimal_excluding="
console-setup
udev
rsyslog
"

cat > /etc/apt/sources.list <<EOS
deb http://archive.ubuntu.com/ubuntu $DISTRIB_CODENAME main universe multiverse
deb http://archive.ubuntu.com/ubuntu $DISTRIB_CODENAME-updates main universe multiverse
deb http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security main universe multiverse
EOS

# cannot upgrade udev; need --privileged during build
#
# see https://github.com/dotcloud/docker/pull/2979
echo "udev hold" | dpkg --set-selections

# install gpgv so we can update
apt_get install gpgv

apt_get update

apt_get install $packages $ubuntu_minimal_stripped

apt_get dist-upgrade

apt-get clean
