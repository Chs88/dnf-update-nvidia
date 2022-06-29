#!/bin/bash

scriptsource="$(readlink -f "$0")" ## path to this script

## Writing the functions

check_if_rebooted () {
    ## check if the temporary file exists
    if [ ! -f /var/run/resume-aferboot ]
    then
        sudo cp "$scriptsource" "/usr/local/bin" ##copies itself to /usr/bin for testing
        # echo "file doesnt exist"
        before_reboot
        

    else
        # echo "file exists"
        after_reboot
       
    fi
}





before_reboot () {
        ##update the system
        apt update
        # echo "updating"
        # dnf update -y
        #preparing for reboot
        script="bash /usr/local/bin/fixnvidia.sh"
        echo "$script" >> ~/.bashrc ##added script to bashrc
        ## creating temporary file to check
        sudo touch /var/run/resume-aferboot
        echo "Update complete!"

        ## rebooting
        echo "Rebooting in 3..."
        sleep 1
        echo "Rebooting in 2..."
        sleep 1
        echo "Rebooting in 1..."
        sleep 1
        sudo reboot
        
}

after_reboot () {
    ## resuming from reboot
    echo "Resuming from reboot..."
    sudo sed -i '/bash/d' ~/.bashrc ##removing the line from bashrc 
    sudo rm -f /var/run/resume-aferboot

    # ## reinstallin Nvidia
    # dnf remove *nvidia*
    # dnf install akmod-nvidia
    echo "You can now reboot the system"


}

# script that runs first:
check_if_rebooted
## Check if user is part of sudoers group
# if [ $(id -u) != 0 ]
# then
#     echo "Script must be ran as root."
# else
# check_if_rebooted
# fi