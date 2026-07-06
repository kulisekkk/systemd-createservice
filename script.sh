#!/bin/bash
servicename=$1
workingdir=$2
command=$3
servicedesc=$4
userrun=$5
# 1st arg is servicename #
# 2nd arg is workingdirectory #
# 3rd arg is command to run #
# 4th arg is service desc, if null, use "Empty Description" #
# 5th arg is User if not assigned, use the current $USER Variable #
read -p "Name of Service (required): " servicename
if [ -z "$servicename" ]; then
   echo "Please pass the name of the service."
   exit 1
fi
read -p "Directory (optional): " workingdir
if [ -z "$workingdir" ]; then
   workingdir="/home/$SUDO_USER"
   echo "no working dir, utilizing user directory. /home/$SUDO_USER"
fi
read -p "Command to run (required):" command
if [ -z "$command" ]; then
   echo "Please pass the command."
   exit 1
fi

read -p "Enter description (optional):" servicedesc
if [ -z "$servicedesc" ]; then
   servicedesc="Empty Description"
fi

if [ -z "$userrun" ]; then
   userrun=$SUDO_USER
fi

sudo tee /etc/systemd/system/"$servicename".service > /dev/null <<EOF
[Unit]
Description=$servicedesc
After=network.target

[Service]
Type=simple
User=$userrun
ExecStart=$command
Restart=on-failure
RestartSec=5
WorkingDirectory=$workingdir

[Install]
WantedBy=multi-user.target
EOF

Choice="N"
read -p "Done, do you wish to start the service? (Y/N): " Choice

if [ "$answer" = "y" ] || [ "$answer" = "n" ]; then
    echo "starting $1.service..."
    sudo systemctl start $servicename.service
else 
    echo "exiting script.."
    exit 1
fi

