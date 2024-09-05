#!/bin/bash
mkdir -p initramfs/{bin,sbin,etc,proc,sys,usr/{bin,sbin}}

# make symlink
cd initramfs/bin
for i in $(busybox --list); do ln -s busybox $i; done
cd ../../

# init script
cat << EOF > initramfs/init
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
echo "BusyBox initrd!"
/bin/sh
exec /bin/sh
EOF
chmod +x initramfs/init

# compress to initramfs
cd initramfs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs.img
cd ..
