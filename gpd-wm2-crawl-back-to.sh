#!/bin/bash

systemd_log_name=gpd-wm2-sleephead

target=$1
echo "crawl-back-to: $target" | systemd-cat -t $systemd_log_name

max_attempts=12
attempt=0

# Loop until suspend.target is inactive or the max_attempts is reached
while systemctl is-active --quiet suspend.target; do
  if [ "$attempt" -ge "$max_attempts" ]; then
    echo "halting script as system has reported that it is still in suspend too many times..." | systemd-cat -t $systemd_log_name
    exit 1
  fi
  echo "suspend is still in progress, waiting... (Attempt $((attempt+1)) of $max_attempts)" | systemd-cat -t $systemd_log_name
  sleep 10
  attempt=$((attempt+1))
done

case $target in
  suspend)
    echo "> systemctl suspend" | systemd-cat -t $systemd_log_name
    systemctl suspend
    ;;
  hibernate)
    echo "> systemctl hibernate" | systemd-cat -t $systemd_log_name
    systemctl hibernate
    ;;
  *)
    echo "unknown target" | systemd-cat -t $systemd_log_name
esac
