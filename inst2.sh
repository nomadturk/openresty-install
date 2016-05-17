#!/bin/bash


### Setup Logging
LOGFILE=Install.log
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

# Check lsb_release
if [ ! -x  $prf_dir/bin/lsb_release ]; then
	show_progress "Installing lsb-release."
	apt-get -y install lsb-release &>> /dev/null
fi

readonly LINUX_DISTRO=$(lsb_release -i |awk '{print $3}')
readonly DEBIAN_VERSION=$(lsb_release -sc)
LINUX_ARCH=$(uname -m)


# Check Linux distro
if [ "$LINUX_DISTRO" != "Ubuntu" ] && [ "$LINUX_DISTRO" != "Debian" ] && [ "$LINUX_DISTRO" != "LinuxMint" ]; then
	show_progress_error "Sorry, only Debian 7 and Ubuntu 14.04 is supported as of now"
	exit 1
fi

# Check Linux distro
if [ "$DEBIAN_VERSION" == "xenial" ]; then
	APTCMD=('apt-get -y'); else
	APTCMD=('apt-get -y --force-yes')
fi

# Get the number of cpu cores in the system
CORES=$(grep -c ^processor /proc/cpuinfo)



### Set output directories
ff_dir=/tmp/src-build/src-ffmpeg
ngx_dir=/tmp/src-build/src-nginx
mgk_dir=/tmp/src-build/src-magick
ff_bld_dir=$HOME/openresty-build/ffmpeg
ngx_bld_dir=$HOME/openresty-build/nginx
mgk_bld_dir=$HOME/openresty-build/magick
prf_dir=/usr

export ff_dir=/tmp/src-build/src-ffmpeg
export ngx_dir=/tmp/src-build/src-nginx
export mgk_dir=/tmp/src-build/src-magick
export ff_bld_dir=$HOME/openresty-build/ffmpeg
export ngx_bld_dir=$HOME/openresty-build/nginx
export mgk_bld_dir=$HOME/openresty-build/magick
export prf_dir=/usr


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
##									##
##									##
##	Down below, it's a mess... 		##
##	Now it'll try to do it's best	##
##									##
##									##
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
# A bit of cleanup first, just in case there're old stuff
if [ -f "/tmp/OpenRestyInstall.log" ]; then rm -rf /tmp/OpenRestyInstall.log ; fi
if [ -f "/tmp/Time.Vars" ]; then rm -rf /tmp/Time.Vars ; fi
if [ -d "$ngx_dir" ]; then rm -rf $ngx_dir ; fi
if [ -d "$ff_dir" ]; then rm -rf $ff_dir ; fi
if [ -d "$mgk_dir" ]; then rm -rf $mgk_dir ; fi
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###


show_progress "The script will terminate if any error to happen."
set -e

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


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### ### ###
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### ### ###

removepackage=(ffmpeg x264 libx264-dev libx265-dev libffms2 ffmsindex libav-tools libvpx-dev yasm libssl-dev libfdk-aac-dev
 libxpm-dev libzimg-dev libxt-dev libmfx libmfx-dev libwebp-dev libmp3lame libmp3lame-dev libogg libxvidcore libfribidi
 libexpat libvpx libutvideo libvstab libass libass-dev)



installpackage=(autoconf automake binutils build-essential bzip2 ccache checkinstall clang cmake devscripts frei0r-plugins-dev g++ git gnutls-dev
 graphicsmagick-imagemagick-compat graphicsmagick-libmagick-dev-compat libavcodec-dev libavformat-dev libavutil-dev libbluray-dev libbz2-dev libc6-dev libcaca-dev libcdio-cdda1 libcdio-dev
 libcdio-paranoia1 libcdio13 libcrypto++-dev libdc1394-22-dev libexif-dev libnuma-dev libjemalloc-dev
 libfontconfig1-dev libfreetype6-dev libgd2-xpm-dev libgeoip-dev libgeoip1 libgif-dev libglib2.0-dev libgpac-dev libgsm1-dev
 libjack-jackd2-dev libjpeg-dev libjpeg-progs libncurses5-dev libogg-dev libopenal-dev libopencore-amrnb-dev
 libopencore-amrwb-dev libopenjpeg-dev libpam0g-dev libpcre3 libpcre3-dev libperl-dev libpng-dev
 libpng12-0 libpng12-dev libpulse-dev libreadline-dev librtmp-dev libsctp-dev libschroedinger-dev libsdl1.2-dev 
 libsox-dev libspeex-dev libssl1.0.0 libtheora-dev libtiff-dev libtool libtwolame-dev libv4l-dev libva-dev libgcrypt-dev
 libvdpau-dev  libssl-dev libvo-aacenc-dev libvo-amrwbenc-dev libvorbis-dev libxml2-dev libxslt-dev libxslt1.1 libzvbi-dev libswscale-dev
 make nasm openssl perl pkg-config python-software-properties rtmpdump software-properties-common tar texi2html texinfo unzip zip zlibc zlib1g-dev)
#libswscale-dev
 echo "You need non-free enabled for apt"

# Remove any existing packages:
show_progress "Doing a system upgrade and removing ffmpeg files if there any."
$APTCMD -f install >> /dev/null
$APTCMD upgrade >> /dev/null

### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
# Function for Install necessary packages
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
function run_install(){
	echo "installing ${installpackage[@]}" 2>&1 >> /dev/null;
	$APTCMD install ${installpackage[@]} >> /dev/null;
}
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
# Function for Remove conflicting packages
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###

function isinstalled { if dpkg -s "$@" 2>&1 > /dev/null; then echo "Uninstalling $@"&& $APTCMD remove $@ >> /dev/null ; else false ; fi }

### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###

### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
# Remove conflicting packages
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
$APTCMD autoremove
for package in ${removepackage[@]}; do if isinstalled "$package"; then echo "$package package found. will be removed" 2>&1 > /dev/null; else echo "$package package not found, skipping" 2>&1 > /dev/null; fi done

### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
### Install necessary packages
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
## Run the run_install function if any of the libraries are missing
dpkg -s "${installpackage[@]}" 2>&1 > /dev/null || run_install



if [ "$DEBIAN_VERSION" == "wheezy" ]; then
	echo "deb http://www.deb-multimedia.org wheezy main" >> /etc/apt/sources.list;
	$APTCMD install deb-multimedia-keyring;
	apt-get update;
	$APTCMD install gnutls-dev libfaac-dev libsoxr-dev libcrypto++9 libpcrecpp0 libpostproc52;
fi
if [ "$DEBIAN_VERSION" == "jessie" ]; then
	$APTCMD install gnutls-dev libfaac-dev libsoxr-dev libcrypto++9 libpcrecpp0 libpostproc52;
fi
if [ "$DEBIAN_VERSION" == "trusty" ]; then
	$APTCMD install libgnutls-dev libfaac-dev libsoxr-dev libcrypto++9 libpcrecpp0 libpostproc52; 
fi
if [ "$DEBIAN_VERSION" == "xenial" ]; then
	$APTCMD install gnutls-dev libcrypto++9v5 libpcrecpp0v5 libpostproc-dev libfaac-dev libsoxr-dev;
fi



### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###



### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### ### ###
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### ### ###

#Lets calculate how much time is spent
# We don't need this apt-get dist-upgrade process to be counted. So, the timer starts here.
START=$(date +%s) 
echo $START > /tmp/Time.Vars


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
show_progress "Creating directories"
mkdir -p $ff_dir
mkdir -p $ngx_dir
mkdir -p $ff_bld_dir
mkdir -p $ngx_bld_dir
mkdir -p $mgk_bld_dir
mkdir -p $mgk_dir


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*  START FFPMEG
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* 
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* 

show_progress "Start FFMpeg Installation"
show_progress "Depending on your CPU this might take a long while"



### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### First, install yasm
show_progress "Installing yasm"
	cd $ff_dir
	if [ -d "$ff_dir/yasm" ]; then rm -rf $ff_dir/yasm/ ; fi
	git clone git://github.com/yasm/yasm.git
	cd yasm
	./autogen.sh x86_64 i386 amd64
	# ./configure x86_64 i386 amd64
	make -j$CORES
	checkinstall --pkgname=yasm --pkgversion="1.3.0" --backup=no --deldoc=yes --fstrans=no --default --pakdir=$ff_bld_dir


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### OpenSSL
show_progress "Installing OpenSSL"
	cd $ff_dir/
	if [ -d "$ff_dir/openssl" ]; then rm -rf $ff_dir/openssl/ ; fi
	#git clone https://github.com/openssl/openssl.git
	wget --no-check-certificate https://github.com/openssl/openssl/archive/OpenSSL_1_0_2h.tar.gz -O openssl.tar.gz
	tar xvfz openssl.tar.gz
	mv openssl-OpenSSL* openssl
	cd openssl

	config_ssl(){
	# Get GCC version.
	gccver=$(gcc -dumpversion | sed -e 's/\.\([0-9][0-9]\)/\1/g' -e 's/\.\([0-9]\)/.\1/g' -e 's/^[0-9]\{3,4\}$/&00/')
	#CC="ccache gcc-4.9 -Wl,-Bsymbolic -fPic"
	# Enable enable-ec_nistp_64_gcc_128 if gcc supports it.
	if strings /usr/lib/gcc/x86_64-linux-gnu/$gccver/cc1 | grep -q "__uint128_t" ; then
	 ./config --prefix="$prf_dir" --openssldir=/etc/ssl --libdir=lib shared \
	zlib-dynamic zlib sctp enable-camellia enable-seed enable-tlsext \
	enable-rfc3779 enable-cms enable-md2 no-mdc2 no-rc5 no-idea \
	enable-ec_nistp_64_gcc_128 -fPIC ;
	show_progress "Enabled enable-ec_nistp_64_gcc_128 for OpenSSL" ;
	else 
	 ./config --prefix="$prf_dir" --openssldir=/etc/ssl --libdir=lib no-shared \
	zlib-dynamic zlib sctp enable-camellia enable-seed enable-tlsext \
	enable-rfc3779 enable-cms enable-md2 no-mdc2 no-rc5 no-idea ;
	fi
	}
	config_ssl
	make depend &&
	make -j$CORES &&
	make install &&
	checkinstall --pkgname="openssl" --pkgversion="1.0.2h" --backup=no \
	 --deldoc=no --fstrans=no --default --install=no --pakdir=$ff_bld_dir
	#dpkg -i --force-all $ff_bld_dir/openssl_*.deb
	#ln -s $prf_dir/lib/x86_64-linux-gnu/libssl.so.1.0.0 $prf_dir/lib/x86_64-linux-gnu/libssl.so




### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libx264
show_progress "Installing libx264"
		# They have git but I had connectivity errors with them so..
		# git clone --depth 1 git://git.videolan.org/x264
	cd $ff_dir
	git clone --depth 1 git://git.videolan.org/x264.git x264 
	cd x264 
	./configure --prefix="$prf_dir" --bindir="$prf_dir/bin" --bit-depth=10 --disable-static --enable-shared --enable-strip --disable-lavf
	make -j$CORES
	make install
	checkinstall --pkgname=libx264 --pkgversion="3:$(./version.sh | \
		awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
	 --fstrans=no --default --pakdir=$ff_bld_dir --install=no


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libx265
show_progress "Installing libx265"
	cd $ff_dir
		#wget --no-check-certificate https://bitbucket.org/multicoreware/x265/downloads/x265_1.9.tar.gz
		#tar xvfz x265_1.9.tar.gz
	git clone https://github.com/videolan/x265.git
	cd x265*
	cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$prf_dir" -DENABLE_SHARED:bool=off -DENABLE_SHARED=ON -DENABLE_STATIC=OFF  -DHIGH_BIT_DEPTH:BOOL=ON  source
	make -j$CORES
	checkinstall --pkgname=libx265-dev --pkgversion=1.9 --backup=no --deldoc=yes \
	 --fstrans=no --default --pakdir=$ff_bld_dir


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libfdk-aac-dev
show_progress "	Installing libfdk-aac"
	cd $ff_dir
	    if [ -d "$ff_dir/fdk-aac" ]; then
	       rm -rf $ff_dir/fdk-aac/
	    fi
	git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
	cd fdk-aac
	./autogen.sh
	autoreconf -fiv
	./configure --prefix="$prf_dir" --enable-shared
	make
	checkinstall --pkgname=libfdk-aac-dev --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no \
	  --deldoc=yes --fstrans=no --default --pakdir=$ff_bld_dir


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libopus
show_progress "Installing libopus"
	cd $ff_dir
		if [ -d "$ff_dir/opus" ]; then rm -rf $ff_dir/opus/ ; fi
	git clone --depth 1 https://github.com/xiph/opus.git
	cd opus
	./autogen.sh
	./configure --prefix="$prf_dir" --enable-shared
	make
	checkinstall --pkgname=libopus --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no \
	 --deldoc=yes --fstrans=no --default --pakdir=$ff_bld_dir


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libmp3lame
show_progress "Installing libmp3lame"
		# doesn't install in ubuntu, ends up with an error
	cd $ff_dir
		#wget --no-check-certificate http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
		#tar xzvf lame-3.99.5.tar.gz
	wget --no-check-certificate https://raw.githubusercontent.com/nomadturk/openresty-install/master/lame-3.99.5.tar.gz
	tar xzvf lame-3.99.5.tar.gz
	cd lame*
	./configure --prefix="$prf_dir" --enable-nasm --enable-shared --enable-mp3x --enable-mp3rtp
	make -j$CORES
	make install
	checkinstall --fstrans=no --backup=no --default --deldoc=yes --pkgversion="3.99.5" --pkgname=libmp3lame \
	 --pakdir=$ff_bld_dir --install=no


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libogg
#show_progress "Installing libogg"
#	cd $ff_dir
#	wget --no-check-certificate http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
#	tar xzvf libogg-1.3.2.tar.gz
#	cd libogg*
#	./configure --prefix="$prf_dir" --enable-shared
#	make
#	make install
#	checkinstall --fstrans=no --backup=no --default --deldoc=yes --pkgversion="1.3.2" --pkgname=libogg --pakdir=$ff_bld_dir --install=no


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libxvidcore
show_progress "Installing libxvidcore"
		# $APTCMD install libxvidcore-dev libxvidcore4
	cd $ff_dir
	wget --no-check-certificate http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz
	tar xzvf xvidcore-1.3.4.tar.gz
	cd xvidcore*
	cd build/generic
	sed -i 's/^LN_S=@LN_S@/& -f -v/' platform.inc.in
	./configure --prefix="$prf_dir" --disable-assembly
	make -j$CORES
	sed -i '/libdir.*STATIC_LIB/ s/^/#/' Makefile
	#rm -rf /usr/lib/libxvidcore*
	make install
	checkinstall --fstrans=no --backup=no --default --deldoc=yes --pkgversion="2:1.3.4" --pkgname="libxvidcore-dev" --pakdir=$ff_bld_dir --install=no
	#dpkg -r libxvidcore4
	#rm -rf /usr/lib/libxvidcore*  #--purge libxvidcore4

### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libfribidi
show_progress "Installing libfribidi"
	cd $ff_dir
	wget --no-check-certificate http://fribidi.org/download/fribidi-0.19.7.tar.bz2
	tar xjvf fribidi-0.19.7.tar.bz2
	cd fribidi*
	./configure --prefix="$prf_dir" --enable-shared #--enable-static
	make -j$CORES
	make install
	checkinstall --fstrans=no --backup=no --default --deldoc=yes --pkgversion="0.19.7" --pkgname="libfribidi" --pakdir=$ff_bld_dir --install=no


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libexpat
show_progress "Installing libexpat"
	cd $ff_dir
	wget --no-check-certificate 'https://raw.githubusercontent.com/nomadturk/openresty-install/master/expat-2.1.1.tar.bz2' -O expat.tar.bz2
	tar xjf expat.tar.bz2
	cd expat*
	./configure --prefix="$prf_dir" --enable-shared #--enable-static
	make -j$CORES
	make install
	checkinstall --fstrans=no --backup=no --default --deldoc=yes --pkgversion="2.1.0" --pkgname="libexpat" --pakdir=$ff_bld_dir --install=no


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### librtmp
show_progress "Installing librtmp"
# Let's install what's needed...
# 	cd $ff_dir
#	if [ -d "$ff_dir/rtmpdump" ]; then
#		rm -rf $ff_dir/rtmpdump/
#	fi
# 	git clone git://git.ffmpeg.org/rtmpdump
# 	cd rtmpdump
# 	make SYS=posix
# 	checkinstall --pkgname=rtmpdump --pkgversion="2:$(date +%Y%m%d%H%M)-git" --backup=no \
#	 --deldoc=yes --fstrans=no --default --pakdir=$ff_bld_dir
# 	export LD_LIBRARY_PATH=$prf_dir/local/lib/


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libvpx
show_progress "Installing libvpx"
$APTCMD install libvpx-dev
#	cd $ff_dir
#	    if [ -d "$ff_dir/libvpx" ]; then rm -rf $ff_dir/libvpx/ ; fi
#	git clone https://chromium.googlesource.com/webm/libvpx
#	cd libvpx
#	#wget --no-check-certificate http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.4.0.tar.bz2
#	#tar xjf libvpx-1.4.0.tar.bz2
#	#cd libvpx-1.4.0

#	sed -i 's/cp -p/cp/' build/make/Makefile &&

#	mkdir libvpx-build   &&
#	cd    libvpx-build

#	../configure --prefix="$prf_dir"    \
#		--enable-shared  \
#		--disable-static  \
#	 	--disable-examples \
#		--disable-unit-tests \
#		--enable-vp8 \
#		--enable-vp9 \
#		--enable-webm-io \
#		--enable-pic

#	make -j$CORES
#	make install
#	checkinstall --pkgname=libvpx-dev --pkgversion="1.4.0" --backup=no \
# --deldoc=yes --fstrans=no --default --pakdir=$ff_bld_dir --install=yes


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libzimg-dev
show_progress "Installing libzimg-dev"
	cd $ff_dir
	git clone https://github.com/sekrit-twc/zimg.git
	cd zimg 
	./autogen.sh
	autoconf
	./configure --prefix="$prf_dir"
	make -j$CORES
	checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgversion="2.0.4" --pkgname="libzimg-dev" --pakdir=$ff_bld_dir


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libmfx-dev
show_progress "Installing libmfx-dev"
		#$APTCMD install libva-dev 
	cd $ff_dir
	git clone https://github.com/lu-zero/mfx_dispatch.git
	cd mfx_dispatch
	autoreconf -i
	./configure --prefix="$prf_dir" --with-pic ldflags="-fPIC"
	make -j$CORES
	checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgname="libmfx-dev" --pakdir=$ff_bld_dir


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libwebp-dev
show_progress "Installing libwebp-dev"
	cd $ff_dir
		#wget --no-check-certificate http://downloads.webmproject.org/releases/webp/libwebp-0.4.2.tar.gz
		#tar -xvzf libwebp-0.4.2.tar.gz
	git clone https://github.com/webmproject/libwebp.git
	cd libwebp
	./autogen.sh
	./configure --prefix="$prf_dir"
	make -j$CORES
	checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgname="libwebp-dev" --pkgversion="0.5.0" --pakdir=$ff_bld_dir


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libutvideo
show_progress "Installing libutvideo"
	cd $ff_dir
	git clone https://github.com/qyot27/libutvideo.git
	cd libutvideo
	./configure --prefix="$prf_dir" --enable-shared --disable-static --enable-pic
	make -j$CORES
	checkinstall --pkgname=libutvideo --pkgversion="3:$(./version.sh | \awk -F'[" ]' '/POINT/{print $4"+git"$5}')" \
 --backup=no --deldoc=yes --fstrans=no --default --pakdir=$ff_bld_dir


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libvstab
show_progress "Installing libvstab"
	cd $ff_dir
	git clone https://github.com/georgmartius/vid.stab.git
	cd vid.stab/
	cmake .
	make -j$CORES
	make install
	checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgname="libvidstab" --pkgversion="1.0" --pakdir=$ff_bld_dir --install=no


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libass
show_progress "Installing libass"
	cd $ff_dir
	git clone https://github.com/libass/libass.git
	cd libass
	./autogen.sh
	./configure --prefix="$prf_dir" --disable-static --enable-shared ldflags="-fPIC -shared" 
	make -j$CORES
	checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgname="libass" --pkgversion="0.13.2" --pakdir=$ff_bld_dir



### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libbluray
### show_progress "Installing libbluray"
### $APTCMD install ant
### cd $ff_dir
### git clone --depth 1 git://git.videolan.org/libbluray.git libbluray
### cd libbluray
### ./bootstrap
### ./configure --prefix="$prf_dir"
### make -j$CORES
### make install



### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### makemkv
###show_progress "Installing makemkv"
### $APTCMD install libgl1-mesa-dev libqt4-dev
### cd $ff_dir
### wget --no-check-certificate http://www.makemkv.com/download/makemkv-oss-1.9.10.tar.gz
### wget --no-check-certificate http://www.makemkv.com/download/makemkv-bin-1.9.10.tar.gz
### tar -xzf makemkv-oss-1.9.10.tar.gz
### tar -xzf makemkv-bin-1.9.10.tar.gz
### cd makemkv-oss-1.9.10
### ./configure --disable-gui
### make -j$CORES
### make install
###
### cd $ff_dir/makemkv-bin-1.9.10
### mkdir tmp
### echo 'accepted' > tmp/eula_accepted
### make
### make install




### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libwavpack
show_progress "Installing libwavpack"
cd $ff_dir
wget --no-check-certificate http://www.wavpack.com/wavpack-4.80.0.tar.bz2
tar xvf wavpack-4.80.0.tar.bz2 
cd wavpack-4.80.0/
./configure --disable-asm --prefix="$prf_dir" --enable-man --enable-tests
make -j$CORES
make install
checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgname="libwavpack" --pkgversion="4.80.0" --pakdir=$ff_bld_dir --install=no

### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libkvazaar
show_progress "Installing libkvazaar"
cd $ff_dir
git clone https://github.com/ultravideo/kvazaar.git
cd kvazaar/
./autogen.sh
./configure --disable-werror --disable-asm --prefix="$prf_dir"
make -j$CORES
make install
checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgname="libkvazaar" --pkgversion="0.8.3" --pakdir=$ff_bld_dir --install=no


#dpkg -r --force-depends libavformat-dev libavfilter-dev libavresample-dev libavutil-dev libavcodec-dev
#apt-get remove libswscale-dev libavutil-dev libavresample-dev


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libav
show_progress "Installing libav"
cd $ff_dir
	# Git release tends to cause problems with nginx upstream fair module.
	# git clone --depth 1 git://git.libav.org/libav.git libav
	wget --no-check-certificate https://libav.org/releases/libav-11.6.tar.gz
	tar xvfz libav-11.6.tar.gz
	mv libav-11.6 libav
cd libav
ldconfig
# We need this patch to due to a bug in compiling. #4956 libvpx has removed reference/entropy controls and ffmpeg won't build.
#wget --no-check-certificate https://raw.githubusercontent.com/nomadturk/openresty-install/master/libvpx-1.5.0.patch
#patch libavcodec/libvpxenc.c libvpx-1.5.0.patch
./configure \
 --cc="ccache gcc" \
 --extra-cflags="-DLIBTWOLAME_STATIC -g -O2 -Wl,-z,relro -fPIC -Wformat -Werror=format-security -I/usr/include"\
 --enable-shared \
 --disable-debug \
 --disable-encoder=libschroedinger \
 --enable-avfilter \
 --enable-avresample \
 --enable-bzlib \
 --enable-decoder=vp9 \
 --enable-filter=movie \
 --enable-frei0r \
 --enable-gpl \
 --enable-gray \
 --enable-libdc1394 \
 --enable-libfaac \
 --enable-libfdk-aac \
 --enable-libfreetype \
 --enable-libgsm \
 --enable-libmp3lame \
 --enable-libopencore-amrnb \
 --enable-libopencore-amrwb \
 --enable-libopenjpeg \
 --enable-libopus \
 --enable-libpulse \
 --enable-libschroedinger \
 --enable-libspeex \
 --enable-libtheora \
 --enable-libtwolame \
 --enable-libvo-amrwbenc \
 --enable-libvorbis \
 --enable-libvpx \
 --enable-libwebp \
 --enable-libx264 \
 --enable-libx265 \
 --enable-libxvid \
 --enable-nonfree \
 --enable-gnutls \
 --enable-pic \
 --enable-protocol=file \
 --enable-pthreads \
 --enable-runtime-cpudetect \
 --enable-swscale \
 --enable-vaapi \
 --enable-version3 \
 --enable-x11grab \
 --enable-zlib \
 --enable-librtmp \
 --enable-openssl \
 --enable-libvo-aacenc \
 --extra-libs="-lstdc++ -llzma -lvpx -lbz2 -lc -ldl -lz -lxvidcore -lx264 -logg -lfdk-aac -lwebp -lopus -lfreetype -lrtmp -lfaac -lgsm -lopenjpeg -lmp3lame" \
 --extra-ldflags="-Wall -L/usr/lib" \
 --prefix="$prf_dir" \
 --enable-openssl \
 --enable-libwavpack 
 #--enable-libmfx \
 #--enable-libkvazaar

make -j$CORES
make install
#checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgname="libav" \
# --pkgversion="11.$(./version.sh)" --pakdir=$ff_bld_dir --install=no
#echo "$prf_dir/local/bin"> /etc/ld.so.conf.d/libav.conf
#ldconfig


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### Rebuild x264 with libav
cd $ff_dir/x264
./configure --prefix="$prf_dir" --bindir="$prf_dir/bin" --bit-depth=10 --enable-pic --enable-shared --enable-strip
make -j$CORES
make install
	checkinstall --pkgname=libx264-dev --pkgversion="3:$(./version.sh | \
		awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
	 --fstrans=no --default --pakdir=$ff_bld_dir



### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### libffms2
show_progress "Installing libffms2"
        cd $ff_dir
        git clone https://github.com/FFMS/ffms2.git
        cd ffms2
        ./autogen.sh
                ./configure --prefix="$prf_dir" --disable-static
        make -j$CORES
        make install
        checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgname="libffms2" --pkgversion="2:$(./version.sh)" --pakdir=$ff_bld_dir --install=no



### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### Finally, ffmpeg
show_progress "Now... Using all above, compiling FFMpeg"
cd $ff_dir
	if [ -d "$ff_dir/FFmpeg" ]; then rm -rf $ff_dir/FFmpeg/ ; fi
git clone https://github.com/FFmpeg/FFmpeg.git
cd FFmpeg

sed -i 's/-lflite" /-lflite -lasound" /' configure

./configure \
--cc="ccache gcc" \
--prefix=/usr \
--bindir=/usr/bin \
--libdir=/usr/lib/x86_64-linux-gnu \
--shlibdir=/usr/lib/x86_64-linux-gnu \
--docdir=/usr/share/doc/ffmpeg \
--extra-libs="-lstdc++ -llzma -lvpx -lbz2 -lc -ldl -lz -lxvidcore -lx264 -logg -lfdk-aac -lwebp -lopus -lfreetype -lrtmp -lfaac -lgsm -lopenjpeg -lmp3lame -lffms2 -lkvazaar" \
--extra-ldflags="-Wall" \
--extra-cflags="-DLIBTWOLAME_STATIC -g -O2 -Wl,-z,relro -Wformat -Werror=format-security" \
--enable-shared \
--enable-avfilter \
--enable-avresample \
--enable-bzlib \
--enable-decoder=vp9 \
--enable-ffplay \
--enable-ffserver \
--enable-filter=movie \
--enable-fontconfig \
--enable-frei0r \
--enable-gpl \
--enable-gray \
--enable-libass \
--enable-libbluray \
--enable-libcaca \
--enable-libdc1394 \
--enable-libfaac \
--enable-libfdk-aac \
--enable-libfreetype \
--enable-libfribidi \
--enable-libgsm \
--enable-libmfx \
--enable-libmp3lame \
--enable-libopencore-amrnb \
--enable-libopencore-amrwb \
--enable-libopenjpeg \
--enable-libopus \
--enable-libpulse \
--enable-libschroedinger \
--enable-libsoxr \
--enable-libspeex \
--enable-libtheora \
--enable-libtwolame \
--enable-libutvideo \
--enable-libv4l2 \
--enable-libvidstab \
--enable-libvo-amrwbenc \
--enable-libvorbis \
--enable-libvpx \
--enable-libwebp \
--enable-libx264 \
--enable-libx265 \
--enable-libxvid \
--enable-libzimg \
--enable-libzvbi \
--enable-nonfree \
--enable-openal \
--enable-gnutls \
--enable-pic \
--enable-postproc \
--enable-protocol=file \
--enable-pthreads \
--enable-runtime-cpudetect \
--enable-swscale \
--enable-vaapi \
--enable-version3 \
--enable-x11grab \
--enable-zlib \
--enable-librtmp \
--enable-openssl \
--enable-libwavpack \
--enable-libkvazaar \
--disable-debug \
--disable-encoder=libschroedinger \
--disable-altivec \
--disable-podpages \
--disable-htmlpages \
--disable-mipsdspr2 \
--disable-mips32r2 \
--disable-vda

make -j$CORES

gcc tools/qt-faststart.c -o tools/qt-faststart

checkinstall --pkgname=ffmpeg --pkgversion="7:$(date +%Y%m%d%H%M)-git" --backup=no \
 --deldoc=yes --fstrans=no --default --pakdir=$ff_bld_dir
hash -r

	### Building FFmpeg Test Suite
	## https://ffmpeg.org/fate.html

	# make fate-rsync SAMPLES=fate-suite/
	# make fate       SAMPLES=fate-suite/
	# ./configure --samples=fate-suite/
	# make fate-rsync
	# make fate

### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### END OF FFPMEG
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###










### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### IMAGEMAGICK
show_progress "Installing ImageMagick"


#show_progress "Installing jpegsrc"
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### JPEGSRC
#cd $mgk_dir
#wget --no-check-certificate http://www.ijg.org/files/jpegsrc.v9a.tar.gz
#tar -xzvf jpegsrc.v9a.tar.gz
#cd jpeg-9a/
#./configure  --enable-shared
#make
#make install
# checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgname="jpegsrc --pkgversion="9a" --pakdir=$mgk_bld_dir
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### END OF JPEGSRC


### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### LINUNWIND & GPERFTOOLS
show_progress "Installing libunwind"
	mkdir -p $mgk_dir/gperftools
	cd $mgk_dir/gperftools
		#wget -c http://ftp.twaren.net/Unix/NonGNU/libunwind/libunwind-1.1.tar.gz
		#tar zxvf libunwind-1.1.tar.gz
	if [ -d "$mgk_dir/gperftools/libunwind" ]; then rm -rf $mgk_dir/gperftools/libunwind/ ; fi
	git clone http://git.savannah.gnu.org/r/libunwind.git
	cd libunwind
	./autogen.sh
	./configure CFLAGS=-U_FORTIFY_SOURCE
	make -j$CORES
		#make install
	checkinstall --fstrans=no --backup=no --default --deldoc=no --pkgname="libunwind" --pkgversion="1.1" --pakdir=$mgk_bld_dir

####################
show_progress "Installing gperftools"
cd $mgk_dir/gperftools
#git clone https://code.google.com/p/gperftools-git/
git clone https://github.com/gperftools/gperftools.git
cd gperftools
./autogen.sh
./configure --prefix=$prf_dir/local/gperftools --enable-shared --enable-frame-pointers
make -j$CORES
make install
cp -r $prf_dir/local/gperftools/lib/* $prf_dir/local/lib/


if [ ! -d "/tmp/tcmalloc" ]; then
	mkdir /tmp/tcmalloc
	chmod 0777 /tmp/tcmalloc/
	chown -R www-data:www-data /tmp/tcmalloc
else
	chmod 0777 /tmp/tcmalloc/
	chown -R www-data:www-data /tmp/tcmalloc
fi

show_progress "Installing apt-get additions for gperftools"
$APTCMD install google-perftools libgoogle-perftools-dev
export PPROF_PATH=$prf_dir/local/bin/pprof
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### 


show_progress "Compile ImageMagick, shall we?"
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###  ImageMagick
cd $mgk_dir/
wget -c http://www.imagemagick.org/download/ImageMagick.tar.gz
tar -zxvf ImageMagick.tar.gz
cd ImageMagick*
./configure --prefix=$prf_dir/local/ImageMagick \
 --sysconfdir=/etc \
 --with-modules \
 --with-gslib \
 --with-wmf \
 --with-webp \
 --with-gslib \
 --with-perl=$prf_dir/bin/perl \
 --disable-static
make -j$CORES
checkinstall --fstrans=no --install=no -y --pakdir=$mgk_bld_dir
make install
#cd $mgk_dir/
#rm -rf ImageMagick-*
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### 


show_progress "Now, let's start Nginx installation"

show_progress "Installing pcre"
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### pcre
cd $ngx_dir
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.gz
tar -xvf pcre-8.38.tar.gz
mv pcre-8.38 pcre

show_progress "Installing ngx_pagespeed"
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### ngx_pagespeed
cd $ngx_dir/
NPS_VERSION=1.11.33.2
wget --no-check-certificate https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip -O release-${NPS_VERSION}-beta.zip
unzip release-${NPS_VERSION}-beta.zip
cd ngx_pagespeed-release-${NPS_VERSION}-beta/
show_progress "Installing psol for ngx_pagespeed"
# Can change it with the https one. But it is slower.
wget --no-check-certificate https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
tar -xzvf ${NPS_VERSION}.tar.gz  # extracts to psol/

# Timer reminder
DIFFX=$(( $(date +%s) - $START )) 
echo Up till now it took $(($DIFFX / 60 )) minutes and $(($DIFFX % 60 )) seconds... > /tmp/time.tmp
show_progress_error2 "$(cat /tmp/time.tmp)"

### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### Necessary modules from GitHub
show_progress "Git cloning modules"
cd $ngx_dir/
git clone https://github.com/nbs-system/naxsi.git
cd $ngx_dir/
git clone https://github.com/arut/nginx-dav-ext-module.git
cd $ngx_dir/
git clone https://github.com/slact/nginx_http_push_module.git
cd $ngx_dir/
git clone https://github.com/arut/nginx-rtmp-module.git
cd $ngx_dir/
git clone https://github.com/arut/nginx-dlna-module.git
cd $ngx_dir/
git clone https://github.com/tg123/websockify-nginx-module.git
cd $ngx_dir/
git clone https://github.com/masterzen/nginx-upload-progress-module.git
cd $ngx_dir/
git clone https://github.com/gnosek/nginx-upstream-fair.git
cd $ngx_dir/
git clone https://github.com/wandenberg/nginx-video-thumbextractor-module.git
cd $ngx_dir/
git clone https://github.com/FRiCKLE/ngx_cache_purge.git
cd $ngx_dir/
git clone https://github.com/aperezdc/ngx-fancyindex.git
git clone git://github.com/bpaquet/ngx_http_enhanced_memcached_module.git
git clone https://github.com/alibaba/nginx-http-concat.git
git clone git://github.com/flavioribeiro/nginx-audio-track-for-hls-module.git

git clone https://github.com/bagder/libbrotli
cd libbrotli
./autogen.sh
./configure
make
make install
cd $ngx_dir/
git clone https://github.com/google/ngx_brotli.git

show_progress "Last... Getting, compiling nginx, doing some tweaks etc. Be patient, will you!"
cd $ngx_dir/

if [ "$LINUX_ARCH" != "x86_64" ] && [ "$LINUX_ARCH" != "i386" ] && [ "$LINUX_ARCH" != "i486" ] && [ "$LINUX_ARCH" != "amd64" ] && [ "$LINUX_ARCH" != "x86" ]; then
	#Ubuntu
	show_progress_error "Warning, Openresty can not be compiled with pcre-jit module on PowerPC, replacing it with Nginx!"
	show_progress_error "Also ngx_pagespeed won't compile on ppc architecture either. So skipping it..."

#the following headers-more and echo modules doesn't compile with openresty
git clone https://github.com/openresty/headers-more-nginx-module.git
git clone https://github.com/openresty/echo-nginx-module.git


wget --no-check-certificate http://nginx.org/download/nginx-1.9.7.tar.gz
tar -xvzf nginx-1.9.7.tar.gz
cd nginx-1.9.7

./configure \
--prefix=$prf_dir/local/nginx  \
--sbin-path=$prf_dir/sbin/nginx \
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
--add-module=$ngx_dir/naxsi/naxsi_src \
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
--with-sha1=$prf_dir/include/openssl \
--with-md5=$prf_dir/include/openssl \
--user=www-data \
--group=www-data \
--with-http_stub_status_module \
--without-mail_pop3_module \
--without-mail_imap_module \
--without-mail_smtp_module \
--with-http_secure_link_module \
--with-http_addition_module \
--with-http_geoip_module  \
--with-http_perl_module \
--with-http_random_index_module \
--with-google_perftools_module \
--with-http_gunzip_module \
--with-http_v2_module \
--with-file-aio \
--with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
--with-ld-opt='-Wl,-z,relro -Wl,--as-needed' \
--with-openssl=$ngx_dir/openssl \
--with-pcre=$ngx_dir/pcre \
--add-module=$ngx_dir/nginx-upload-progress-module \
--add-module=$ngx_dir/ngx_pagespeed-release-1.11.33.2-beta \
--add-module=$ngx_dir/nginx_http_push_module \
--add-module=$ngx_dir/ngx-fancyindex \
--add-module=$ngx_dir/nginx-dav-ext-module \
--add-module=$ngx_dir/ngx_cache_purge \
--add-module=$ngx_dir/nginx-rtmp-module \
--add-module=$ngx_dir/nginx-video-thumbextractor-module \
--add-module=$ngx_dir/websockify-nginx-module \
--add-module=$ngx_dir/headers-more-nginx-module \
--add-module=$ngx_dir/echo-nginx-module \
--add-module=$ngx_dir/ngx_brotli \
--add-module=$ngx_dir/nginx-upstream-fair -j$CORES
else
wget --no-check-certificate https://openresty.org/download/openresty-1.9.7.4.tar.gz
tar -xvzf openresty-1.9.7.4.tar.gz
git clone https://github.com/openssl/openssl.git
cd openresty-1.9.7.4
CC="ccache clang" CXX="ccache clang++" CFLAGS="-Wno-c++11-extensions" ./configure \
--prefix=$prf_dir/share/nginx \
--sbin-path=$prf_dir/sbin/nginx \
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
--add-module=$ngx_dir/naxsi/naxsi_src \
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
--with-sha1=$prf_dir/include/openssl \
--with-md5=$prf_dir/include/openssl \
--user=www-data \
--group=www-data \
--with-mail \
--with-mail_ssl_module \
--with-http_stub_status_module \
--with-http_secure_link_module \
--with-http_addition_module \
--with-http_geoip_module  \
--with-http_perl_module \
--with-http_random_index_module \
--with-google_perftools_module \
--with-http_gunzip_module \
--with-http_v2_module \
--with-file-aio \
--with-cc-opt='-static-libgcc -march=native -mtune=native -D_GLIBCXX_USE_CXX11_ABI=0 -pipe -m64  -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wno-deprecated-declarations -Wno-unused-parameter -Wno-unused-const-variable -Wno-conditional-uninitialized -Wno-mismatched-tags -Wno-c++11-extensions -Wno-sometimes-uninitialized -Wno-parentheses-equality -Wno-tautological-compare -Wno-self-assign' \
--with-ld-opt='-Wl,-z,relro -Wl,--as-needed -lrt -ljemalloc -lstdc++' \
--with-openssl=$ff_dir/openssl \
--with-openssl-opt=enable-tlsext \
--with-pcre=$ngx_dir/pcre \
--with-stream \
--with-stream_ssl_module \
--add-module=$ngx_dir/nginx-upload-progress-module \
--add-module=$ngx_dir/nginx_http_push_module \
--add-module=$ngx_dir/ngx-fancyindex \
--add-module=$ngx_dir/nginx-dav-ext-module \
--add-module=$ngx_dir/ngx_cache_purge \
--add-module=$ngx_dir/nginx-dlna-module \
--add-module=$ngx_dir/nginx-rtmp-module \
--add-module=$ngx_dir/nginx-video-thumbextractor-module \
--add-module=$ngx_dir/websockify-nginx-module \
--add-module=$ngx_dir/nginx-upstream-fair \
--add-module=$ngx_dir/nginx-audio-track-for-hls-module \
--add-module=$ngx_dir/ngx_brotli \
--add-module=$ngx_dir/nginx-http-concat \
--add-module=$ngx_dir/ngx_http_enhanced_memcached_module \
--add-module=$ngx_dir/ngx_pagespeed-release-1.11.33.2-beta  -j$CORES
fi

make -j$CORES
#make install
# mkdir -p /var/cache/nginx/{client,scgi,uwsgi,fastcgi,proxy}
# Create and change ownership some folders
	for dir in /var/cache/nginx/  /var/cache/nginx/client /var/cache/nginx/scgi /var/cache/nginx/uwsgi /var/cache/nginx/fastcgi /var/cache/nginx/proxy /var/ngx_pagespeed_cache /var/log/nginx /var/log/pagespeed $prf_dir/local/nginx/nginx/logs /var/ngx_pagespeed_cache /var/log/pagespeed /etc/nginx/sites-available /etc/nginx/sites-enabled
	do
	if [ ! -d "$dir" ]; then
	mkdir -p $dir ;
	chown -R  www-data:www-data $dir ;
	else
	chown -R  www-data:www-data $dir ;
	fi
	done

# Now let's build nginx deb file. 
show_progress "Installing Nginx"
cd $ngx_dir/openresty-1.9.7.4
checkinstall  --fstrans=no --pkgname=nginx --pkgversion="1.9.7.4" -y --pakdir=$ngx_bld_dir \
--provides="nginx" --requires="libc6, libpcre3, zlib1g" --strip=yes --stripso=yes --backup=yes -y --install=no

show_progress "Creating Nginx startup script"
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### Add nginx to /etc/init.d for
#wget -O nginx.init https://raw.githubusercontent.com/Fleshgrinder/nginx-sysvinit-script/master/nginx
#mv nginx.init /etc/init.d/nginx
#chmod +x /etc/init.d/nginx
#Add it to system startup
#update-rc.d -f nginx defaults 

#The script below does the above steps for nginx init script
git clone https://github.com/Fleshgrinder/nginx-sysvinit-script.git
cd nginx-sysvinit-script
make


#alternately
#chkconfig —add nginx
#chkconfig nginx on
# Let's make sure naxsi library is in nginx directory
cp $ngx_dir/naxsi/naxsi_config/naxsi_core.rules /etc/nginx



cd $ngx_dir/
git clone https://github.com/nomadturk/nginx-conf.git
cd nginx-conf
mv -f * /etc/nginx/
mv -f sites-enabled/* /etc/nginx/sites-enabled/
cd $ngx_dir/
rm -r $ngx_dir/nginx-conf


show_progress "Uh oh... We forgot installing mysql. So... MariaDB it is!"
cd $ngx_dir/
## MariaDB
if [ "$LINUX_ARCH" != "x86_64" ] && [ "$LINUX_ARCH" != "i386" ] && [ "$LINUX_ARCH" != "i486" ] && [ "$LINUX_ARCH" != "amd64" ] && [ "$LINUX_ARCH" != "x86" ]; then
	show_progress_error "Can't install MariaDB to this system using external repos. Let's try if your own repos have anything to offer"
	$APTCMD install mariadb-server
	# End timer, we do not want mysql password screen to mess up with our resulting time now, do we?
	END=$(date +%s)
	echo $END >> /tmp/Time.Vars
else
	$APTCMD install python-software-properties
	if [ "$LINUX_DISTRO"== "Debian" ]; then
	#Debian 
		show_progress "Installing MariaDB"
		$APTCMD install mariadb-server
	elif [ "$LINUX_DISTRO"== "Ubuntu" ] && [ "$LINUX_DISTRO" != "LinuxMint" ]; then
		#Ubuntu
		apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db

		show_progress "Adding MariaDB Trusty Repository"
		add-apt-repository 'deb http://ams2.mirrors.digitalocean.com/mariadb/repo/5.5/ubuntu trusty main'
		apt-get update
		$APTCMD install mariadb-server
	fi
	# End timer, we do not want mysql password screen to mess up with our resulting time now, do we?
	END=$(date +%s)
	echo $END >> /tmp/Time.Vars
fi
# mariadb-client mariadb-common
# Start timer again.
START2=$(date +%s)
echo $START2 >> /tmp/Time.Vars


## DotDeb Php repository for Debian
if [ "$LINUX_DISTRO"== "Debian" ]; then
	#Debian 
	show_progress "Adding DotDeb Php Repository"
	add-apt-repository 'deb http://packages.dotdeb.org jessie all'
	add-apt-repository 'deb-src http://packages.dotdeb.org jessie all'
	wget --no-check-certificate http://www.dotdeb.org/dotdeb.gpg
	apt-key add dotdeb.gpg
fi
 

apt-get update
$APTCMD install php5-xcache
$APTCMD install php5-fpm php5-mysql memcached php5-memcache php5-memcached
$APTCMD install php5-mcrypt php5-cli php5-curl php5-gd php5-json php5-sqlite php5-pspell php5-readline php5-recode php5-xmlrpc php5-xsl php5-intl php5-imagick php5-tidy

show_progress "Time for a bit of tweaks"
if [ -f "/etc/php5/fpm/php.ini" ]; then
	sed -i "s/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
fi
if [ -f "/etc/php5/fpm/pool.d/www.conf" ]; then
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
if [ -f "/etc/nginx/h5bp/location/expires.conf" ]; then
	sed -i "s/^  access_log logs\/static.log/  access_log \/var\/log\/nginx\/static.log/" /etc/nginx/h5bp/location/expires.conf
fi


if [ ! -d "/var/www" ]; then
        mkdir -p /var/www
        if [ -d "$prf_dir/local/nginx/nginx/html/" ]; then
                show_progress "Creating /var/www"
                cp $prf_dir/local/nginx/nginx/html/* /var/www/
        elif [ -d "$prf_dir/local/nginx/html" ]; then
                show_progress "Creating /var/www"
                cp $prf_dir/local/nginx/html/* /var/www/
        fi
fi


 
show_progress "Starting Nginx"
service nginx start


show_progress "Add nginx to logrotate"
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### Let's add nginx to logrotate and do an update
cd$ngx_dir/
echo " /var/log/nginx/*.log {">> nginx.logrotate
echo "     daily">> nginx.logrotate
echo "     missingok">> nginx.logrotate
echo "     rotate 52">> nginx.logrotate
echo "     compress">> nginx.logrotate
echo "     delaycompress">> nginx.logrotate
echo "     notifempty">> nginx.logrotate
echo "     create 640 www-data adm">> nginx.logrotate
echo "     sharedscripts">> nginx.logrotate
echo "     postrotate">> nginx.logrotate
echo "     [ ! -f /var/run/nginx.pid ] || kill -USR1 `cat /var/run/nginx.pid`">> nginx.logrotate
echo "     endscript">> nginx.logrotate
echo "}"> nginx.logrotate
if [ -f "/etc/logrotate.d/nginx" ]; then
        rm /etc/logrotate.d/nginx
fi
mv nginx.logrotate /etc/logrotate.d/nginx
chmod 0644 /etc/logrotate.d/nginx
logrotate -f -v /etc/logrotate.d/nginx
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ###

show_progress "Done and done... Enjoy it. All is ready to go."

END2=$(date +%s)
echo $END2>> /tmp/Time.Vars
DIFF1=$(( END - START ))
DIFF2=$(( END2 - START2 ))
DIFF=$(( DIFF1 + DIFF2 ))
echo Hurray! In mere $(($DIFF / 60 )) minutes and $(($DIFF % 60 )) seconds all is finished! Congrats dude... >>Time.Output
show_progress_info "$(cat Time.Output)"
show_progress_info "This is of course excluding the time spent at MariaDB Password input page."
#echo "Hurray! In mere "$(($DIFF / 3600 ))""hours "$(($DIFF / 60 ))"minutes and "$(($DIFF % 60 ))"seconds all is finished! Congrats dude...">>Time.Output
read -s -n 1 any_key | show_progress_info "Press a key to exit now..."&& wait

# apt-mark hold ffmpeg
apt-mark hold nginx
# apt-mark hold mysql-common

### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### Install Webmin
# wget -O VirtMin.sh http://software.virtualmin.com/gpl/scripts/install.sh
# sed -i '/debdeps=/s/ mysql-/ mariadb-/g' VirtMin.sh
# chmod +x VirtMin.sh
# bash -c "bash VirtMin.sh"
# /etc/init.d/apache2 stop
# update-rc.d apache2 remove
# $APTCMD install webmin-virtualmin-nginx webmin-virtualmin-nginx-ssl
#
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### Install Webmin Themes
# cd $mgk_dir
# wget --no-check-certificate http://theme.winfuture.it/bwtheme.wbt.gz -4
# wget --no-check-certificate https://github.com/qooob/authentic-theme/archive/master.zip
# wget --no-check-certificate http://www.turnkeylinux.org/files/attachments/theme-metal_0.tar
# wget --no-check-certificate http://www.xenlayer.com/xenlayer-theme.wbt.gz
# wget --no-check-certificate http://www.luizlopes.com/virtualmin/finally-theme-0.3.wbt.gz
# tar -xvf theme-metal_0.tar
# unzip master.zip
# tar -xvzf bwtheme.wbt.gz
# tar xvzf xenlayer-theme.wbt.gz
# tar xvzf finally-theme-0.3.wbt.gz
# mv bootstrap/ theme-metal/ authentic-theme-master/ xenlayer-theme/ virtual-server-theme/ $prf_dir/share/webmin/
### ++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++*++* ### Install Webmin Themes End

return &
exit 0
