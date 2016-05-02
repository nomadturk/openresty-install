#!/bin/bash
cd ~/
apt-get update
apt-get -y --force-yes upgrade
apt-get -y --force-yes install screen nano
rm inst2.sh* 
wget --no-check-certificate https://raw.githubusercontent.com/nomadturk/openresty-install/master/inst2.sh


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
#bash inst2.sh
chmod a+x inst2.sh
#killall screen
screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill
screen -d -m -S OpenRestyInstall  ~/inst2.sh
screen -R OpenRestyInstall
echo "Now...  If you see this, it means I couldn't automatically get back to screen."
echo "Just use one of the below commands:"
echo "     screen -RR" 
echo "     screen -R"
echo "     screen -r OpenRestyInstall"

