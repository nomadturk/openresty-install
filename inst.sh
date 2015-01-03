#!/bin/bash
#Lets calculate how much time is spent
START=$(date +%s)

# Yellow
function show_progress()
{
	echo $(tput setaf 3)$@$(tput sgr0)
}

# Blue
function show_progress_info()
{
	echo $(tput setaf 4)$@$(tput sgr0)
}

# Red color
function show_progress_error()
{
	echo $(tput setaf 1)$@$(tput sgr0)
}

# Checking permissions
if [[ $EUID -ne 0 ]]; then
	 show_progress_error "You need root permissions to run the script."
	exit 1
fi

###################################################################

 show_progress "The script will terminate if any error to happen."
set -e
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# Remove any existing packages:
 show_progress "Removing ffmpeg files if there any."
apt-get update &>> /dev/null
apt-get -y --force-yes dist-upgrade &>> /dev/null
apt-get -y --force-yes remove ffmpeg x264 libav-tools libvpx-dev libx264-dev yasm &>> /dev/null
apt-get -y --force-yes install software-properties-common python-software-properties &>> /dev/null
# Let's install what's needed...

 show_progress "Adding multimedia repository and doing an apt-get update."
add-apt-repository 'deb http://www.deb-multimedia.org wheezy main non-free' &>> /dev/null
apt-get update &>> /dev/null
apt-get -y --force-yes install deb-multimedia-keyring &>> /dev/null


show_progress "Installing necessary packages apt-get update, please wait..."
apt-get -y --force-yes install build-essential checkinstall git libfaac-dev libjack-jackd2-dev &>> /dev/null
show_progress "Installing necessary packages apt-get update, please wait......."
apt-get -y --force-yes install libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev  libtheora-dev &>> /dev/null
show_progress "Installing necessary packages apt-get update, please wait.........."
apt-get -y --force-yes install libvorbis-dev texi2html zlib1g-dev autoconf automake g++ bzip2 libfreetype6-dev libgpac-dev libtool pkg-config &>> /dev/null
show_progress "Installing necessary packages apt-get update, please wait............."
apt-get -y --force-yes install libssl1.0.0 libssl-dev libxvidcore-dev libxvidcore4 libass-dev librtmp-dev &>> /dev/null
show_progress "Installing necessary packages apt-get update, please wait................"
apt-get -y --force-yes install libpcre3 libpcre3-dev unzip tar zip libpcrecpp0 &>> /dev/null
show_progress "Installing necessary packages apt-get update, please wait..................."
apt-get -y --force-yes install libreadline-dev libncurses5-dev perl make libjpeg-dev libjpeg-progs devscripts graphicsmagick-imagemagick-compat &>> /dev/null
show_progress "Installing necessary packages apt-get update, please wait......................"
apt-get -y --force-yes install graphicsmagick-libmagick-dev-compat libpam0g-dev libpng-dev libpng12-0 libpng12-dev libxml2-dev &>> /dev/null
show_progress "Installing necessary packages apt-get update, please wait........................."
apt-get -y --force-yes install libtiff-dev libgif-dev libgeoip1 libxslt1.1 libxslt-dev openssl libgd2-xpm-dev &>> /dev/null
show_progress "Installing necessary packages apt-get update, please wait............................"
apt-get -y --force-yes install libperl-dev libjpeg8-dev  libcdio-cdda1 libcdio-paranoia1 libcdio13 libpostproc52 libswresample0 libgsm1-dev libbz2-dev &>> /dev/null
show_progress "Installing necessary packages apt-get update, please wait..............................."
apt-get -y --force-yes install libavfilter-dev libavcodec-dev libavutil-dev libavdevice-dev libavformat-dev libswscale-dev libgeoip-dev &>> /dev/null


 show_progress "Start FFMpeg Installation"
 show_progress "Depending on your CPU this might take a long while"
##################################################################Start FFMPEG 

mkdir -p ~/src-build/build-ffmpeg
mkdir -p /root/ngx-build/
#apt-get install yasm
 show_progress "		Installing yasm"
################################### First, install yasm
cd ~/src-build/build-ffmpeg
git clone git://github.com/yasm/yasm.git
cd yasm
./autogen.sh &>> /dev/null
./configure &>> /dev/null
make &>> /dev/null
checkinstall --pkgname=yasm --pkgversion="1.3.0" --backup=no \
  --deldoc=yes --fstrans=no --default
  
 show_progress "		Installing libx246"
################################### libx264
cd ~/src-build/build-ffmpeg
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --enable-static &>> /dev/null
make &>> /dev/null
checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | \
  awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
  --fstrans=no --default
 show_progress "		Installing fdk-aac"
################################### fdk-aac
cd ~/src-build/build-ffmpeg
git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
./autogen.sh &>> /dev/null
autoreconf -fiv &>> /dev/null
./configure --disable-shared &>> /dev/null
make &>> /dev/null
checkinstall --pkgname=fdk-aac --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no \
  --deldoc=yes --fstrans=no --default
 show_progress "		Installing libvpx" 
################################### libvpx
cd ~/src-build/build-ffmpeg
git clone --depth 1 http://git.chromium.org/webm/libvpx.git
cd libvpx
./configure --disable-examples --disable-unit-tests &>> /dev/null
make &>> /dev/null
checkinstall --pkgname=libvpx --pkgversion="1:$(date +%Y%m%d%H%M)-git" --backup=no \
  --deldoc=yes --fstrans=no --default

  show_progress "		Installing opus"
################################### opus
cd ~/src-build/build-ffmpeg
git clone --depth 1 git://git.xiph.org/opus.git
cd opus
./autogen.sh &>> /dev/null
./configure --disable-shared &>> /dev/null
make
checkinstall --pkgname=libopus --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no \
  --deldoc=yes --fstrans=no --default


# show_progress "		Installing libmp3lame"
################################### libmp3lame
# doesn't install in ubuntu, ends up with an error
#apt-get -y --force-yes install nasm
#cd ~/src-build/build-ffmpeg
#wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
#tar xzvf lame-3.99.5.tar.gz
#cd lame-3.99.5
#./configure --enable-nasm --disable-shared
#make
#checkinstall --fstrans=no --pkgname=lame-ffmpeg --pkgversion="3.98.4" --backup=no --default --deldoc=yes

 show_progress "		Installing librtmp"
#################################### librtmp
cd ~/src-build/build-ffmpeg
git clone git://git.ffmpeg.org/rtmpdump &>> /dev/null
cd rtmpdump
make SYS=posix &>> /dev/null
checkinstall --pkgname=rtmpdump --pkgversion="2:$(date +%Y%m%d%H%M)-git" --backup=no \
    --deldoc=yes --fstrans=no --default

export LD_LIBRARY_PATH=/usr/local/lib/

 show_progress "Now... Using all above, compiling FFMpeg"
################################### Finally, ffmpeg
cd ~/src-build/build-ffmpeg
git clone https://github.com/FFmpeg/FFmpeg.git &>> /dev/null
cd FFmpeg
./configure \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree \
  --enable-libfaac \
  --enable-libopencore-amrnb \
  --enable-libopencore-amrwb \
  --enable-postproc \
  --enable-version3 \
  --enable-librtmp \
  --enable-libxvid \
  --enable-libgsm \
  --enable-zlib \
  --enable-swscale \
  --enable-pthreads &>> /dev/null
make &>> /dev/null
checkinstall --pkgname=ffmpeg --pkgversion="7:$(date +%Y%m%d%H%M)-git" --backup=no \
  --deldoc=yes --fstrans=no --default
hash -r
################################################################### END OF FFPMEG
###################################################################
###################################################################



 show_progress "Installing ImageMagick"
################################################################### IMAGEMAGICK
# show_progress "		Installing jpegsrc"
######################################### JPEGSRC
#cd ~/src-build/
#wget http://www.ijg.org/files/jpegsrc.v9a.tar.gz
#tar -xzvf jpegsrc.v9a.tar.gz
#cd jpeg-9a/
#./configure --enable-static --enable-shared
#make
#make install
######################################### END OF JPEGSRC


######################################### LINUNWIND & GPERFTOOLS
 show_progress "		Installing libunwind"
mkdir -p ~/src-build/gperftools
cd ~/src-build/gperftools
#wget -c http://ftp.twaren.net/Unix/NonGNU/libunwind/libunwind-1.1.tar.gz
#tar zxvf libunwind-1.1.tar.gz
git clone git://git.sv.gnu.org/libunwind.git &>> /dev/null
cd libunwind
./autogen.sh &>> /dev/null
./configure CFLAGS=-U_FORTIFY_SOURCE &>> /dev/null
make  &>> /dev/null
make install &>> /dev/null

 show_progress "		Installing gperftools"
cd ~/src-build/gperftools
git clone https://code.google.com/p/gperftools-git/ &>> /dev/null
cd gperftools-git
./autogen.sh &>> /dev/null
./configure --prefix=/usr/local/gperftools --enable-shared --enable-frame-pointers &>> /dev/null
make  &>> /dev/null
make install &>> /dev/null
cp -r /usr/local/gperftools/lib/* /usr/local/lib/

mkdir /tmp/tcmalloc
chmod 0777 /tmp/tcmalloc/
chown -R www-data:www-data /tmp/tcmalloc

show_progress "		Installing apt-get additions for gperftools"
apt-get -y --force-yes install google-perftools libgoogle-perftools-dev &>> /dev/null
export PPROF_PATH=/usr/local/bin/pprof
######################################### 

 show_progress "		Installing webp"
cd ~/src-build/
#wget http://downloads.webmproject.org/releases/webp/libwebp-0.4.2.tar.gz
#tar -xvzf libwebp-0.4.2.tar.gz
git clone https://github.com/webmproject/libwebp.git
cd libwebp
./autogen.sh &>> /dev/null
./configure &>> /dev/null
make &>> /dev/null
make install	 &>> /dev/null

 show_progress "Compile ImageMagick, shall we?"
#########################################  ImageMagick
cd ~/src-build/
wget -c http://www.imagemagick.org/download/ImageMagick.tar.gz &>> /dev/null
tar -zxvf ImageMagick.tar.gz &>> /dev/null
cd ImageMagick*
./configure --prefix=/usr/local/ImageMagick/     \
	--sysconfdir=/etc \
	--with-modules    \
	--with-gslib \
	--with-wmf \
	--with-webp \
	--with-gslib \
	--with-perl=/usr/bin/perl \
	--disable-static &>> /dev/null
make &>> /dev/null
#checkinstall --fstrans=no --install=no -y 
make install &>> /dev/null
#cd ~/src-build/
#rm -rf ImageMagick-*
######################################### 


 show_progress "Now, let's start Nginx installation"
 show_progress "		Installing OpenSSL"
######################################### OpenSSL
cd /root/ngx-build/
git clone https://github.com/openssl/openssl.git &>> /dev/null

 show_progress "		Installing ngx_pagespeed"
######################################### ngx_pagespeed
cd /root/ngx-build/
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-1.9.32.2-beta.zip &>> /dev/null
unzip release-1.9.32.2-beta.zip &>> /dev/null
cd ngx_pagespeed-release-1.9.32.2-beta/
 show_progress "		Installing psol for ngx_pagespeed"
wget https://dl.google.com/dl/page-speed/psol/1.9.32.2.tar.gz &>> /dev/null
tar -xzvf 1.9.32.2.tar.gz   &>> /dev/null # extracts to psol/


######################################### Necessary modules from GitHub
 show_progress "Git cloning modules"
#cd /root/ngx-build/
#git clone https://github.com/openresty/headers-more-nginx-module.git
#cd /root/ngx-build/
#git clone https://github.com/openresty/echo-nginx-module.git
cd /root/ngx-build/
git clone https://github.com/nbs-system/naxsi.git &>> /dev/null
cd /root/ngx-build/
git clone https://github.com/arut/nginx-dav-ext-module.git &>> /dev/null
cd /root/ngx-build/
git clone https://github.com/slact/nginx_http_push_module.git &>> /dev/null
cd /root/ngx-build/
git clone https://github.com/arut/nginx-rtmp-module.git &>> /dev/null
cd /root/ngx-build/
git clone https://github.com/arut/nginx-dlna-module.git &>> /dev/null
cd /root/ngx-build/
git clone https://github.com/tg123/websockify-nginx-module.git &>> /dev/null
cd /root/ngx-build/
git clone https://github.com/masterzen/nginx-upload-progress-module.git &>> /dev/null
cd /root/ngx-build/
git clone https://github.com/gnosek/nginx-upstream-fair.git &>> /dev/null
cd /root/ngx-build/
git clone https://github.com/wandenberg/nginx-video-thumbextractor-module.git &>> /dev/null
cd /root/ngx-build/
git clone https://github.com/FRiCKLE/ngx_cache_purge.git &>> /dev/null
cd /root/ngx-build/
git clone https://github.com/aperezdc/ngx-fancyindex.git &>> /dev/null









 show_progress "Last... Getting, compiling nginx, doing some tweaks etc. Be patient, will you!"
mkdir ~/nginx-package/
cd ~/nginx-package/
wget http://openresty.org/download/ngx_openresty-1.7.7.1.tar.gz &>> /dev/null
tar -xvzf ngx_openresty-1.7.7.1.tar.gz &>> /dev/null
cd ngx_openresty-1.7.7.1
./configure \
--prefix=/usr/local/nginx/  \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/cache/nginx/client \
--http-proxy-temp-path=/var/cache/nginx/proxy \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi \
--http-scgi-temp-path=/var/cache/nginx/scgi \
--add-module=/root/ngx-build/naxsi/naxsi_src \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gzip_static_module \
--with-http_image_filter_module \
--with-http_realip_module \
--with-http_ssl_module \
--with-http_sub_module \
--with-http_xslt_module \
--with-ipv6 \
--with-debug  \
--with-pcre-jit  \
--with-sha1=/usr/include/openssl \
--with-md5=/usr/include/openssl \
--user=www-data \
--group=www-data \
--with-http_stub_status_module \
--without-mail_pop3_module \
--without-mail_imap_module \
--without-mail_smtp_module \
--with-http_stub_status_module \
--with-http_secure_link_module \
--with-http_sub_module \
--with-http_addition_module \
--with-http_geoip_module  \
--with-http_perl_module \
--with-http_random_index_module \
--with-http_stub_status_module \
--with-google_perftools_module \
--with-http_gunzip_module \
--with-http_spdy_module \
--with-file-aio \
--with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
--with-ld-opt='-Wl,-z,relro -Wl,--as-needed' \
--with-openssl=/root/ngx-build/openssl \
--add-module=/root/ngx-build/nginx-upload-progress-module \
--add-module=/root/ngx-build/ngx_pagespeed-release-1.9.32.2-beta \
--add-module=/root/ngx-build/nginx_http_push_module \
--add-module=/root/ngx-build/ngx-fancyindex \
--add-module=/root/ngx-build/nginx-dav-ext-module \
--add-module=/root/ngx-build/ngx_cache_purge \
--add-module=/root/ngx-build/nginx-dlna-module \
--add-module=/root/ngx-build/nginx-rtmp-module \
--add-module=/root/ngx-build/websockify-nginx-module \
--add-module=/root/ngx-build/nginx-upstream-fair  &>> /dev/null
make &>> /dev/null
#make install

#mkdir /root/nginx-package/ngx_openresty-1.7.7.1/build/nginx- 1.7.7/conf/
mkdir -p /var/cache/nginx/{client,scgi,uwsgi,fastcgi,proxy}
mkdir -p /etc/nginx/{sites-available,sites-enabled}
mkdir -p /var/{ngx_pagespeed_cache,log/nginx,log,pagespeed}
mkdir -p /usr/local/nginx/nginx/logs
mkdir -p /var/ngx_pagespeed_cache
mkdir -p /var/log/pagespeed
chown -R www-data:www-data /var/cache/nginx
chown -R www-data:www-data /var/ngx_pagespeed_cache
chown -R www-data:www-data /var/log/nginx
chown -R www-data:www-data /var/log/pagespeed
chown -R www-data:www-data /usr/local/nginx/nginx/logs
chown -R www-data:www-data /etc/nginx/sites-available
chown -R www-data:www-data /etc/nginx/sites-enabled
chown -R www-data:www-data /var/ngx_pagespeed_cache

# Now let's build nginx deb file. 
# Warning, it's not set to auto-install as of now.
show_progress "Installing Nginx"
checkinstall --fstrans=no --install=yes -y  &>> /dev/null

show_progress "Creating Nginx startup script"
######################################### Add nginx to /etc/init.d for
wget -O nginx.init https://raw.githubusercontent.com/Fleshgrinder/nginx-sysvinit-script/master/nginx
mv nginx.init /etc/init.d/nginx
chmod +x /etc/init.d/nginx

#Add it to system startup
update-rc.d -f nginx defaults 
#alternately
#chkconfig —add nginx
#chkconfig nginx on
# Let's make sure naxsi library is in nginx directory
cp /root/ngx-build/naxsi/naxsi_config/naxsi_core.rules /etc/nginx



cd ~/
git clone https://github.com/nomadturk/nginx-conf.git
cd nginx-conf
mv -f * /etc/nginx/
git clone https://github.com/h5bp/server-configs-nginx.git
cd server-configs-nginx
mv -f h5bp mime.types doc/ /etc/nginx
cd ~/
rm -r ~/nginx-conf





show_progress "Uh oh... We forgot installing mysql. So... MariaDB it is!"
cd ~/

## MariaDB
apt-get -y --force-yes install python-software-properties &>> /dev/null
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db &>> /dev/null
add-apt-repository 'deb http://lon1.mirrors.digitalocean.com/mariadb/repo/10.0/debian wheezy main'
apt-get update &>> /dev/null
# End timer, we do not want mysql password screen to mess up with our resulting time now, do we?
END=$(date +%s)
apt-get -y --force-yes install mariadb-server
# Start timer again.
START2=$(date +%s)
show_progress "Since I feel lazy, we'll get the Php5.5 from DotDeb..."
## DotDeb Php 5.5, 
add-apt-repository 'deb http://packages.dotdeb.org wheezy all'
add-apt-repository 'deb http://packages.dotdeb.org wheezy-php55 all'
wget http://www.dotdeb.org/dotdeb.gpg &>> /dev/null
apt-key add dotdeb.gpg &>> /dev/null
apt-get update &>> /dev/null
apt-get -y --force-yes install php5-fpm php5-mysql php5-xcache memcached php5-memcache php5-memcached &>> /dev/null
apt-get -y --force-yes install php5-mcrypt php5-cli php5-curl php5-gd php5-json php5-sqlite php5-pspell php5-readline php5-recode php5-xmlrpc php5-xsl php5-intl php5-imagick php5-tidy &>> /dev/null

show_progress "Time for a bit of tweaks"
sed -i "s/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
sed -i "s/^;listen.owner = www-data/listen.owner = www-data/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^;listen.group = www-data/listen.group = www-data/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^;listen.backlog = 128/listen.backlog = 65536/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^;listen.backlog = 65535/listen.backlog = 65536/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^listen=.*$/listen = 127.0.0.1:9001/" /etc/php5/fpm/pool.d/www.conf 
sed -i "s/^listen =.*$/listen = 127.0.0.1:9001/" /etc/php5/fpm/pool.d/www.conf 
sed -i "s/^  access_log logs\/static.log/  access_log \/var\/log\/nginx\/static.log/" /etc/nginx/h5bp/location/expires.conf


mkdir -p /var/www
cp /usr/local/nginx/nginx/html/*.html /var/www/
chown -R www-data:www-data /var/www/


 
show_progress "Starting Nginx"
service nginx start


show_progress "Add nginx to logrotate"
######################################### Let's add nginx to logrotate and do an update
echo "/var/log/nginx/*.log {" >> nginx.logrotate
echo "        daily" >> nginx.logrotate
echo "        missingok" >> nginx.logrotate
echo "        rotate 52" >> nginx.logrotate
echo "        compress" >> nginx.logrotate
echo "        delaycompress" >> nginx.logrotate
echo "        notifempty" >> nginx.logrotate
echo "        create 640 www-data adm" >> nginx.logrotate
echo "        sharedscripts" >> nginx.logrotate
echo "        postrotate" >> nginx.logrotate
echo "                [ ! -f /var/run/nginx.pid ] || kill -USR1 `cat /var/run/nginx.pid`" >> nginx.logrotate
echo "        endscript" >> nginx.logrotate
echo "}" >> nginx.logrotate

mv nginx.logrotate /etc/logrotate.d/nginx
chmod 0644 /etc/logrotate.d/nginx
logrotate -f -v /etc/logrotate.d/nginx
#########################################

show_progress "Done and done... Enjoy it. All is ready to go."

END2=$(date +%s)
DIFF1=$(( $END - $START ))
DIFF2=$(( $END2 - $START2 ))
DIFF=$(( $DIFF1 + $DIFF2 ))
echo Hurray! In mere $(($DIFF / 3600 )) hours $(($DIFF / 60 )) minutes and $(($DIFF % 60 )) seconds all is finished! Congrats dude... >>Time.log
show_progress_info "$(cat Time.log)"
show_progress_info "This is also excluding the time you spent at MariaDB Password page."
#echo "Hurray! In mere "$(($DIFF / 3600 ))"" hours "$(($DIFF / 60 ))" minutes and "$(($DIFF % 60 ))" seconds all is finished! Congrats dude..." >>Time.log
read -s -n 1 any_key | show_progress_info "Press a key to exit now..."
exit



# More info about RTMP
#https://github.com/arut/nginx-rtmp-module
#https://github.com/tg123/websockify-nginx-module
#https://github.com/masterzen/nginx-upload-progress-module
#http://pkula.blogspot.com.tr/2013/06/live-video-stream-from-raspberry-pi.html
