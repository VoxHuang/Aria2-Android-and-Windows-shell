#!/system/bin/sh
export PATH="/system/bin:/system/xbin:$PATH"
INFO="/storage/emulated/0/Aria2/aria2.info"
if [[ -s "$INFO" ]]
then
	. "$INFO";wait
	if [[ `busybox 2>/dev/null` != "" ]]
	then
		MODE=busybox
	elif [[ `ls -l "/system/bin/ps" | grep "toybox"` != "" ]]
	then
		MODE=toybox
	else
		MODE=toolbox
	fi
	mount -o remount,rw /system 2>/dev/null
	rm "$ADIR/Beep.odex" 2>/dev/null
	case $MODE in
		busybox|toybox)
			cd "$($MODE dirname "$0")";;
		toolbox)
			cd "$0/..";;
	esac
	cp Beep.dex Beep.zip dex2odex error.sh complete.sh "$ADIR";wait
	chmod 0755 "$ADIR"/*;wait
	cd "$ADIR"
	./dex2odex Beep.zip Beep.odex;wait
	chmod 0644 Beep.odex
	rm Beep.zip dex2odex
	mount -o remount,ro /system 2>/dev/null
fi
exit
