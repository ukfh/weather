#!/bin/bash

# https://ocroquette.wordpress.com/2013/04/21/how-to-generate-a-list-of-dates-from-the-shell-bash/

# daily ingest of old data

DATE=date
FORMAT="%Y-%m-%d"
start=`$DATE +$FORMAT -d "2021-07-17"`
end=`$DATE +$FORMAT -d "2021-07-28"`
#end=`$DATE +$FORMAT -d "2016-01-02"`
now=$start
while [[ "$now" < "$end" ]] ; do
    now=`$DATE +$FORMAT -d "$now + 1 day"`
    echo "$now"
    hive --hivevar WHERE=" where dt = '"$now"' " -f ingestRawWeather.sql 
done

exit
