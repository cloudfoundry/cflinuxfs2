set -e -x

source /etc/lsb-release

function apt_get() {
  apt-get -y --force-yes --no-install-recommends "$@"
}

packages="
aptitude
autoconf
bind9-host
bison
build-essential
ca-certificates
cmake
cron
curl
dmidecode
dnsutils
fakeroot
flex
fontconfig
fuse-emulator-utils
gdb
git-core
gnupg-curl
gsfonts
imagemagick
iputils-arping
krb5-user
jq
laptop-detect
less
libaio1
libatk1.0-0
libatm1
libavahi-client3
libavahi-common-data
libavahi-common3
libbz2-dev
libcairo2
libcap2-bin
libclass-accessor-perl
libcups2
libcurl3
libcurl3-dev
libcwidget3
libdatrie1
libdirectfb-1.2-9
libdjvulibre-dev
libdjvulibre-text
libdjvulibre21
libdrm-intel1
libdrm-nouveau2
libdrm-radeon1
libept1.4.12
libfuse-dev
libfuse2
libgd2-noxpm-dev
libgpm2
libgraphviz-dev
libgtk-3-0
libgtk-3-common
libicu-dev
libilmbase-dev
libilmbase6
libio-string-perl
liblapack-dev
libmagickcore-dev
libmagickwand-dev
libmariadbd-dev
libncurses5-dev
libnl-3-200
libopenblas-dev
libopenexr-dev
libopenexr6
libpango1.0-0
libparse-debianchangelog-perl
libpcre3-dev
libpixman-1-0
libpq-dev
libreadline6-dev
libsasl2-modules
libsigc++-2.0-0c2a
libsqlite-dev
libsqlite3-dev
libssl-dev
libsub-name-perl
libsysfs2
libthai-data
libthai0
libts-0.0-0
libxapian22
libxcb-render-util0
libxcb-render0
libxcomposite1
libxcursor1
libxdamage1
libxfixes3
libxft2
libxi6
libxinerama1
libxml2
libxml2-dev
libxrandr2
libxrender1
libxslt1-dev
libxslt1.1
libxt-dev
libxt6
libyaml-dev
lsof
lzma
manpages
manpages-dev
ocaml-base-nox
openssh-server
openssl
psmisc
python
quota
rsync
shared-mime-info
sshfs
strace
sysstat
tasksel
tasksel-data
tcpdump
traceroute
tsconf
ttf-dejavu-core
unzip
wget
zip
"
if [ "`uname -m`" == "ppc64le" ]; then
packages=$(sed '/\b\(libopenblas-dev\|libdrm-intel1\|dmidecode\)\b/d' <<< "${packages}")
ubuntu_url="http://ports.ubuntu.com/ubuntu-ports"
else
ubuntu_url="http://archive.ubuntu.com/ubuntu"
fi

cat > /etc/apt/sources.list <<EOS
deb $ubuntu_url $DISTRIB_CODENAME main universe multiverse
deb $ubuntu_url $DISTRIB_CODENAME-updates main universe multiverse
deb $ubuntu_url $DISTRIB_CODENAME-security main universe multiverse
EOS

# install gpgv so we can update
apt_get install gpgv
apt_get update
apt_get dist-upgrade
apt_get install $packages ubuntu-minimal

apt-get clean

rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /usr/share/linda/*
