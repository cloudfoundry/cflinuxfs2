set -e -x

source /etc/lsb-release

function apt_get() {
  # CHANGES from lucid64 script:
  # - REMOVED `--fix-broken` option as seems to be missing in trusty
  # - ADDED --no-install-recommends
  apt-get -y --force-yes --no-install-recommends "$@"
}

# CHANGES from lucid64 packages:
# - REMOVED aptitude
# - REMOVED defoma
# - REMOVED dmidecode
# - REMOVED fontconfig
# - REMOVED gsfonts
# - REMOVED laptop-detect
# - REMOVED libatk
# - REMOVED libatm
# - REMOVED libavahi-client
# - REMOVED libavahi-common-data
# - REMOVED libavahi-common
# - REMOVED libcairo
# - REMOVED libclass-accessor-perl
# - REMOVED libcups
# - REMOVED libcwidget
# - REMOVED libdatrie
# - REMOVED libdirectfb
# - REMOVED libdjvulibre-dev
# - REMOVED libdjvulibre-text
# - REMOVED libdjvulibre
# - REMOVED libdrm-intel
# - REMOVED libdrm-nouveau
# - REMOVED libdrm-radeon
# - REMOVED libept
# - REMOVED libgd-noxpm
# - REMOVED libgpm
# - REMOVED libgraphviz-dev
# - REMOVED libgraphviz
# - REMOVED libgtk
# - REMOVED libgtk-common
# - REMOVED libilmbase-dev
# - REMOVED libilmbase
# - REMOVED libio-string-perl
# - REMOVED libmagickcore-dev
# - REMOVED libmagickwand-dev
# - REMOVED libnl
# - REMOVED libopenexr-dev
# - REMOVED libopenexr
# - REMOVED libpango
# - REMOVED libpango-common
# - REMOVED libparse-debianchangelog-perl
# - REMOVED libpixman
# - REMOVED libsub-name-perl
# - REMOVED libthai-data
# - REMOVED libthai
# - REMOVED libts
# - REMOVED libxapian
# - REMOVED libxcb-render-util
# - REMOVED libxcb-render
# - REMOVED libxcomposite
# - REMOVED libxcursor
# - REMOVED libxdamage
# - REMOVED libxfixes
# - REMOVED libxft
# - REMOVED libxi6
# - REMOVED libxinerama
# - REMOVED libxrandr
# - REMOVED libxrender
# - REMOVED libxt-dev
# - REMOVED libxt
# - REMOVED python-central
# - REMOVED shared-mime-info
# - REMOVED tasksel
# - REMOVED tasksel-data
# - REMOVED tsconf
# - REMOVED ttf-dejavu-core
# - REPLACED libmagick9-dev with graphicsmagick-libmagick-dev-compat

lucid_packages="
bind9-host
bison
build-essential
ca-certificates
curl
dnsutils
flex
fuse-emulator-utils
gdb
git-core
gnupg-curl
graphicsmagick-libmagick-dev-compat
imagemagick
iputils-arping
libaio1
libbz2-dev
libcap2-bin
libcurl3
libcurl3-dev
libfuse-dev
libfuse2
libmysqlclient-dev
libncurses5-dev
libpq-dev
libreadline6-dev
libsasl2-modules
libsigc++-2.0-0c2a
libsqlite-dev
libsqlite3-dev
libssl-dev
libsysfs2
libxml2
libxml2-dev
libxslt1-dev
libxslt1.1
lsof
lzma
ocaml-base-nox
openssh-server
openssl
psmisc
quota
rsync
sshfs
strace
sysstat
tcpdump
traceroute
unzip
wget
zip
libssl0.9.8
"

## Pulled from Diego Trusty rootfs
additional_packages="
cron
fakeroot
less
libicu-dev
libyaml-dev
manpages
manpages-dev
python
"

cat > /etc/apt/sources.list <<EOS
deb http://archive.ubuntu.com/ubuntu $DISTRIB_CODENAME main universe multiverse
deb http://archive.ubuntu.com/ubuntu $DISTRIB_CODENAME-updates main universe multiverse
deb http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security main universe multiverse
EOS

# install gpgv so we can update
apt_get install gpgv

apt_get update

apt_get install $lucid_packages $additional_packages ubuntu-minimal

apt_get dist-upgrade

apt-get clean
