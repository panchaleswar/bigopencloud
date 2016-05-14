#!/bin/bash
# utilitymenu.sh - A sample shell script to display menus on screen
# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$
 
# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$
BACKTITLE="Configur OpenStack Cloud Software"
 
# get text editor or fall back to vi_editor
vi_editor=${EDITOR-vi}
 
# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

internetnic=""
managementnic=""
password=""
email=""
region=""
 
#
# Purpose - display output using msgbox 
#  $1 -> set msgbox height
#  $2 -> set msgbox width
#  $3 -> set msgbox title
#
function display_output(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 	# box title 
	dialog --backtitle "$BACKTITLE" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}

}

function get_input(){
    echo "Configuring Server $1"

#open fd
exec 3>&1
    # Store data to $VALUES variable
VALUES=$(dialog --ok-label "Submit"  --backtitle "OpenStack Cloud Server Configuration" --title "Configure OpenStack Cloud Server" --form "Create a new user" 15 80 0  \
        "Enter the device name for the Internet NIC (eth0, etc.) :"     1 1     "$internetnic"         1 60 10 0 \
        "Enter the device name for the Management NIC (eth1, etc.):"    2 1     "$managementnic"         2 60 15 0 \
        "Enter a password to be used for the OpenStack services :"      3 1     "$password"     3 60 8 0 \
        "Enter the email address for service accounts :"                4 1     "$email"        4 60 20 0 \
        "Enter a short name to use for your default region :"           5 1     "$region"       5 60 10 0 \
2>&1 1>&3)

INTERNET_IP=$(/sbin/ifconfig $internetnic| sed -n 's/.*inet *addr:\([0-9\.]*\).*/\1/p')
MANAGEMENT_IP=$(/sbin/ifconfig $managementnic| sed -n 's/.*inet *addr:\([0-9\.]*\).*/\1/p')

SG_MULTI_NODE=1
# making a unique token for this install
token=`cat /dev/urandom | head -c2048 | md5sum | cut -d' ' -f1`

cat > setuprc <<EOF
export SG_INSTALL_SWIFT=$SG_INSTALL_SWIFT
export SG_MULTI_NODE=$SG_MULTI_NODE
export SG_SERVICE_EMAIL=$email
export SG_SERVICE_PASSWORD=$password
export SG_SERVICE_TOKEN=$token
export SG_SERVICE_REGION=$region
export INTERNET_IP=$INTERNET_IP
export MANAGEMENT_IP=$MANAGEMENT_IP
EOF

#Close fd
exec 3>&-
 
}

function configure_controller(){
    echo "Configuring Server Controller Server Configuration"
    get_input

# display values just entered
#echo "$VALUES"

 
    display_output 6 60 "Controller Server Configuration"

}
#
# Purpose - display current system date & time
#
function show_date(){
	echo "Today is $(date) @ $(hostname -f)." >$OUTPUT
    display_output 6 60 "Date and Time"
}
#
# Purpose - display a calendar
#
function show_calendar(){
	cal >$OUTPUT
	display_output 13 25 "Calendar"
}
#
# set infinite loop
#
while true
do
 
### display main menu ###

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then

dialog --backtitle "System Information" \
--title "About" \
--msgbox 'You Need To be root to run this configuration .' 10 30
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi
clear


dialog --backtitle "System Information" \
--title "System network Configuration" \
--msgbox 'First edit your /etc/network/interfaces file to look something like this:
# primary internet connection
auto eth0
iface eth0 inet static
 address 192.168.1.51
 network 192.168.1.0
 netmask 255.255.255.0
 broadcast 192.168.1.255
 gateway 192.168.1.1
 dns-nameservers 8.8.8.8

# management interface
auto eth1
iface eth1 inet static
 address 10.10.10.51
 network 10.10.10.0
 netmask 255.255.255.0
 broadcast 10.10.10.255

# storage network
auto eth2
iface eth2 inet static
 address 10.20.20.51
 network 10.20.20.51
 netmask 255.255.255.0
 broadcast 10.20.20.51
' 35 50

dialog --title "Confirm Network Settings" \
--backtitle "$BACKTITLE" \
--yesno "Did You Configure the Network for Internet and Management ?" 7 60

response=$?
case $response in
   1) echo "Exiting Now."; break;;
   0) echo "proceed normally .";;
   255) echo "[ESC] key pressed.";;
esac

dialog --clear  --help-button --backtitle "$BACKTITLE"  \
--title "[ Select The Server Function You want to Configure ]" \
--hline "Copyrighr BigOpenCloud.com......................" \
--menu "You can use the UP/DOWN arrow keys, the first letter of the choice as a hot key, or the number keys 1-9 to choose an option.\n\
Choose the TASK" 20 80 8 \
Controller "OpenStack Controller Services With the Management Console " \
Compute "OpenStack Compute Server For Running the VMs" \
Network "OpenStack Network Server for Providing Networking for Cloud" \
Swift   "OpenStack Object Storage Server" \
AllInOne "All Services of OpenStack in One Server" \
Exit "Exit to the shell" 2>"${INPUT}"
 
menuitem=$(<"${INPUT}")
 
 
# make decsion 
case $menuitem in
	Controller) configure_controller;;
	Compute) configure_compute;;
	Network) configure_network;;
        Swift) configure_swift;;
        AllInOne) configure_allinone;;
	Exit) echo "Bye"; break;;
esac
 
done
 
# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
