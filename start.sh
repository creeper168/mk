#!/bin/bash

DEBUG="quiet"
if [ "$1" == "-d" ]; then
DEBUG="debug"
fi

qemu-system-x86_64 -m 256M -kernel iso/linux -nographic  -net nic,vlan=0 -net tap,vlan=0 -hda cf.vmdk -initrd iso/initrd.img -append "console=ttyS0 rdinit=/sbin/init kgdboc=ttyS0 $DEBUG"  
