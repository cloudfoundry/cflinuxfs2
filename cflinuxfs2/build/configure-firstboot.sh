set -e -x

cp /tmp/assets/etc/rc.local /etc/rc.local
cp /tmp/assets/firstboot.sh /root/firstboot.sh
chmod 0755 /root/firstboot.sh
