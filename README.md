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
So far I've tested it on:
Online.net Server Debian Installation<br>
Kimsufi Debian 7.5 Installation<br>
Linode Debian <br>
Vultr Debian Servers<br>
Miranis Openstacks Debian<br>
DigitalOcean Debian Droplets (Eventhough DO gave me a lot off dropping connections from different locations whilst all my other ssh connections were flawless, all the test were success)<br>

You need a FRESH Debian 7 installation for this to run the way it is intended. It might still run but it's not tested...

You can run it with:

<blockquote>
wget http://bit.ly/openresty -O start.sh
<br>
bash start.sh
</blockquote>
