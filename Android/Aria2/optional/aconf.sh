#!/system/bin/sh
export PATH="/system/bin:/system/xbin:$PATH"
INFO="/storage/emulated/0/Aria2/aria2.info"
if [[ -s "$INFO" ]]
then
	. "$INFO";wait
	BACKUP="$BDIR/aria2.conf.backup"
	mount -o remount,rw /system 2>/dev/null
	COMMAND() {
		grep -Ev "^$|^#" "$BACKUP" > "$CONF"
		chmod 0644 "$CONF" 2>/dev/null;
	}
	if [[ -s "$BACKUP" ]]
	then
		COMMAND;exit
	fi
	if [[ -s "$CONF" ]]
	then
		mv "$CONF" "$BACKUP" 2>/dev/null
		COMMAND;exit
	fi
	mount -o remount,ro /system 2>/dev/null
fi
exit
