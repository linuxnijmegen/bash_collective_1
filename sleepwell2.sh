#!/bin/bash
set -e

#zet computer in slaapstand
#dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" /org/freedesktop/UPower org.freedesktop.UPower.Suspend



#bepaal volume niveau
#amixer get Master | grep % | awk '{print $4}'| sed 's/[^0-9]//g'

#amixer get Master | grep % | awk '{print $5}'| sed 's/[^0-9]//g'

#volume wijzigen
#amixer -q set Master n

#amixer -q set Master n% 

if [ "$1" = "" ]; then
	n=$( zenity --entry )
else
	n=$1
fi
#
orig=$(amixer get Master | grep % | awk '{print $4}'| sed 's/[^0-9]//g')
echo $orig
#
# execute the loop
#
for i in `seq $n -1 0`; do
	# Wacht een minuut
	sleep 1
	vol=$(( $i \* $orig / $n ))
	echo "volume $vol"
	amixer -q set Master ${vol}%
done
#
#
dbus-send --print-reply --system --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend
