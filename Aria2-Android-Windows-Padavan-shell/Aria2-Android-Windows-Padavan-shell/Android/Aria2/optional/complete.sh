#!/system/bin/sh
export PATH="/system/bin:/system/xbin:$PATH"
INFO="/storage/emulated/0/Aria2/aria2.info"
if [[ -s "$INFO" ]]
then
	. "$INFO";wait
	if [[ -s "$CONF" ]]
	then
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
				DDIR="$(grep -E "^dir=" "$CONF" | $MODE cut -d "=" -f 2)"
				COMMAND() {
					if [[ `$MODE find "$DDIR" -type f -name "*.aria2"` != "" ]]
					then
						exit
					fi;
				};;
			toolbox)
				AA="$(grep -E "^dir=" "$CONF")";DDIR="${AA##*=}"
				COMMAND() {
					for FILE in $(ls "$DDIR"/*.*);do
						if [[ "${FILE##*.}" == "aria2" ]]
						then
							exit
						fi
					done;
				};;
		esac
		if [[ -d "$DDIR" ]]
		then
			PROG="$ADIR/Beep.dex"
			AUDIO="$BDIR/complete.wav"
			if [[ -s "$PROG" ]]
			then
				if [[ -f "$AUDIO" ]]
				then
					if [[ -s "$AUDIO" ]]
					then
						COMMAND;app_process -Djava.class.path="$PROG" "$ADIR" Beep "$AUDIO" >/dev/null 2>&1 &
					fi
				else
					mount -o remount,rw /system 2>/dev/null
					touch "$AUDIO" 2>/dev/null
					chmod 0644 "$AUDIO" 2>/dev/null
					mount -o remount,ro /system 2>/dev/null
				fi
			fi
		fi
	fi
fi
exit
