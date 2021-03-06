#!/usr/bin/env bash

cp $SCRIPTS/scripts/kernel.config_vmware_intel /mnt/gentoo/tmp/

chroot /mnt/gentoo /bin/bash <<'EOF'
sed -i "s/COMMON_FLAGS=\"-O2 -pipe\"/COMMON_FLAGS=\"-march=$MARCH -O2 -pipe\"/" /etc/portage/make.conf
echo 'ACCEPT_LICENSE="*"' >> /etc/portage/make.conf
echo "MAKEOPTS=\"-j$MAKE_OPTS\"" >> /etc/portage/make.conf
# echo "" >> /etc/portage/make.conf
# echo "" >> /etc/portage/make.conf
emerge --quiet-fail app-portage/mirrorselect
mirrorselect -s3 -b10 -D
emerge --quiet-fail sys-fs/lvm2
rc-update add lvm boot
echo 'devices { filter=["r/cdrom/"] }' >> /etc/lvm/lvm.conf
emerge --quiet-fail sys-kernel/gentoo-sources
cd /usr/src/linux
mv /tmp/kernel.config_vmware_intel .config
make oldconfig && make prepare
make && make modules_install
make install
EOF
