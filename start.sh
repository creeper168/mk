#!/bin/bash

DEBUG="quiet"
QEMU_CMD="qemu-system-x86_64"
TEST_ISO=0
GRA=" -nographic"

while test $# -gt 0; do
case "$1" in
	-d|--debug)
		DEBUG="debug"
		shift
	;;
	-k|--kvm)
		QEMU_CMD="/usr/libexec/qemu-kvm"
		shift
	;;
	-i|--iso)
		TEST_ISO=1
		shift
	;;
	-g|--graphic)
		GRA=""
		shift
	;;


	*)
		break
	;;
esac
done

[ ! -f cf.qcow2 ] &&  qemu-img convert -f vmdk cf.vmdk  -O qcow2 cf.vmdk cf.qcow2 

if [ ${TEST_ISO} != 1 ] ; then
${QEMU_CMD} -m 256M -kernel iso/linux ${GRA}  	\
	-net nic,vlan=0 -net tap,vlan=0 		\
	-hda cf.qcow2 -initrd iso/initrd.img		\
	 -append "console=ttyS0 rdinit=/sbin/init kgdboc=ttyS0 ${DEBUG} "  
else

${QEMU_CMD} -m 256M  -cdrom image.iso -net nic,vlan=0 -net tap,vlan=0 -hda cf.qcow2 -boot d ${GRA}
fi

rm -f cf.qcow2
