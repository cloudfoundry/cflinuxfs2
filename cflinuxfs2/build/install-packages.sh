set -e -x

# source /etc/lsb-release

# function apt_get() {
#   apt-get -y --force-yes --no-install-recommends "$@"
# }

# function install_mysql_so_files() {
#     mysqlpath="/usr/lib/x86_64-linux-gnu"
#     if [ "`uname -m`" == "ppc64le" ]; then
#         mysqlpath="/usr/lib/powerpc64le-linux-gnu"
#     fi
#     apt_get install libmysqlclient-dev
#     tmp=`mktemp -d`
#     mv $mysqlpath/libmysqlclient* $tmp
#     apt_get remove libmysqlclient-dev libmysqlclient18
#     mv $tmp/* $mysqlpath/
# }

packages="
# Additional packages needed on openSUSE
tar
gcc
gcc-c++
util-linux-systemd
sudo
netcat-openbsd
which
glibc-locale
# ----------
zypper-aptitude
autoconf
bind-utils
bison
# build-essential ?
bzr
ca-certificates
cmake
cron
curl
dmidecode
# dnsutils ?
# fakeroot ?
flex
fontconfig
# fuse-emulator-utils ?
gdb
git-core
# gnupg-curl ?
# gsfonts ?
ImageMagick
# iputils-arping ? iputils
# krb5-user ?
jq
# laptop-detect ?
less
libaio1
libatk-1_0-0
libatm1
libavahi-client3
# libavahi-common-data ?
libavahi-common3
libbz2-devel
libcairo2
# libcap2-bin ?
perl-Class-Accessor
# libcups2 ?
libcurl4
libcurl-devel
# libcwidget3 ?
libdatrie1
libdirectfb-1_7-1
libdjvulibre-devel
# libdjvulibre-text ?
libdjvulibre21
libdrm_intel1
libdrm_nouveau2
libdrm_radeon1
# libept1.4.12 ?
# libfuse-dev ?
libfuse2
# libgd2-noxpm-dev ?
# libgmp-dev ?
# libgpm2 ?
# libgraphviz-dev ?
libgtk-3-0
# libgtk-3-common ?
libicu-devel
# libilmbase-dev ?
# libilmbase6 ?
perl-IO-String
lapack-devel
# libmagickcore-dev ?
# libmagickwand-dev ?
# libmariadbclient-dev ?
ncurses-devel
libnl3-200
openblas-devel
openexr-devel
# libopenexr6 ?
libpango-1_0-0
# libparse-debianchangelog-perl ?
pcre-devel
libpixman-1-0
postgresql-devel
readline-devel
# libsasl2-dev ? libsasl2-3
# libsasl2-modules
libsigc++2-devel
sqlite2-devel
sqlite3-devel
libopenssl-devel
perl-Sub-Name
# libsysfs2 ? sysfsutils
libthai-data
libthai0
libts-1_0-0
libxapian22
libxcb-render-util0
libxcb-render0
libXcomposite1
libXcursor1
libXdamage1
libXfixes3
libXft2
libXi6
libXinerama1
libxml2-2
libxml2-devel
libXrandr2
libXrender1
# libxslt1-dev ? libxslt1
# libxslt1.1 ?
libXt-devel
libXt6
libyaml-devel
lsof
# lzma ? (only liblzma5)
# manpages ?
# manpages-dev ?
mercurial
# ocaml-base-nox ?
openssh
openssl
psmisc
python
quota
rsync
shared-mime-info
sshfs
strace
subversion
sysstat
# tasksel ?
# tasksel-data ?
tcpdump
traceroute
# tsconf ?
# ttf-dejavu-core ? dejavu-fonts
unzip
uuid-devel
wget
zip
"
packages=$(sed '/^#/d' <<< "${packages}")

# cat > /etc/apt/sources.list <<EOS
# deb $ubuntu_url $DISTRIB_CODENAME main universe multiverse
# deb $ubuntu_url $DISTRIB_CODENAME-updates main universe multiverse
# deb $ubuntu_url $DISTRIB_CODENAME-security main universe multiverse
# EOS

# # install gpgv so we can update
# apt_get install gpgv
# apt_get update
# apt_get dist-upgrade
# # TODO: deprecate libmysqlclient
# install_mysql_so_files
# apt_get install $packages ubuntu-minimal
zypper install -y $packages

# apt-get clean

# rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /usr/share/linda/*

