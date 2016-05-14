#!/bin/bash

PACKAGES=(mysql-server python-mysqldb rabbitmq-server cpu-checker vlan bridge-utils kvm libvirt-bin pm-utils ntp rabbitmq-server memcached python-memcache mysql-server python-mysqldb iscsitarget iscsitarget-source  open-iscsi iscsitarget-dkms cinder-api cinder-scheduler cinder-volume quantum-server quantum-plugin-linuxbridge quantum-plugin-linuxbridge-agent dnsmasq quantum-dhcp-agent quantum-l3-agent glance nova-api nova-cert novnc nova-consoleauth nova-scheduler nova-novncproxy nova-doc nova-conductor nova-compute-kvm openstack-dashboard memcached)

dialog --begin 4 4 --title "Update System Packages" --progressbox 16 90 < <( apt-get update -y) 
       
dialog --begin 20 4 --title "Upgrading System Packages" --progressbox 16 90 < <( apt-get upgrade -y);  

dialog  --begin 36 4 --title "Installing Packages ..." --gauge "Installing Package ..." 10 75 < <(  
# Get total number of packages to be installed
   n=${#PACKAGES[*]}; 
   # set counter - it will increase every-time a package is installed 
  i=0
   #
   # Start the for loop 
   #
   # read each package from array 
   
 for package in "${PACKAGES[@]}"
   do
      # calculate progress
      PCT=$(( 100*(++i)/n ))
      # update dialog box 
cat <<EOF
XXX
$PCT
Installing Package  "$package"...
XXX
EOF
  # install the package  
  apt-get -y install $package &>/dev/null
   done
)

