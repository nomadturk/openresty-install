#!/bin/bash
apt-get -y --force-yes install screen 
/usr/bin/screen -m -S LOMPInstaller bash -c 'wget --no-check-certificate https://raw.githubusercontent.com/nomadturk/openresty-install/master/inst.sh; exec bash inst.sh'
echo $(tput setaf 1)The installer is now running in a screen. You can detach or if your connection to ever drop you can reconnect to this screen with the command:$(tput setaf 2) screen -r LOMPInstaller$(tput sgr0)&>> /dev/null 
sleep 5 
exit 
