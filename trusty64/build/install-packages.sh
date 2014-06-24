set -e -x

source /etc/lsb-release

function apt_get() {
  # CHANGES from lucid64 script:
  # - REMOVED `--fix-broken` option as seems to be missing in trusty
  apt-get -y --force-yes --no-install-recommends "$@"
}

# CHANGES from lucid64 script:
# - REMOVED python-central as it is obsolete
# - REPLACED libmagick9-dev with graphicsmagick-libmagick-dev-compat
# - REPLACED fuse-utils with fuse
packages="
  bind9-host
  bison
  build-essential
  cron
  curl
  dnsutils
  fakeroot
  flex
  fuse
  gdb
  git-core
  graphicsmagick-libmagick-dev-compat
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

# CHANGES from lucid64 script, based on changes to ubuntu-minimal package:
#
# REMOVED from the list we got from lucid64:
# - dash
# - iproute
# - module-init-tools
# - python
# - tasksel
#
# ADDED to the list we got from lucid64:
# - debconf-i18n
# - iproute2
# - isc-dhcp-client
# - kmod
# - python3
# - resolvconf
# - vim-tiny
#
# ideally we'd just include ubuntu-minimal. but we can't.
#
# we can include this subset:
ubuntu_minimal_stripped="
adduser
apt
apt-utils
bzip2
debconf
debconf-i18n
dhcp3-client
eject
gnupg
ifupdown
initramfs-tools
iproute2
iputils-ping
isc-dhcp-client
kbd
kmod
less
locales
lsb-release
makedev
mawk
net-tools
netbase
netcat-openbsd
ntpdate
passwd
procps
python3
resolvconf
sudo
tzdata
ubuntu-keyring
upstart
ureadahead
vim-tiny
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
