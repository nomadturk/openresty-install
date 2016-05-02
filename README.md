openresty-install
=================

short info
==========
This script intends to install OpenResty OR Nginx with RTMP support, ~~SPDY~~ HTTP2, FFMep and OpenMagick. It tries to install all the necessary dependencies and thus compiles most from source files. During compiling, I've tried to make it as close to the nginx installation from the repos.
Be advised. It takes a long while. Therefore it runs with screen command.


more info
==========
A bash script to install <br>
FFMpeg (from Source with libx246, fdk-aac, libvpx, opus, librtmp, lame support)<br>
ImageMagick (from Source)<br>
OpenResty/Nginx (from Source, with ~~SPDY~~ HTTP2, ngx_pagespeed, RTMP support and many extra modules)<br>
MariaDB 5.5 from it's official repository<br>
Php5.5 from DotDeb repository.<br>
[Nginx default configuration template](https://github.com/nomadturk/nginx-conf "Nomad's default Nginx configuration template"),<br>
php-fpm fixes (cgi.fix_pathinfo, change user to www-data)<br>
[h5bp for Nginx.](https://github.com/h5bp/server-configs-nginx "Server Configs Nginx")
Webmin + Virtualmin with NginX modules and themes  - **Disabled by default** To enable it before running bash start.sh command, edit the file manually<br>
<br>
<br>
<br>
So far I've tested it on:  
ESXi VM's<br>
Proxmox VM's<br>
Online.net Server Debian Installation<br>
Kimsufi Debian 7.5 Installation<br>
Linode Debian <br>
Vultr Debian Servers<br>
Miranis Openstacks Debian<br>
RunAbove.com Servers<br>
DigitalOcean Debian Droplets (Eventhough DO gave me a lot off dropping connections from different locations whilst all my other ssh connections were flawless, all the test were success)<br>

You need a FRESH Debian 7 or 8 installation for this to run the way it is intended. It might still run but it's not tested...  
It also does run with Ubuntu (D'uh!) But in some cases some manual tweaking might be required.

You can run it with:

<blockquote>
wget --no-check-certificate http://bit.ly/openresty -O start.sh
<br>
bash start.sh
</blockquote>



known issues and things to do
==========
There's a logging process embedded in the script but I've somehow broken it. Will fix it when I have time.  
If by any reason the installation stops, it restarts from scratch. I need to implement a way to continue from where it left to save time and sanity.  
Currently the script doesn't ask if you want to install MariaDB. A multiple-choice way to install is needed.  


Feel free to open an issue or create a PR if you can.  
I'm trying to keep it up-to-date but I can't test it with every change so your input will be appreciated.
