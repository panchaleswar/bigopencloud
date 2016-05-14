
VALUE=$(dialog --default-item "2" --stdout --menu "MENU" 50 160 50 \
          "1" "Test-1" \
          "2" "Test-2" \
          "3" "quit")

    case $VALUE in
        1) dialog --title "Install Packages" --progressbox 16 80 < <( apt-get update -y) ;;  
        2) apt-get upgrade -y /etc/init.d/mysql restart 2>&1 | dialog --progressbox 16 80; sleep 1;;
        3) break;;
    esac
