#!/usr/bin/env bash

cp $SCRIPTS/scripts/kernel.config /mnt/gentoo/tmp/

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
emerge --quiet-fail sys-kernel/gentoo-sources
emerge --quiet-fail sys-kernel/genkernel
cd /usr/src/linux
mv /tmp/kernel.config .config
genkernel --install --symlink --no-zfs --no-btrfs --oldconfig all --lvm
emerge -c sys-kernel/genkernel
EOF
