#!/bin/bash
apt-get -y --force-yes install screen 
rm inst.sh* 
wget --no-check-certificate https://raw.githubusercontent.com/nomadturk/openresty-install/master/inst.sh

echo $(tput setaf 1)The installer is now gonna run in a screen. You can detach or if your connection to ever drop you can reconnect to this screen with the command:$(tput setaf 2) screen -RR $(tput sgr0)&>> /dev/null 
bash inst.sh &
#screen -dmS Install bash -c "bash inst.sh" &
#screen -r Install
