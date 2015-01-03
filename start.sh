#!/bin/bash
cd ~/
apt-get update
apt-get -y --force-yes upgrade
apt-get -y --force-yes install screen nano
rm inst.sh* 
wget --no-check-certificate https://raw.githubusercontent.com/nomadturk/openresty-install/master/inst.sh


# Some systems problems with locales. So lets try to add them just to run smoother.
LANGUAGE=en_US.UTF-8
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
LC_COLLATE=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
LC_MESSAGES=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
locale-gen en_US.UTF-8
update-locale en_US.UTF-8
. /etc/default/locale

echo $(tput setaf 1)The installer is now gonna run in a screen. You can detach or if your connection to ever drop you can reconnect to this screen with the command:$(tput setaf 2) screen -RR $(tput sgr0)&>> /dev/null 
#bash inst.sh
screen -a -A -S InstallScreen -U bash -c "bash inst.sh"
