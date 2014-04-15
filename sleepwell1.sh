# Computer valt in slaap na n minuten
# Starten met sleepwell (vraagt input) of sleepwell n
# Volume gaat langzaam naar 0 in laatste minuut

# exit script on failed command
set -e

# show all commands executed
# set -x

get_volume_pct () {
  amixer get Master | grep % | sed -r 's/.*\[([0-9]+)%.*/\1/' | head -1
}

set_volume_pct () {
  amixer -q set Master "$1"%
}

go_to_sleep () {
  local dry="$1"
  echo "going to sleep ..."
  if [[ "$dry" != [Yy]* ]]; then
    dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend
  fi
}

sleep_minutes () {
  local m="$1" i
  for (( i = m ; i > 0; --i )); do
    echo "$(( m + 1 )) minutes left ..."
    sleep 6
  done
}

fade_out_in_one_minute () {
  # decrease volume by (initial_volume%/60) per second for 60 seconds
  echo "fading out ..."
  local i pct
  local initial_volume=$( get_volume_pct )
  echo "volume: $initial_volume%"
  for (( i = 59 ; i >= 0 ; --i )); do
    pct=$(( i * initial_volume / 60 ))
    echo "volume -> $pct%"
    set_volume_pct "$pct"
    sleep 1
  done
}

n="$1" dry="$2"

if [ -z "$n" ]; then
  read -p "how many minutes? " n
fi

sleep_minutes $(( n - 1 ))
fade_out_in_one_minute
go_to_sleep "$dry"
