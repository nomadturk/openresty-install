If the build completes successfuly, this will bethe resulting configuration for your FFmpeg instance:

```
install prefix            /usr
source path               .
C compiler                ccache gcc
C library                 glibc
ARCH                      x86 (generic)
big-endian                no
runtime cpu detection     yes
yasm                      yes
MMX enabled               yes
MMXEXT enabled            yes
3DNow! enabled            yes
3DNow! extended enabled   yes
SSE enabled               yes
SSSE3 enabled             yes
AESNI enabled             yes
AVX enabled               yes
XOP enabled               yes
FMA3 enabled              yes
FMA4 enabled              yes
i686 features enabled     yes
CMOV is fast              yes
EBX available             yes
EBP available             yes
debug symbols             no
strip symbols             yes
optimize for size         no
optimizations             yes
static                    yes
shared                    no
postprocessing support    yes
new filter support        yes
network support           yes
threading support         pthreads
safe bitstream reader     yes
SDL support               yes
opencl enabled            no
JNI support               no
texi2html enabled         no
perl enabled              yes
pod2man enabled           yes
makeinfo enabled          yes
makeinfo supports HTML    yes

Enabled programs:
ffmpeg			    ffplay			ffprobe			    ffserver

External libraries:
bzlib			    libfontconfig		libpulse		    libvo_amrwbenc		libxvid
frei0r			    libfreetype			librtmp			    libvorbis			libzimg
gnutls			    libfribidi			libschroedinger		    libvpx			libzvbi
iconv			    libgsm			libsoxr			    libwavpack			lzma
libass			    libkvazaar			libspeex		    libwebp			openal
libbluray		    libmp3lame			libtheora		    libx264			openssl
libcaca			    libopencore_amrnb		libtwolame		    libx265			sdl
libdc1394		    libopencore_amrwb		libutvideo		    libxcb			xlib
libfaac			    libopenjpeg			libv4l2			    libxcb_shape		zlib
libfdk_aac		    libopus			libvidstab		    libxcb_xfixes

Libraries:
avcodec			    avfilter			avresample		    postproc			swscale
avdevice		    avformat			avutil			    swresample

Enabled decoders:
aac			    avrp			flashsv			    microdvd			pcm_s24le_planar
aac_fixed		    avs				flashsv2		    mimic			pcm_s32be
aac_latm		    avui			flic			    mjpeg			pcm_s32le
aasc			    ayuv			flv			    mjpegb			pcm_s32le_planar
ac3			    bethsoftvid			fourxm			    mlp				pcm_s8
ac3_fixed		    bfi				fraps			    mmvideo			pcm_s8_planar
adpcm_4xm		    bink			frwu			    motionpixels		pcm_u16be
adpcm_adx		    binkaudio_dct		g2m			    movtext			pcm_u16le
adpcm_afc		    binkaudio_rdft		g723_1			    mp1				pcm_u24be
adpcm_aica		    bintext			g729			    mp1float			pcm_u24le
adpcm_ct		    bmp				gif			    mp2				pcm_u32be
adpcm_dtk		    bmv_audio			gsm			    mp2float			pcm_u32le
adpcm_ea		    bmv_video			gsm_ms			    mp3				pcm_u8
adpcm_ea_maxis_xa	    brender_pix			h261			    mp3adu			pcm_zork
adpcm_ea_r1		    c93				h263			    mp3adufloat			pcx
adpcm_ea_r2		    cavs			h263i			    mp3float			pgm
adpcm_ea_r3		    ccaption			h263p			    mp3on4			pgmyuv
adpcm_ea_xas		    cdgraphics			h264			    mp3on4float			pgssub
adpcm_g722		    cdxl			h264_qsv		    mpc7			pictor
adpcm_g726		    cfhd			h264_vdpau		    mpc8			pjs
adpcm_g726le		    cinepak			hap			    mpeg1_vdpau			png
adpcm_ima_amv		    cljr			hevc			    mpeg1video			ppm
adpcm_ima_apc		    cllc			hevc_qsv		    mpeg2_qsv			prores
adpcm_ima_dat4		    comfortnoise		hnm4_video		    mpeg2video			prores_lgpl
adpcm_ima_dk3		    cook			hq_hqa			    mpeg4			ptx
adpcm_ima_dk4		    cpia			hqx			    mpeg4_vdpau			qcelp
adpcm_ima_ea_eacs	    cscd			huffyuv			    mpeg_vdpau			qdm2
adpcm_ima_ea_sead	    cyuv			iac			    mpegvideo			qdraw
adpcm_ima_iss		    dca				idcin			    mpl2			qpeg
adpcm_ima_oki		    dds				idf			    msa1			qtrle
adpcm_ima_qt		    dfa				iff_ilbm		    msmpeg4v1			r10k
adpcm_ima_rad		    dirac			imc			    msmpeg4v2			r210
adpcm_ima_smjpeg	    dnxhd			indeo2			    msmpeg4v3			ra_144
adpcm_ima_wav		    dpx				indeo3			    msrle			ra_288
adpcm_ima_ws		    dsd_lsbf			indeo4			    mss1			ralf
adpcm_ms		    dsd_lsbf_planar		indeo5			    mss2			rawvideo
adpcm_psx		    dsd_msbf			interplay_acm		    msvideo1			realtext
adpcm_sbpro_2		    dsd_msbf_planar		interplay_dpcm		    mszh			rl2
adpcm_sbpro_3		    dsicinaudio			interplay_video		    mts2			roq
adpcm_sbpro_4		    dsicinvideo			jacosub			    mvc1			roq_dpcm
adpcm_swf		    dss_sp			jpeg2000		    mvc2			rpza
adpcm_thp		    dvaudio			jpegls			    mxpeg			rscc
adpcm_thp_le		    dvbsub			jv			    nellymoser			rv10
adpcm_vima		    dvdsub			kgv1			    nuv				rv20
adpcm_xa		    dvvideo			kmvc			    on2avc			rv30
adpcm_yamaha		    dxa				lagarith		    opus			rv40
aic			    dxtory			libfdk_aac		    paf_audio			s302m
alac			    dxv				libgsm			    paf_video			sami
alias_pix		    eac3			libgsm_ms		    pam				sanm
als			    eacmv			libopencore_amrnb	    pbm				screenpresso
amrnb			    eamad			libopencore_amrwb	    pcm_alaw			sdx2_dpcm
amrwb			    eatgq			libopenjpeg		    pcm_bluray			sgi
amv			    eatgv			libopus			    pcm_dvd			sgirle
anm			    eatqi			libschroedinger		    pcm_f32be			shorten
ansi			    eightbps			libspeex		    pcm_f32le			sipr
ape			    eightsvx_exp		libutvideo		    pcm_f64be			smackaud
apng			    eightsvx_fib		libvorbis		    pcm_f64le			smacker
ass			    escape124			libvpx_vp8		    pcm_lxf			smc
asv1			    escape130			libvpx_vp9		    pcm_mulaw			smvjpeg
asv2			    evrc			libzvbi_teletext	    pcm_s16be			snow
atrac1			    exr				loco			    pcm_s16be_planar		sol_dpcm
atrac3			    ffv1			m101			    pcm_s16le			sonic
atrac3p			    ffvhuff			mace3			    pcm_s16le_planar		sp5x
aura			    ffwavesynth			mace6			    pcm_s24be			srt
aura2			    fic				mdec			    pcm_s24daud			ssa
avrn			    flac			metasound		    pcm_s24le			stl
subrip			    truemotion2			vc1_qsv			    vqa				xan_wc3
subviewer		    truemotion2rt		vc1_vdpau		    wavpack			xan_wc4
subviewer1		    truespeech			vc1image		    webp			xbin
sunrast			    tscc			vcr1			    webvtt			xbm
svq1			    tscc2			vmdaudio		    wmalossless			xface
svq3			    tta				vmdvideo		    wmapro			xl
tak			    twinvq			vmnc			    wmav1			xma1
targa			    txd				vorbis			    wmav2			xma2
targa_y216		    ulti			vp3			    wmavoice			xsub
tdsc			    utvideo			vp5			    wmv1			xwd
text			    v210			vp6			    wmv2			y41p
theora			    v210x			vp6a			    wmv3			yop
thp			    v308			vp6f			    wmv3_vdpau			yuv4
tiertexseqvideo		    v408			vp7			    wmv3image			zero12v
tiff			    v410			vp8			    wnv1			zerocodec
tmv			    vb				vp9			    ws_snd1			zlib
truehd			    vble			vplayer			    xan_dpcm			zmbv
truemotion1		    vc1

Enabled encoders:
a64multi		    ffv1			libwavpack		    pcm_s24le_planar		sonic
a64multi5		    ffvhuff			libwebp			    pcm_s32be			sonic_ls
aac			    flac			libx264			    pcm_s32le			srt
ac3			    flashsv			libx264rgb		    pcm_s32le_planar		ssa
ac3_fixed		    flashsv2			libx265			    pcm_s8			subrip
adpcm_adx		    flv				libxvid			    pcm_s8_planar		sunrast
adpcm_g722		    g723_1			ljpeg			    pcm_u16be			svq1
adpcm_g726		    gif				mjpeg			    pcm_u16le			targa
adpcm_ima_qt		    h261			movtext			    pcm_u24be			text
adpcm_ima_wav		    h263			mp2			    pcm_u24le			tiff
adpcm_ms		    h263p			mp2fixed		    pcm_u32be			tta
adpcm_swf		    h264_qsv			mpeg1video		    pcm_u32le			utvideo
adpcm_yamaha		    h264_vaapi			mpeg2_qsv		    pcm_u8			v210
alac			    hevc_qsv			mpeg2video		    pcx				v308
alias_pix		    huffyuv			mpeg4			    pgm				v408
amv			    jpeg2000			msmpeg4v2		    pgmyuv			v410
apng			    jpegls			msmpeg4v3		    png				vc2
ass			    libfaac			msvideo1		    ppm				vorbis
asv1			    libfdk_aac			nellymoser		    prores			wavpack
asv2			    libgsm			pam			    prores_aw			webvtt
avrp			    libgsm_ms			pbm			    prores_ks			wmav1
avui			    libkvazaar			pcm_alaw		    qtrle			wmav2
ayuv			    libmp3lame			pcm_f32be		    r10k			wmv1
bmp			    libopencore_amrnb		pcm_f32le		    r210			wmv2
cinepak			    libopenjpeg			pcm_f64be		    ra_144			wrapped_avframe
cljr			    libopus			pcm_f64le		    rawvideo			xbm
comfortnoise		    libspeex			pcm_mulaw		    roq				xface
dca			    libtheora			pcm_s16be		    roq_dpcm			xsub
dnxhd			    libtwolame			pcm_s16be_planar	    rv10			xwd
dpx			    libutvideo			pcm_s16le		    rv20			y41p
dvbsub			    libvo_amrwbenc		pcm_s16le_planar	    s302m			yuv4
dvdsub			    libvorbis			pcm_s24be		    sgi				zlib
dvvideo			    libvpx_vp8			pcm_s24daud		    snow			zmbv
eac3			    libvpx_vp9			pcm_s24le

Enabled hwaccels:
h263_vaapi		    hevc_qsv			mpeg2_vaapi		    mpeg4_vdpau			vc1_vdpau
h264_qsv		    mpeg1_vdpau			mpeg2_vdpau		    vc1_qsv			wmv3_vaapi
h264_vaapi		    mpeg2_qsv			mpeg4_vaapi		    vc1_vaapi			wmv3_vdpau
h264_vdpau

Enabled parsers:
aac			    dirac			g729			    mpeg4video			rv40
aac_latm		    dnxhd			gsm			    mpegaudio			tak
ac3			    dpx				h261			    mpegvideo			vc1
adx			    dvaudio			h263			    opus			vorbis
bmp			    dvbsub			h264			    png				vp3
cavsvideo		    dvd_nav			hevc			    pnm				vp8
cook			    dvdsub			mjpeg			    rv30			vp9
dca			    flac			mlp

Enabled demuxers:
aa			    dts				image_sgi_pipe		    ogg				sol
aac			    dtshd			image_sunrast_pipe	    oma				sox
ac3			    dv				image_tiff_pipe		    paf				spdif
acm			    dvbsub			image_webp_pipe		    pcm_alaw			srt
act			    dvbtxt			ingenient		    pcm_f32be			stl
adf			    dxa				ipmovie			    pcm_f32le			str
adp			    ea				ircam			    pcm_f64be			subviewer
ads			    ea_cdata			iss			    pcm_f64le			subviewer1
adx			    eac3			iv8			    pcm_mulaw			sup
aea			    epaf			ivf			    pcm_s16be			svag
afc			    ffm				ivr			    pcm_s16le			swf
aiff			    ffmetadata			jacosub			    pcm_s24be			tak
aix			    filmstrip			jv			    pcm_s24le			tedcaptions
amr			    flac			live_flv		    pcm_s32be			thp
anm			    flic			lmlm4			    pcm_s32le			threedostr
apc			    flv				loas			    pcm_s8			tiertexseq
ape			    fourxm			lrc			    pcm_u16be			tmv
apng			    frm				lvf			    pcm_u16le			truehd
aqtitle			    fsb				lxf			    pcm_u24be			tta
asf			    g722			m4v			    pcm_u24le			tty
asf_o			    g723_1			matroska		    pcm_u32be			txd
ass			    g729			mgsts			    pcm_u32le			v210
ast			    genh			microdvd		    pcm_u8			v210x
au			    gif				mjpeg			    pjs				vag
avi			    gsm				mlp			    pmp				vc1
avr			    gxf				mlv			    pva				vc1t
avs			    h261			mm			    pvf				vivo
bethsoftvid		    h263			mmf			    qcp				vmd
bfi			    h264			mov			    r3d				vobsub
bfstm			    hevc			mp3			    rawvideo			voc
bink			    hls				mpc			    realtext			vpk
bintext			    hnm				mpc8			    redspark			vplayer
bit			    ico				mpegps			    rl2				vqf
bmv			    idcin			mpegts			    rm				w64
boa			    idf				mpegtsraw		    roq				wav
brstm			    iff				mpegvideo		    rpl				wc3
c93			    ilbc			mpjpeg			    rsd				webm_dash_manifest
caf			    image2			mpl2			    rso				webvtt
cavsvideo		    image2_alias_pix		mpsub			    rtp				wsaud
cdg			    image2_brender_pix		msf			    rtsp			wsd
cdxl			    image2pipe			msnwc_tcp		    sami			wsvqa
cine			    image_bmp_pipe		mtv			    sap				wtv
concat			    image_dds_pipe		musx			    sbg				wv
data			    image_dpx_pipe		mv			    sdp				wve
daud			    image_exr_pipe		mvi			    sdr2			xa
dcstr			    image_j2k_pipe		mxf			    segafilm			xbin
dfa			    image_jpeg_pipe		mxg			    shorten			xmv
dirac			    image_jpegls_pipe		nc			    siff			xvag
dnxhd			    image_pcx_pipe		nistsphere		    sln				xwma
dsf			    image_pictor_pipe		nsv			    smacker			yop
dsicin			    image_png_pipe		nut			    smjpeg			yuv4mpegpipe
dss			    image_qdraw_pipe		nuv			    smush

Enabled muxers:
a64			    flac			matroska		    opus			sap
ac3			    flv				matroska_audio		    pcm_alaw			segment
adts			    framecrc			md5			    pcm_f32be			singlejpeg
adx			    framehash			microdvd		    pcm_f32le			smjpeg
aiff			    framemd5			mjpeg			    pcm_f64be			smoothstreaming
amr			    g722			mkvtimestamp_v2		    pcm_f64le			sox
apng			    g723_1			mlp			    pcm_mulaw			spdif
asf			    gif				mmf			    pcm_s16be			spx
asf_stream		    gsm				mov			    pcm_s16le			srt
ass			    gxf				mp2			    pcm_s24be			stream_segment
ast			    h261			mp3			    pcm_s24le			swf
au			    h263			mp4			    pcm_s32be			tee
avi			    h264			mpeg1system		    pcm_s32le			tg2
avm2			    hash			mpeg1vcd		    pcm_s8			tgp
bit			    hds				mpeg1video		    pcm_u16be			truehd
caf			    hevc			mpeg2dvd		    pcm_u16le			uncodedframecrc
cavsvideo		    hls				mpeg2svcd		    pcm_u24be			vc1
crc			    ico				mpeg2video		    pcm_u24le			vc1t
dash			    ilbc			mpeg2vob		    pcm_u32be			voc
data			    image2			mpegts			    pcm_u32le			w64
daud			    image2pipe			mpjpeg			    pcm_u8			wav
dirac			    ipod			mxf			    psp				webm
dnxhd			    ircam			mxf_d10			    rawvideo			webm_chunk
dts			    ismv			mxf_opatom		    rm				webm_dash_manifest
dv			    ivf				null			    roq				webp
eac3			    jacosub			nut			    rso				webvtt
f4v			    latm			oga			    rtp				wtv
ffm			    lrc				ogg			    rtp_mpegts			wv
ffmetadata		    m4v				oma			    rtsp			yuv4mpegpipe
filmstrip

Enabled protocols:
async			    ftp				librtmp			    mmsh			subfile
bluray			    gopher			librtmpe		    mmst			tcp
cache			    hls				librtmps		    pipe			tls_gnutls
concat			    http			librtmpt		    rtp				udp
crypto			    httpproxy			librtmpte		    sctp			udplite
data			    https			md5			    srtp			unix
file			    icecast

Enabled filters:
abench			    bandreject			erosion			    movie			showspectrumpic
acompressor		    bass			extractplanes		    mpdecimate			showvolume
acrossfade		    bbox			extrastereo		    mptestsrc			showwaves
adelay			    bench			fade			    negate			showwavespic
adrawgraph		    biquad			fftfilt			    nnedi			shuffleframes
aecho			    blackdetect			field			    noformat			shuffleplanes
aemphasis		    blackframe			fieldhint		    noise			sidechaincompress
aeval			    blend			fieldmatch		    null			sidechaingate
aevalsrc		    boxblur			fieldorder		    nullsink			signalstats
afade			    bwdif			find_rect		    nullsrc			silencedetect
afftfilt		    cellauto			firequalizer		    overlay			silenceremove
aformat			    channelmap			flanger			    owdenoise			sine
agate			    channelsplit		format			    pad				smartblur
ahistogram		    chorus			fps			    palettegen			smptebars
ainterleave		    chromakey			framepack		    paletteuse			smptehdbars
alimiter		    ciescope			framerate		    pan				spectrumsynth
allpass			    codecview			framestep		    perms			split
allrgb			    color			frei0r			    perspective			spp
allyuv			    colorbalance		frei0r_src		    phase			ssim
aloop			    colorchannelmixer		fspp			    pixdesctest			stereo3d
alphaextract		    colorkey			geq			    pp				stereotools
alphamerge		    colorlevels			gradfun			    pp7				stereowiden
amerge			    colormatrix			haldclut		    psnr			streamselect
ametadata		    colorspace			haldclutsrc		    pullup			subtitles
amix			    compand			hdcd			    qp				super2xsai
amovie			    compensationdelay		hflip			    random			swaprect
anequalizer		    concat			highpass		    readvitc			swapuv
anoisesrc		    convolution			histeq			    realtime			tblend
anull			    copy			histogram		    remap			telecine
anullsink		    cover_rect			hqdn3d			    removegrain			testsrc
anullsrc		    crop			hqx			    removelogo			testsrc2
apad			    cropdetect			hstack			    repeatfields		thumbnail
aperms			    curves			hue			    replaygain			tile
aphasemeter		    datascope			hwdownload		    resample			tinterlace
aphaser			    dcshift			hwupload		    reverse			transpose
apulsator		    dctdnoiz			idet			    rgbtestsrc			treble
arealtime		    deband			il			    rotate			tremolo
aresample		    decimate			inflate			    sab				trim
areverse		    deflate			interlace		    scale			unsharp
aselect			    dejudder			interleave		    scale2ref			uspp
asendcmd		    delogo			join			    scale_vaapi			vectorscope
asetnsamples		    deshake			kerndeint		    select			vflip
asetpts			    detelecine			lenscorrection		    selectivecolor		vibrato
asetrate		    dilation			life			    sendcmd			vidstabdetect
asettb			    displace			loop			    separatefields		vidstabtransform
ashowinfo		    drawbox			lowpass			    setdar			vignette
asplit			    drawgraph			lut			    setfield			volume
ass			    drawgrid			lut3d			    setpts			volumedetect
astats			    drawtext			lutrgb			    setsar			vstack
astreamselect		    dynaudnorm			lutyuv			    settb			w3fdif
asyncts			    earwax			mandelbrot		    showcqt			waveform
atadenoise		    ebur128			maskedmerge		    showfreqs			xbr
atempo			    edgedetect			mcdeint			    showinfo			yadif
atrim			    elbg			mergeplanes		    showpalette			zoompan
avectorscope		    eq				metadata		    showspectrum		zscale
bandpass		    equalizer

Enabled bsfs:
aac_adtstoasc		    h264_mp4toannexb		mjpeg2jpeg		    mp3_header_decompress	remove_extradata
chomp			    hevc_mp4toannexb		mjpega_dump_header	    mpeg4_unpack_bframes	text2movsub
dca_core		    imx_dump_header		mov2textsub		    noise			vp9_superframe
dump_extradata

Enabled indevs:
alsa			    jack			libdc1394		    oss				v4l2
dv1394			    lavfi			openal			    pulse			x11grab_xcb
fbdev

Enabled outdevs:
alsa			    fbdev			pulse			    sdl				v4l2
caca			    oss

Enabled Hardware-accelerated codecs:
libmfx
```
