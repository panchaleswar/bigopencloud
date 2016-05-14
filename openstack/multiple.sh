dialog --ok-label "Submit"  --backtitle "OpenStack Cloud Server Configuration" --begin 4 4 --title "Configure OpenStack Cloud Server" --form "Please Enter the following Details" 15 80 0  \
        "Enter the device name for the Internet NIC (eth0, etc.)  :"    1 1     "$internetnic"    1 60 10 0 \
        "Enter the device name for the Management NIC (eth1, etc.):"    2 1     "$managementnic"  2 60 10 0 \
        "Enter a password to be used for the OpenStack services   :"    3 1     "$password"       3 60 15 0 \
        "Enter the email address for service accounts             :"    4 1     "$email"          4 60 20 0 \
        "Enter a short name to use for your default region        :"    5 1     "$region"         5 60 10 0 \
        --and-widget --begin 20 4 --title msgbox2 --msgbox Second 15 80 


##dialog --backtitle "Multiple dialog widgets" --begin 4 4 --title msgbox1 --msgbox First 4 4  \
#                --and-widget --begin 10 10 --title msgbox2 --msgbox Second 0 0 \
#                --and-widget --begin 16 16 --title msgbox3 --msgbox Third 0 0 \
#                --and-widget --begin 20 40 --title infobox1 --infobox "There are multiple widgets." 0 0 \
#                --and-widget --begin 30 35 --title infobox2 --infobox "I'm here too." 0 0
