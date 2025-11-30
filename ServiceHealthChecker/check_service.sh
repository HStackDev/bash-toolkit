#!/bin/bash

CONFIG_FILE="services.conf"
LOG_FILE="health.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "----- Health Check - $DATE -----" >> $LOG_FILE

while read service; do
    if systemctl is-active --quiet "$service"; then
        echo "$service: RUNNING"
        echo "$service: RUNNING" >> $LOG_FILE
    else
        echo "$service: NOT RUNNING"
        echo "$service: NOT RUNNING" >> $LOG_FILE
    fi
done < $CONFIG_FILE
echo -e "\n" >> $LOG_FILE