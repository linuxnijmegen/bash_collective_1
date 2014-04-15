#!/bin/bash
#sleepcmd="dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" /org/freedesktop/UPower org.freedesktop.UPower.Suspend"
COMMAND="echo sleep"
DELAY=30
for i in $*
do
        case $i in
        -s)
                COMMAND="echo /usr/sbin/shutdown h now"
                ;;
        -m=*)
                DELAY=`echo $i | cut -c 4-`
                ;;
        -v)
                VERBOSE=true
                ;;
        *)
                # unknown option
                echo "USAGE: $(basename $0) [-s] [-m=minutes]"
		exit
                ;;
        esac
done
echo "DELAY: $DELAY"
# sleep till one minute before  
if [ $DELAY -gt 1 ];then
  sleep $((DELAY-1))m
  total=60
else
  total=$((DELAY*60))
fi

cur_volume=`amixer get Master | grep -Po "(?<=\[)\d{1,3}(?=%\])" | head -1`
echo "cur_vol: $cur_volume"
if [ $cur_volume -eq 0 ];then
  sleep 60
else
  step=`echo $total/$cur_volume | bc -l`
  for i in `seq $cur_volume -1 0`
  do 
    #echo "i: $i"
    sleep $step
    amixer set Master ${i}%
  done
fi
echo "ZZZZZZZzzzzzzz"
$COMMAND
