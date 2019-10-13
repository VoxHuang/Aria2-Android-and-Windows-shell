#!/system/bin/sh

export PATH="/system/bin:/system/xbin:$PATH"

#Aria2 Launcher 1.0

#安装模块
function INSTALL() {
	case $MODE in
		busybox|toybox)
			CDIR="$(cd "$($MODE dirname "$0")";pwd)";;
		toolbox)
			CDIR="$(cd "$0/..";pwd)";;
	esac
	CORE="$CDIR/aria2c"
	if [[ ! -f "$CORE" ]]
	then
		echo "核心文件缺失 ×\n请先下载核心 ¡"
		{ sleep 1;am start --user 0 -a android.intent.action.VIEW -n com.android.chrome/com.google.android.apps.chrome.Main -d 'http://aria2.github.io/' >/dev/null;} &
	elif [[ -x "$0" ]]
	then
		if [[ "$USER_ID" == "0" ]]
		then
			ADIR="$CDIR"
		else
			echo "现为普通用户 ×\n请用超级用户 ¡"
		fi
	else
		if [[ "$USER_ID" != "0" ]]
		then
			if [[ -x "$HOME" ]]
			then
				HOME="$HOME"
			else
				AA=($(cat "/proc/$PPID/stat"));BB="/data/data/$(cat "/proc/${AA[3]}/cmdline")"
				if [[ -x "$BB" ]]
				then
					HOME="$BB/files"
				else
					AA=($(ps "$PPID" | grep "$PPID"));BB=($(ps "${AA[2]}" | grep "${AA[2]}"));HOME="/data/data/${BB[8]}/files"
				fi
			fi
			ADIR="$HOME/Aria2";mkdir -p "$ADIR" && cp "$CORE" "$ADIR" && chmod -R 0775 "$HOME" && rm "$CORE"
		else
			echo "现为超级用户 ×\n请用普通用户 ¡"
		fi
	fi
	if [[ -x "$ADIR" ]]
	then
		mkdir -p "$SDIR";print 'ADIR="'$ADIR'"\nBDIR="'$CDIR'"\nCORE="$ADIR/aria2c"\nCONF="$BDIR/aria2.conf"' > "$INFO" && sh "$0"
	fi;
}

#初始模块
function INITIALIZE() {
	if [[ `"$CORE" -v | grep "aria2 version"` == "" ]]
	then
		echo "核心文件错误 ×\n请您确认核心 ¡";exit
	fi
	if [[ ! -s "$CONF" ]]
	then
		CONF() {
		print '#【 运行日志相关 】#'
		print ''
		print '# 日志的保存路径'
		print "log=$SDIR/aria2.log"
		print ''
		print '# 日志记录等级，默认：debug'
		print 'log-level=warn'
		print ''
		print ''
		print '#【 RPC设置相关 】#'
		print ''
		print '# 启用RPC，默认：false'
		print 'enable-rpc=true'
		print ''
		print '# 接受所有访问请求，默认：false'
		print 'rpc-allow-origin-all=true'
		print ''
		print '# 在所有网络上监听，默认：false'
		print '#rpc-listen-all=true'
		print ''
		print '# RPC监听端口，端口被占用时可以修改，默认：6800'
		print 'rpc-listen-port=6800'
		print ''
		print '# RPC访问令牌，启用后默认访问地址为：http://token:<PASSWORD>@localhost:6800/jsonrpc'
		print 'rpc-secret=voxhuang.com'
		print ''
		print ''
		print '#【 全局代理相关 】#'
		print ''
		print '# 代理服务器'
		print '#all-proxy=[http://][USER:PASSWORD@]HOST[:PORT]'
		print ''
		print '# 代理服务器用户名'
		print '#all-proxy-user=<USER>'
		print ''
		print '# 代理服务器密码'
		print '#all-proxy-passwd=<PASSWORD>'
		print ''
		print '# 代理服务器请求方法，取值：get，tunnel，默认：get'
		print '#proxy-method=tunnel'
		print ''
		print '# 不代理HOST列表，多个需使用逗号隔开'
		print '#no-proxy=<DOMAINS>'
		print ''
		print ''
		print '#【 下载连接相关 】#'
		print ''
		print '# 禁用IPv6，默认：false'
		print '#disable-ipv6=true'
		print ''
		print '# 超时时间，单位(秒)，默认：60'
		print 'timeout=60'
		print ''
		print '# 连接超时时间，单位(秒)，默认：60'
		print 'connect-timeout=30'
		print ''
		print '# 重试等待时间，单位(秒)，0为禁用，默认：0'
		print 'retry-wait=1'
		print ''
		print '# 单个任务最大线程数，添加时可指定，默认：5'
		print 'split=16'
		print ''
		print '# 最大同时下载任务数，运行时可修改，默认：5'
		print 'max-concurrent-downloads=3'
		print ''
		print '# 最大单服务器连接数，添加时可指定，默认：1'
		print 'max-connection-per-server=16'
		print ''
		print '# 单个任务下载速度限制，默认：0'
		print 'max-download-limit=0'
		print ''
		print '# 单个任务上传速度限制，默认：0'
		print 'max-upload-limit=0'
		print ''
		print '# 整体下载速度限制，运行时可修改，默认：0'
		print 'max-overall-download-limit=0'
		print ''
		print '# 整体上传速度限制，运行时可修改，默认：0'
		print 'max-overall-upload-limit=0'
		print ''
		print '# 优化并发下载，根据带宽自动调整并发下载数量，默认：false'
		print '#optimize-concurrent-downloads=true'
		print ''
		print '# 文件分片大小，所有的分割都是这个长度的倍数，默认：1M'
		print 'piece-length=1M'
		print ''
		print '# 最小分割大小，添加时可指定，取值范围1M-1024M，默认：20M'
		print 'min-split-size=1M'
		print ''
		print '# 第一次请求HTTP服务器时使用HEAD方法，默认：false'
		print '#use-head=true'
		print ''
		print '# 设置请求来源，仅对HTTP(S)有效'
		print '#referer=<REFERER>'
		print ''
		print '# 保存Cookies文件'
		print "save-cookies=$SDIR/aria2.cookies"
		print ''
		print '# 加载Cookies文件'
		print "load-cookies=$SDIR/aria2.cookies"
		print ''
		print '# 客户端UA伪装，仅对HTTP(S)有效'
		print 'peer-id-prefix=-TR2770-'
		print 'user-agent=Transmission/2.77'
		print ''
		print '# 参数化URI支持，默认：false'
		print '#parameterized-uri=true'
		print ''
		print '# 响应GZip请求头，默认：false'
		print '#http-accept-gzip=true'
		print ''
		print '# 禁用HTTP缓存，默认：false'
		print '#http-no-cache=true'
		print ''
		print '# 使用UTF-8处理Content-Disposition，默认：false'
		print '#content-disposition-default-utf8=true'
		print ''
		print '# 自定义HTTP请求头，该参数可用作网站验证，在添加任务时可指定，并且可以使用多个'
		print '#header="Host: "'
		print '#header="Content-Type: "'
		print '#header="Content-Disposition: "'
		print '#header="Cache-Control: "'
		print '#header="Pragma: "'
		print '#header="Referer: "'
		print '#header="Cookie: "'
		print '#header="User-Agent: "'
		print ''
		print ''
		print '#【 异步DNS相关 】#'
		print ''
		print '# 启用异步DNS，默认：true'
		print '#async-dns=false'
		print ''
		print '# 异步DNS解析器中使用的DNS服务器地址，多个需使用逗号隔开，默认读取：/etc/resolv.conf'
		print '#async-dns-server=<IPADDRESS>'
		print ''
		print ''
		print '#【 任务状态相关 】#'
		print ''
		print '# 当下载任务切换到某状态时需要执行的命令，取值：/path/to/command'
		print '# 下载开始时要执行的命令'
		print '#on-download-start=<COMMAND>'
		print ''
		print '# 下载停止时要执行的命令'
		print '#on-download-stop=<COMMAND>'
		print ''
		print '# 下载暂停时要执行的命令'
		print '#on-download-pause=<COMMAND>'
		print ''
		print '# 下载错误时要执行的命令'
		print "on-download-error=$ADIR/error.sh"
		print ''
		print '# 下载完成时要执行的命令'
		print "on-download-complete=$ADIR/complete.sh"
		print ''
		print '# BT下载完成时要执行的命令'
		print "on-bt-download-complete=$ADIR/complete.sh"
		print ''
		print ''
		print '#【 文件保存相关 】#'
		print ''
		print '# 所有下载任务的相关文件的保存路径'
		print "dir=/sdcard/Download/"
		print ''
		print '# 断点续传，仅对HTTP(S)/FTP有效'
		print 'continue=true'
		print ''
		print '# 允许分片变化，当文件分片长度与其控制文件中的不同时默认会中止下载，默认：false'
		print '#allow-piece-length-change=true'
		print ''
		print '# 条件下载，当本地存在文件并且比远程文件旧时才进行下载，默认：false'
		print '#conditional-get=true'
		print ''
		print '# 允许覆盖文件，如果相应的控制文件不存在时则重新下载，默认：false'
		print '#allow-overwrite=true'
		print ''
		print '# 自动重命名，如果已存在同名文件时自动重命名新的下载，默认：true'
		print 'auto-file-renaming=true'
		print ''
		print ''
		print '#【 会话保存相关 】#'
		print ''
		print '# 强制保存会话和控制文件，即使任务已经完成，该参数可用作断电保护，防止重启后任务丢失，默认：false'
		print '#force-save=true'
		print ''
		print '# 定时保存会话，单位(秒)，0为程序退出时保存，默认：0'
		print 'save-session-interval=60'
		print ''
		print '# 定时保存控制文件，单位(秒)，取值：0~600，0为不保存，默认：60'
		print 'auto-save-interval=30'
		print ''
		print '# 在内存中存储的最大下载结果数量，0为不存储，默认：1000'
		print '#max-download-result=<NUM>'
		print ''
		print '# 无数量上限保留所有未完成的下载结果，默认：true'
		print '#keep-unfinished-download-result=false'
		print ''
		print '# 在Aria2退出时保存“错误/未完成”的下载任务到会话文件'
		print "save-session=$SDIR/aria2.session"
		print ''
		print '# 在Aria2启动时从会话文件中读取下载任务'
		print "input-file=$SDIR/aria2.session"
		print ''
		print ''
		print '#【 FTP/SFTP相关 】#'
		print ''
		print '# FTP/SFTP用户名'
		print '#ftp-user=<USER>'
		print ''
		print '# FTP/SFTP密码'
		print '#ftp-passwd=<PASSWORD>'
		print ''
		print '# FTP被动模式，默认：true'
		print '#ftp-pasv=false'
		print ''
		print '# 传输类型，取值：binary，ascii，默认：binary'
		print '#ftp-type=ascii'
		print ''
		print '# 禁用Netrc，默认：false'
		print '#no-netrc=true'
		print ''
		print '# 设置.netrc文件路径，其文件权限必须为 600，否则将忽略该文件，默认：当前用户HOME目录'
		print "netrc-path=$BDIR/aria2.netrc"
		print ''
		print ''
		print '#【 Metalink相关 】#'
		print ''
		print '# 当下载的是一个Metalink文件时，自动下载Metelink中的文件，取值：true，false，mem，默认：true'
		print '#follow-metalink=false'
		print ''
		print '# 首选使用协议，取值：http，https，ftp，none，默认：none'
		print '#metalink-preferred-protocol=http'
		print ''
		print '# 仅使用唯一协议，默认：true'
		print '#metalink-enable-unique-protocol=false'
		print ''
		print ''
		print '#【 BitTorrent相关 】#'
		print ''
		print '# 当下载的是一个BitTorrent文件时，自动下载BitTorrent中的文件，取值：true，false，mem，默认：true'
		print 'follow-torrent=false'
		print ''
		print '# 将元数据保存为“.torrent”文件，仅在使用磁力链接时此选项才会生效，默认：false'
		print 'bt-save-metadata=true'
		print ''
		print '# 在用磁力链接获取数据之前，首先读取 bt-save-metadata 选项保存的文件，如果存在，则跳过从DHT下载元数据，默认：false'
		print 'bt-load-saved-metadata=true'
		print ''
		print '# 自动删除种子文件中未选择下载的文件，默认：false'
		print 'bt-remove-unselected-file=true'
		print ''
		print '# 下载无速度时自动停止的时间，单位(秒)，0为禁用，默认：0'
		print 'bt-stop-timeout=120'
		print ''
		print '# BT监听端口，默认：6881-6999'
		print '#listen-port=51413'
		print ''
		print '# 单个种子最大连接数，0为不限制，默认：55'
		print 'bt-max-peers=0'
		print ''
		print '# 期望的下载速度，当下载速度低于此值时，将临时调整单个种子最大连接数，默认：50K'
		print 'bt-request-peer-speed-limit=100K'
		print ''
		print '# 打开IPv4 DHT功能，默认：true'
		print 'enable-dht=true'
		print ''
		print '# 设置IPv4的DHT网络入口点'
		print '#dht-entry-point=<HOST>:<PORT>'
		print ''
		print '# 设置IPv4 DHT文件路径，默认：当前用户HOME目录'
		print "dht-file-path=$SDIR/dht.dat"
		print ''
		print '# 打开IPv6 DHT功能，默认：false'
		print 'enable-dht6=true'
		print ''
		print '# 设置IPv6的DHT网络入口点'
		print '#dht-entry-point6=<HOST>:<PORT>'
		print ''
		print '# 设置IPv6 DHT文件路径，默认：当前用户HOME目录'
		print "dht-file-path6=$SDIR/dht6.dat"
		print ''
		print '# DHT网络监听端口，默认：6881-6999'
		print '#dht-listen-port=51413'
		print ''
		print '# 启用对等体交换，默认：true'
		print 'enable-peer-exchange=true'
		print ''
		print '# 指定对等体代理字符串'
		print '#peer-agent=<PEER_AGENT>'
		print ''
		print '# 指定对等体ID前缀，最大长度为20字节'
		print '#peer-id-prefix=<PEER_ID_PREFIX>'
		print ''
		print '# 启用本地对等体发现，默认：false'
		print 'bt-enable-lpd=true'
		print ''
		print '# 完整性校验，默认：false'
		print 'check-integrity=true'
		print ''
		print '# 继续之前的BT任务时，无需再次校验，默认：false'
		print '#bt-seed-unverified=true'
		print ''
		print '# 做种前检查文件哈希值，默认：true'
		print '#bt-hash-check-seed=false'
		print ''
		print '# 指定分享率，当种子的分享率达到这个数时停止做种，0为一直做种，默认：1.0'
		print '#seed-ratio=0'
		print ''
		print '# 最小做种时间，当种子的做种时长达到这个数时停止做种，单位(分)，0为从不做种'
		print 'seed-time=0'
		print ''
		print '# BT服务器地址，多个需使用逗号隔开'
		print 'bt-tracker=udp://tracker.coppersurfer.tk:6969/announce,udp://tracker.open-internet.nl:6969/announce,udp://9.rarbg.to:2710/announce,udp://tracker.skyts.net:6969/announce,udp://tracker.piratepublic.com:1337/announce,udp://tracker.opentrackr.org:1337/announce,udp://public.popcorn-tracker.org:6969/announce,udp://wambo.club:1337/announce,udp://tracker4.itzmx.com:2710/announce,udp://tracker1.wasabii.com.tw:6969/announce,udp://tracker.zer0day.to:1337/announce,udp://tracker.xku.tv:6969/announce,udp://tracker.vanitycore.co:6969/announce,udp://ipv4.tracker.harry.lu:80/announce,udp://inferno.demonoid.pw:3418/announce,udp://open.facedatabg.net:6969/announce,udp://mgtracker.org:6969/announce,udp://tracker.tiny-vps.com:6969/announce,udp://p4p.arenabg.com:1337/announce,udp://open.stealth.si:80/announce,udp://explodie.org:6969/announce,udp://bt.xxx-tracker.com:2710/announce,http://tracker.city9x.com:2710/announce,http://retracker.mgts.by:80/announce,udp://tracker.tvunderground.org.ru:3218/announce,udp://tracker.torrent.eu.org:451/announce,udp://tracker.internetwarriors.net:1337/announce,udp://tracker.grepler.com:6969/announce,udp://tracker.files.fm:6969/announce,udp://tracker.dler.org:6969/announce,udp://tracker.desu.sh:6969/announce,udp://tracker.cypherpunks.ru:6969/announce,udp://tracker.uw0.xyz:6969/announce,udp://t.agx.co:61655/announce,udp://sd-95.allfon.net:2710/announce,udp://santost12.xyz:6969/announce,udp://sandrotracker.biz:1337/announce,udp://retracker.nts.su:2710/announce,udp://retracker.lanta-net.ru:2710/announce,udp://thetracker.org:80/announce,http://tracker.skyts.net:6969/announce,http://retracker.telecom.by:80/announce,wss://tracker.openwebtorrent.com:443/announce,wss://tracker.fastcast.nz:443/announce,wss://tracker.btorrent.xyz:443/announce,ws://tracker.btsync.cf:2710/announce,udp://zephir.monocul.us:6969/announce,http://0d.kebhana.mx:443/announce,udp://torr.ws:2710/announce,udp://retracker.coltel.ru:2710/announce,udp://pubt.in:2710/announce,udp://tracker.swateam.org.uk:2710/announce,udp://tracker.mg64.net:6969/announce,udp://tracker.martlet.tk:6969/announce,udp://tracker.kamigami.org:2710/announce,udp://tracker.cyberia.is:6969/announce,udp://tracker.bluefrog.pw:2710/announce,udp://tracker.acg.gg:2710/announce,udp://peerfect.org:6969/announce,https://open.acgnxtracker.com:443/announce,https://evening-badlands-6215.herokuapp.com:443/announce,http://open.acgnxtracker.com:80/announce,http://fxtt.ru:80/announce,udp://z.crazyhd.com:2710/announce,udp://tracker.justseed.it:1337/announce,udp://packages.crunchbangplusplus.org:6969/announce,udp://104.238.198.186:8000/announce,https://open.kickasstracker.com:443/announce,http://tracker2.itzmx.com:6961/announce,http://tracker.vanitycore.co:6969/announce,http://tracker.torrentyorg.pl:80/announce,http://tracker.tfile.me:80/announce,http://tracker.mg64.net:6881/announce,http://tracker.electro-torrent.pl:80/announce,http://t.nyaatracker.com:80/announce,http://share.camoe.cn:8080/announce,http://servandroidkino.ru:80/announce,http://open.kickasstracker.com:80/announce,http://open.acgtracker.com:1096/announce,http://omg.wtftrackr.pw:1337/announce,http://mgtracker.org:6969/announce,http://bt.dl1234.com:80/announce,http://agusiq-torrents.pl:6969/announce,http://104.238.198.186:8000/announce,'
		print ''
		print ''
		print '#【 高级设置相关 】#'
		print ''
		print '# 使用SSL/TLS加密传输，RPC客户端需要使用https协议连接，WebSocket客户端则需使用wss协议，默认：false'
		print '#rpc-secure=true'
		print ''
		print '# 启用RPC加密设置的证书，文件必须是PKCS12或PEM格式'
		print '# PKCS12文件必须包含证书和密钥且密码必须为空，使用PEM则必须同时指定私钥'
		print '#rpc-certificate=<FILE>'
		print ''
		print '# 启用RPC加密设置的私钥，文件必须是PEM格式'
		print '#rpc-private-key=<FILE>'
		print ''
		print '# 启用客户端验证设置的证书，文件必须是PKCS12或PEM格式'
		print '# PKCS12文件必须包含证书和密钥且密码必须为空，使用PEM则必须同时指定私钥'
		print '#certificate=<FILE>'
		print ''
		print '# 启用客户端验证设置的私钥，文件必须是PEM格式'
		print '#private-key=<FILE>'
		print ''
		print '# 使用CA证书验证SSL/TLS对等体，文件必须是PEM格式，且可以包含多个CA证书'
		print '#ca-certificate=<FILE>'
		print ''
		print '# 启用CA证书验证SSL/TLS对等体，默认：true'
		print 'check-certificate=false'
		print ''
		print '# 设置进程资源限制，设定值必须大于软限制，但不能超过硬限制'
		print '#rlimit-nofile=<NUM>'
		print ''
		print '# 启用磁盘缓存，0为禁用，默认：16M'
		print 'disk-cache=128M'
		print ''
		print '# 禁用控制台输出，默认：false'
		print '#quiet=true'
		print ''
		print '# 自动关闭应用时间，单位(秒)，0为禁用，默认：0'
		print '#stop=<SEC>'
		print ''
		print '# 保存上传的种子文件，默认：true'
		print 'rpc-save-upload-metadata=true'
		print ''
		print '# 当种子文件下载完成后暂停后续的下载，默认：false'
		print '#pause-metadata=true'
		print ''
		print '# 延迟加载会话文件，并在需要时按需读取，当使用 save-session 参数时，此项将被禁用，默认：false'
		print '#deferred-input=true'
		print ''
		print '# 下载前删除控制文件，此选项有助于使用不支持断点续传代理服务器的用户，默认：false'
		print '#remove-control-file=true'
		print ''
		print '# 实时数据块验证，如果数据块头部包含校验和，将在下载过程中对数据进行实时验证，默认：true'
		print 'realtime-chunk-checksum=true'
		print ''
		print '# 优先下载，尝试先下载每个文件的开头和结尾，这将有助于文件预览'
		print '# 参数可以包括两个关键词：head和tail，需要使用逗号分隔，每个关键词可以包含一个参数SIZE'
		print '# 例如，如果指定head，每个文件的最前SIZE数据将会获得更高的优先级，tail表示每个文件的最后SIZE数据'
		print 'bt-prioritize-piece=head=10M,tail=10M'
		print ''
		print '# 事件轮询方式，取值：epoll，select，默认：epoll'
		print '#event-poll=select'
		print ''
		print '# 文件预分配方式，能有效减少文件碎片，取值：prealloc，trunc，none，默认：prealloc'
		print '# 预分配所需时间：prealloc > trunc > none，其中trunc需要EXT3/4文件系统支持'
		print '#file-allocation=none'
		}
		$(MOUNT);CONF > "$CONF";chmod 0644 "$CONF";$(UMOUNT)
	fi
	case $MODE in
		busybox|toybox)
			SESSION="$(grep -E "^input-file=" "$CONF" | $MODE cut -d "=" -f 2)";;
		toolbox)
			AA="$(grep -E "^input-file=" "$CONF")";SESSION="${AA##*=}";;
	esac
	if [[ "$SESSION" != "" ]] && [[ ! -f "$SESSION" ]]
	then
		$(MOUNT);touch "$SESSION";$(UMOUNT)
	fi
	case $MODE in
		busybox|toybox)
			LOG="$(grep -E "^log=" "$CONF" | $MODE cut -d "=" -f 2)";;
		toolbox)
			AA="$(grep -E "^log=" "$CONF")";LOG="${AA##*=}";;
	esac
	if [[ "$LOG" != "" ]] && [[ -f "$LOG" ]]
	then
		$(MOUNT);rm "$LOG";$(UMOUNT)
	fi;
}

#检测模块
function CHECK() {
	case $MODE in
		busybox|toybox)
			PID=$($MODE pidof "aria2c");;
		toolbox)
			PROC=($(ps | grep -E "aria2c$"));PID=${PROC[1]};;
	esac;
}

#卸载模块
function UNINSTALL() {
	if [[ -s "$INFO" ]]
	then
		. "$INFO";wait
		CHECK;kill -9 $PID;CHECK
		if [[ "$PID" == "" ]]
		then
			$(MOUNT);rm -f "$CORE";$(UMOUNT)
			if [[ ! -f "$CORE" ]]
			then
				echo "程序卸载成功 √\n清理残余文件 ¡"
				$(MOUNT)
				cd "$SDIR";rm -f "aria2.info" "aria2.session" "aria2.log" "aria2.cookies" "dht.dat" "dht6.dat";rmdir "Download"
				cd "$ADIR";rm -f "error.sh" "complete.sh" "Beep.dex" "Beep.odex"
				cd "$BDIR";rm -rf "optional" "aria2.conf" "aria2.conf.backup" "aria2.netrc" "error.wav" "complete.wav" "aconf.sh" "daemon.sh" "$0"
				rmdir "$SDIR"
				rmdir "$ADIR"
				rmdir "$BDIR"
				$(UMOUNT)
			else
				echo "请用原安装器 ×\n或用超级用户 ¡"
			fi
		else
			echo "程序正在运行 ×\n请先关闭程序 ¡"
		fi
	else
		echo "安装信息缺失 ×\n无法完成卸载 ¡"
	fi;
}

#逻辑主体
alias MOUNT='mount -o remount,rw /system'
alias UMOUNT='mount -o remount,ro /system'
SDIR="/storage/emulated/0/Aria2"
INFO="$SDIR/aria2.info"
if [[ `busybox 2>/dev/null` != "" ]]
then
	MODE=busybox
elif [[ `ls -l "/system/bin/ps" | grep "toybox"` != "" ]]
then
	MODE=toybox
else
	MODE=toolbox
fi
if [[ "$1" != "-del" ]] && [[ "${0##*/}" != "del.sh" ]]
then
	if [[ ! -s "$INFO" ]]
	then
		INSTALL 2>/dev/null
	else
		. "$INFO";wait
		INITIALIZE 2>/dev/null;CHECK
		if [[ "$PID" == "" ]]
		then
			"$CORE" --conf-path="$CONF" -D
			unset PROC PID;sleep 0.1;CHECK
			if [[ "$PID" != "" ]]
			then
				echo "程序已经启动 ●"
			else
				echo "程序未能启动 ○"
			fi
		else
			kill -9 $PID
			unset PROC PID;sleep 0.1;CHECK
			if [[ "$PID" == "" ]]
			then
				echo "程序已经关闭 ○"
			else
				echo "程序未能关闭 ●"
			fi
		fi
	fi
else
	UNINSTALL 2>/dev/null
fi
exit
