set -e -x

cd /usr/share/locale/
locale-gen * || echo 0
locale-gen
