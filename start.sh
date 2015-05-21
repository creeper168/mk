#!/bin/bash

DEBUG="quiet"
QEMU_CMD="qemu-system-x86_64"

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
	*)
		break
	;;
esac
done

[ ! -f cf.qcow2 ] &&  qemu-img convert -f vmdk cf.vmdk  -O qcow2 cf.vmdk cf.qcow2 

${QEMU_CMD} -m 256M -kernel iso/linux -nographic  	\
	-net nic,vlan=0 -net tap,vlan=0 		\
	-hda cf.qcow2 -initrd iso/initrd.img		\
	 -append "console=ttyS0 rdinit=/sbin/init kgdboc=ttyS0 ${DEBUG}"  

rm -f cf.qcow2
