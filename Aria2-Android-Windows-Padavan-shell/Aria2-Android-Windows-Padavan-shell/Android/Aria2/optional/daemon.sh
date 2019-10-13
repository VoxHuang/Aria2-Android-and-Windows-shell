#!/system/bin/sh
export PATH="/system/bin:/system/xbin:$PATH"
INFO="/storage/emulated/0/Aria2/aria2.info"
NUM=0
while ((NUM<10));do
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
		CHECK() {
			case $MODE in
				busybox|toybox)
					PID=$($MODE pidof aria2c);;
				toolbox)
					PROC=($(ps | grep -E "aria2c$"));PID=${PROC[1]};;
			esac;
		}
		CHECK
		if [[ "$PID" == "" ]]
		then
			"$CORE" --conf-path="$CONF" -D >/dev/null 2>&1
			unset PROC PID;sleep 0.1;CHECK
			if [[ "$PID" == "" ]]
			then
				break
			fi
		else
			unset MODE PROC PID;sleep 60
		fi
	else
		sleep 10;let NUM++
	fi
done &
