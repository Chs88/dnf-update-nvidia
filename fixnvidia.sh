#!/bin/bash

## Writing the functions

check_if_rebooted () {
    ## check if the temporary file exists
    if [ ! -f /var/run/resume-aferboot ]
    then
        before_reboot
    else
        after_reboot
    fi
}





before_reboot () {
        ##update the system
        dnf update -y
        #preparing for reboot
        script="bash /usr/local/bin/fixnvidia.sh"
        echo "$script" >> ~/.bashrc ##added script to bashrc
        ## creating temporary file to check
        touch /var/run/resume-aferboot
        echo "Update complete!"

        ## rebooting
        echo "Rebooting in 2..."
        sleep 1
        echo "Rebooting in 1..."
        sleep 1
        reboot

}

after_reboot () {
    ## resuming from reboot
    echo "Resuming from reboot..."
    sed -i '/bash/d' ~/.bashrc ##removing the line from bashrc 
    rm -f /var/run/resume-aferboot

    ## reinstallin Nvidia
    dnf remove *nvidia*
    dnf install akmod-nvidia
    echo "You can now reboot the system"


}

# script that runs first:
check_if_rebooted



## Check if user is part of sudoers group -- REDACTED
# if [ $(id -u) != 0 ]
# then
#     echo "Script must be ran as root."
# else
# check_if_rebooted
# fi