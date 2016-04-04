#!/bin/bash
# you have write permissions there. set RETAIN_NUM_LINES to the

### Setup Logging
LOGFILE=~/Install.log
RETAIN_NUM_LINES=10

function logsetup {
    TMP=$(tail -n $RETAIN_NUM_LINES $LOGFILE 2>/dev/null) && echo "${TMP}" > $LOGFILE
    exec > >(tee -a $LOGFILE)
    exec 2>&1
}

function log {
    echo "[$(date)]: $*"
}
logsetup
### Logging started

# Yellow
function show_progress ()
{
	echo $(tput setaf 3)$@$(tput sgr0)
}

# Torquise
function show_progress_info ()
{
	echo $(tput setaf 6)$@$(tput sgr0)
}

# Red color
function show_progress_error ()
{
	echo $(tput setaf 1)$@$(tput sgr0)
}
# Red Background color
function show_progress_error2 ()
{
	echo $(tput setb 4)$@$(tput sgr0)
}

# Loader
function show_progress_loader ()
{
	echo $(tput setb 4)$(tput setaf 1)$@$(tput sgr0)
}

# Checking permissions
if [[ $EUID -ne 0 ]]; then
	 show_progress_error "You need root permissions to run the script."
	exit 1
fi

readonly LINUX_DISTRO=$(lsb_release -i |awk '{print $3}')
readonly DEBIAN_VERSION=$(lsb_release -sc)
LINUX_ARCH=$(uname -m)

# Check lsb_release
if [ ! -x  /usr/bin/lsb_release ]; then
	show_progress "Installing lsb-release."
	apt-get -y --force-yes install lsb-release &>> /dev/null
fi

# Check Linux distro
if [ "$LINUX_DISTRO" != "Ubuntu" ] && [ "$LINUX_DISTRO" != "Debian" ]; then
	show_progress_error "Sorry, only Debian 7 and Ubuntu 14.04 is supported as of now"
	exit 1
fi

###################################################################
##								 ##
##								 ##
##	Down below, it's a mess... 				 ##
##	Now it'll try to do it's best.				 ##
##								 ##
##								 ##
###################################################################
#     A bit of cleanup first, just in case there're old stuff	 #
rm -r ~/ngx-build ~/src-build ~/nginx-package ~/Time* ~/Install.log
###################################################################


show_progress "The script will terminate if any error to happen."
set -e
mkdir -p ~/ngx-build/

# Some systems problems with locales. So lets try to add them just to run smoother.
show_progress "Setting system locales. If they are erroneous MariaDB install just might fail"
dpkg-reconfigure locales
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

# Remove any existing packages:
show_progress "Doing a system upgrade and removing ffmpeg files if there any."
apt-get -y --force-yes dist-upgrade >> /dev/null
apt-get -y --force-yes remove ffmpeg x264 libav-tools libvpx-dev libx264-dev yasm >> /dev/null
apt-get -y --force-yes install software-properties-common python-software-properties >> /dev/null

#Lets calculate how much time is spent
# We don't need this apt-get dist-upgrade process to be counted. So, the timer starts here.
START=$(date +%s) 
echo $START > ~/Time.Varsars

# Let's install what's needed...
if [ "$LINUX_DISTRO" == "Debian" ]; then
	#Debian 
	show_progress "Adding multimedia repository and doing an apt-get update."
	add-apt-repository -y 'deb http://www.deb-multimedia.org wheezy main non-free'
	apt-get update
	apt-get -y --force-yes install deb-multimedia-keyring  libswresample0
elif [ "$LINUX_DISTRO" == "Ubuntu" ]; then
	#Ubuntu
	show_progress "Adding Ubuntu repository for FFMpeg and installing Ubuntu only stuff"
	#apt-add-repository multiverse
	#add-apt-repository -y ppa:jon-severinsson/ffmpeg
	#apt-get update
	apt-get -y --force-yes install libglib2.0-dev libfontconfig1-dev libtiff4-dev libexif-dev
fi

show_progress_info "Installing necessary packages apt-get update, please wait $(tput setb 4)$(tput setaf 1)..."
apt-get -y --force-yes install build-essential checkinstall git libjack-jackd2-dev >> /dev/null
show_progress_info "Installing necessary packages apt-get update, please wait $(tput setb 4)$(tput setaf 1)......."
apt-get -y --force-yes install openssl autoconf make automake g++ bzip2 >> /dev/null
show_progress_info "Installing necessary packages apt-get update, please wait $(tput setb 4)$(tput setaf 1).........."
apt-get -y --force-yes install texi2html zlib1g-dev libfreetype6-dev libtool pkg-config >> /dev/null
show_progress_info "Installing necessary packages apt-get update, please wait $(tput setb 4)$(tput setaf 1)............."
apt-get -y --force-yes install libssl1.0.0 libssl-dev libgsm1-dev libxvidcore-dev libxvidcore4 libass-dev librtmp-dev libmp3lame-dev >> /dev/null
show_progress_info "Installing necessary packages apt-get update, please wait $(tput setb 4)$(tput setaf 1)................"
apt-get -y --force-yes install libpcre3 libpcre3-dev unzip tar zip libpcrecpp0 >> /dev/null
show_progress_info "Installing necessary packages apt-get update, please wait $(tput setb 4)$(tput setaf 1)..................."
apt-get -y --force-yes install libreadline-dev libncurses5-dev perl libjpeg-dev libjpeg-progs devscripts graphicsmagick-imagemagick-compat >> /dev/null
show_progress_info "Installing necessary packages apt-get update, please wait $(tput setb 4)$(tput setaf 1)......................"
apt-get -y --force-yes install graphicsmagick-libmagick-dev-compat libpam0g-dev libpng-dev libpng12-0 libpng12-dev libxml2-dev >> /dev/null
show_progress_info "Installing necessary packages apt-get update, please wait $(tput setb 4)$(tput setaf 1)........................."
apt-get -y --force-yes install libtiff-dev libgif-dev libgeoip1 libxslt1.1 libxslt-dev libgd2-xpm-dev >> /dev/null
show_progress_info "Installing necessary packages apt-get update, please wait $(tput setb 4)$(tput setaf 1)............................"
apt-get -y --force-yes install libperl-dev libjpeg8-dev  libcdio-cdda1 libcdio-paranoia1 libcdio13 libpostproc52 libbz2-dev >> /dev/null
show_progress_info "Installing necessary packages apt-get update, please wait $(tput setb 4)$(tput setaf 1)..............................."
apt-get -y --force-yes install libopencore-amrnb-dev libopencore-amrwb-dev  libtheora-dev libfaac-dev libavfilter-dev libavcodec-dev libavutil-dev libavdevice-dev libavformat-dev libswscale-dev libgeoip-dev libsdl1.2-dev libva-dev libvdpau-dev  >> /dev/null
#Debian 8 doesn't have libjpeg8 so let's install another and some others
apt-get -y --force-yes install libjpeg62-turbo-dev libvorbis-dev libgsm1-dev libspeex-dev libschroedinger-dev libvo-aacenc-dev libvo-amrwbenc-dev libbluray-dev libcdio-dev libgnutls28-dev libass-dev libpulse-dev libvidstab-dev libzvbi-dev libutvideo-dev libx265-dev libiec61883-dev

show_progress "Start FFMpeg Installation"
show_progress "Depending on your CPU this might take a long while"
##################################################################Start FFMPEG 
mkdir -p ~/src-build/build-ffmpeg
mkdir -p ~/ngx-build/
#apt-get -y --force-yes install yasm
show_progress "		Installing yasm"
################################### First, install yasm
# YASM refused to install on ppc64le system. At least it broke the script. So let me try fixing it.
if [ "$LINUX_ARCH" != "x86_64" ] && [ "$LINUX_ARCH" != "i386" ] && [ "$LINUX_ARCH" != "i486" ] && [ "$LINUX_ARCH" != "amd64" ] && [ "$LINUX_ARCH" != "x86" ]; then
	show_progress_error "Downloading YASM from the repository since we dont know your system architecture"
else
    cd ~/src-build/build-ffmpeg
	git clone git://github.com/yasm/yasm.git
	cd yasm
	./autogen.sh x86_64 i386 amd64
	# ./configure x86_64 i386 amd64
	make
	checkinstall --pkgname=yasm --pkgversion="1.3.0" --backup=no \
	--deldoc=yes --fstrans=no --default
fi

  
show_progress "		Installing libx246"
################################### libx264
cd ~/src-build/build-ffmpeg
# They have git but I had connectivity errors with them so..
# git clone --depth 1 git://git.videolan.org/x264
#cd x264


# Check Linux distro
# On RunAbove Power8 systems due to system bein ppc64le the script didn't work. So, here's my workaround.
# if [[ $LINUX_ARCH == "x86_64" ]] && [[ $LINUX_ARCH == "i386" ]] && [[ $LINUX_ARCH == "i486" ]] && [[ $LINUX_ARCH == "amd64" ]] && [[ $LINUX_ARCH == "x86" ]] && [[ $LINUX_ARCH == "powerpc" ]] && [[ $LINUX_ARCH == "powerpc64" ]] && [[ $LINUX_ARCH == "sparc" ]] && [[ $LINUX_ARCH == "aarch64" ]] && [[ $LINUX_ARCH == "s390" ]] && [[ $LINUX_ARCH == "hppa*" ]] && [[ $LINUX_ARCH == "alpha*" ]]; then
if [ "$LINUX_ARCH" != "x86_64" ] && [ "$LINUX_ARCH" != "i386" ] && [ "$LINUX_ARCH" != "i486" ] && [ "$LINUX_ARCH" != "amd64" ] && [ "$LINUX_ARCH" != "x86" ] && [ "$LINUX_ARCH" != "powerpc" ] && [ "$LINUX_ARCH" != "powerpc64" ] && [ "$LINUX_ARCH" != "sparc" ] && [ "$LINUX_ARCH" != "aarch64" ] && [ "$LINUX_ARCH" != "s390" ] && [ "$LINUX_ARCH" != "hppa*" ] && [ "$LINUX_ARCH" != "alpha*" ]; then
	show_progress_error "Sorry, architecture is not supported. Let's see if the repos has this"
	apt-get -y --force-yes install libx264-dev
else
	wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
	tar xjvf last_x264.tar.bz2
	cd x264-snapshot*
	./configure --enable-static
	make
	checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | \
		awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
		--fstrans=no --default
fi

show_progress "	Installing fdk-aac"
################################### fdk-aac
cd ~/src-build/build-ffmpeg
git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
./autogen.sh
autoreconf -fiv
./configure --disable-shared
make
checkinstall --pkgname=fdk-aac --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no \
  --deldoc=yes --fstrans=no --default
show_progress "		Installing libvpx" 
################################### libvpx
cd ~/src-build/build-ffmpeg
git clone https://chromium.googlesource.com/webm/libvpx
cd libvpx
./configure --disable-examples --disable-unit-tests
make
checkinstall --pkgname=libvpx --pkgversion="1:$(date +%Y%m%d%H%M)-git" --backup=no \
  --deldoc=yes --fstrans=no --default

 show_progress "		Installing opus"
################################### opus
cd ~/src-build/build-ffmpeg
git clone --depth 1 git://git.xiph.org/opus.git
cd opus
./autogen.sh
./configure --disable-shared
make
checkinstall --pkgname=libopus --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no \
  --deldoc=yes --fstrans=no --default


#show_progress "		Installing libmp3lame"
################################### libmp3lame
# doesn't install in ubuntu, ends up with an error
apt-get -y --force-yes install nasm
#cd ~/src-build/build-ffmpeg
#wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
#tar xzvf lame-3.99.5.tar.gz
#cd lame-3.99.5
#./configure --enable-nasm --disable-shared
#make
#checkinstall --fstrans=no --pkgname=lame-ffmpeg --pkgversion="3.98.4" --backup=no --default --deldoc=yes

show_progress "		Installing librtmp"
#################################### librtmp
# Let's install what's needed...
if [ "$LINUX_ARCH" != "x86_64" ] && [ "$LINUX_ARCH" != "i386" ] && [ "$LINUX_ARCH" != "i486" ] && [ "$LINUX_ARCH" != "amd64" ] && [ "$LINUX_ARCH" != "x86" ]; then
	# Systems such as ppc64 does have trouble compiling this...
	show_progress_error "Warning! This will affect the total time since instead of compiling, I will be using the librtmp-dev from the repos"
	apt-get install librtmp-dev
else
	cd ~/src-build/build-ffmpeg
	git clone git://git.ffmpeg.org/rtmpdump
	cd rtmpdump
	make SYS=posix
	checkinstall --pkgname=rtmpdump --pkgversion="2:$(date +%Y%m%d%H%M)-git" --backup=no \
    --deldoc=yes --fstrans=no --default
	export LD_LIBRARY_PATH=/usr/local/lib/
fi

show_progress "Now... Using all above, compiling FFMpeg"
################################### Finally, ffmpeg
cd ~/src-build/build-ffmpeg
git clone https://github.com/FFmpeg/FFmpeg.git
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
  --enable-pthreads
make
checkinstall --pkgname=ffmpeg --pkgversion="7:$(date +%Y%m%d%H%M)-git" --backup=no \
  --deldoc=yes --fstrans=no --default
hash -r
################################################################### END OF FFPMEG
###################################################################
###################################################################

show_progress "Installing ImageMagick"
################################################################### IMAGEMAGICK
#show_progress "		Installing jpegsrc"
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
git clone git://git.sv.gnu.org/libunwind.git
cd libunwind
./autogen.sh
./configure CFLAGS=-U_FORTIFY_SOURCE
make 
make install

show_progress "		Installing gperftools"
cd ~/src-build/gperftools
git clone https://code.google.com/p/gperftools-git/
cd gperftools-git
./autogen.sh
./configure --prefix=/usr/local/gperftools --enable-shared --enable-frame-pointers
make 
make install
cp -r /usr/local/gperftools/lib/* /usr/local/lib/


if [ ! -d /tmp/tcmalloc ]; then
	mkdir /tmp/tcmalloc
	chmod 0777 /tmp/tcmalloc/
	chown -R www-data:www-data /tmp/tcmalloc
else
	chmod 0777 /tmp/tcmalloc/
	chown -R www-data:www-data /tmp/tcmalloc
fi

show_progress "		Installing apt-get additions for gperftools"
apt-get -y --force-yes install google-perftools libgoogle-perftools-dev
export PPROF_PATH=/usr/local/bin/pprof
######################################### 

show_progress "		Installing webp"
cd ~/src-build/
#wget http://downloads.webmproject.org/releases/webp/libwebp-0.4.2.tar.gz
#tar -xvzf libwebp-0.4.2.tar.gz
git clone https://github.com/webmproject/libwebp.git
cd libwebp
./autogen.sh
./configure
make
make install	

show_progress "Compile ImageMagick, shall we?"
#########################################  ImageMagick
cd ~/src-build/
wget -c http://www.imagemagick.org/download/ImageMagick.tar.gz
tar -zxvf ImageMagick.tar.gz
cd ImageMagick*
./configure --prefix=/usr/local/ImageMagick/     \
	--sysconfdir=/etc \
	--with-modules    \
	--with-gslib \
	--with-wmf \
	--with-webp \
	--with-gslib \
	--with-perl=/usr/bin/perl \
	--disable-static
make
#checkinstall --fstrans=no --install=no -y 
make install
#cd ~/src-build/
#rm -rf ImageMagick-*
######################################### 


show_progress "Now, let's start Nginx installation"
show_progress "		Installing OpenSSL"
######################################### OpenSSL
cd /root/ngx-build/
git clone https://github.com/openssl/openssl.git

show_progress "		Installing ngx_pagespeed"
######################################### ngx_pagespeed
cd /root/ngx-build/
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-1.11.33.0-beta.zip
unzip release-1.11.33.0-beta.zip
cd ngx_pagespeed-release-1.11.33.0-beta/
show_progress "		Installing psol for ngx_pagespeed"
# Can change it with the https one. But it is slower.
wget http://dl.google.com/dl/page-speed/psol/1.11.33.0.tar.gz
tar -xzvf 1.11.33.0.tar.gz   # extracts to psol/

# Timer reminder
DIFFX=$(( $(date +%s) - $START )) 
echo Up till now it took $(($DIFFX / 60 )) minutes and $(($DIFFX % 60 )) seconds... > time.tmp
show_progress_error2 "$(cat time.tmp)"

######################################### Necessary modules from GitHub
show_progress "Git cloning modules"
#cd /root/ngx-build/
#git clone https://github.com/openresty/headers-more-nginx-module.git
#cd /root/ngx-build/
#git clone https://github.com/openresty/echo-nginx-module.git
cd /root/ngx-build/
git clone https://github.com/nbs-system/naxsi.git
cd /root/ngx-build/
git clone https://github.com/arut/nginx-dav-ext-module.git
cd /root/ngx-build/
git clone https://github.com/slact/nginx_http_push_module.git
cd /root/ngx-build/
git clone https://github.com/arut/nginx-rtmp-module.git
cd /root/ngx-build/
git clone https://github.com/arut/nginx-dlna-module.git
cd /root/ngx-build/
git clone https://github.com/tg123/websockify-nginx-module.git
cd /root/ngx-build/
git clone https://github.com/masterzen/nginx-upload-progress-module.git
cd /root/ngx-build/
git clone https://github.com/gnosek/nginx-upstream-fair.git
cd /root/ngx-build/
git clone https://github.com/wandenberg/nginx-video-thumbextractor-module.git
cd /root/ngx-build/
git clone https://github.com/FRiCKLE/ngx_cache_purge.git
cd /root/ngx-build/
git clone https://github.com/aperezdc/ngx-fancyindex.git





show_progress "Last... Getting, compiling nginx, doing some tweaks etc. Be patient, will you!"
mkdir ~/nginx-package/
cd ~/nginx-package/

if [ "$LINUX_ARCH" != "x86_64" ] && [ "$LINUX_ARCH" != "i386" ] && [ "$LINUX_ARCH" != "i486" ] && [ "$LINUX_ARCH" != "amd64" ] && [ "$LINUX_ARCH" != "x86" ]; then
	#Ubuntu
	show_progress_error "Warning, Openresty can not be compiled with pcre-jit module on PowerPC, replacing it with Nginx!"
	show_progress_error "Also ngx_pagespeed won't compile on ppc architecture either. So skipping it..."
wget http://nginx.org/download/nginx-1.9.7.tar.gz
tar -xvzf nginx-1.9.7.tar.gz
cd nginx-1.9.7

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
--add-module=/root/ngx-build/nginx_http_push_module \
--add-module=/root/ngx-build/ngx-fancyindex \
--add-module=/root/ngx-build/nginx-dav-ext-module \
--add-module=/root/ngx-build/ngx_cache_purge \
--add-module=/root/ngx-build/nginx-rtmp-module \
--add-module=/root/ngx-build/websockify-nginx-module \
--add-module=/root/ngx-build/nginx-upstream-fair 
else
wget https://openresty.org/download/openresty-1.9.7.4.tar.gz
tar -xvzf ngx_openresty-1.9.7.4.tar.gz
cd ngx_openresty-1.9.7.4
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
--add-module=/root/ngx-build/ngx_pagespeed-release-1.11.33.0-beta \
--add-module=/root/ngx-build/nginx_http_push_module \
--add-module=/root/ngx-build/ngx-fancyindex \
--add-module=/root/ngx-build/nginx-dav-ext-module \
--add-module=/root/ngx-build/ngx_cache_purge \
--add-module=/root/ngx-build/nginx-rtmp-module \
--add-module=/root/ngx-build/websockify-nginx-module \
--add-module=/root/ngx-build/nginx-upstream-fair 
fi

make
#make install

# mkdir -p /var/cache/nginx/{client,scgi,uwsgi,fastcgi,proxy}
# Create and change ownership some folders
for dir in /var/cache/nginx/  /var/cache/nginx/client /var/cache/nginx/scgi /var/cache/nginx/uwsgi /var/cache/nginx/fastcgi /var/cache/nginx/proxy /var/ngx_pagespeed_cache /var/log/nginx /var/log/pagespeed /usr/local/nginx/nginx/logs /var/ngx_pagespeed_cache /var/log/pagespeed /etc/nginx/sites-available sites-enabled
do
if [ ! -d $dir ]; then
	mkdir -p $dir
	chown -R  www-data:www-data $dir
else
	chown -R  www-data:www-data $dir
fi
done

# Now let's build nginx deb file. 
# Warning, it's not set to auto-install as of now.
show_progress "Installing Nginx"
checkinstall 	--fstrans=no --pkgname=nginx --install=yes -y

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
mv -f sites-enabled/* /etc/nginx/sites-enabled/
cd ~/
rm -r ~/nginx-conf


show_progress "Uh oh... We forgot installing mysql. So... MariaDB it is!"
cd ~/
## MariaDB
if [ "$LINUX_ARCH" != "x86_64" ] && [ "$LINUX_ARCH" != "i386" ] && [ "$LINUX_ARCH" != "i486" ] && [ "$LINUX_ARCH" != "amd64" ] && [ "$LINUX_ARCH" != "x86" ]; then
	show_progress_error "Can install MariaDB to this system using external repos. Let's try if your own repos have anything to offer"
	apt-get -y --force-yes install mariadb-server
	# End timer, we do not want mysql password screen to mess up with our resulting time now, do we?
	END=$(date +%s)
	echo $END >> ~/Time.Varsars
else
	apt-get -y --force-yes install python-software-properties
	apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
	
	if [ "$LINUX_DISTRO" == "Debian" ]; then
	#Debian 
		show_progress "Adding MariaDB Wheezy Repository"
		add-apt-repository 'deb http://ams2.mirrors.digitalocean.com/mariadb/repo/5.5/debian wheezy main'
		apt-get update
	elif [ "$LINUX_DISTRO" == "Ubuntu" ]; then
		#Ubuntu
		show_progress "Adding MariaDB Trusty Repository"
		add-apt-repository 'deb http://ams2.mirrors.digitalocean.com/mariadb/repo/5.5/ubuntu trusty main'
		apt-get update
	fi
	# End timer, we do not want mysql password screen to mess up with our resulting time now, do we?
	END=$(date +%s)
	echo $END >> ~/Time.Varsars
	apt-get -y --force-yes install mariadb-server 
fi
# mariadb-client mariadb-common
# Start timer again.
START2=$(date +%s)
echo $START2 >> ~/Time.Varsars


## DotDeb Php 5.5 repository for Debian
if [ "$LINUX_DISTRO" == "Debian" ]; then
	#Debian 
	show_progress "Adding DotDeb Php 5.5 Repository"
	add-apt-repository 'deb http://packages.dotdeb.org wheezy all'
	add-apt-repository 'deb http://packages.dotdeb.org wheezy-php55 all'
	wget http://www.dotdeb.org/dotdeb.gpg
	apt-key add dotdeb.gpg
fi
 

apt-get update
apt-get -y --force-yes install php5-xcache
apt-get -y --force-yes install php5-fpm php5-mysql memcached php5-memcache php5-memcached
apt-get -y --force-yes install php5-mcrypt php5-cli php5-curl php5-gd php5-json php5-sqlite php5-pspell php5-readline php5-recode php5-xmlrpc php5-xsl php5-intl php5-imagick php5-tidy

show_progress "Time for a bit of tweaks"
if [ -f /etc/php5/fpm/php.ini ]; then
	sed -i "s/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
fi
if [ -f /etc/php5/fpm/pool.d/www.conf ]; then
	sed -i "s/^;listen.owner = www-data/listen.owner = www-data/" /etc/php5/fpm/pool.d/www.conf
	sed -i "s/^;listen.group = www-data/listen.group = www-data/" /etc/php5/fpm/pool.d/www.conf
	sed -i "s/^;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/www.conf
	sed -i "s/^;listen.backlog = 128/listen.backlog = 65536/" /etc/php5/fpm/pool.d/www.conf
	sed -i "s/^;listen.backlog = 65535/listen.backlog = 65536/" /etc/php5/fpm/pool.d/www.conf
	sed -i "s/^listen=.*$/listen = 127.0.0.1:9000/" /etc/php5/fpm/pool.d/www.conf 
	sed -i "s/^listen =.*$/listen = 127.0.0.1:9000/" /etc/php5/fpm/pool.d/www.conf 
	/etc/init.d/php5-fpm stop
	/etc/init.d/php5-fpm start
fi
if [ -f /etc/nginx/h5bp/location/expires.conf ]; then
	sed -i "s/^  access_log logs\/static.log/  access_log \/var\/log\/nginx\/static.log/" /etc/nginx/h5bp/location/expires.conf
fi


if [ ! -d /var/www ]; then
        mkdir -p /var/www
        if [ -d /usr/local/nginx/nginx/html/ ]; then
                show_progress "Creating /var/www"
                cp /usr/local/nginx/nginx/html/* /var/www/
        elif [ -d /usr/local/nginx/html ]; then
                show_progress "Creating /var/www"
                cp /usr/local/nginx/html/* /var/www/
        fi
fi


 
show_progress "Starting Nginx"
service nginx start


show_progress "Add nginx to logrotate"
######################################### Let's add nginx to logrotate and do an update
cd~/
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
echo "        [ ! -f /var/run/nginx.pid ] || kill -USR1 `cat /var/run/nginx.pid`" >> nginx.logrotate
echo "        endscript" >> nginx.logrotate
echo "}" > nginx.logrotate
if [ -f /etc/logrotate.d/nginx ]; then
        rm /etc/logrotate.d/nginx
fi
mv nginx.logrotate /etc/logrotate.d/nginx
chmod 0644 /etc/logrotate.d/nginx
logrotate -f -v /etc/logrotate.d/nginx
#########################################

show_progress "Done and done... Enjoy it. All is ready to go."

END2=$(date +%s)
echo $END2>> ~/Time.Varsars
DIFF1=$(( END - START ))
DIFF2=$(( END2 - START2 ))
DIFF=$(( DIFF1 + DIFF2 ))
echo Hurray! In mere $(($DIFF / 60 )) minutes and $(($DIFF % 60 )) seconds all is finished! Congrats dude... >>Time.Output
show_progress_info "$(cat Time.Output)"
show_progress_info "This is of course excluding the time spent at MariaDB Password input page."
#echo "Hurray! In mere "$(($DIFF / 3600 ))"" hours "$(($DIFF / 60 ))" minutes and "$(($DIFF % 60 ))" seconds all is finished! Congrats dude..." >>Time.Output
read -s -n 1 any_key | show_progress_info "Press a key to exit now..." && wait

# wget -O VirtMin.sh http://software.virtualmin.com/gpl/scripts/install.sh
# sed -i '/debdeps=/s/ mysql-/ mariadb-/g' VirtMin.sh
# chmod +x VirtMin.sh
# bash -c "bash VirtMin.sh"
# /etc/init.d/apache2 stop
# update-rc.d apache2 remove
# apt-get -y --force-yes install webmin-virtualmin-nginx webmin-virtualmin-nginx-ssl
# apt-mark hold ffmpeg
apt-mark hold nginx
# apt-mark hold mysql-common


############################################################### Install Webmin Themes
# cd ~/src-build
# wget http://theme.winfuture.it/bwtheme.wbt.gz -4
# wget --no-check-certificate https://github.com/qooob/authentic-theme/archive/master.zip
# wget http://www.turnkeylinux.org/files/attachments/theme-metal_0.tar
# wget http://www.xenlayer.com/xenlayer-theme.wbt.gz
# wget http://www.luizlopes.com/virtualmin/finally-theme-0.3.wbt.gz
# tar -xvf theme-metal_0.tar
# unzip master.zip
# tar -xvzf bwtheme.wbt.gz
# tar xvzf xenlayer-theme.wbt.gz
# tar xvzf finally-theme-0.3.wbt.gz
# mv bootstrap/ theme-metal/ authentic-theme-master/ xenlayer-theme/ virtual-server-theme/ /usr/share/webmin/
############################################################### Install Webmin Themes End
