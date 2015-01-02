openresty-install
=================

A bash script to install <br>
FFMpeg (from Source with libx246, fdk-aac, libvpx, opus, librtmp, lame support)<br>
ImageMagick (from Source)<br>
OpenResty Nginx (from Source, with SPDY, ngx_pagespeed, RTMP support and many extra modules)<br>
MariaDB 10 from it's official repository<br>
Php5.5 from DotDeb repository.<br>
Nginx default configuration template,<br>
php-fpm fixes (cgi.fix_pathinfo, change user to www-data)<br>
<br>
<br>
<br>

You can run it with:

<blockquote>
apt-get -y --force-yes install screen
<br>
screen -m -S LOMPInstaller
<br>
echo $(tput setaf 1)The installer is now running in a screen. You can detach or if your connection to ever drop you can reconnect to this screen with the command:$(tput setaf 2) screen -r LOMPInstaller$(tput sgr0)&>> /dev/null
<br>
sleep 5
<br>
wget --no-check-certificate https://raw.githubusercontent.com/nomadturk/openresty-install/master/inst.sh && bash inst.sh
exit
<br>
</blockquote>
