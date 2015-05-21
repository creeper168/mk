#!/bin/bash

#make sure genisoimage installed
[ ! -f /usr/bin/genisoimage ] &&\
 ( rpm -i rpms/libusal-1.1.11-22.el7.x86_64.rpm 2>/dev/null; rpm -i rpms/genisoimage-1.1.11-22.el7.x86_64.rpm 2>/dev/null)
[ ! -f /usr/bin/isohybrid ] && rpm -i --nodeps rpms/syslinux-4.05-12.el7.x86_64.rpm 2>/dev/null

( [ ! -x /usr/bin/genisoimage ] || [ ! -x /usr/bin/isohybrid ]) && echo "error!!!" && exit 1

rm  -f image.iso 
[ ! -d iso ] &&  echo "No iso dir!" && exit 1
rm -f iso/initrd.img

#first, generate initrd

pushd fs
find . | cpio -H newc -o > ../iso/initrd.img
popd


#then, make iso
for i in initrd.img  isolinux.bin  isolinux.cfg linux
do
	[ ! -f "iso/$i" ] &&  echo "iso/$i not found!" && exit 1
done 

mkisofs -J -r -o image.iso -b isolinux.bin -c boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table iso


if [ -f image.iso ] ; then
	isohybrid image.iso 2>/dev/null
fi

if [ "$1" != "-k" ]; then
	rm -f iso/initrd.img
fi

