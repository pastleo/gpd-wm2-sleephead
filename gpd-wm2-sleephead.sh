#!/bin/bash

systemd_log_name=gpd-wm2-sleephead
sleep_timestamp_file=/tmp/gpd-wm2-sleep-start-time
hibernation_threshold_hours=6

echo "hook script running with args: $@" | systemd-cat -t $systemd_log_name

case $1/$2 in
  pre/suspend)
    if ! [ -f "$sleep_timestamp_file" ]; then
      date +%s > $sleep_timestamp_file
      echo "sleep started at $(date)" | systemd-cat -t $systemd_log_name
    fi
    ;;
  post/*)
    echo 'resumed...' | systemd-cat -t $systemd_log_name
    sleep 1

    lid_closed=$(grep closed /proc/acpi/button/lid/LID0/state)
    bat_discharging=$(grep Discharging /sys/class/power_supply/BAT0/status)
    echo "lid_closed=$lid_closed bat_discharging=$bat_discharging"  | systemd-cat -t $systemd_log_name

    if [ "$lid_closed" -a "$bat_discharging" ]
    then
      if [ -f "$sleep_timestamp_file" ]; then
        sleep_start=$(cat $sleep_timestamp_file)
        current_time=$(date +%s)
        sleep_duration=$((current_time - sleep_start))
        sleep_hours=$((sleep_duration / 3600))

        echo "sleep duration: ${sleep_hours} hours" | systemd-cat -t $systemd_log_name
            
        if [ $sleep_hours -ge $hibernation_threshold_hours ]; then
          echo "sleep duration exceeded ${hibernation_threshold_hours} hours, hibernating..." | systemd-cat -t $systemd_log_name
          rm -f $sleep_timestamp_file
          /usr/local/bin/gpd-wm2-crawl-back-to hibernate
        else
          /usr/local/bin/gpd-wm2-crawl-back-to suspend
        fi
      else
        /usr/local/bin/gpd-wm2-crawl-back-to suspend
      fi
    else
      echo "time to wakeup!" | systemd-cat -t $systemd_log_name
      rm -f $sleep_timestamp_file
    fi
    ;;
  *)
    echo "unknown args, skipping..." | systemd-cat -t $systemd_log_name
esac
