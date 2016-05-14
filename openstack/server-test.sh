#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

# install and run kvm-ok to see if we have virt capabilities
if /usr/sbin/kvm-ok
then 
dialog --title "Hello" --clear --msgbox "Your CPU seems to support KVM extensions.!" 10 41
else
dialog --title "Hello" --clear --msgbox "Your system isn't configured to run KVM properly.  Investigate this before continuing !" 10 41
fi
dialog --title "Create Openstack Volumes"  --yesno "Do you want me to format the disk for Openstack Volumes ? Or or run fdisk yourself to create and run the script ?"  10 42


