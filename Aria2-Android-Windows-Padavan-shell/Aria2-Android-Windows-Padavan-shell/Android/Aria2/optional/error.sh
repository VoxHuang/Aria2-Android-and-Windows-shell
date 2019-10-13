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
	case $MODE in
		busybox|toybox)
			BROWSER=$($MODE pidof "com.android.chrome");;
		toolbox)
			BROWSER=$(ps | grep -E "^com.android.chrome$");;
	esac
	if [[ "$BROWSER" == "" ]]
	then
		am start --user 0 -a android.intent.action.VIEW -n com.android.chrome/com.google.android.apps.chrome.Main -d 'http://aria2.me/' >/dev/null 2>&1 &
	fi
	PROG="$ADIR/Beep.dex"
	AUDIO="$BDIR/error.wav"
	if [[ -s "$PROG" ]]
	then
		if [[ -f "$AUDIO" ]]
		then
			if [[ -s "$AUDIO" ]]
			then
				app_process -Djava.class.path="$PROG" "$ADIR" Beep "$AUDIO" >/dev/null 2>&1 &
			fi
		else
			mount -o remount,rw /system 2>/dev/null
			touch "$AUDIO" 2>/dev/null
			chmod 0644 "$AUDIO" 2>/dev/null
			mount -o remount,ro /system 2>/dev/null
		fi
	fi
fi
exit
