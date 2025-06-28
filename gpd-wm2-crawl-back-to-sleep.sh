#!/bin/bash

systemd_log_name=gpd-wm2-sleephead
sleep_timestamp_file=/run/gpd-wm2-sleep-start-time
hibernation_threshold_hours=6

debounce=10 # secs
max_attempts=12
attempt=0

echo "crawl-back-to-sleep: debounce for ${debounce}s" | systemd-cat -t $systemd_log_name
sleep $debounce
# Loop until suspend.target is inactive or the max_attempts is reached
while [ $(systemctl is-active suspend.target) != "inactive" ]; do
  if [ "$attempt" -ge "$max_attempts" ]; then
    echo "halting script as system has reported that it is still in suspend too many times..." | systemd-cat -t $systemd_log_name
    exit 1
  fi
  echo "suspend is still in progress, waiting... (Attempt $((attempt+1)) of $max_attempts)" | systemd-cat -t $systemd_log_name
  sleep $debounce
  attempt=$((attempt+1))
done

if [ -f "$sleep_timestamp_file" ]; then
  sleep_start=$(cat $sleep_timestamp_file)
  current_time=$(date +%s)
  sleep_duration=$((current_time - sleep_start))
  sleep_hours=$((sleep_duration / 3600))

  echo "sleep duration: ${sleep_hours} hours" | systemd-cat -t $systemd_log_name
      
  if [ $sleep_hours -ge $hibernation_threshold_hours ]; then
    echo "sleep duration exceeded ${hibernation_threshold_hours} hours, hibernating..." | systemd-cat -t $systemd_log_name

    echo "> systemctl hibernate" | systemd-cat -t $systemd_log_name
    systemctl hibernate
  else
    echo "> systemctl suspend" | systemd-cat -t $systemd_log_name
    systemctl suspend
  fi
else
  echo "> systemctl suspend" | systemd-cat -t $systemd_log_name
  systemctl suspend
fi
