#!/bin/bash
declare PACKAGES=("/etc/crontab"  "/etc/dmtab"  "/etc/fstab"  "/etc/inittab"  "/etc/mtab")

NUM_PACKAGES=${#PACKAGES[*]} # no. of packages to update (#packages in the array $PACKAGES)

step=$((100/$NUM_PACKAGES))  # progress bar step

cur_file_idx=0
counter=0
DEST=${HOME}
(
# infinite while loop
while :
do
    cat <<EOF
XXX
$counter
$counter% upgraded

$COMMAND
XXX
EOF
##    COMMAND="cp ${PACKAGES[$cur_file_idx]} $DEST &>/dev/null" # sets/updates command to exec.
    [[ $NUM_PACKAGES -lt $cur_file_idx ]] && $COMMAND # executes command

    (( cur_file_idx+=1 )) # increase counter
    (( counter+=step ))
    [ $counter -gt 100 ] && break  # break when reach the 100% (or greater
                                   # since Bash only does integer arithmetic)
    sleep 10 # delay it a specified amount of time i.e. 1 sec
done
) |
dialog --title "File upgrade" --gauge "Please wait..." 10 70 0
