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

function get_input(){
    echo "Configuring Server $1"

while true 
do
    #open fd
exec 3>&1
    # Store data to $VALUES variable
       VALUES=$(dialog --ok-label "Submit"  --backtitle "OpenStack Cloud Server Configuration" --title "Configure OpenStack Cloud Server" --form "Please Enter the following Details" 15 80 0  \
        "Enter the device name for the Internet NIC (eth0, etc.)  :"    1 1     "$internetnic"    1 60 10 0 \
        "Enter the device name for the Management NIC (eth1, etc.):"    2 1     "$managementnic"  2 60 10 0 \
        "Enter a password to be used for the OpenStack services   :"    3 1     "$password"       3 60 15 0 \
        "Enter the email address for service accounts             :"    4 1     "$email"          4 60 20 0 \
        "Enter a short name to use for your default region        :"    5 1     "$region"         5 60 10 0 \
     2>&1 1>&3)

internetnic=$(echo $VALUES |  awk  '{ print $1 }')
managementnic=$(echo $VALUES |  awk  '{ print $2 }')
password=$(echo $VALUES |  awk  '{ print $3 }')
email=$(echo $VALUES |  awk  '{ print $4 }')
region=$(echo $VALUES |  awk  '{ print $5 }')

echo $internetnic $managementnic $password $email $region

INTERNET_IP=$(/sbin/ifconfig $internetnic| sed -n 's/.*inet *addr:\([0-9\.]*\).*/\1/p')
MANAGEMENT_IP=$(/sbin/ifconfig $managementnic| sed -n 's/.*inet *addr:\([0-9\.]*\).*/\1/p')

##echo "please check if the IP's are correct ?"
dialog --title "Please check if the System IPs "  --yesno "Check if the IPs are correct or not ? 
                                                            Internet IP is $INTERNET_IP 
                                                            Management IP is $MANAGEMENT_IP " 10 42
output="$?"
if [[ $output =~ "0" ]]
then break;
fi
done

     SG_MULTI_NODE=0
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
function configure_allinone() {
 get_input;
}

############################# display main menu ###

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then

dialog --backtitle "System Information" \
--title "About" \
--msgbox 'You Need To be root to run this configuration .' 10 30
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi
clear

dialog --clear  --help-button --backtitle "$BACKTITLE"  \
--title "[ Select The Server Function You want to Configure ]" \
--hline "Copyrighr BigOpenCloud.com......................" \
--menu "You can use the UP/DOWN arrow keys, the first letter of the choice as a hot key, or the number keys 1-9 to choose an option.\n\
Choose the TASK" 20 80 8 \
AllInOne "All Services of OpenStack in One Server" \
Controller "OpenStack Controller Services With the Management Console " \
Compute "OpenStack Compute Server For Running the VMs" \
Network "OpenStack Network Server for Providing Networking for Cloud" \
Swift   "OpenStack Object Storage Server" \
Exit "Exit to the shell" 2>"${INPUT}"

menuitem=$(<"${INPUT}")

# make decsion
case $menuitem in
        AllInOne) configure_allinone;;
        Controller) configure_controller;;
        Compute) configure_compute;;
        Network) configure_network;;
        Swift) configure_swift;;
        Exit) echo "Bye"; break;;
esac

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT

